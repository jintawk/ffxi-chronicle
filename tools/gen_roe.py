"""Generate Chronicle's Records of Eminence catalogue from the game client's own data.

The client ships the whole Records of Eminence system in two item-record ranges of its DAT
files, so nothing here is scraped or hand-written:

    0xD979   the menu tree       root -> 12 categories -> 112 sub-categories -> objectives,
                                 each child carrying up to four visibility requirements
    0xD978   objective records   id, date added, repeat flag, goal count, four reward values,
                                 name and description

This script takes those two ranges, already extracted to JSON by a DAT reader, and writes the
addon's `roe/` folder:

    roe/index.lua     the tree, every objective's name / goal / repeat flag, the visibility
                      gates at all three levels, the names of the records that gates name, and
                      a derived content hint per sub-category
    roe/cNN.lua       one file per category: description, rewards and cross-link per objective

The split keeps the heavy text out of the heap: the index is always loaded, a category file only
while one of its sub-categories is open.

Usage:

    python tools/gen_roe.py --tree roe_tree.json --records records.json [--out .]

`--tree` is the 0xD979 extraction, `--records` the 0xD978 one; both are produced by a DAT
reader run against an installed client, and neither ships with Chronicle.

Re-run after a game update. The November 2026 update added a whole category (Trust Ascension,
five objectives) with full names and descriptions, so the only step needed to pick up new
objectives, new sub-categories and new categories is to re-extract the two inputs and run this
again. Nothing else in the addon is touched.
"""
import argparse
import collections
import json
import os
import re
import struct
import sys

REQ = {1: 'quest_completed', 2: 'jobs_unlocked_mask', 3: 'job_level_at_least', 4: 'zone_visited',
       5: 'skill_at_least', 6: 'pkt110_byte_equals', 7: 'unity_is', 8: 'any_job_level_at_most'}

ROE_BASE = 0xE000       # objective records sit at 0xE000 + id
CAT_LO, CAT_HI = 0xF200, 0xF5FF


# ---------------------------------------------------------------------------
# text
# ---------------------------------------------------------------------------

# The DAT text is Shift-JIS. Everything in the Records of Eminence strings is ASCII bar a
# handful of full-width punctuation marks, which are folded to their ASCII equivalent so the
# addon never has to care about a second encoding.
SJIS_FOLD = {
    '\x81\x40': ' ', '\x81\x41': ',', '\x81\x42': '.', '\x81\x43': ',', '\x81\x44': '.',
    '\x81\x45': '-', '\x81\x46': ':', '\x81\x47': ';', '\x81\x48': '?', '\x81\x49': '!',
    '\x81\x5b': '-', '\x81\x60': '~', '\x81\x6d': '[', '\x81\x6e': ']',
    '\x81\x75': '"', '\x81\x76': '"', '\x81\x9a': '*', '\x81\x99': '*',
}


def fold(s):
    """ASCII-only text: fold the few Shift-JIS punctuation pairs, drop anything else above 7 bit."""
    if all(ord(ch) < 128 for ch in s):
        return s
    for k, v in SJIS_FOLD.items():
        s = s.replace(k, v)
    return ''.join(ch if ord(ch) < 128 else '?' for ch in s)


# ---------------------------------------------------------------------------
# inputs
# ---------------------------------------------------------------------------

def load_tree(path):
    """-> categories, and the gates of every tree entry by its id.

    Every leaf of this tree sits at depth 3, so the shape is fixed: root -> category ->
    sub-category -> objective. Gates sit at all three levels and have to be ANDed along the
    whole path, so they are kept per node id rather than flattened onto the objective.
    """
    tree = json.load(open(path, encoding='utf-8'))
    root = tree.get('%04X' % CAT_LO)
    if not root:
        sys.exit('no root node %04X in %s' % (CAT_LO, path))

    def gates_of(entry):
        out = []
        for q in entry.get('reqs', []):
            t = q['type']
            if t == 0:
                continue
            out.append((t, q['value']))
        return out

    cats = []
    for c in root['entries']:
        cid = c['id']
        node = tree.get('%04X' % cid)
        if not node:
            continue
        subs = []
        for s in node['entries']:
            sid = s['id']
            leaf = tree.get('%04X' % sid)
            if not leaf:
                continue
            objs = []
            for o in leaf['entries']:
                if o['id'] & 0xF000 != ROE_BASE:
                    continue
                objs.append((o['id'] - ROE_BASE, gates_of(o)))
            subs.append({'id': sid, 'gates': gates_of(s), 'objs': objs})
        cats.append({'id': cid, 'gates': gates_of(c), 'subs': subs})
    return cats


def load_names(path):
    """Category and sub-category names: the tree ids are item records too."""
    recs = json.load(open(path, encoding='utf-8'))['records']
    out = {}
    for r in recs:
        if CAT_LO <= r['id'] <= CAT_HI:
            text = [x for x in r['text'] if isinstance(x, str)]
            if text and text[0] not in ('.', ''):
                out[r['id']] = fold(text[0])
    return out


def load_records(path):
    """id -> name, description, repeat flag, goal count, the four reward values."""
    recs = json.load(open(path, encoding='utf-8'))['records']
    out = {}
    for r in recs:
        if r['label'] != 'roe':
            continue
        text = [x for x in r['text'] if isinstance(x, str)]
        if not text or text[0] in ('.', ''):
            continue
        f = struct.unpack_from('<8I', bytes.fromhex(r['hdr']), 0)
        desc = r['text'][4] if len(r['text']) > 4 and isinstance(r['text'][4], str) else ''
        out[r['id'] - ROE_BASE] = {
            'name': fold(text[0]), 'desc': fold(desc), 'added': f[1],
            'rep': bool(f[2]), 'goal': f[3],
            'sparks': f[4], 'exp': f[5], 'cp': f[6], 'acc': f[7]}
    return out


# ---------------------------------------------------------------------------
# cross-links: the objective wraps a quest or mission Chronicle already documents
# ---------------------------------------------------------------------------

def norm(n):
    n = n.lower().strip().replace('’', "'")
    n = re.sub(r'\s*\((quest|mission)\)\s*$', '', n)
    return re.sub(r'[^a-z0-9]+', '', n)


def chronicle_entries(root):
    """Chronicle's own entries: normalised name -> (cat, area, id, name).

    meta/index.lua gives name -> areas; the per-area metadata gives each entry its id, which is
    what pages/index.lua and the navigation are keyed by. An entry whose name joins two quests
    with a slash ("Elder Memories/The Old Lady") is registered under each half as well.
    """
    idx = open(os.path.join(root, 'meta', 'index.lua'), encoding='utf-8', errors='replace').read()
    mi, qi = idx.find('mission={'), idx.find('quest={')
    halves = {'mission': idx[mi:qi], 'quest': idx[qi:]}
    want = collections.defaultdict(set)         # cat -> areas we must read
    name_areas = {}                             # (cat, lowered name) -> [areas]
    # the index writes a key either quoted or bare, whichever Lua accepts
    KEY = re.compile(r'\["([^"]+)"\]=\{([^}]*)\}|(?:^|[,{])([a-z0-9_]+)=\{([^}]*)\}')
    for cat, s in halves.items():
        for qn, qa, bn, ba in KEY.findall(s):
            name, areas = (qn, qa) if qn else (bn, ba)
            if name in ('mission', 'quest'):
                continue
            al = re.findall(r'"([^"]+)"', areas)
            if not al:
                continue
            name_areas[(cat, name)] = al
            want[cat].update(al)

    ids = {}            # (cat, area, lowered name) -> (id, display name)
    for cat, areas in want.items():
        sub = 'missions' if cat == 'mission' else 'quests'
        for area in sorted(areas):
            p = os.path.join(root, 'meta', sub, area + '.lua')
            if not os.path.exists(p):
                continue
            body = open(p, encoding='utf-8', errors='replace').read()
            for m in re.finditer(r'\["((?:[^"\\]|\\.)*)"\]=\{', body):
                start = m.end()
                depth, i = 1, start
                while i < len(body) and depth:
                    if body[i] == '{':
                        depth += 1
                    elif body[i] == '}':
                        depth -= 1
                    i += 1
                rid = re.search(r'(?:^|[,{])id=(-?\d+)', body[start:i])
                if rid:
                    ids[(cat, area, m.group(1).lower())] = (int(rid.group(1)), m.group(1))

    out = {}
    for (cat, name), areas in name_areas.items():
        for area in areas:
            hit = ids.get((cat, area, name.lower()))
            if hit is None:
                continue
            rec = (cat, area, hit[0], hit[1])
            out.setdefault(norm(name), rec)
            # a combined entry covers both quests it names
            if '/' in name:
                for half in name.split('/'):
                    out.setdefault(norm(half), rec)
            break
    return out


QUOTE = re.compile(r'[“"]([^”"]{3,70})[”"]')


def resolve(desc, entries):
    """The Chronicle entry a description names in quotes, or None.

    Punctuation inside the quotes is already normalised away. A name that differs from
    Chronicle's only by a trailing plural s ("Smash the Orcish Scout" against Chronicle's
    "Smash the Orcish Scouts") is matched as a last resort.
    """
    for q in QUOTE.findall(desc):
        k = norm(q)
        if not k:
            continue
        for cand in (k, k + 's', k[:-1] if k.endswith('s') else None):
            if cand and cand in entries:
                return entries[cand]
    return None


# ---------------------------------------------------------------------------
# the derived content hint for a sub-category
# ---------------------------------------------------------------------------

TAG = re.compile(r'\s*\((?:D|W|M|VB|VBD|UC)\)\s*$')     # daily / weekly / monthly / event tags
LEAD = re.compile(r'^(?:Level\s+\d+|Lv\.?\s*\d+)\s+', re.I)
NUMBERING = re.compile(r'^(?:Lv\.?\s*)?[0-9IVXLC]+(?:\s*-\s*[0-9IVXLC]+)?$|^[A-F]$', re.I)


def variants(names):
    """The distinct part of each name once the shared pattern is gone."""
    n = [TAG.sub('', x).strip() for x in names]
    colon = [x for x in n if ': ' in x]
    if len(colon) >= max(2, int(.6 * len(n))):
        return [x.split(': ', 1)[1].strip() for x in colon], 'after-colon'
    if sum(1 for x in n if LEAD.match(x)) >= max(2, int(.6 * len(n))):
        return [LEAD.sub('', x).strip() for x in n if LEAD.match(x)], 'ladder'
    words = [x.split() for x in n]
    if len(words) > 1:
        k = 0
        while all(len(w) > k + 1 for w in words) and len({w[k] for w in words}) == 1:
            k += 1
        if k:
            return [' '.join(w[k:]) for w in words], 'common-prefix'
    return n, 'plain'


def hint(names, limit=4):
    """A line saying what is inside a sub-category, derived from its objectives' names.

    The client's own sub-category names are often opaque ("Job Levels 1", "Quests 1"), which
    is what makes the middle navigation level hard to use; this is what fixes it.
    """
    v, how = variants(names)
    seen, out = set(), []
    for x in v:
        if x and x not in seen:
            seen.add(x)
            out.append(x)
    if not out:
        return '', how
    # a pure numbering sequence says nothing as a list; its span says the range
    if len(out) > 2 and all(NUMBERING.match(x) for x in out):
        return '%s -> %s' % (out[0], out[-1]), how + '/span'
    shown = out[:limit]
    more = len(out) - len(shown)
    return ', '.join(shown) + ((' +%d more' % more) if more > 0 else ''), how


# ---------------------------------------------------------------------------
# Lua output
# ---------------------------------------------------------------------------

def q(s):
    """A Lua string literal. Descriptions carry real newlines, which have to survive."""
    out = []
    for ch in s:
        if ch == '\\':
            out.append('\\\\')
        elif ch == '"':
            out.append('\\"')
        elif ch == '\n':
            out.append('\\n')
        elif ch == '\r':
            out.append('')
        elif ord(ch) < 32:
            out.append('\\%d' % ord(ch))
        else:
            out.append(ch)
    return '"' + ''.join(out) + '"'


def gl(gates):
    """Gates as Lua: a flat array of type * 0x10000 + value.

    One packed number a gate rather than a pair of them in a table of its own: a nested table
    for each of the 1,900-odd gates costs more heap than the whole rest of the index, and the
    client's own values are small (type 1-8, value below 4096).
    """
    return '{' + ','.join(str(t * 0x10000 + v) for t, v in gates) + '}'


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--tree', required=True, help='the 0xD979 category-tree extraction (JSON)')
    ap.add_argument('--records', required=True, help='the item-record extraction holding 0xD978 (JSON)')
    ap.add_argument('--zones', default=None,
                    help="optional: Windower's res/zones.lua, to name the zones a visibility gate asks for")
    ap.add_argument('--out', default=None, help="the addon's root (default: this script's parent)")
    a = ap.parse_args()

    root = a.out or os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    outdir = os.path.join(root, 'roe')
    os.makedirs(outdir, exist_ok=True)

    cats = load_tree(a.tree)
    names = load_names(a.records)
    recs = load_records(a.records)
    entries = chronicle_entries(root)

    # every record a gate names, at any level: a locked objective can then say what unlocks it;
    # and every zone a gate asks for, so the one requirement Chronicle cannot evaluate can at
    # least be named
    gate_recs, gate_zones = set(), set()
    for c in cats:
        lists = [c['gates']] + [s['gates'] for s in c['subs']]
        for s in c['subs']:
            lists.extend(og for _, og in s['objs'])
        for lst in lists:
            for g in lst:
                if g[0] == 1:
                    gate_recs.add(g[1])
                elif g[0] == 4:
                    gate_zones.add(g[1])

    zones = {}
    if a.zones:
        body = open(a.zones, encoding='utf-8', errors='replace').read()
        for zid, en in re.findall(r'\[(\d+)\]\s*=\s*\{[^}]*?\ben="((?:[^"\\]|\\.)*)"', body):
            zones[int(zid)] = en

    missing, linked, total = [], 0, 0
    cat_lines, index_cats = [], []
    for n, c in enumerate(cats, 1):
        fname = 'roe/c%02d.lua' % n
        body = []
        subs = []
        for s in c['subs']:
            objs = []
            sub_names = []
            for oid, og in s['objs']:
                r = recs.get(oid)
                if not r:
                    missing.append(oid)
                    continue
                total += 1
                objs.append((oid, og, r))
                sub_names.append(r['name'])
            h, _ = hint(sub_names)
            subs.append({'name': names.get(s['id'], ''), 'hint': h, 'gates': s['gates'],
                         'objs': objs})

        for s in subs:
            for oid, _, r in s['objs']:
                w = resolve(r['desc'], entries)
                wrap = ''
                if w:
                    linked += 1
                    wrap = ',w="%s|%s|%d",wn=%s' % (w[0], w[1], w[2], q(w[3]))
                body.append('[%d]={d=%s,s=%d,x=%d,c=%d,a=%d%s},'
                            % (oid, q(r['desc']), r['sparks'], r['exp'], r['cp'], r['acc'], wrap))

        with open(os.path.join(root, fname), 'w', encoding='utf-8', newline='\n') as f:
            f.write('-- Generated by tools/gen_roe.py from the game client. Do not edit.\n')
            f.write('-- %s: the text, rewards and cross-links of its objectives.\n' % names.get(c['id'], ''))
            f.write('return {\n')
            for line in body:
                f.write(line + '\n')
            f.write('}\n')
        index_cats.append((c, names.get(c['id'], ''), fname, subs))

    # ---- index ----
    with open(os.path.join(outdir, 'index.lua'), 'w', encoding='utf-8', newline='\n') as f:
        f.write('-- Generated by tools/gen_roe.py from the game client. Do not edit.\n')
        f.write('-- The Records of Eminence menu tree, exactly as the client draws it, with every\n')
        f.write('-- objective\'s name, goal count and repeat flag, the visibility gates at all three\n')
        f.write('-- levels, and the name of every record a gate names.\n')
        f.write('return {\n')
        f.write('version = 1,\n')
        f.write('counts = {categories = %d, subcategories = %d, objectives = %d},\n'
                % (len(index_cats), sum(len(x[3]) for x in index_cats), total))
        f.write('cats = {\n')
        for c, cname, fname, subs in index_cats:
            f.write('{n=%s,f=%s,g=%s,subs={\n' % (q(cname), q(fname), gl(c['gates'])))
            for s in subs:
                ids = ','.join(str(o[0]) for o in s['objs'])
                f.write('{n=%s,h=%s,g=%s,o={%s}},\n' % (q(s['name']), q(s['hint']), gl(s['gates']), ids))
            f.write('}},\n')
        f.write('},\n')

        # Parallel tables, not a table per objective: a table of its own for each of the 1,508
        # costs several hundred KB of heap in a 32-bit client, and only two of the three fields
        # are set for most of them anyway.
        f.write('-- objective -> name\n')
        f.write('name = {\n')
        for c, cname, fname, subs in index_cats:
            for s in subs:
                for oid, og, r in s['objs']:
                    f.write('[%d]=%s,\n' % (oid, q(r['name'])))
        f.write('},\n')

        f.write('-- objective -> goal count, when it needs more than one\n')
        f.write('goal = {\n')
        for c, cname, fname, subs in index_cats:
            for s in subs:
                for oid, og, r in s['objs']:
                    if (r['goal'] or 0) > 1:
                        f.write('[%d]=%d,\n' % (oid, r['goal']))
        f.write('},\n')

        f.write('-- the repeatable objectives\n')
        f.write('rep = {\n')
        for c, cname, fname, subs in index_cats:
            for s in subs:
                for oid, og, r in s['objs']:
                    if r['rep']:
                        f.write('[%d]=true,\n' % oid)
        f.write('},\n')

        f.write('-- objective -> its own visibility gates (its category\'s and sub-category\'s are above)\n')
        f.write('gates = {\n')
        for c, cname, fname, subs in index_cats:
            for s in subs:
                for oid, og, r in s['objs']:
                    if og:
                        f.write('[%d]=%s,\n' % (oid, gl(og)))
        f.write('},\n')

        f.write('-- the records gates name, so a locked objective can say what unlocks it\n')
        f.write('gate_names = {\n')
        for rid in sorted(gate_recs):
            r = recs.get(rid)
            f.write('[%d]=%s,\n' % (rid, q(r['name'] if r else '?')))
        f.write('},\n')

        # Records that are named but sit in no menu category: retired objectives, hidden
        # trackers, and the rotation pools the daily / weekly / monthly and limited-time slots
        # draw from. They are not part of the tree and never listed, but one can turn up in an
        # active slot, and a name there beats "Record 4018".
        in_menu = set()
        for c, cname, fname, subs in index_cats:
            for s in subs:
                for oid, og, r in s['objs']:
                    in_menu.add(oid)
        extra = sorted(oid for oid in recs if oid not in in_menu)
        f.write('-- named records that sit in no menu category: a slot can still hold one\n')
        f.write('extra = {\n')
        for oid in extra:
            f.write('[%d]={%s,%d},\n' % (oid, q(recs[oid]['name']), recs[oid]['goal'] or 1))
        f.write('},\n')

        f.write('-- the zones a gate asks for; no packet says which zones have been visited, so\n')
        f.write('-- these are named rather than evaluated\n')
        f.write('zone_names = {\n')
        for zid in sorted(gate_zones):
            if zones.get(zid):
                f.write('[%d]=%s,\n' % (zid, q(zones[zid])))
        f.write('},\n')
        f.write('}\n')

    print('categories %d, sub-categories %d, objectives %d'
          % (len(index_cats), sum(len(x[3]) for x in index_cats), total))
    print('objectives with no record: %d %s' % (len(missing), missing[:10]))
    print('cross-links to a Chronicle entry: %d' % linked)
    print('records named by a gate: %d' % len(gate_recs))
    print('named records outside the menu: %d' % (len(recs) - total))
    gated = collections.Counter()
    for c, cname, fname, subs in index_cats:
        for s in subs:
            for oid, og, r in s['objs']:
                gated[tuple(sorted({REQ.get(g[0], '?') for g in og})) or ('none',)] += 1
    print('objective gates:', {'+'.join(k): v for k, v in gated.most_common()})
    print('-> %s' % outdir)


if __name__ == '__main__':
    main()

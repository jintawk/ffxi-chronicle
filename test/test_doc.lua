--[[
    test_doc.lua - the Three Paths page (pages/missions/cop/530.lua) through ui/doc.lua: decoded
    structure against the markup, and layout at widths from the minimum up: every line of text stays
    inside the column, every link and tab has a hit, the height shrinks as the width grows.

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_doc.lua
]]

package.path = './?.lua;' .. package.path
local ops = require('ui/ops')
local D = require('ui/doc')

local pass, fail = 0, 0
local function check(name, cond, detail)
    if cond then pass = pass + 1 else
        fail = fail + 1
        print('FAIL ' .. name .. (detail ~= nil and (': ' .. tostring(detail)) or ''))
    end
end

-- the real fonts' widths when the DLL and the install are here
do
    package.cpath = './libs/?.dll;' .. package.cpath
    package.preload['_chronicle'] = dofile('test/crdll.lua').loader()      -- CR_DLL: a build other than libs/_chronicle.dll
    local ok, N = pcall(require, '_chronicle')
    local FFXI = [[C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI\]]
    if ok and N then
        N.start(FFXI)                   -- fails to hook (no game) but loads the fonts
        ops.set_metrics(N.metrics())
    end
    print('  metrics: ' .. (ops.metrics() and 'from the game' or 'built-in'))
end

collectgarbage() collectgarbage()
local heap0 = collectgarbage('count')
local mk = dofile('pages/missions/cop/530.lua')
local doc = D.decode(mk)
collectgarbage() collectgarbage()
local heap1 = collectgarbage('count')

check('title', doc.title == 'Three Paths')
check('8 pictures', #doc.images == 8)
local tabs
for _, b in ipairs(doc.blocks) do if b.k == 'tabs' then tabs = b end end
check('one tab group with three paths', tabs and #tabs.tabs == 3)
check('tab labels', tabs.tabs[1].label == 'Past Sins' and tabs.tabs[2].label == 'The Pursuit of Paradise'
    and tabs.tabs[3].label == 'Where Messengers Gather')
check('tab sublabels', tabs.tabs[1].sub == "(Louverance's Path)" and tabs.tabs[3].sub == "(Ulmia's Path)")
for i, t in ipairs(tabs.tabs) do
    check('tab ' .. i .. ' header has 9 fields', #t.head == 9, #t.head)
    check('tab ' .. i .. ' has a body', #t.blocks > 10, #t.blocks)
end

-- every link and icon in the markup decodes
local function count_markup(pat)
    local n = 0
    for _ in mk.body:gmatch(pat) do n = n + 1 end
    for _, v in pairs(mk.meta) do for _ in v:gmatch(pat) do n = n + 1 end end
    return n
end
local links, icons, ids = 0, 0, 0
local function walk_spans(spans)
    for _, s in ipairs(spans) do
        if s.t == 'link' then links = links + 1 end
        if s.t == 'icon' and s.icon == 'item' then
            icons = icons + 1
            if s.id then ids = ids + 1 end
        end
    end
end
local function walk(bs)
    for _, b in ipairs(bs) do
        if b.k == 'tabs' then
            for _, t in ipairs(b.tabs) do
                for _, h in ipairs(t.head) do walk_spans(h.spans) end
                walk(t.blocks)
            end
        elseif b.k == 'list' then
            local function items(its) for _, it in ipairs(its) do walk_spans(it.spans) items(it.children) end end
            items(b.items)
        elseif b.k == 'box' then walk_spans(b.title) walk(b.blocks)
        elseif b.k == 'image' then walk_spans(b.caption)
        elseif b.spans then walk_spans(b.spans) end
    end
end
for _, v in pairs(doc.meta) do walk_spans(v) end
walk(doc.blocks)
local want_links = count_markup('{[nzikmqMsp]:')
check('every link decodes', links == want_links, links .. ' / ' .. want_links)
check('every item icon decodes, with its id', icons == count_markup('{@i:') and ids == icons, icons .. ' ' .. ids)
local names = D.tab_names(doc)
check("path names switch tabs", names['past sins'] and names['where messengers gather'] and names['the pursuit of paradise'])

-- layout at every width: text inside the column, hits for every link, height shrinks
local last_h
for _, w in ipairs({300, 420, 539, 540, 640, 800, 1000}) do
    for tab = 1, 3 do
        local b = ops.new()
        local t0 = os.clock()
        local h = D.draw(b, doc, 0, 0, w, {tabs = {[tabs.group] = tab}, pics = function() return 'loading' end})
        local ms = (os.clock() - t0) * 1000
        local over = 0
        for _, line in ipairs(b.o) do
            if line:sub(1, 1) == 'T' then
                local x, s = line:match('^T\t([%-%d%.]+)\t[%-%d%.]+\t%x+\t(.*)$')
                if tonumber(x) + ops.text_w(s) > w + 1 then over = over + 1 end
            end
        end
        check(('w %d tab %d: no text past the column'):format(w, tab), over == 0, over)
        local link_hits, tab_hits = 0, 0
        for _, hh in ipairs(b.hits) do
            if hh.id == 'link' then link_hits = link_hits + 1 end
            if hh.id == 'tab' then tab_hits = tab_hits + 1 end
        end
        check(('w %d tab %d: hits'):format(w, tab), link_hits > 20 and tab_hits == 3, link_hits .. ' ' .. tab_hits)
        if tab == 1 then
            if last_h then check(('w %d: shorter than narrower'):format(w), h <= last_h, h .. ' ' .. last_h) end
            last_h = h
            print(('  width %4d: tab 1 %5d px tall, %4d commands, %3d hits, %.1f ms'):format(w, h, #b.o, #b.hits, ms))
        end
    end
end

-- a quest page's infobox is a header in the infobox's order; a page with tabs has none of its own
do
    local qk = dofile('pages/quests/sandoria/11.lua')
    local q = D.decode(qk)
    local keys = {}
    for _, h in ipairs(q.head) do keys[#keys + 1] = h.key end
    check('quest page: not tabbed, header in the infobox order', not q.tabbed and table.concat(keys, ',') == table.concat(qk.meta_order, ','),
        table.concat(keys, ','))
    check('quest page: the Name equal to the title is not drawn', D.head_hidden(q.head[1], q.title) and not D.head_hidden(q.head[2], q.title))
    check('three paths: tabbed', doc.tabbed == true)
    local b = ops.new()
    D.draw(b, q, 0, 0, 440, {})
    local text = table.concat(b.o, '|')
    check('quest page: header drawn (start NPC, reward)', text:find('	Start|') ~= nil and text:find('	Reward') ~= nil and text:find('	Andecia') ~= nil)
end

local chr10 = string.char(10)
-- the page header leaves out what the guide card shows (core/card.lua) and what says nothing; no empty box
do
    local card = require('core/card')
    local function field(key, text, spans) return {key = key, spans = spans or {{t = 'text', s = text}}} end
    local none = field('Pack', 'None')
    check('head_hidden: "None" on a page', D.head_hidden(none, 'T') == true)
    check('head_hidden: "--", empty, spaces', D.head_hidden(field('Pack', '--'), 'T') and D.head_hidden(field('Pack', ''), 'T')
        and D.head_hidden(field('Pack', '  none '), 'T'))
    check('head_hidden: a break span only is empty', D.head_hidden(field('Pack', nil, {{t = 'br'}}), 'T') == true)
    check('head_hidden: a value stays', D.head_hidden(field('Pack', 'Dagger'), 'T') == false)
    check('head_hidden: an icon is a value', D.head_hidden(field('Pack', nil, {{t = 'icon', icon = 'item', id = 5}}), 'T') == false)
    check('head_hidden: "None" in a tab panel stays when there is no card', D.head_hidden(none, nil) == false)
    check('head_hidden: Name of a panel', D.head_hidden(field('Name', 'X'), nil) == true)
    local fame = field('Required Fame', "San d'Oria Fame Level: 1")
    check('head_hidden: card shows fame', D.head_hidden(fame, 'T', {fame = true}) == true)
    check('head_hidden: card lacks fame', D.head_hidden(fame, 'T', {npc = true}) == false and D.head_hidden(fame, 'T', {}) == false)
    check('head_hidden: no card, nothing dropped for it', D.head_hidden(fame, 'T', nil) == false)
    -- Requirements: the card's list is items only, so a row that also says a skill or a condition stays
    local function req(spans) return {key = 'Requirements', spans = spans} end
    local link = function(s) return {t = 'link', kind = 'item', s = s} end
    local plink = function(s) return {t = 'link', kind = 'page', s = s} end   -- {p:Polearm}: a wiki page, not an item
    local items_only = req({link('Sahagin Key')})
    local with_skill = req({plink('Polearm'), {t = 'text', s = ' skill 240+, Level 71'}, {t = 'br'}, link('Sahagin Key')})
    check('head_hidden: a Requirements row of items only repeats the card',
          D.head_hidden(items_only, 'T', {requirements = true}) == true)
    check('head_hidden: one that also names a skill and a level stays',
          D.head_hidden(with_skill, 'T', {requirements = true}) == false)
    check('head_hidden: a quantity or an "or" is not more than the card says',
          D.head_hidden(req({link('Bronze Ingot'), {t = 'text', s = ' x10 or '}, link('Brass Ingot')}), 'T',
                        {requirements = true}) == true)
    -- the words sit in the item's own line, so drawing them would name the item a second time (the card already does)
    check('head_hidden: a condition beside the item itself goes with it',
          D.head_hidden(req({link('Moon Bauble'), {t = 'text', s = ' (first time completion only)'}}), 'T',
                        {requirements = true}) == true)
    check('head_hidden: a condition on a line of its own stays',
          D.head_hidden(req({link('Moon Bauble'), {t = 'br'}, {t = 'text', s = 'Region under Bastok control'}}), 'T',
                        {requirements = true}) == false)
    -- and only that line is drawn: the item's line is the card's
    local kept = D.req_extra(with_skill)
    check('req_extra: the item line is left out', kept ~= nil and #kept == 2
          and kept[1].s == 'Polearm' and kept[2].s == ' skill 240+, Level 71')
    check('req_extra: a row of items only has nothing to draw', D.req_extra(items_only) == nil)
    check('req_extra: the lines kept are joined by a break',
          (function()
              local k = D.req_extra(req({{t = 'text', s = 'A fishing rod'}, {t = 'br'}, link('Lure'),
                                         {t = 'br'}, {t = 'text', s = 'Level 20'}}))
              return k ~= nil and #k == 3 and k[2].t == 'br' and k[3].s == 'Level 20'
          end)())
    check('req_extra: only a Requirements row is trimmed', D.req_extra({key = 'Rewards', spans = {}}) == nil)
    check('head_spans: the row the card has no list for is drawn whole',
          D.head_spans(with_skill, 'T', {}) == with_skill.spans)
    check('head_spans: a tab panel draws it whole', D.head_spans(with_skill, nil, {requirements = true}) == with_skill.spans)
    check('head_spans: under a card list only the prose line', #D.head_spans(with_skill, 'T', {requirements = true}) == 2)
    check('head_hidden: with no card list the row stays either way',
          D.head_hidden(items_only, 'T', {}) == false and D.head_hidden(with_skill, 'T', {}) == false)
    D.REQ_EXTRA = false
    check('head_hidden: self-test, the old drawing dropped the skill row',
          D.head_hidden(with_skill, 'T', {requirements = true}) == true)
    check('head_spans: self-test, the old drawing had nothing to trim',
          D.head_spans(with_skill, 'T', {requirements = true}) == with_skill.spans)
    D.REQ_EXTRA = true

    local start = field('Starting NPC', 'Kuu - Zone (F-8)')
    check('head_hidden: Starting NPC needs the NPC and the zone', D.head_hidden(start, 'T', {npc = true, zone = true}) == true
        and D.head_hidden(start, 'T', {npc = true}) == false and D.head_hidden(start, 'T', {zone = true}) == false)
    check('head_hidden: Next Quest is not on the card', D.head_hidden(field('Next Quest', 'Other'), 'T', {fame = true, npc = true,
        zone = true, title = true, repeatable = true, description = true, reward = true, requirements = true}) == false)
    -- core/card: only a real value counts (the card draws '--' for the rest, and 'No' for repeatable)
    local e = {start_npc = 'Kuu', start_zone = '', start_pos = 'F-8', fame = "San d'Oria", reward = '  ', title = 'T',
               description = 'd', requirements = {}}
    local sh = card.shown(e)
    check('card.shown: real values only', sh.npc and sh.fame and sh.title and sh.description and not sh.zone and not sh.reward
        and not sh.repeatable and not sh.requirements)
    check('card.shown: requirements when listed', card.shown({requirements = {{name = 'x', count = 1}}}).requirements == true)
    check('card.shown: the chain links', card.shown({previous = {'A'}, next = {}}).previous == true and not card.shown({previous = {'A'}, next = {}}).next)
    local prev_f, next_f = field('Previous Quest', 'A'), field('Next Quest', 'B')
    check('head_hidden: Previous / Next Quest follow the card chain', D.head_hidden(prev_f, 'T', {previous = true}) == true
        and D.head_hidden(next_f, 'T', {previous = true}) == false and D.head_hidden(next_f, 'T', {next = true}) == true
        and D.head_hidden(prev_f, 'T', {}) == false and D.head_hidden(prev_f, 'T', nil) == false)
    -- the card's default text: a header Repeatable with the very text the card prints repeats it (2026-10-20)
    check('card.printed: No by default, the entry value otherwise', card.printed({}).repeatable == 'No' and card.printed(nil).repeatable == 'No'
        and card.printed({repeatable = ''}).repeatable == 'No' and card.printed({repeatable = 'Yes'}).repeatable == 'Yes')
    check('card.shown: carries the printed text, and it is not a field', card.shown({}).printed.repeatable == 'No' and not card.shown({}).repeatable)
    local rep_no = field('Repeatable', 'No')
    check('head_hidden: Repeatable No repeats the card default', D.head_hidden(rep_no, 'T', card.shown({})) == true)
    check('head_hidden: ...whatever the case, spacing and full stop', D.head_hidden(field('Repeatable', '  no. '), 'T', card.shown({})) == true)
    check('head_hidden: Repeatable Yes is not the card default', D.head_hidden(field('Repeatable', 'Yes, once a week'), 'T', card.shown({})) == false)
    check('head_hidden: a card that prints Yes repeats a Yes, not a No',
        D.head_hidden(field('Repeatable', 'Yes'), 'T', {printed = {repeatable = 'Yes'}}) == true
        and D.head_hidden(rep_no, 'T', {printed = {repeatable = 'Yes'}}) == false)
    check('head_hidden: no printed text, no card, nothing dropped for it', D.head_hidden(rep_no, 'T', {}) == false and D.head_hidden(rep_no, 'T', nil) == false)
    check('head_hidden: a Repeatable with an icon is not plain text', D.head_hidden(field('Repeatable', nil, {{t = 'text', s = 'No '}, {t = 'icon', icon = 'item', id = 5}}),
        'T', card.shown({})) == false)
    check('head_hidden: in a tab panel Repeatable No repeats the card default (cop 530)', D.head_hidden(rep_no, nil, card.shown({})) == true
        and D.head_hidden(rep_no, nil, {printed = {repeatable = 'Yes'}}) == false and D.head_hidden(rep_no, nil, nil) == false)
    -- 2026-10-20: the wiki wins where it and the card's v1 data disagree (sandoria 84-89, 94-96: "Yes, after Memory reset" over a card
    -- that prints "No"): a Repeatable is hidden only when it says what the card prints, whether or not the card has a value
    local after_reset = field('Repeatable', 'Yes, after Memory reset')
    check('head_hidden: a Repeatable the card contradicts is drawn, though the card has a value',
        D.head_hidden(after_reset, 'T', {repeatable = true, printed = {repeatable = 'No'}}) == false
        and D.head_hidden(after_reset, 'T', card.shown({repeatable = 'No'})) == false)
    check('head_hidden: ...and one that says the card\'s own value is not drawn twice',
        D.head_hidden(field('Repeatable', 'No'), 'T', card.shown({repeatable = 'No'})) == true
        and D.head_hidden(field('Repeatable', 'Yes'), 'T', card.shown({repeatable = 'Yes'})) == true
        and D.head_hidden(field('Repeatable', 'Yes'), 'T', card.shown({repeatable = 'No'})) == false)
    check('head_hidden: a Repeatable holding a link reads as text', D.head_hidden(field('Repeatable', nil, {{t = 'text', s = 'Yes, after '},
        {t = 'link', s = 'Memory reset', to = 'x'}}), 'T', {printed = {repeatable = 'Yes, after Memory reset'}}) == true)
    -- Title: the same letters as the card's title are hidden (the card's own marks do not count); a list the card cuts to its first stays
    local ttl = field('Title', 'Royal Wedding Planner')
    local ttls = field('Title', nil, {{t = 'text', s = 'Royal Wedding Planner'}, {t = 'br'}, {t = 'text', s = 'Consort Candidate'}})
    check('card.printed: carries the title (nil when the entry has none)', card.printed({title = '*Royal Wedding Planner'}).title == '*Royal Wedding Planner'
        and card.printed({}).title == nil and card.printed({title = '  '}).title == nil)
    check('head_hidden: a Title with the card\'s letters is hidden', D.head_hidden(ttl, 'T', card.shown({title = '*Royal Wedding Planner'})) == true)
    check('head_hidden: a title list longer than the card\'s title stays', D.head_hidden(ttls, 'T', card.shown({title = 'Royal Wedding Planner'})) == false)
    check('head_hidden: a Title the card lacks stays', D.head_hidden(ttl, 'T', card.shown({})) == false and D.head_hidden(ttl, 'T', nil) == false)
    check('head_hidden: in a tab panel the card Title is hidden, another path Title stays', D.head_hidden(ttl, nil, card.shown({title = 'Royal Wedding Planner'})) == true
        and D.head_hidden(ttl, nil, card.shown({title = 'Other Title'})) == false and D.head_hidden(ttl, nil, card.shown({})) == false)
    local none_rw = field('Rewards', 'None')
    -- a tab panel's infobox against the card (cop 530): Next and Reward equal the card's, a path's own Previous / Starting NPC differ
    do
        local e = {previous = {'Desires of Emptiness'}, next = {'For Whom the Verse Is Sung'}, start_npc = 'Cid', start_zone = 'Metalworks', start_pos = 'H-8'}
        local c = card.shown(e)
        local function link(s) return {{t = 'link', s = s, kind = 'mission'}} end
        check('panel_hidden: Next equal to the card (case and spacing aside)', D.head_hidden(field('Next Mission', nil, link('For Whom the Verse is Sung')), nil, c) == true)
        check('panel_hidden: Previous that is another mission stays', D.head_hidden(field('Previous Mission', 'Three Paths'), nil, c) == false)
        check('panel_hidden: Starting NPC of another path stays, the card own goes', D.head_hidden(field('Starting NPC', "Hinaree, Southern San d'Oria"), nil, c) == false
            and D.head_hidden(field('Starting NPC', 'Cid, Metalworks'), nil, c) == true and D.head_hidden(field('Starting NPC', 'Cid, Metalworks (H-8)'), nil, c) == true)
        check('panel_hidden: Reward None goes where the card has none, stays where it has one', D.head_hidden(none_rw, nil, c) == true
            and D.head_hidden(none_rw, nil, card.shown({reward = 'Ring'})) == false)
        check('panel_hidden: a field with no counterpart on the card stays', D.head_hidden(field('Series', 'Chains of Promathia'), nil, c) == false)
        check('panel_hidden: a Name always goes', D.head_hidden(field('Name', 'X'), nil, c) == true and D.head_hidden(field('Name', 'X'), nil, nil) == true)
    end
    do  -- no entry: no field has a value; only the printed defaults are there
        local k = next(card.shown(nil))
        check('card.shown: no entry, no fields', k == 'printed' and next(card.shown(nil), k) == nil)
    end
    check('card.zone_text: a zoneless entry is the dash alone, never "-- (F-8)"', card.zone_text(e) == '--' and card.zone_text({start_zone = 'Z'}) == 'Z'
        and card.zone_text({start_zone = 'Z', start_pos = 'F-8'}) == 'Z (F-8)')

    -- a page whose every field is hidden has no header box: it draws exactly as the same page without a header
    local function page(meta, order)
        return D.decode({title = 'Q', page = 'Q', images = {}, meta = meta, meta_order = order, body = '=2 Walkthrough\nGo.\n'})
    end
    local all = page({Name = 'Q', ['Required Fame'] = 'F', Title = 'None', Pack = '--', ['Previous Quest'] = 'None'},
        {'Name', 'Required Fame', 'Title', 'Pack', 'Previous Quest'})
    local bare = page({}, {})
    local ba, bb = ops.new(), ops.new()
    local ha = D.draw(ba, all, 0, 0, 440, {card = {fame = true}})
    local hb = D.draw(bb, bare, 0, 0, 440, {})
    check('no field left: no header box, the page as without a header', ha == hb and table.concat(ba.o, '|') == table.concat(bb.o, '|'),
        ha .. ' vs ' .. hb)
    local bc = ops.new()
    local hc = D.draw(bc, all, 0, 0, 440, {})
    check('a field the card lacks draws the box (the same page, no card)', hc > ha and table.concat(bc.o, chr10):find(chr10 .. 'R	0	0	440	') ~= nil, bc.o[1])
    local nxt = page({Name = 'Q', ['Next Quest'] = '{q:Other|Other|Other}', Title = 'None'}, {'Name', 'Next Quest', 'Title'})
    local bd = ops.new()
    D.draw(bd, nxt, 0, 0, 440, {card = {title = true, fame = true}})
    local td = table.concat(bd.o, '|')
    check('Next Quest stays when the card has other things', td:find('	Next|') ~= nil and td:find('	Other') ~= nil and not td:find('	Title'), td:sub(1, 200))
end

-- table blocks (convert.py, Phase 1c): '|' rows, '^' header rows, '~r2c3h~' cell marks, a link whose own fields hold '|'
do
    local function page(body) return D.decode({title = 'T', page = 'T', images = {}, meta = {}, body = body}) end
    local d = page(table.concat({
        '=2 Walkthrough',
        '|^Area|Position|Name',
        "|~r2~{z:Southern San d'Oria}|(K-5)|{n:Daggao}",
        '|(J-9)|{p:Light|Light (Skillchain)}',
        '|~hc2~Band',
        '|\\^caret|\\~tilde|plain',
        '',
        '|One|Two',
    }, '\n'))
    local t1, t2 = d.blocks[2], d.blocks[3]
    check('table markup: two tables, a blank line apart', d.blocks[1].k == 'h' and t1 and t1.k == 'table' and t2 and t2.k == 'table' and #t1.rows == 5 and #t2.rows == 1,
        #d.blocks)
    check('table markup: ^ is a header row, every cell of it a th', t1.rows[1].head and t1.rows[1].cells[1].th and #t1.rows[1].cells == 3 and not t1.rows[2].head)
    check('table markup: ~r2~ is a rowspan, the next row has one cell fewer', t1.rows[2].cells[1].rs == 2 and #t1.rows[2].cells == 3 and #t1.rows[3].cells == 2)
    check('table markup: a link with | inside its braces stays one cell, with its target',
        #t1.rows[3].cells == 2 and t1.rows[3].cells[2].spans[1].t == 'link' and t1.rows[3].cells[2].spans[1].to == 'Light (Skillchain)'
        and t1.rows[3].cells[2].spans[1].s == 'Light', t1.rows[3].cells[2].spans[1])
    check('table markup: ~hc2~ is a th cell over two columns, not a header row', t1.rows[4].cells[1].th and t1.rows[4].cells[1].cs == 2 and not t1.rows[4].head)
    check('table markup: an escaped ^ or ~ at the start of a cell is text', t1.rows[5].cells[1].spans[1].s == '^caret' and t1.rows[5].cells[2].spans[1].s == '~tilde'
        and not t1.rows[5].head and not t1.rows[5].cells[1].th and t1.rows[5].cells[2].rs == 1, t1.rows[5].cells)
    -- layout: columns side by side, a header bar, a rowspan cell kept across its rows, nothing past the column
    local fixture = D.decode(dofile('test/fixtures/table_block.lua'))
    for _, w in ipairs({300, 440, 700, 1060}) do
        local b = ops.new()
        D.draw(b, fixture, 0, 0, w, {})
        local xs, over, ys = {}, 0, {}
        for _, line in ipairs(b.o) do
            if line:sub(1, 1) == 'T' then
                local x, y, s = line:match('^T\t([%-%d%.]+)\t([%-%d%.]+)\t%x+\t(.*)$')
                x, y = tonumber(x), tonumber(y)
                if x + ops.text_w(s) > w + 1 then over = over + 1 end
                if s == 'Area' or s == 'Position' or s == 'Name' then xs[s] = x ys[s] = y end
            end
        end
        check(('table layout w %d: nothing past the column'):format(w), over == 0, over)
        check(('table layout w %d: the header cells on one line, side by side, in order'):format(w), xs.Area and xs.Position and xs.Name and ys.Area == ys.Position
            and ys.Position == ys.Name and xs.Area < xs.Position and xs.Position < xs.Name, ('%s %s %s'):format(tostring(xs.Area), tostring(xs.Position), tostring(xs.Name)))
        local bars = 0
        for _, line in ipairs(b.o) do if line:find('^R\t[%-%d%.]+\t[%-%d%.]+\t[%-%d%.]+\t[%-%d%.]+\t783434C8$') then bars = bars + 1 end end
        check(('table layout w %d: a title bar behind each header row'):format(w), bars >= 3, bars)
    end
    -- the narrowest window: an eight-column grid runs each row's cells on, nothing is cut, thin bars between them
    local grid = D.decode(dofile('test/fixtures/table_wide.lua'))
    local b = ops.new()
    local h = D.draw(b, grid, 0, 0, 440, {})
    local over, words, bars = 0, {}, 0
    for _, line in ipairs(b.o) do
        if line:sub(1, 1) == 'T' then
            local x, s = line:match('^T\t([%-%d%.]+)\t[%-%d%.]+\t%x+\t(.*)$')
            if tonumber(x) + ops.text_w(s) > 441 then over = over + 1 end
            words[s] = true
        end
    end
    check('wide table at 440: every word drawn whole, none past the column', words.Apkallufa and words.Hoptoad and words["Ra'Kaznar"] and words.Contortopus and over == 0, over)
    -- a table with more than the window holds at its narrowest is shorter at 1060 (columns) than at 440 (runs of cells)
    local b2 = ops.new()
    local h2 = D.draw(b2, grid, 0, 0, 1060, {})
    check('wide table: columns at 1060 are shorter than the run-on rows at 440', h2 < h, h2 .. ' vs ' .. h)
    -- a wide picture (two screenshots side by side) is a block of its own, not a 168 px float where nothing can be read
    local pg = D.decode({title = 'T', page = 'T', images = {'Wide.png', 'Tall.png'}, meta = {}, body = '=2 A\n!Wide.png||\ntext\n!Tall.png||\n'})
    local function quads(width, pics)
        local bb = ops.new()
        D.draw(bb, pg, 0, 0, width, {pics = function(f) return pics[f] end})
        local out = {}
        for _, line in ipairs(bb.o) do
            if line:sub(1, 1) == 'Q' then
                local tex, x0, y0, x1, y1 = line:match('^Q\t(%d+)\t([%-%d%.]+)\t([%-%d%.]+)\t([%-%d%.]+)\t([%-%d%.]+)')
                out[#out + 1] = {tex = tonumber(tex), x0 = tonumber(x0), y0 = tonumber(y0), x1 = tonumber(x1), y1 = tonumber(y1)}
            end
        end
        return out
    end
    local pics = {['Wide.png'] = {h = 1, w = 746, h_px = 285}, ['Tall.png'] = {h = 2, w = 400, h_px = 300}}
    local q = quads(700, pics)
    local wide, tall
    for _, r in ipairs(q) do if r.tex == 1 then wide = r else tall = r end end
    check('wide picture at 700: 460 px wide, not at the right edge; a normal one still floats at 168', wide and tall and wide.x1 - wide.x0 == 460
        and tall.x1 - tall.x0 == 168 and tall.x1 == 700, (wide and (wide.x1 - wide.x0) or 'none') .. ' ' .. (tall and (tall.x1 - tall.x0) or 'none'))
    q = quads(440, pics)
    for _, r in ipairs(q) do if r.tex == 1 then wide = r else tall = r end end
    check('wide picture at 440: the width of the column, up to 440', wide.x1 - wide.x0 == 440 or wide.x1 - wide.x0 >= 400, wide.x1 - wide.x0)
end

-- a word wider than the column is broken: after a '/', '.', '-' ... when one is near the end of the room,
-- else by character; the pieces rebuild the word and each fits
do
    local word = 'https://forum.square-enix.com/ffxi/threads/50760-Jun.-7-2016-Version-Update'
    local parts = D.break_word(word, 300, 300, 0)
    check('break_word: pieces rebuild the word', table.concat(parts) == word, table.concat(parts, '|'))
    local fits = true
    for _, pc in ipairs(parts) do if ops.text_w(pc) > 300 then fits = false end end
    check('break_word: each piece fits', fits and #parts >= 2, table.concat(parts, '|'))
    local natural = true
    for i = 1, #parts - 1 do if not parts[i]:find('[/%.%-%?=&_,:%%]$') then natural = false end end
    check('break_word: breaks after a punctuation mark when one is near', natural, table.concat(parts, '|'))
    local plain = D.break_word(string.rep('a', 120), 200, 200, 0)
    check('break_word: no mark, by character', #plain >= 3 and table.concat(plain) == string.rep('a', 120) and ops.text_w(plain[1]) <= 200,
        #plain)
    check('break_word: a tail after the word still fits the last line',
        ops.text_w(D.break_word(word, 300, 300, 40)[#D.break_word(word, 300, 300, 40)]) + 40 <= 300)
    local none = D.break_word(string.rep('a', 20), 3, 200, 0)
    check('break_word: no room on this line starts the next', none[1] == '' and table.concat(none) == string.rep('a', 20), #none)
    check('break_word: a word that fits is one piece', #D.break_word('short', 300, 300, 0) == 1)
end

-- 2026-10-20 (Phase 1d): an icon's label and the word it stands for, a closing mark after a space, a long alt text, a link in a heading
do
    local function spans(markup) return D.inline(markup) end
    local function shows(markup)
        local sp = spans(markup)
        for i, s in ipairs(sp) do if s.t == 'icon' then return D.icon_shows_label(sp, i) end end
    end
    check('icon label: the same word right after is not repeated', shows('{@a:Sight}Sight') == false)
    check('icon label: ...nor past a space of its own', shows('{@g:Sight} **{p:Sight}**') == false)
    check('icon label: ...nor when the label ends with the word ("Element: Ice" before "Ice")', shows('{@g:Element: Ice|Ice} **{p:Ice}**') == false)
    check('icon label: a different word after it keeps the label', shows('{@g:Element: Ice|Ice} **{p:Fire}**') == true)
    check('icon label: nothing after it keeps the label', shows('weak to {@g:Element: Ice|Ice}') == true)

    -- an icon's label inside a sentence is the plain word ("Element: Fire" is "Fire"); at the start of a line it is a chip with its whole label
    local function drawn(markup)
        local sp = spans(markup)
        for i, s in ipairs(sp) do if s.t == 'icon' then return D.icon_text(sp, i) end end
    end
    local t1, p1 = drawn('is Red{@g:Element: Fire|Fire}. Hot spells')
    local t2, p2 = drawn('Use {@g:Two-Hour ability|Two-Hour ability} {p:Manafont}')
    local t3, p3 = drawn('{@g:Element: Fire|Fire}{br}Zones')
    local t4, p4 = drawn('weak to {@g:Element: Ice|Ice}')
    check('icon text: in a sentence the plain word, the template prefix gone', t1 == 'Fire' and p1 == true, tostring(t1))
    check('icon text: a label with no prefix keeps its words', t2 == 'Two-Hour ability' and p2 == true, tostring(t2))
    check('icon text: at the start of a line it is a chip with the whole label', t3 == 'Element: Fire' and p3 == false, tostring(t3))
    check('icon text: nothing after it, a chip', t4 == 'Element: Ice' and p4 == false, tostring(t4))
    do
        local keep = D.INLINE_CHIPS
        D.INLINE_CHIPS = true
        local t5, p5 = drawn('is Red{@g:Element: Fire|Fire}. Hot spells')
        D.INLINE_CHIPS = keep
        check('icon text: the old behaviour was a chip anywhere (the fault this guards)', t5 == 'Element: Fire' and p5 == false, tostring(t5))
    end

    -- a run of pictures the text beside cannot fill is rows under their label; one the text fills floats
    local NL = string.char(10)
    local function pics_of(markup, W)
        local b = ops.new()
        local fake = {h = 99, w = 400, h_px = 300}
        local h = D.draw(b, D.decode({page = 'x', title = 'x', images = {'a.jpg', 'b.jpg', 'c.jpg', 'd.jpg', 'e.jpg', 'f.jpg'}, meta = {},
            body = '=2 W' .. NL .. markup}), 0, 0, W, {pics = function() return fake end})
        local xs, ys = {}, {}
        for _, l in ipairs(b.o) do
            local x0, y0 = l:match('^Q\t%d+\t([%-%d%.]+)\t([%-%d%.]+)')
            if x0 then xs[tonumber(x0)] = true ys[tonumber(y0)] = true end
        end
        local nx, ny = 0, 0
        for _ in pairs(xs) do nx = nx + 1 end
        for _ in pairs(ys) do ny = ny + 1 end
        return nx, ny, h
    end
    local RUN = table.concat({'>**Label**', '!a.jpg||A', '!b.jpg||B', '!c.jpg||C', '!d.jpg||D', '!e.jpg||E', '!f.jpg||F', '* Then go.'}, NL)
    local nx, ny = pics_of(RUN, 860)
    check('run of pictures, short text after: rows (several columns of x, at most two rows of y)', nx >= 3 and ny <= 2, nx .. ' columns, ' .. ny .. ' rows')
    local TEXT = string.rep('This is a long paragraph of text that fills the room beside a column of pictures floated at the right. ', 12)
    local nx2, ny2 = pics_of(table.concat({'!a.jpg||A', '!b.jpg||B', '* ' .. TEXT, '* ' .. TEXT, '* ' .. TEXT}, NL), 860)
    check('run of two pictures, long text after: floated in one column', nx2 == 1 and ny2 == 2, nx2 .. ' columns, ' .. ny2 .. ' rows')
    local nx3 = pics_of('!a.jpg||A', 860)
    check('one picture floats', nx3 == 1)
    -- rule 150: the only content of a box is drawn in the box's width; a box with text keeps its picture at the right
    local function box_pic_x(markup, W)
        local b = ops.new()
        local fake = {h = 99, w = 400, h_px = 300}
        D.draw(b, D.decode({page = 'x', title = 'x', images = {'a.jpg', 'b.jpg'}, meta = {}, body = '=2 W' .. NL .. markup}), 0, 0, W, {pics = function() return fake end})
        local xs = {}
        for _, l in ipairs(b.o) do
            local x0, x1 = l:match('^Q\t%d+\t([%-%d%.]+)\t[%-%d%.]+\t([%-%d%.]+)')
            if x0 then xs[#xs + 1] = {tonumber(x0), tonumber(x1)} end
        end
        return xs
    end
    local BOX1 = '[Map' .. NL .. '!a.jpg||' .. NL .. ']'
    local lone = box_pic_x(BOX1, 860)
    check('rule 150: the only picture of a titled box is not floated at the right (centred, 260 px)', #lone == 1 and lone[1][2] - lone[1][1] == 260 and 860 - lone[1][2] > 100, lone[1] and lone[1][1])
    local lone2 = box_pic_x('[' .. NL .. '!a.jpg||' .. NL .. '!b.jpg||' .. NL .. ']', 860)
    check('rule 150: two pictures alone in an untitled box: one row, not at the right', #lone2 == 2 and 860 - lone2[2][2] > 100 and lone2[2][1] > lone2[1][2], #lone2)
    local lone3 = box_pic_x(BOX1, 440)
    D.LONE_PICTURE = false
    local lone3b = box_pic_x(BOX1, 440)
    local old = box_pic_x(BOX1, 860)
    D.LONE_PICTURE = true
    check('rule 150: below the float width the layout is unchanged', #lone3 == 1 and #lone3b == 1 and lone3[1][1] == lone3b[1][1] and lone3[1][2] == lone3b[1][2])
    check('rule 150: the old layout floated it at 168 px at the right (the fault this guards)', #old == 1 and old[1][2] - old[1][1] == 168 and old[1][1] > 500, old[1] and old[1][1])
    local withtext = box_pic_x('[Map' .. NL .. '!a.jpg||' .. NL .. '* ' .. TEXT .. NL .. ']', 860)
    check('rule 150: a box with text keeps its picture at the right', #withtext == 1 and withtext[1][2] - withtext[1][1] == 168 and withtext[1][1] > 500, withtext[1] and withtext[1][1])
    local outside = box_pic_x('!a.jpg||' .. NL .. '* ' .. TEXT, 860)
    check('rule 150: a picture outside a box floats at the right', #outside == 1 and outside[1][2] - outside[1][1] == 168 and outside[1][1] > 500)
    D.FLOAT_RUNS = true
    local nx4, ny4 = pics_of(RUN, 860)
    D.FLOAT_RUNS = nil
    check('run of pictures, the old behaviour: one column of six (the fault this guards)', nx4 == 1 and ny4 == 6, nx4 .. ' columns, ' .. ny4 .. ' rows')

    -- a closing mark after a space is drawn against the word before it: it never starts a line
    local function lines_of(markup, W)
        local b = ops.new()
        D.draw(b, D.decode({page = 'x', title = 'x', images = {}, meta = {}, body = '=2 W\n' .. markup}), 0, 0, W, {})
        local rows = {}
        for _, l in ipairs(b.o) do
            local x, y, s = l:match('^T\t([%-%d%.]+)\t([%-%d%.]+)\t%x+\t(.*)$')
            if x then rows[tonumber(y)] = (rows[tonumber(y)] or '') .. s end
        end
        local ys = {}
        for y in pairs(rows) do ys[#ys + 1] = y end
        table.sort(ys)
        local out = {}
        for _, y in ipairs(ys) do out[#out + 1] = rows[y] end
        return out
    end
    local alone = false
    for n = 1, 40 do
        local text = string.rep('word ', n) .. '/clock )'
        for _, l in ipairs(lines_of(text, 440)) do if l:match('^%s*%)$') then alone = true end end
    end
    check('closing mark: after a space it stays with its word at every length', not alone)
    D.GLUE_CLOSERS = false
    local alone2 = false
    for n = 1, 40 do
        for _, l in ipairs(lines_of(string.rep('word ', n) .. '/clock )', 440)) do if l:match('^%s*%)$') then alone2 = true end end
    end
    D.GLUE_CLOSERS = true
    check('closing mark: the old layout left it alone on a line (the fault this guards)', alone2)
    -- "???" is a word, not a closing mark: the space before it stays (bastok 0 drew "a???"). Judged by position: a word drawn
    -- against the one before it (a gap under 3 px) has no space between them.
    local function touching(markup, ends, starts)
        local b = ops.new()
        D.draw(b, D.decode({page = 'x', title = 'x', images = {}, meta = {}, body = '=2 W' .. string.char(10) .. markup}), 0, 0, 440, {})
        local items = {}
        for _, l in ipairs(b.o) do
            local x, y, s = l:match('^T	([%-%d%.]+)	([%-%d%.]+)	%x+	(.*)$')
            if x then items[#items + 1] = {x = tonumber(x), y = tonumber(y), s = s, w = ops.text_w(s)} end
        end
        table.sort(items, function(a, c) if a.y ~= c.y then return a.y < c.y end return a.x < c.x end)
        for i = 2, #items do
            local a, c = items[i - 1], items[i]
            if a.y == c.y and a.s:find(ends) and c.s:find(starts) and c.x - (a.x + a.w) < 3 then return true end
        end
        return false
    end
    check('placeholder: a space before "???" stays', not touching('Travel to J-9 and look for a ???. The ??? will appear, then examine the ??? again', '%w$', '^%?%?%?'))
    check('placeholder: a space before "???." after a bold run stays', not touching('look for a **???**. Then the **???**, or a ???.', '%w$', '^%?%?%?'))
    D.GLUE_PLACEHOLDER = true
    local glued_old = touching('look for a ???. The ??? will appear', '%w$', '^%?%?%?')
    D.GLUE_PLACEHOLDER = false
    check('placeholder: the old layout glued it to the word before (the fault this guards)', glued_old)
    check('closing mark: a single "?" still closes the sentence it follows', touching('what is it ?', '%w$', '^%?'))

    -- a sentence for an icon's label wraps inside the column; as a chip it would not
    local sentence = 'The chance of seeing drop is increased after procing yellow abilities on the monster.'
    local function widest(markup, W)
        local b, wmax = ops.new(), 0
        D.draw(b, D.decode({page = 'x', title = 'x', images = {}, meta = {}, body = '=2 W\n' .. markup}), 0, 0, W, {})
        for _, l in ipairs(b.o) do
            local x, _, s = l:match('^T\t([%-%d%.]+)\t([%-%d%.]+)\t%x+\t(.*)$')
            if x then wmax = math.max(wmax, tonumber(x) + ops.text_w(s)) end
        end
        return wmax
    end
    check('long label: wraps inside a 440 px column', widest('Free space. {@g:' .. sentence .. '}', 440) <= 441, widest('Free space. {@g:' .. sentence .. '}', 440))
    D.CHIP_WRAP = false
    check('long label: as a chip it ran out of the column (the fault this guards)', widest('Free space. {@g:' .. sentence .. '}', 440) > 441)
    D.CHIP_WRAP = true
    check('short label: still a chip', widest('{@g:Magic}', 440) > 0 and (function()
        local b = ops.new()
        D.draw(b, D.decode({page = 'x', title = 'x', images = {}, meta = {}, body = '=2 W\n{@g:Magic}'}), 0, 0, 440, {})
        for _, l in ipairs(b.o) do if l:sub(1, 1) == 'R' and l:find('FFFFFF16', 1, true) then return true end end
        return false
    end)())

    -- a link in a heading: one hit per word, each over the word
    do
        local b = ops.new()
        D.draw(b, D.decode({page = 'x', title = 'x', images = {}, meta = {}, body = '=2 {z:Maze of Shakhrami}\nGo.'}), 0, 0, 440, {})
        local hits = {}
        for _, h in ipairs(b.hits) do if h.id == 'link' then hits[#hits + 1] = h end end
        check('heading link: a hit for each of the three words', #hits == 3 and hits[1].x1 <= hits[2].x0 + 1 and hits[2].x1 <= hits[3].x0 + 1
            and hits[1].to == 'Maze of Shakhrami', #hits)
        D.HEAD_HITS = false
        local b2 = ops.new()
        D.draw(b2, D.decode({page = 'x', title = 'x', images = {}, meta = {}, body = '=2 {z:Maze of Shakhrami}\nGo.'}), 0, 0, 440, {})
        D.HEAD_HITS = true
        check('heading link: the old layout had none (the fault this guards)', #b2.hits == 0, #b2.hits)
    end
end

-- core/gif.lua (rule 79): the renderer reads PNG, JPEG and BMP, and BG-wiki has some pictures as GIFs only (adoulin 280's two floor maps).
-- A GIF becomes an 8-bit BMP pixel for pixel; fixtures/gifs.lua holds GIFs and the pixels PIL decodes from them.
do
    local gif = require('core/gif')
    local fx = dofile('test/fixtures/gifs.lua')
    local function bmp_pixels(bmp)
        local function u32(i) return bmp:byte(i) + bmp:byte(i + 1) * 256 + bmp:byte(i + 2) * 65536 + bmp:byte(i + 3) * 16777216 end
        if bmp:sub(1, 2) ~= 'BM' or u32(15) ~= 40 then return nil end
        local w, h, bpp, off = u32(19), u32(23), bmp:byte(29), u32(11)
        if bpp ~= 8 or u32(31) ~= 0 then return nil end
        local rb = math.ceil(w / 4) * 4
        local t = {}
        for y = 0, h - 1 do                                         -- bottom-up
            local row = off + (h - 1 - y) * rb
            for x = 0, w - 1 do
                local i = bmp:byte(row + x + 1)
                local p = 55 + i * 4
                t[#t + 1] = ('%02x%02x%02x'):format(bmp:byte(p + 2), bmp:byte(p + 1), bmp:byte(p))
            end
        end
        return w, h, table.concat(t), #bmp == off + rb * h
    end
    local names = {}
    for k in pairs(fx) do names[#names + 1] = k end
    table.sort(names)
    for _, k in ipairs(names) do
        local f = fx[k]
        local raw = f.gif:gsub('%x%x', function(h) return string.char(tonumber(h, 16)) end)
        local gw, gh = gif.size(raw)
        check('gif ' .. k .. ': size', gw == f.w and gh == f.h, tostring(gw) .. 'x' .. tostring(gh))
        local bmp, why = gif.to_bmp(raw)
        check('gif ' .. k .. ': converted', bmp ~= nil, why)
        if bmp then
            local w, h, px, whole = bmp_pixels(bmp)
            check('gif ' .. k .. ': a BMP of the same size, 8 bits, no compression, the size the header says', w == f.w and h == f.h and whole == true, tostring(w) .. 'x' .. tostring(h))
            check('gif ' .. k .. ': every pixel as the GIF decoder gives it', px == f.rgb)
        end
    end
    check('gif: a cut file is refused, not drawn', gif.to_bmp((fx.noise_plain.gif:gsub('%x%x', function(h) return string.char(tonumber(h, 16)) end)):sub(1, 60)) == nil)
    local png = string.char(137) .. 'PNG' .. string.char(13, 10, 26, 10) .. string.rep('x', 20)
    check('gif: a PNG is not one', gif.size(png) == nil and gif.to_bmp(png) == nil)
end

print(('  decoded page: %.0f KB of heap (markup %d KB)'):format(heap1 - heap0, #mk.body / 1024))
check('decoded page under 400 KB of heap', heap1 - heap0 < 400, heap1 - heap0)
print(('test_doc: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)

--[[
    test_progress_ui.lua - step progress on the page (ui/doc.lua checkboxes, ui/screens/guide.lua strip), against the real
    page of A Purchase of Arms (pages/quests/sandoria/27.lua) with a stub of core/progress.lua's for_page result:
      - each mapped top-level bullet is drawn as the checkbox of its state instead of the gold bullet, and every text
        command (every word, where it stands) is the same as without progress, at three widths
      - a step whose fingerprint does not match its bullet is not marked (the draw is byte for byte the plain one)
      - the strip: "Step N of M:" with the next step's own bullet text; with nothing next, the count only
      - one-step groups (any-order steps, routes) share a row: the count as the lead, "Any order" while several are open

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_progress_ui.lua
]]

package.path = './?.lua;' .. package.path
local ops = require('ui/ops')
local kit = require('ui/kit')
local D = require('ui/doc')

local pass, fail = 0, 0
local function check(name, cond, detail)
    if cond then pass = pass + 1 else
        fail = fail + 1
        print('FAIL ' .. name .. (detail ~= nil and (': ' .. tostring(detail)) or ''))
    end
end

local KEY = 'quest|sandoria|27'
local doc = D.decode(dofile('pages/quests/sandoria/27.lua'))
local FP = {'speak to helbort in southern', 'bring the weapons order to alexius', 'return to helbort to complete'}

local function progress(states, fps)
    local p = {steps = {}, rows = {{label = nil, steps = {}}}}
    for i, s in ipairs(states) do
        p.steps[i] = {n = i, tab = nil, fp = (fps or FP)[i], shown = s}
        p.rows[1].steps[i] = i
    end
    return p
end

local function draw(w, prog)
    local b = ops.new()
    local h = D.draw(b, doc, 0, 0, w, {progress = prog})
    return b, h
end

local function lines(b, pat)
    local out = {}
    for _, l in ipairs(b.o) do if l:match(pat) then out[#out + 1] = l end end
    return out
end

local GOLD = ops.hex(kit.C.gold)
local function bullets(b)          -- the level-1 bullets: 5 x 5 gold rects -> their tops
    local out = {}
    for _, l in ipairs(b.o) do
        local x0, y0, x1, y1, col = l:match('^R\t([%d%.%-]+)\t([%d%.%-]+)\t([%d%.%-]+)\t([%d%.%-]+)\t(%x+)$')
        if col == GOLD and tonumber(x1) - tonumber(x0) == 5 and tonumber(y1) - tonumber(y0) == 5 then
            out[#out + 1] = {x0 = tonumber(x0), y0 = tonumber(y0)}
        end
    end
    return out
end

-- the commands kit.step_box draws for a state at (x, y)
local function box_cmds(state, x, y)
    local b = ops.new()
    kit.step_box(b, x, y, state)
    return b.o
end

local function has_run(o, run)     -- run appears in o as consecutive lines
    for i = 1, #o - #run + 1 do
        local same = true
        for k = 1, #run do if o[i + k - 1] ~= run[k] then same = false break end end
        if same then return true end
    end
    return false
end

local CASES = {
    {name = 'accepted', states = {'done', 'next', 'todo'}},
    {name = 'receipt', states = {'done', 'done', 'next'}},
    {name = 'complete', states = {'done', 'done', 'done'}},
    {name = 'not started', states = {'next', 'todo', 'todo'}},
}

for _, w in ipairs({440, 580, 900}) do
    local plain, h0 = draw(w, nil)
    local bl = bullets(plain)
    check(w .. ': the page has three top-level bullets', #bl == 3, #bl)
    local text0 = table.concat(lines(plain, '^[TH]\t'), '\n')
    for _, c in ipairs(CASES) do
        local b, h = draw(w, progress(c.states))
        local what = w .. ' ' .. c.name
        check(what .. ': same height', h == h0, h .. ' vs ' .. h0)
        check(what .. ': every word where it was', table.concat(lines(b, '^[TH]\t'), '\n') == text0)
        check(what .. ': no gold bullet left on a step', #bullets(b) == 0, #bullets(b))
        for i, st in ipairs(c.states) do
            local x, y = bl[i].x0 - 4, bl[i].y0 - 3          -- the box sits where the bullet was
            check(what .. ': bullet ' .. i .. ' is a ' .. st .. ' box', has_run(b.o, box_cmds(st, x, y)))
            for _, other in ipairs({'done', 'next', 'todo'}) do
                if other ~= st then check(what .. ': bullet ' .. i .. ' is not a ' .. other .. ' box', not has_run(b.o, box_cmds(other, x, y))) end
            end
        end
    end
    -- stale fingerprints: nothing marked
    local b = draw(w, progress({'done', 'next', 'todo'}, {'talk to someone', 'bring the weapons order to alexius', 'x'}))
    check(w .. ' stale fp: only the matching bullet is marked', #bullets(b) == 2, #bullets(b))
    b = draw(w, progress({'done', 'next', 'todo'}, {'zz one', 'zz two', 'zz three'}))
    check(w .. ' no fp matches: the plain page, byte for byte', b:text_out() == plain:text_out())
    -- a step addressed to a tab the page does not have: nothing marked
    local p = progress({'done', 'next', 'todo'})
    for _, s in ipairs(p.steps) do s.tab = 'Past Sins' end
    b = draw(w, p)
    check(w .. ' wrong tab: the plain page', b:text_out() == plain:text_out())
end

-- a bullet inside a box is not a step: Three Paths' tab 3 (Ulmia) has bullets in boxes; address each box bullet's ordinal as if
-- counted and check nothing in the box changes
do
    local d530 = D.decode(dofile('pages/missions/cop/530.lua'))
    local function d(prog)
        local b = ops.new()
        D.draw(b, d530, 0, 0, 700, {tabs = {[1] = 3}, progress = prog})
        return b
    end
    local plain = d(nil)
    local label = 'Where Messengers Gather'
    local steps = {}
    for n = 1, 40 do steps[#steps + 1] = {n = n, tab = label, fp = 'some form of reraise', shown = 'done'} end
    local b = d({steps = steps, rows = {}})
    check('530: a box\'s bullets are never steps', b:text_out() == plain:text_out())
    -- and a tab's own bullet is: Ulmia's second top-level bullet (Hinaree)
    local t = D.step_text(d530, label, 2, 'head to southern san d oria')
    check('530: step_text finds a tab\'s bullet', t and t:find('^Head to Southern San d\'Oria') ~= nil, t)
    b = d({steps = {{n = 2, tab = label, fp = 'head to southern san d oria', shown = 'next'}}, rows = {}})
    check('530: the tab\'s bullet is marked', #bullets(b) == #bullets(plain) - 1, #bullets(b) .. ' vs ' .. #bullets(plain))
end

-- the strip's text: the next step's own bullet text
do
    check('step_text: bullet 2', D.step_text(doc, nil, 2, FP[2]) == 'Bring the Weapons order to Alexius in Jugner Forest (I-6) near the lake.',
        D.step_text(doc, nil, 2, FP[2]))
    check('step_text: a stale fingerprint gives nothing', D.step_text(doc, nil, 2, 'speak to') == nil)
    check('step_text: no such bullet', D.step_text(doc, nil, 9, nil) == nil)

    -- ui/screens/guide.lua's strip, with the page open (core/pages stub) and a stub app.progress
    _G.windower = _G.windower or {addon_path = './', ffxi = {}}
    package.loaded['core/pages'] = {current = function() return {key = KEY, doc = doc} end}
    local G = require('ui/screens/guide')
    local p = {cat = 'quest', area = 'sandoria', name = 'A Purchase of Arms', id = 27}
    local function strip(states, w)
        local b = ops.new()
        local app = {progress = {for_page = function(k) return k == KEY and progress(states) or nil end}}
        local prog = G.progress(app, p)
        local y = prog and G.strip(b, 20, 20 + w, 78, prog, p) or 78
        local texts = {}
        for _, l in ipairs(lines(b, '^T\t')) do texts[#texts + 1] = l:match('\t([^\t]*)$') end
        return texts, y, b
    end
    for _, w in ipairs({440, 580}) do
        local t, y = strip({'done', 'next', 'todo'}, w)
        check(w .. ' strip accepted: "Step 2 of 3: "', t[1] == 'Step 2 of 3: ', t[1])
        check(w .. ' strip accepted: the bullet\'s text', t[2] and ('Bring the Weapons order to Alexius in Jugner Forest (I-6) near the lake.'):sub(1, #t[2] - 2) == t[2]:gsub('%.%.$', ''), t[2])
        check(w .. ' strip: the header grows', y > 78, y)
        t = strip({'done', 'done', 'next'}, w)
        check(w .. ' strip receipt: "Step 3 of 3: "', t[1] == 'Step 3 of 3: ' and t[2] and t[2]:find('^Return to Helbort') ~= nil, tostring(t[1]) .. ' / ' .. tostring(t[2]))
        t = strip({'done', 'done', 'done'}, w)
        check(w .. ' strip complete: the count only', #t == 1 and t[1] == '3/3', table.concat(t, '|'))
    end
    -- the strip's text fits its line: every text command ends inside the strip's width
    for _, w in ipairs({440, 580}) do
        local _, _, b = strip({'done', 'next', 'todo'}, w)
        local right = 0
        for _, l in ipairs(lines(b, '^T\t')) do
            local x, s = l:match('^T\t([%d%.%-]+)\t[%d%.%-]+\t%x+\t(.*)$')
            right = math.max(right, tonumber(x) + ops.text_w(s))
        end
        check(w .. ' strip: no text past the right edge', right <= 20 + w, right)
    end
    -- no mapping: nothing
    local b = ops.new()
    check('strip: no step mapping, no progress', G.progress({progress = {for_page = function() return nil end}}, p) == nil)
    check('strip: no progress module', G.progress({}, p) == nil)
end

-- Rule 147 (vision, toau 6 12 21 28 44 93, other 79, outlands 135 199): the strip's hint was cut at a pixel by ops.fit, so it ended in the
-- middle of a word ("Palace Do..", "cut-scen..") or on an open bracket ("(.."). Every committed step mapping, every step shown as the next
-- one, at the three window widths of the pixel gate (480, 760, 1100): the drawn hint is the whole text, or a prefix of it that ends at a
-- word (the next character of the text is a space, after any joining marks) with no space, open bracket or joining mark last, then "..";
-- only when the first word alone is too wide is it cut inside the word (ops.fit). ops.WORD_FIT = false is the cut before rule 147.
do
    local JOINSET = '[%(%[{<,;:%-/&+=|%.!%?]'
    local function word_cut_ok(hint, full, room)
        if hint == full then return true end
        if hint:sub(-2) ~= '..' then return false, 'no ".." on a cut text' end
        local core = hint:sub(1, -3)
        if core == '' or full:sub(1, #core) ~= core then return false, 'not a prefix' end
        if core:find('[%s%(%[{<,;:%-/&+=|%.!%?]$') then return false, 'ends on "' .. core:sub(-1) .. '"' end
        local rest = full:sub(#core + 1)
        if rest:find('^' .. JOINSET .. '*%s') then return true end
        -- cut inside the first word: only when that word alone does not fit
        local first = full:match('^%S+')
        if not core:find('%s') and first and ops.text_w(first .. '..') > room and hint == ops.fit(full, room) then return true end
        return false, 'ends inside "' .. (core:match('%S+$') or '') .. '"'
    end
    local index = dofile('progress/index.lua')
    local keys = {}
    for k in pairs(index) do keys[#keys + 1] = k end
    table.sort(keys)
    local pages_stub = {cur = nil}
    package.loaded['core/pages'] = {current = function() return pages_stub.cur end}
    local G = require('ui/screens/guide')
    local common = require('ui/screens/common')
    local P = require('core/progress')
    local function scan()
        local bad, pagesbad, tried, cut = {}, {}, 0, 0
        for _, key in ipairs(keys) do
            local cat, area, id = key:match('^(%a+)|([%w_]+)|(%d+)$')
            local mf = loadfile(('progress/%ss/%s/%s.lua'):format(cat, area, id))
            local pf = loadfile(('pages/%ss/%s/%s.lua'):format(cat, area, id))
            if mf and pf then
                local m, pdoc = mf(), D.decode(pf())
                pages_stub.cur = {key = key, doc = pdoc}
                local steps, groups, order = {}, {}, {}
                for _, s in ipairs(m.steps) do
                    if s.kind ~= 'note' then
                        steps[#steps + 1] = {n = s.at.n, tab = s.at.tab, fp = s.at.fp, g = s.group or 'main'}
                        local g = s.group or 'main'
                        if not groups[g] then
                            groups[g] = {label = m.groups and m.groups[g] and m.groups[g].label, steps = {}}
                            order[#order + 1] = g
                        end
                        table.insert(groups[g].steps, #steps)
                    end
                end
                for i, st in ipairs(steps) do
                    local full = D.step_text(pdoc, st.tab, st.n, st.fp)
                    if full then
                        local prog = {steps = {}, rows = {}}
                        for k, s2 in ipairs(steps) do
                            local shown = 'todo'
                            if k == i then shown = 'next' elseif s2.g == st.g and k < i then shown = 'done' end
                            prog.steps[k] = {n = s2.n, tab = s2.tab, fp = s2.fp, shown = shown}
                        end
                        for _, g in ipairs(order) do prog.rows[#prog.rows + 1] = {label = groups[g].label, steps = groups[g].steps} end
                        prog.rows = P._join_rows(prog.rows)
                        for _, W in ipairs({480, 760, 1100}) do
                            local x0, x1 = common.PAD, W - common.PAD
                            local b = ops.new()
                            G.strip(b, x0, x1, 78, prog, {cat = cat, area = area, id = tonumber(id)})
                            local ts = {}
                            for _, l in ipairs(b.o) do
                                local x, y, s = l:match('^T\t([%d%.%-]+)\t([%d%.%-]+)\t%x+\t(.*)$')
                                if x then ts[#ts + 1] = {x = tonumber(x), y = y, s = s} end
                            end
                            for k, t in ipairs(ts) do
                                if t.s:find('step %d+ of %d+: $') or t.s:find('^Step %d+ of %d+: $') or t.s:find('^%d+/%d+: $') then
                                    local nxt = ts[k + 1]
                                    local lx = t.x + ops.text_w(t.s)
                                    if x1 - lx > 30 then
                                        tried = tried + 1
                                        local hint = nxt and nxt.y == t.y and nxt.s
                                        if not hint then
                                            bad[#bad + 1] = ('%s step %d at %d: no hint drawn'):format(key, i, W)
                                            pagesbad[key] = true
                                        else
                                            if hint ~= full then cut = cut + 1 end
                                            local ok, why = word_cut_ok(hint, full, x1 - lx)
                                            if not ok then
                                                bad[#bad + 1] = ('%s step %d at %d: "%s" (%s)'):format(key, i, W, hint, why)
                                                pagesbad[key] = true
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        local n = 0
        for _ in pairs(pagesbad) do n = n + 1 end
        return bad, n, tried, cut
    end
    local bad, npages, tried, cut = scan()
    check('the strip hint is the whole step text or ends at a word (' .. tried .. ' hints, ' .. cut .. ' of them cut, every mapped page, 3 widths)',
        #bad == 0 and tried > 3000 and cut > 500, #bad .. ' in ' .. npages .. ' pages, e.g. ' .. tostring(bad[1]))
    -- the cut itself
    local W = ops.text_w
    local f = ops.fit_words
    check('fit_words: a text that fits is whole', f('Open the Palace Doors', 400) == 'Open the Palace Doors')
    check('fit_words: "Palace Doors" is not cut inside Doors', f('Open the Palace Doors', W('Open the Palace Do..') + 1) == 'Open the Palace..',
        f('Open the Palace Doors', W('Open the Palace Do..') + 1))
    check('fit_words: "cut-scene" is not cut inside the word', f('Watch the cut-scene then leave', W('Watch the cut-scen..') + 1) == 'Watch the..',
        f('Watch the cut-scene then leave', W('Watch the cut-scen..') + 1))
    check('fit_words: no open bracket before the dots', f('Go to (Map 1) soon', W('Go to (..') + 1) == 'Go to..', f('Go to (Map 1) soon', W('Go to (..') + 1))
    check('fit_words: a comma or a dash before the dots is dropped', f('Speak to Ratihb, then wait', W('Speak to Ratihb,..') + 1) == 'Speak to Ratihb..'
        and f('Walk to the gate - then wait', W('Walk to the gate -..') + 1) == 'Walk to the gate..')
    check('fit_words: a full stop, "!" or "?" before the dots is dropped (not "Lower Jeuno...")',
        f('Talk to him. Then go', W('Talk to him...') + 1) == 'Talk to him..' and f('Really? Yes it is', W('Really?..') + 1) == 'Really..'
        and f('Go to Lower Jeuno. Then wait', W('Go to Lower Jeuno...') + 1) == 'Go to Lower Jeuno..',
        f('Talk to him. Then go', W('Talk to him...') + 1) .. ' / ' .. f('Really? Yes it is', W('Really?..') + 1))
    check('fit_words: a run of marks is dropped whole', f('Wait?! Then go', W('Wait?!..') + 1) == 'Wait..', f('Wait?! Then go', W('Wait?!..') + 1))
    check('fit_words: a first word too wide is cut inside it', f('Supercalifragilistic word', 60) == ops.fit('Supercalifragilistic word', 60), f('Supercalifragilistic word', 60))
    ops.WORD_FIT = false
    local old, oldpages = scan()
    check('fit_words off is fit', f('Open the Palace Doors', W('Open the Palace Do..') + 1) == ops.fit('Open the Palace Doors', W('Open the Palace Do..') + 1))
    ops.WORD_FIT = true
    ops.WORD_STOPS = false
    local nostops, nostoppages = scan()
    ops.WORD_STOPS = true
    check('self-test: with the full stop kept the scan finds hints ending in a mark before the dots (caught)', #nostops > 10, #nostops .. ' in ' .. nostoppages .. ' pages, e.g. ' .. tostring(nostops[1]))
    print(('rule 147 stops: without WORD_STOPS %d faults in %d pages'):format(#nostops, nostoppages))
    check('self-test: with the old cut the scan finds hints cut inside a word or on a bracket (caught)', #old > 100 and oldpages > 20, #old .. ' in ' .. oldpages .. ' pages, e.g. ' .. tostring(old[1]))
    print(('rule 147 scan: %d hints, %d cut; old cut: %d faults in %d pages'):format(tried, cut, #old, oldpages))

    -- One-step groups share a row (zilart 10 and wotg 49 drew 8 and 7 unlabelled rows, flagged major, 165 to 245 px pinned on every frame).
    -- join_rows itself: runs of two or more, a label or a longer group ends a run, nothing else moves
    local function row(n, label)
        local r = {steps = {}, label = label}
        for k = 1, n do r.steps[k] = k end
        return r
    end
    local function shape(rows)
        local t = {}
        for _, r in ipairs(rows) do t[#t + 1] = (r.joined and 'j' or '') .. #r.steps .. (r.label and 'L' or '') end
        return table.concat(t, ' ')
    end
    local function joined(...)
        local rows = {}
        for _, a in ipairs({...}) do rows[#rows + 1] = type(a) == 'table' and row(a[1], a[2]) or row(a) end
        return shape(P._join_rows(rows))
    end
    check('join: seven one-step groups, one row', joined(1, 1, 1, 1, 1, 1, 1) == 'j7', joined(1, 1, 1, 1, 1, 1, 1))
    check('join: a lone one-step group between paths keeps its row', joined(1, 8, 10) == '1 8 10' and joined(5, 12, 1) == '5 12 1', joined(1, 8, 10))
    check('join: three then a two-step group', joined(1, 1, 1, 2) == 'j3 2', joined(1, 1, 1, 2))
    check('join: a longer group ends a run', joined(1, 1, 3, 1, 1) == 'j2 3 j2', joined(1, 1, 3, 1, 1))
    check('join: a labelled group keeps its row', joined({1, 'Ulmia'}, 1, 1) == '1L j2' and joined(1, {1, 'Tenzen'}) == '1 1L', joined({1, 'Ulmia'}, 1, 1))
    local src = {row(1), row(1), row(1)}
    P._join_rows(src)
    check('join: the rows given are left alone', shape(src) == '1 1 1', shape(src))

    -- the real mappings through core/progress.lua: the mission current (the login snapshot), then steps done in any order
    local mlines = {}
    local data = {is_loaded = function() return true end, get_area_status = function() return {items = {}} end,
                  get_mission_read = function() return mlines, nil end}
    P.init(data, nil, nil)
    P.on_login(nil)                -- no character: nothing is written, the snapshot alone is judged
    local function for_page(key, line, current, completed)
        mlines = {[line] = {current = current, completed = completed or {}}}
        P.on_log()
        return P.for_page(key)
    end
    local function strip_of(key, prog, W)
        local c, a, i = key:match('^(%a+)|([%w_]+)|(%d+)$')
        pages_stub.cur = {key = key, doc = D.decode(dofile(('pages/%ss/%s/%s.lua'):format(c, a, i)))}
        local b = ops.new()
        local x0, x1 = common.PAD, W - common.PAD
        local y = G.strip(b, x0, x1, 78, prog, {cat = c, area = a, id = tonumber(i)})
        local ts = {}
        for _, l in ipairs(lines(b, '^T\t')) do
            local x, ty, s = l:match('^T\t([%d%.%-]+)\t([%d%.%-]+)\t%x+\t(.*)$')
            ts[#ts + 1] = {x = tonumber(x), y = ty, s = s}
        end
        return ts, y, x1
    end
    local function shown(prog, state)
        local n = 0
        for _, s in ipairs(prog.steps) do if s.shown == state then n = n + 1 end end
        return n
    end
    local _, one_row = strip_of(KEY, progress({'done', 'next', 'todo'}), 480)

    local WOTG, ZIL = 'mission|wotg|49', 'mission|zilart|10'
    local p49 = for_page(WOTG, 'wotg', 49)
    check('wotg 49: seven steps in one row', #p49.rows == 1 and p49.rows[1].joined and #p49.rows[1].steps == 7, shape(p49.rows))
    check('wotg 49: all seven open at once', shown(p49, 'next') == 7, shown(p49, 'next'))
    for _, W in ipairs({480, 760, 1100}) do
        local ts, y, x1 = strip_of(WOTG, p49, W)
        check(W .. ' wotg 49: the strip is one row high', y == one_row, y .. ' vs ' .. one_row)
        check(W .. ' wotg 49: the lead says any order, with no step number', ts[1] and ts[1].s == 'Any order, 0/7: ', ts[1] and ts[1].s)
        local full = D.step_text(pages_stub.cur.doc, nil, 2, p49.steps[1].fp)
        local hint = ts[2] and ts[2].s
        local ok, why = false, 'no hint'
        if hint then ok, why = word_cut_ok(hint, full, x1 - ts[1].x - ops.text_w(ts[1].s)) end
        check(W .. ' wotg 49: the hint is the first open step, cut at a word', ok, tostring(why) .. ': ' .. tostring(hint))
        local right = 0
        for _, t in ipairs(ts) do right = math.max(right, t.x + ops.text_w(t.s)) end
        check(W .. ' wotg 49: no text past the right edge', right <= x1, right)
    end
    local function with_states(prog, states)
        local p = {rows = prog.rows, steps = {}}
        for k, s in ipairs(prog.steps) do p.steps[k] = {n = s.n, tab = s.tab, fp = s.fp, shown = states[k]} end
        return p
    end
    local ts = strip_of(WOTG, with_states(p49, {'next', 'next', 'done', 'next', 'done', 'next', 'next'}), 760)
    check('wotg 49: two done out of order', ts[1].s == 'Any order, 2/7: ' and ts[2].s:find('^Jugner dawndrop') ~= nil, ts[1].s)
    ts = strip_of(WOTG, with_states(p49, {'done', 'done', 'done', 'done', 'done', 'next', 'done'}), 760)
    check('wotg 49: the last one open is no longer any order', ts[1].s == '6/7: ' and ts[2].s:find('^Throne Room dawndrop') ~= nil, ts[1].s)
    ts = strip_of(WOTG, with_states(p49, {'done', 'done', 'done', 'done', 'done', 'done', 'done'}), 760)
    check('wotg 49: all done, the count only', #ts == 1 and ts[1].s == '7/7', ts[1] and ts[1].s)
    ts = strip_of(WOTG, with_states(p49, {'todo', 'todo', 'todo', 'todo', 'todo', 'todo', 'todo'}), 760)
    check('wotg 49: nothing known, the count only', #ts == 1 and ts[1].s == '0/7', ts[1] and ts[1].s)

    local z = for_page(ZIL, 'zilart', 0, {[8] = true})
    check('zilart 10: seven fragments and the last bullet in one row', #z.rows == 1 and #z.rows[1].steps == 8, shape(z.rows))
    check('zilart 10: the seven fragments open, the last bullet not', shown(z, 'next') == 7 and z.steps[8].shown == 'todo', shown(z, 'next'))
    local zts, zy = strip_of(ZIL, z, 480)
    check('zilart 10: the lead counts all eight', zts[1].s == 'Any order, 0/8: ', zts[1].s)
    check('zilart 10: the strip is one row high', zy == one_row, zy)

    local c = for_page('mission|cop|738', 'cop', 738)
    check('cop 738: three monsters share a row, Cid and Sueleen keep theirs', shape(c.rows) == 'j3 2', shape(c.rows))
    ts = strip_of('mission|cop|738', c, 760)
    check('cop 738: the hint under the rows leads any order', ts[#ts - 1].s == 'Any order, 0/3: ', ts[#ts - 1].s)
    local a = for_page('mission|zilart|30', 'zilart', 0, {[28] = true})
    check('zilart 30: two bullets, one row', shape(a.rows) == 'j2', shape(a.rows))
    -- route alternatives are never "any order": one open step at most, so the lead is the count
    local w1 = P.for_page('mission|wotg|1')
    check('wotg 1: the routes and the maw in one row', shape(w1.rows) == 'j4', shape(w1.rows))
    ts = strip_of('mission|wotg|1', with_states(w1, {'next', 'todo', 'todo', 'todo'}), 760)
    check('wotg 1: one open step is not any order', ts[1].s == '0/4: ', ts[1].s)

    -- every committed mapping: at most four rows; the unjoined count finds the eight of zilart 10 (the check can fail)
    local most, most_key, raw = 0, nil, 0
    for _, key in ipairs(keys) do
        local p = P.for_page(key)
        if p then
            if #p.rows > most then most, most_key = #p.rows, key end
            local n = 0
            for _, r in ipairs(p.rows) do n = n + (r.joined and #r.steps or 1) end
            raw = math.max(raw, n)
        end
    end
    check('no mapped page draws more than four strip rows', most <= 4, tostring(most_key) .. ': ' .. most)
    check('self-test: without joining a page would draw eight (caught)', raw >= 8, raw)
    local paths = P.for_page('mission|bastok|5')
    check('bastok 5: a page of paths keeps its rows', shape(paths.rows) == '1 8 10', shape(paths.rows))
end

print(('test_progress_ui: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)

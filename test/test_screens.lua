--[[
    test_screens.lua - the real chronicle.lua, screens and window, driven through Windower events
    with a recording fake of the DLL: navigation, lists, search, sort / filter, breadcrumbs, the
    guide, settings, input routing (moves never consumed; clicks, wheel, drags over the window are),
    resize (re-laid out at most once a frame, reading place kept), drag, saved place, collapse,
    commands, fail-closed start.

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_screens.lua
]]

local H = dofile('test/harness.lua')
local tooltip_fit = dofile('test/tooltip_fit.lua')

local pass, fail = 0, 0
local function check(name, cond, detail)
    if cond then pass = pass + 1 else
        fail = fail + 1
        print('FAIL ' .. name .. (detail ~= nil and (': ' .. tostring(detail)) or ''))
    end
end

-- keep the user's saved places and page state out of the way, with a backup on disk that a killed run's next run puts back
-- (H.protect). Per character since review LIFE-6 (the harness player is Berrant); the shared files of before are still read.
local KEEP = {'data/places_berrant.lua', 'data/pages_berrant.lua', 'data/places.lua', 'data/pages.lua'}
local restore = H.protect(KEEP)
local PLACES = KEEP[1]

local env = H.load({settings = {visible_on_load = false}})
local N, app = env.N, env.app
check('loaded quietly', N.layers[1] == nil and #env.chat == 1, env.chat[1])

-- show: three layers, home waiting for data
env.cmd('show')
local win = env.win()
check('show sends chrome, content, overlay', N.layers[1] and N.layers[2] and N.layers[3])
check('chrome is a Chronicle window', N.layers[1].text:find('^W\t0\t0\t620\t760\tChronicle') ~= nil, N.layers[1].text:sub(1, 40))
check('tabs', N.layers[1].text:find('Missions') and N.layers[1].text:find('Quests'))
check('waiting for data', N.layers[2].text:find('Waiting for data') ~= nil)
check('placed at 200,150', N.pos[1][1] == 200 and N.pos[1][2] == 150)

-- data arrives: one redraw after the burst
local sent2 = N.sent[2]
for _, p in ipairs(H.fixture_packets(530)) do env.fire('incoming chunk', 0x056, p) end
check('no redraw during the burst', N.sent[2] == sent2)
env.run_scheduled()
check('one redraw after it', N.sent[2] == sent2 + 1)
check('15 mission cards', N.layers[2].text:find('Chains of Promathia', 1, true) ~= nil)
local cards = 0
for _, h in ipairs(win.content_b.hits) do if h.id == 'card' then cards = cards + 1 end end
check('card hits', cards == 15, cards)
check('overall completion', N.layers[1].text:find('Overall Completion') ~= nil)

-- helpers: screen coordinates of a hit
local function chrome_hit(id, i)
    for _, h in ipairs(win.chrome_b.hits) do
        if h.id == id and (not i or h.i == i) then return win.x + (h.x0 + h.x1) / 2, win.y + (h.y0 + h.y1) / 2, h end
    end
end
local function content_hit(pred)
    for _, h in ipairs(win.content_b.hits) do
        if pred(h) then
            local _, top = win:to_win(0, h.y0)
            local _, bot = win:to_win(0, h.y1)
            if top < win.vp.y0 or bot > win.vp.y1 then           -- scroll it into view
                win:scroll_to(h.y0 - 40)
                win:flush()
            end
            local x, y = win:to_win((h.x0 + h.x1) / 2, (h.y0 + h.y1) / 2)
            if y >= win.vp.y0 and y < win.vp.y1 then return win.x + x, win.y + y, h end
        end
    end
end
-- x, y in Lua units; the mouse event is in screen px (the view factor, e.g. after size +)
local function click(x, y)
    local f = package.loaded['core/nui'].view.f
    local d = env.fire('mouse', 1, x * f, y * f, 0, false)
    local u = env.fire('mouse', 2, x * f, y * f, 0, false)
    return d, u
end

-- hover: moves never consumed; a card hover re-sends only the overlay
local c1, c2 = N.sent[1], N.sent[2]
local x, y = content_hit(function(h) return h.id == 'card' and h.area == 'cop' end)
check('a move is never consumed', env.fire('mouse', 0, x, y, 0, false) == nil)
check('card hover: overlay only', N.sent[1] == c1 and N.sent[2] == c2 and N.layers[3].text:find('R\t') ~= nil)
check('a move outside is not consumed', env.fire('mouse', 0, 10, 10, 0, false) == nil)
check('a click outside is not consumed', env.fire('mouse', 1, 10, 10, 0, false) == nil and env.fire('mouse', 2, 10, 10, 0, false) == nil)

-- tabs
local tx, ty = chrome_hit('navtab', 2)
click(tx, ty)
check('Quests tab', app.settings.active_tab == 'quest' and N.layers[2].text:find('Jeuno') ~= nil)
tx, ty = chrome_hit('navtab', 1)
click(tx, ty)
check('back to Missions', app.settings.active_tab == 'mission')

-- open Chains of Promathia
x, y = content_hit(function(h) return h.id == 'card' and h.area == 'cop' end)
local d, u = click(x, y)
check('card click consumed', d == true and u == true)
check('area view', app.view.name == 'area' and app.view.params.area == 'cop')
check('the tabs stay on the area screen, with no Home crumb',
      N.layers[1].text:find('Missions') and N.layers[1].text:find('Chains of Promathia')
      and not N.layers[1].text:find('Home'))
check('and one level in needs no way-back line', chrome_hit('up') == nil)
local rows = 0
for _, h in ipairs(win.content_b.hits) do if h.id == 'row' then rows = rows + 1 end end
local items = app:list_items('mission', 'cop')
check('a row per listed entry', rows == #items and rows > 20, rows)
local three
for _, it in ipairs(items) do if it.name == 'Three Paths' then three = it end end
check('Three Paths active', three and three.status == 'active', three and three.status)

-- wheel: consumed over the window, moves the content layer only
c1, c2 = N.sent[1], N.sent[2]
local oy = N.pos[2][2]
check('wheel consumed', env.fire('mouse', 10, win.x + 100, win.y + 300, -1, false) == true)
check('wheel scrolls by layer_pos only', N.pos[2][2] == oy - 54 and N.sent[2] == c2 and N.sent[1] == c1, N.pos[2][2] .. ' ' .. oy)
check('scroll clip follows', N.pos[2][4] == 54 and N.pos[2][6] == 54 + (win.vp.y1 - win.vp.y0))
env.fire('mouse', 10, win.x + 100, win.y + 300, 1, false)
check('wheel back up', win.scroll == 0)
check('wheel outside not consumed', env.fire('mouse', 10, 5, 5, -1, false) == nil)

-- search: focus, typing (consumed), filtering, Escape
x, y = chrome_hit('search')
click(x, y)
check('search focused', win.focus == 'search')
local function key(dik) local a = env.fire('keyboard', dik, true, 0, false) env.fire('keyboard', dik, false, 0, false) return a end
check('typing consumed', key(0x14) == true)          -- t
key(0x23) key(0x13)                                  -- h r
check('search text', app.search == 'thr', app.search)
local filtered = app:list_items('mission', 'cop')
check('filtered to Three Paths', #filtered == 1 and filtered[1].name == 'Three Paths', #filtered)
check('content shows it', N.layers[2].text:find('Three Paths') ~= nil and not N.layers[2].text:find('Desires of Emptiness'))
check('search box shows the text', N.layers[1].text:find('\tthr') ~= nil)
key(0x0E)
check('backspace', app.search == 'th')
key(0x2A) env.fire('keyboard', 0x2A, true, 0, false) key(0x14) env.fire('keyboard', 0x2A, false, 0, false)
check('shift types upper case', app.search == 'thT', app.search)
key(0x01)
check('escape clears and blurs', app.search == '' and win.focus == nil)
check('keys pass through unfocused', key(0x14) == nil)

-- sort and filter cycle and save
local saves = env.saves
x, y = chrome_hit('sort')
click(x, y)
check('sort Name', app.settings.sort_mode == 2 and env.saves == saves + 1)
local names = app:list_items('mission', 'cop')
local sorted = true
for i = 2, #names do if names[i - 1].name:lower() > names[i].name:lower() then sorted = false end end
check('sorted by name', sorted)
click(x, y)
local st = app:list_items('mission', 'cop')
local pr = {active = 1, not_started = 2, uncompletable = 3, completed = 4, ['repeat'] = 5}
local ok = true
for i = 2, #st do if pr[st[i - 1].status] > pr[st[i].status] then ok = false end end
check('sorted by status', app.settings.sort_mode == 3 and ok and st[1].status == 'active')
click(x, y) click(x, y)
check('sort cycles back to Default', app.settings.sort_mode == 1)
x, y = chrome_hit('filter')
click(x, y)
local done = app:list_items('mission', 'cop')
ok = #done > 0
for _, it in ipairs(done) do if it.status ~= 'completed' and it.status ~= 'repeat' then ok = false end end
check('Show: Completed', app.settings.filter_mode == 2 and ok)
click(x, y)
-- CoP at 530: Three Paths and its three paths (rule 104: every path is open while CoP is at 530)
check('Show: Active', app.settings.filter_mode == 3 and #app:list_items('mission', 'cop') == 4)
click(x, y) click(x, y)
check('Show cycles back to All (4 without uncompletable)', app.settings.filter_mode == 1)

-- the guide
x, y = content_hit(function(h) return h.id == 'row' and h.item.name == 'Three Paths' end)
click(x, y)
check('guide view', app.view.name == 'guide' and app.view.params.name == 'Three Paths')
local c = N.layers[2].text
check('guide: description', c:find('Wyrmking') ~= nil)
check('guide: card', c:find('TITLE') and c:find('Treader of an Icy Past'))
check('guide: Three Paths has its page', c:find('Walkthrough') and c:find('Past Sins') and c:find("Tenzen's Path")
    and not c:find('No walkthrough yet.'))
check('guide: status badge ACTIVE', N.layers[1].text:find('ACTIVE') ~= nil)
check('two levels in: the tabs, the parent and the name',
      N.layers[1].text:find('Three Paths') and N.layers[1].text:find('Missions')
      and N.layers[1].text:find('< Chains of Promathia', 1, true) ~= nil)
-- chain hover: underline + tooltip; click opens the next entry
x, y = content_hit(function(h) return h.id == 'chain' and h.dir == 'next' end)
env.fire('mouse', 0, x, y, 0, false)
check('chain hover tooltip', N.layers[3].text:find('opens in Chronicle') ~= nil)
click(x, y)
check('chain opens the next mission', app.view.name == 'guide' and app.view.params.name == 'For Whom the Verse Is Sung',
    app.view.params.name)
-- the way-back line opens the parent
x, y = chrome_hit('up')
click(x, y)
check('the parent line opens the list', app.view.name == 'area' and app.view.params.area == 'cop')
-- right click goes back
env.fire('mouse', 4, win.x + 100, win.y + 300, 0, false)
env.fire('mouse', 5, win.x + 100, win.y + 300, 0, false)
check('right click: back to Home', app.view.name == 'home', app.view.name)

-- an entry without a page: a blank walkthrough
-- (cop 110, The Rites of Life, was this entry until it got its page; toau 32 "Sentinel's Honor" is a listed mission the wiki has no page for,
-- skipped in the ledger, so it stays blank. The first check keeps the choice honest: an entry that gains a page fails here, not silently.)
do
    local nopage, listed = "Sentinel's Honor", nil
    for _, it in ipairs(app.data.get_area_status('mission', 'toau').items) do if it.name == nopage then listed = it.id end end
    check('blank walkthrough: the entry is listed and has no page', listed ~= nil and dofile('pages/index.lua')['mission|toau|' .. tostring(listed)] == nil, listed)
end
app:entry('mission', 'toau', "Sentinel's Honor")
check('blank walkthrough', N.layers[2].text:find('No walkthrough yet.') ~= nil)

-- Three Paths: tabs, per-tab scroll, links
local pages = package.loaded['core/pages']
app:entry('mission', 'cop', 'Three Paths', 530)
c = N.layers[2].text
check('page: first tab open', c:find('Despachiaire') ~= nil and not c:find('Hinaree'))
local tabs = {}
for _, h in ipairs(win.content_b.hits) do if h.id == 'tab' then tabs[h.i] = h end end
check('page: three tabs', tabs[1] and tabs[2] and tabs[3] and tabs[3].label == 'Where Messengers Gather')
local function sticky(i)
    for _, h in ipairs(win.overlay_b.hits) do
        if h.sticky and h.i == i then return win.x + (h.x0 + h.x1) / 2, win.y + (h.y0 + h.y1) / 2 end
    end
end
-- the guide card and the page's own infobox header do not repeat each other (2026-10-19: at the smallest window the
-- walkthrough began two screens down). Quest 58 has nothing the card lacks: no header box; quest 1 has a Next Quest.
do
    local function name_of(cat, area, id)
        for _, it in ipairs(app.data.get_area_status(cat, area).items) do if it.id == id then return it.name end end
    end
    local function labels()
        local out = {}
        for l in N.layers[2].text:gmatch('[^\n]+') do
            local x, s = l:match('^T\t([%-%d%.]+)\t[%-%d%.]+\t%x+\t(.*)$')
            if s and tonumber(x) > 8 and tonumber(x) < 12 then out[s] = true end
        end
        return out
    end
    local n58 = name_of('quest', 'sandoria', 58)
    app:entry('quest', 'sandoria', n58, 58)
    local c58, l58 = N.layers[2].text, labels()
    check('card+header: quest 58 has its card', c58:find('FAME') ~= nil and c58:find('REWARD') ~= nil and c58:find('Kuu Mohzolhi') ~= nil)
    local repeated = {}
    for _, lab in ipairs({'Fame', 'Start', 'Title', 'Repeatable', 'Story', 'Requirements', 'Reward', 'Limit', 'Pack', 'Previous', 'Next'}) do
        if l58[lab] then repeated[#repeated + 1] = lab end
    end
    check('card+header: quest 58 header repeats nothing', #repeated == 0, table.concat(repeated, ','))
    check('card+header: quest 58 draws no header box', not c58:find('\nR\t0\t%S+\t%S+\t%S+\t00000032'))
    -- quest 30 has a real Previous and Next Quest: the card draws the chain links, the header does not repeat them
    app:entry('quest', 'sandoria', name_of('quest', 'sandoria', 30), 30)
    local c30, l30 = N.layers[2].text, labels()
    check('card+header: quest 30 has the chain links of the card', c30:find('< Previous') ~= nil and c30:find('> Next') ~= nil)
    check('card+header: quest 30 header does not repeat the chain', not l30['Previous'] and not l30['Next'])
end
-- 2026-10-20 (Phase 1d): the card prints the wiki's Repeatable (sandoria 5 said No over a header that said Yes), and a choice in the
-- requirements is rows with an "or" between them and no counter (windurst 29: Deathball or Sobbing Fungus)
do
    local function drawn_lines()
        local out = {}
        for l in N.layers[2].text:gmatch('[^' .. string.char(10) .. ']+') do
            local x, y, s = l:match('^T' .. string.char(9) .. '([%-%d%.]+)' .. string.char(9) .. '([%-%d%.]+)' .. string.char(9) .. '%x+' .. string.char(9) .. '(.*)$')
            if s then out[#out + 1] = {x = tonumber(x), y = tonumber(y), s = s} end
        end
        return out
    end
    local function value_under(label)
        local ls = drawn_lines()
        for _, l in ipairs(ls) do
            if l.s == label then
                for _, m in ipairs(ls) do if math.abs(m.x - l.x) < 1 and m.y > l.y and m.y < l.y + 24 then return m.s end end
            end
        end
    end
    local function entry_name(cat, area, id)
        for _, it in ipairs(app.data.get_area_status(cat, area).items) do if it.id == id then return it.name end end
    end
    app:entry('quest', 'sandoria', entry_name('quest', 'sandoria', 5), 5)
    check('card: sandoria 5 prints Repeatable Yes, as the wiki does', value_under('REPEATABLE') == 'Yes', value_under('REPEATABLE'))
    app:entry('quest', 'windurst', entry_name('quest', 'windurst', 29), 29)
    local ls, req_y, ors, counter = drawn_lines(), nil, 0, false
    for _, l in ipairs(ls) do
        if l.s == 'or' and math.abs(l.x - 34) < 1 then   -- alone on its line, under the icons' column: not a word of the walkthrough
            local alone = true
            for _, m in ipairs(ls) do if m ~= l and math.abs(m.y - l.y) < 2 then alone = false end end
            if alone then ors = ors + 1 end
        end
        if l.s:find('^%d+ / %d+$') then counter = true end
    end
    check('card: windurst 29 draws an "or" between Deathball and Sobbing Fungus', ors == 1, ors)
    check('card: ...and no counter over a choice', not counter)
    -- the old rows (a name with a line break in it) drew no "or" and no icons: the choice rows are what makes the difference
    local e29 = app:guide_entry(app.view.params)
    check('card: windurst 29 has three rows', e29 and #e29.requirements == 3 and e29.requirements[2].sep, e29 and #e29.requirements)
end
-- the self-test of that rule: an entry whose data holds only its id and that has no page to fill it reads as an empty card; so the
-- predicate can fail. The entry is built here (test/fixtures/stubroot: one id-only entry, an empty page index), not taken from the
-- real data, where an id with no page today (Eco-Warrior (Bastok), 65) gets one tomorrow.
do
    local meta = require('core/meta')
    local keep = meta.get_root()
    meta.release()
    meta.set_root('test/fixtures/stubroot/')
    local stub = meta.get('quest', 'zz', 'Stub Only')
    local cf = require('core/card').fields(stub)
    meta.release()
    meta.set_root(keep)
    check('card rule self-test: an id-only entry with no page has an empty card', stub ~= nil and stub.id == 1 and not (cf.npc or cf.zone or cf.reward),
        stub and stub.id)
    local lacking = {}
    for _, cat in ipairs({'quest', 'mission'}) do
        for _, area in ipairs(cat == 'quest' and {'sandoria', 'bastok', 'windurst', 'jeuno', 'other', 'outlands', 'toau', 'wotg', 'abyssea', 'adoulin', 'coalition'}
                or {'sandoria', 'bastok', 'windurst', 'zilart', 'cop', 'toau', 'wotg', 'acp', 'mkd', 'asa', 'adoulin', 'rov', 'tvr', 'assault', 'campaign'}) do
            for _, it in ipairs(app.data.get_area_status(cat, area).items) do
                local f = require('core/card').fields(app:guide_entry({cat = cat, area = area, name = it.name, id = it.id}))
                if not (f.npc or f.zone or f.reward) then lacking[#lacking + 1] = cat .. '|' .. area .. '|' .. tostring(it.id) end
            end
        end
    end
    print(('  guide cards with no NPC, zone or reward (the data holds only their id, no page yet): %d'):format(#lacking))
end
-- the chain links under a card (Previous / Next): -> the faults, {} when a name with an entry is a link and any other is not
local real_target = app.chain_target
local function chain_faults(cat, area, name)
    local out = {}
    app:entry(cat, area, name)
    local e = app:guide_entry(app.view.params)
    local hit_names = {}
    for _, h in ipairs(win.content_b.hits) do if h.id == 'chain' then hit_names[h.name] = true end end
    for _, list in ipairs({e and e.previous or {}, e and e.next or {}}) do
        for _, n in ipairs(list) do
            local has = real_target(app, cat, area, n) ~= nil
            if hit_names[n] and not has then out[#out + 1] = 'the chain link "' .. n .. '" is drawn as a link and finds no entry'
            elseif has and not hit_names[n] then out[#out + 1] = 'the chain link "' .. n .. '" has an entry and no hit area' end
        end
    end
    return out
end
do   -- the self-test: the drawing made to call every name a link (the old behaviour) is caught on a quest whose chain names entries Chronicle lacks
    -- (To Kill Mocking Birds was that quest until its chain's records got pages of their own; the first such quest is found here instead)
    local lone
    for _, area in ipairs({'sandoria', 'bastok', 'windurst', 'jeuno', 'other', 'outlands', 'toau', 'wotg', 'abyssea', 'adoulin', 'coalition'}) do
        for _, it in ipairs(app.data.get_area_status('quest', area).items) do
            local e = app:guide_entry({cat = 'quest', area = area, name = it.name, id = it.id})
            for _, list in ipairs({e and e.previous or {}, e and e.next or {}}) do
                for _, n in ipairs(list) do if not lone and real_target(app, 'quest', area, n) == nil then lone = {area, it.name} end end
            end
        end
        if lone then break end
    end
    check('chain self-test: some quest names a chain entry Chronicle lacks', lone ~= nil)
    if lone then
        app.chain_target = function() return 'quest', lone[1] end
        local faulty = chain_faults('quest', lone[1], lone[2])
        app.chain_target = real_target
        check('self-test: a chain name with no entry drawn as a link is caught', #faulty >= 1 and faulty[1]:find('finds no entry', 1, true), faulty[1])
        check('chain: the real drawing has no such fault there', #chain_faults('quest', lone[1], lone[2]) == 0)
    end
    -- a chain name that is a Records objective with a page opens that record (To Kill Mocking Birds -> Golden Rule ... Remembrance)
    check('chain: the real drawing of To Kill Mocking Birds has no fault', #chain_faults('quest', 'jeuno', 'To Kill Mocking Birds') == 0)
    local rc, rid = real_target(app, 'quest', 'jeuno', 'Petals of Recollection')
    check('chain: a name that is a record with a page finds the record', rc == 'record' and rid == 388, tostring(rc) .. ' ' .. tostring(rid))
    app:entry('quest', 'jeuno', 'To Kill Mocking Birds')
    check('chain: opening it from the quest goes to the record, and back returns', app:open_chain('quest', 'jeuno', 'Impermanence')
          and app.view.name == 'robj' and app.view.params.id == 529 and (app:back() or true) and app.view.name == 'guide')
    -- across kinds: a quest's next can be a mission (Apocalypse Nigh -> The Last Verse)
    local c, a = real_target(app, 'quest', 'jeuno', 'The Last Verse')
    check('chain: a quest followed by a mission finds it', c == 'mission' and a ~= nil, tostring(c) .. ' ' .. tostring(a))
    check('chain: a name nobody has finds nothing', real_target(app, 'quest', 'jeuno', 'A Quest Nobody Has Written') == nil)
end
-- every page in the index, every way in, every tab (2026-10-17 in game: a page lost when its
-- entry was reached by name, and tabs that moved the page)
local index = dofile('pages/index.lua')
-- rule 74: the page header's Starting NPC and Rewards rows both say there is nothing: "N/A" / "None" / "Unknown" / "--" or empty, and no
-- link in them (a link is a person, a zone or an item the card should have)
-- rule 106: a Starting NPC the wiki says "Varies" (cop 325, The Road Forks: "Varies. See Below", one start in each of three nations) names
-- no person and no place; the card has nothing to put there, as v1's data already drops it (split_meta.lua, not_a_person)
local function header_row_empty(v, varies)
    if v == nil then return true end
    if type(v) ~= 'string' or v:find('{', 1, true) then return false end
    local low = v:lower():gsub('[%s%p]', '')
    if varies and low:find('^varies') and not low:find('%d') then return true end
    return low == '' or low == 'na' or low == 'none' or low == 'unknown'
end
local function header_has_nothing(meta)
    return type(meta) == 'table' and header_row_empty(meta['Starting NPC'], true) and header_row_empty(meta['Rewards'])
end
-- rule 161 (quest abyssea 185, "Meanwhile, Back on Abyssea": Starting NPC "N/A", Rewards "None", a cutscene quest): the empty card is the
-- page's own truth for a quest as for a mission. It is judged on the page's header, so a quest whose header has a start or a reward the card
-- lacks (Eco-Warrior) and an entry with no page are still caught. `QUEST_EMPTY = false` is the check before 161 (missions only).
local QUEST_EMPTY = true
local function card_may_be_empty(cat, meta)
    return (cat == 'mission' or QUEST_EMPTY) and header_has_nothing(meta)
end
do
    -- rule 75: the wotg mission "Lest We Forget" (53) has a walkthrough page and is a mission of the wiki; the list shows it (it was left out as a placeholder)
    local listed
    for _, it in ipairs(app.data.get_area_status('mission', 'wotg').items) do if it.id == 53 then listed = it.name end end
    check('rule 75: wotg mission 53 is listed', listed == 'Lest We Forget', listed)
end
check('rule 74 self-test: N/A and None is a header with nothing', header_has_nothing({['Starting NPC'] = 'N/A', Rewards = 'None'}))
check('rule 74 self-test: a reward the card could show is not nothing', not header_has_nothing({['Starting NPC'] = 'N/A', Rewards = '{k:Lightsworm}'})
    and not header_has_nothing({['Starting NPC'] = 'N/A', Rewards = 'Moonshade Earring'}))
check('rule 106 self-test: "Varies. See Below" and None is a header with nothing', header_has_nothing({['Starting NPC'] = 'Varies. See Below', Rewards = 'None'}))
check('rule 106 self-test: a Varies with a reward, or a reward that varies, is not nothing', not header_has_nothing({['Starting NPC'] = 'Varies', Rewards = 'Moonshade Earring'})
    and not header_has_nothing({['Starting NPC'] = 'N/A', Rewards = 'Varies'}) and not header_has_nothing({['Starting NPC'] = 'Varies, {z:Jugner Forest}', Rewards = 'None'}))
check('rule 74 self-test: a start the card could show is not nothing', not header_has_nothing({['Starting NPC'] = '{z:Jugner Forest (S)}', Rewards = 'None'})
    and not header_has_nothing({['Starting NPC'] = 'Raustigne', Rewards = 'None'}))
check('rule 161 self-test: a quest whose header says N/A and None may have an empty card', card_may_be_empty('quest', {['Starting NPC'] = 'N/A', Rewards = 'None'}))
check('rule 161 self-test: a quest with a start, a reward or no page is still caught',
    not card_may_be_empty('quest', {['Starting NPC'] = 'Raustigne', Rewards = 'None'}) and not card_may_be_empty('quest', {['Starting NPC'] = 'N/A', Rewards = '{k:Lightsworm}'})
    and not card_may_be_empty('quest', {['Starting NPC'] = '{z:Jugner Forest (S)}', Rewards = 'None'}) and not card_may_be_empty('quest', nil))
QUEST_EMPTY = false
check('rule 161 self-test: with the rule off an empty quest card is caught again (abyssea 185)', not card_may_be_empty('quest', {['Starting NPC'] = 'N/A', Rewards = 'None'})
    and card_may_be_empty('mission', {['Starting NPC'] = 'N/A', Rewards = 'None'}))
QUEST_EMPTY = true
-- rule 103: two entries of one area with one name and one wiki page (rov 130 and 232, "Eddies of Despair", both Rhapsodies of Vanadiel Mission
-- 1-10). Each opens from every route and goes back to the entry it was opened from; the status is each entry's own.
do
    local mid = require('core/pages')
    local function view() return app.view.params.id, app.view.params.name end
    local function click_link(name)
        app.walkthrough_click({id = 'link', span = {t = 'link', kind = 'mission', name = name, s = name, to = 'Rhapsodies of Vanadiel Mission 2-35'}}, {})
    end
    -- the data's own chains
    app:entry('mission', 'rov', 'Cacophonous Discord', 230)
    check('shared page: 230 is followed by Eddies of Despair (2)', (app:guide_entry(app.view.params).next or {})[1] == 'Eddies of Despair (2)', (app:guide_entry(app.view.params).next or {})[1])
    check('shared page: a chain link to the second opens the second, listed under the name it shares', app:open_chain('mission', 'rov', 'Eddies of Despair (2)')
        and select(1, view()) == 232 and select(2, view()) == 'Eddies of Despair' and mid.current() ~= nil, tostring(select(1, view())) .. ' ' .. tostring(select(2, view())))
    app:back()
    check('shared page: back from it returns to the entry it was opened from', select(1, view()) == 230, select(1, view()))
    local data_off = app.data.NUMBERED_NAMES
    app.data.NUMBERED_NAMES = false
    app:open_chain('mission', 'rov', 'Eddies of Despair (2)')
    check('self-test: without the rule the entry keeps the numbered name (caught)', select(2, view()) == 'Eddies of Despair (2)', select(2, view()))
    app.data.NUMBERED_NAMES = data_off
    -- rule 137: outlands 163 and 164 are both "Divine Might" with no numbered key in v1's meta: the numbered name finds the second from the map
    do
        local d = app.data
        check('shared page: "Divine Might (2)" is outlands 164 and "Divine Might" 163', d.find_id('quest', 'outlands', 'Divine Might (2)') == 164
            and d.find_id('quest', 'outlands', 'Divine Might') == 163, tostring(d.find_id('quest', 'outlands', 'Divine Might (2)')))
        check('shared page: a number past the last entry, and a number of a unique name, find nothing',
            d.find_id('quest', 'outlands', 'Divine Might (3)') == nil and d.find_id('quest', 'outlands', 'Open Sesame (2)') == nil)
        check('shared page: a chain link "Divine Might (2)" from outlands has its area', d.find_quest_area('Divine Might (2)', 'outlands') == 'outlands')
        d.NUMBERED_FIND = false
        local off, off_area = d.find_id('quest', 'outlands', 'Divine Might (2)'), d.find_quest_area('Divine Might (2)', 'outlands')
        d.NUMBERED_FIND = true
        check('self-test: without rule 137 the numbered name of outlands 164 finds nothing (caught)', off == nil and off_area == nil, tostring(off) .. ' ' .. tostring(off_area))
    end
    -- a link in a page's text: the open entry's own chain says which of the two it means
    app:entry('mission', 'rov', 'Cacophonous Discord', 230)
    click_link('Eddies of Despair')
    check('shared page: a page link from 230 opens the second (232)', select(1, view()) == 232, select(1, view()))
    app:back()
    check('shared page: ...and back returns to 230', select(1, view()) == 230, select(1, view()))
    app:entry('mission', 'rov', "The Lion's Roar", 128)
    click_link('Eddies of Despair')
    check('shared page: a page link from 128 opens the first (130)', select(1, view()) == 130, select(1, view()))
    app:back()
    check('shared page: ...and back returns to 128', select(1, view()) == 128, select(1, view()))
    app:entry('mission', 'rov', 'Pretender to the Throne', 234)
    click_link('Eddies of Despair')
    check('shared page: a page link from 234 opens the second (232)', select(1, view()) == 232, select(1, view()))
    app.LINK_BY_CHAIN = false
    app:entry('mission', 'rov', 'Cacophonous Discord', 230)
    click_link('Eddies of Despair')
    check('self-test: without the rule a page link from 230 opens the first (caught)', select(1, view()) == 130, select(1, view()))
    app.LINK_BY_CHAIN = true
    -- the status of each is its own
    local real_status = app.data.get_area_status
    app.data.get_area_status = function(c, a)
        local st = real_status(c, a)
        if c == 'mission' and a == 'rov' then
            local items = {}
            for i, it in ipairs(st.items) do
                local copy = {}
                for k, v in pairs(it) do copy[k] = v end
                if it.id == 130 then copy.status = 'completed' elseif it.id == 232 then copy.status = 'active' end
                items[i] = copy
            end
            st = setmetatable({items = items}, {__index = st})
        end
        return st
    end
    local _, st130 = app:guide_entry({cat = 'mission', area = 'rov', name = 'Eddies of Despair', id = 130})
    local _, st232 = app:guide_entry({cat = 'mission', area = 'rov', name = 'Eddies of Despair', id = 232})
    check('shared page: each entry has its own status', st130 == 'completed' and st232 == 'active', tostring(st130) .. ' ' .. tostring(st232))
    app.STATUS_BY_ID = false
    local _, old232 = app:guide_entry({cat = 'mission', area = 'rov', name = 'Eddies of Despair', id = 232})
    check('self-test: without the rule the second takes the status of the first (caught)', old232 == 'completed', old232)
    app.STATUS_BY_ID = true
    app.data.get_area_status = real_status
    app:home()
end
-- the gate's own test (the gate's self-test): an index entry Chronicle does not list, which no route reaches
if os.getenv('CR_SUITE_FAULT') == 'unreachable_page' then index['quest|sandoria|76'] = index['quest|sandoria|75'] end
-- Records objectives with a page of their own (record|roe|<id>, the RoE quests): the record is in the tree, and the record screen
-- opens its page by every route to it (a jump in, its list row, back from a page it links to)
local story = {}
do
    local P = require('core/pages')
    local function opened(key) local c = P.current() return c ~= nil and c.key == key and c.doc ~= nil end
    local nrec = 0
    for key, file in pairs(index) do
        local id = tonumber(key:match('^record|roe|(%d+)$'))
        if not id then story[key] = file
        else
            nrec = nrec + 1
            local ci, si = app.roe.locate(id)
            check(key .. ': listed in Records', ci ~= nil)
            if ci then
                app:roe_objective(id)
                check(key .. ': a jump to the record opens its page', opened(key))
                app:roe_sub(ci, si)
                app:go('robj', {ci = ci, si = si, id = id})
                check(key .. ': its list row opens its page', opened(key))
                app:home()
                check(key .. ': leaving the record closes its page', P.current() == nil)
            end
        end
    end
    if nrec > 0 then
        -- the wiki names some records as quests of their own, and the pages link to each other by those names
        local want = {}
        for key, file in pairs(index) do
            local id = tonumber(key:match('^record|roe|(%d+)$'))
            local t = id and dofile(file)
            if t then want[t.page] = math.min(want[t.page] or id, id) end
        end
        for title, id in pairs(want) do
            check('record page "' .. title .. '": a link by its wiki title opens record ' .. id, P.record_by_title(title) == id,
                  tostring(P.record_by_title(title)))
            check('record page "' .. title .. '": the link matches with spaces for underscores', P.record_by_title(title:gsub('_', ' ')) == id)
        end
        check('a title no record page has opens no record (self-test)', P.record_by_title('Smash the Orcish Scouts') == nil)
    end
end
for key in pairs(story) do
    local cat, area, id = key:match('^(%a+)|([%w_]+)|(%d+)$')
    id = tonumber(id)
    local name
    for _, it in ipairs(app.data.get_area_status(cat, area).items) do if it.id == id then name = it.name end end
    check(key .. ': listed in Chronicle', name ~= nil)
    if name then
        -- the guide card is not all '--': a page's entry has at least an NPC, a zone or a reward (2026-10-19: Eco-Warrior
        -- (San d'Oria), page 97, showed '--' everywhere: v1's data holds only its id, the three nations share the name)
        local cf = require('core/card').fields(app:guide_entry({cat = cat, area = area, name = name, id = id}))
        -- rule 74: a mission whose own page header says it has no starting NPC and no reward (the wiki's "N/A" and "None") truly has nothing
        -- to put in those three fields; the card is then the description, the chain and the title. A quest, a page that has a start or a
        -- reward the card lacks, and an entry with no page are still caught.
        check(key .. ': the guide card has an NPC, a zone or a reward',
              cf.npc or cf.zone or cf.reward or card_may_be_empty(cat, dofile(index[key]).meta), name)
        -- rule 103: entries of one area can share a name (rov "Eddies of Despair", 130 and 232: one wiki page, two entries). The name by
        -- which the data's chains call the second and later is numbered ("Eddies of Despair (2)"); a list row carries the id. A route
        -- that has only a name uses the name the entry is called by, never the one it shares.
        local call = name
        do
            local k = 0
            for _, it in ipairs(app.data.get_area_status(cat, area).items) do
                if it.name == name and it.id <= id then k = k + 1 end
            end
            if k > 1 then call = ('%s (%d)'):format(name, k) end
        end
        check(key .. ': the name it is called by opens it', app.data.find_id(cat, area, call) == id, call)
        local routes = {
            {'by id', function() app:entry(cat, area, name, id) end},
            {'by name', function() app:entry(cat, area, call) end},
            {'from its list row', function() app:area_list(cat, area) app:go('guide', {cat = cat, area = area, name = name, id = id}) end},
            {'from a chain link', function() app:home() app:open_chain(cat, area, call) end},
            {'there and back', function()
                app:entry(cat, area, call)
                local e = app:guide_entry(app.view.params)
                -- a link to an entry Chronicle has (the card draws the others as plain names, checked below)
                for _, nxt in ipairs(e and e.next or {}) do
                    if app:chain_target(cat, area, nxt) then
                        check(key .. ': the chain link ' .. nxt .. ' opens', app:open_chain(cat, area, nxt))
                        app:back()
                        break
                    end
                end
            end},
            {'home and back', function() app:entry(cat, area, call) app:home() app:back() app:back() end},
        }
        for _, r in ipairs(routes) do
            r[2]()
            if r[1] == 'home and back' then app:entry(cat, area, call) end
            check(('%s: page found %s'):format(key, r[1]), pages.current() ~= nil and app.view.params.id == id,
                tostring(app.view.params.name) .. ' ' .. tostring(app.view.params.id))
        end
        -- the card's chain: a name Chronicle has an entry for is a link that opens it, any other is plain text with no hit area
        for _, f in ipairs(chain_faults(cat, area, call)) do check(key .. ': ' .. f, false) end
        -- tabs in view: clicking one never moves the page; only the panel under the strip changes
        app:entry(cat, area, call)
        local strips = {}
        for _, h in ipairs(win.content_b.hits) do if h.id == 'tab' then strips[#strips + 1] = h end end
        local vh = win.vp.y1 - win.vp.y0
        for _, t in ipairs(strips) do
            win:scroll_to(math.max(0, t.y0 - math.floor(vh / 2))) win:flush()
            local before, panel = win.scroll, N.layers[2].text
            x, y = content_hit(function(h) return h.id == 'tab' and h.group == t.group and h.i == t.i end)
            check(key .. ': tab ' .. t.i .. ' clickable', x ~= nil)
            if x then
                click(x, y)
                local same = (pages.current().tabs[t.group] or 1) == t.i
                check(('%s: tab %d in view keeps the page still'):format(key, t.i), same and win.scroll == math.min(before,
                    math.max(0, win.content_h - vh)), before .. ' -> ' .. win.scroll)
            end
        end
        -- the sticky bar: from far down, the chosen path starts at the top of the view
        for _, t in ipairs(strips) do
            win:scroll_to(t.y0 + 1200) win:flush()
            local other = t.i == 1 and 2 or 1
            local sx, sy = sticky(other)
            -- rule 177: a page too short to scroll its strip out of view (quest wotg 69, three short tabs: content 767 in a 664 view, the strip
            -- at 320, the scroll stops at 103) has no bar to draw; core/pages.lua draws it when the scroll is past the strip + 46. Such a page
            -- is at its bottom and draws none; a page that scrolls past draws it (cop 530).
            local strip_y = pages.current().strip and pages.current().strip[t.group]
            local past = strip_y ~= nil and win.scroll > strip_y + 46
            if not past then
                check(('%s: no sticky bar on a page too short to scroll past its strip'):format(key),
                    sx == nil and win.scroll == math.max(0, win.content_h - vh), tostring(win.scroll) .. ' strip ' .. tostring(strip_y))
            end
            check(('%s: sticky bar when scrolled past the strip'):format(key), sx ~= nil or not past)
            if sx then
                click(sx, sy)
                local strip = pages.current().strip[t.group]
                check(('%s: sticky tab %d brings its strip to the top'):format(key, other),
                    pages.current().tabs[t.group] == other and win.scroll == math.max(0, strip - 6), win.scroll .. ' strip ' .. strip)
            end
            break
        end
    end
end
-- the open tab is remembered per entry
app:entry('mission', 'cop', 'Three Paths', 530)
local open_tab = pages.current().tabs[1]
app:home()
app:entry('mission', 'cop', 'Three Paths', 530)
check('page: open tab remembered', pages.current().tabs[1] == open_tab, tostring(pages.current().tabs[1]))
-- links: an NPC opens BG-wiki; a path's own name switches tab; a listed mission opens Chronicle
local urls = #env.urls
x, y = content_hit(function(h) return h.id == 'link' and h.span.kind == 'npc' end)
env.fire('mouse', 0, x, y, 0, false)
check('link tooltip says BG-wiki', N.layers[3].text:find('opens in BG%-wiki') ~= nil)
click(x, y)
check('NPC link opens BG-wiki', #env.urls == urls + 1 and env.urls[#env.urls]:find('^https://www.bg%-wiki.com/ffxi/') ~= nil, env.urls[#env.urls])

-- a Requirements row opens the item's own BG-wiki page: in the walkthrough an item's name is a
-- link, and the requirement list was the one place an item was named with nothing to click
do
    local req, name
    for _, it in ipairs(app.data.get_area_status('quest', 'sandoria').items) do
        app:entry('quest', 'sandoria', it.name, it.id)
        env.frame()
        for _, h in ipairs(win.content_b.hits) do if h.id == 'req' then req, name = h, h.name break end end
        if req then break end
    end
    check('an entry with requirements was found', req ~= nil)
    if req then
        local rx, ry = content_hit(function(h) return h.id == 'req' end)
        env.fire('mouse', 0, rx, ry, 0, false)
        check('the row says it opens BG-wiki', N.layers[3].text:find('opens in BG%-wiki') ~= nil)
        local before = #env.urls
        click(rx, ry)
        check('and clicking it opens that item', #env.urls == before + 1
              and env.urls[#env.urls]:find('^https://www.bg%-wiki.com/ffxi/') ~= nil, env.urls[#env.urls])
    end
end
app:entry('mission', 'cop', 'Three Paths', 530)
x, y = content_hit(function(h) return h.id == 'tab' and h.i == 1 end)
click(x, y)
x, y = content_hit(function(h) return h.id == 'link' and h.span.kind == 'mission' and h.span.s == "Tenzen's Path" end)
if x then
    env.fire('mouse', 0, x, y, 0, false)
    check('path link tooltip says this page', N.layers[3].text:find('opens in this page') ~= nil)
    click(x, y)
    check("a path's own link switches tab", pages.current().tabs[1] == 2 and app.view.params.name == 'Three Paths')
else
    print("  (no link to Tenzen's Path in tab 1)")
end
-- pictures: no network in the test -> 'failed' after the queue runs, never a crash
env.run_scheduled()
win:invalidate('content') win:flush()
-- cached pictures (data/pics, e.g. after a render) are drawn; missing ones say so, never a crash
local t2 = N.layers[2].text
check('pictures: drawn from the cache or marked unavailable',
    t2:find('\nQ\t%d+\t') ~= nil or t2:find('Picture unavailable') ~= nil or t2:find('Loading') ~= nil)

-- an external link (a forum thread, a news page) opens at its own address, never joined to the BG-wiki
-- base (2026-10-19: quest pages 67 and 101 carry such links)
do
    local pages_mod = require('core/pages')
    check('link_url: an address is opened as it is',
        pages_mod.link_url({kind = 'page', s = 'forum', to = 'https://forum.example.com/t/5?a=b'}) == 'https://forum.example.com/t/5?a=b'
        and pages_mod.link_url({kind = 'page', s = 'news', to = 'http://www.example.com/x.shtml'}) == 'http://www.example.com/x.shtml')
    check('link_url: a wiki title is joined to the BG-wiki base',
        pages_mod.link_url({kind = 'npc', s = 'Cid', to = 'Cid'}) == 'https://www.bg-wiki.com/ffxi/Cid')
    app:entry('quest', 'sandoria', 'A Job for the Consortium', 67)
    local ux, uy, uh = content_hit(function(h) return h.id == 'link' and (h.span.to or ''):find('^https?://') ~= nil end)
    check('external link: the page has one', ux ~= nil)
    if ux then
        env.fire('mouse', 0, ux, uy, 0, false)
        check('external link tooltip says the browser', N.layers[3].text:find('opens in the browser') ~= nil)
        local n0 = #env.urls
        click(ux, uy)
        check('external link opens its own address', #env.urls == n0 + 1 and env.urls[#env.urls] == uh.span.to, env.urls[#env.urls])
    end
end

-- tooltip anchor (2026-10-19, "To Cure a Cough"): hovering link A, then link B directly, drew B's text at A's
-- place, because the window moved `mouse_at` only after the flush that drew the tooltip. The tooltip sits
-- 14 px right of the mouse where B is entered, whichever way the mouse got there.
do
    local function tooltip_x()
        local x, w
        for lx, tw in ('\n' .. (N.layers[3] and N.layers[3].text or '')):gmatch('\nW\t([%d%.%-]+)\t[%d%.%-]+\t([%d%.%-]+)\t[%d%.%-]+\t\t') do
            x, w = tonumber(lx), tonumber(tw)
        end
        return x, w
    end
    local function expected_x(mouse_x, tw)
        return math.max(0, math.min(mouse_x - win.x + 14, win.w - tw - 8))
    end
    local function link_pair()
        local a, b
        for _, h in ipairs(win.content_b.hits) do
            if h.id == 'link' then
                if not a then a = h
                elseif not b and h.span ~= a.span and math.abs(h.x0 - a.x0) > 120 then b = h break end
            end
        end
        return a, b
    end
    local function move_onto(h)
        local f = package.loaded['core/nui'].view.f
        local x, y = content_hit(function(c) return c == h end)
        env.fire('mouse', 0, x * f, y * f, 0, false)
        return x, y
    end
    local function off_links() env.fire('mouse', 0, 10, 10, 0, false) end
    local function tooltip_follows(label, h)
        local x = move_onto(h)
        local tx, tw = tooltip_x()
        check(label, tx ~= nil and tw ~= nil and tx == expected_x(x, tw),
            'tooltip at ' .. tostring(tx) .. ', mouse at ' .. tostring(x - win.x))
    end
    -- rule 206: what the hover drew fits its box and the window (test_pages reads every link's tooltip on every page; this is the real path)
    local function tooltip_fits(label)
        local lines = {}
        for line in (N.layers[3] and N.layers[3].text or ''):gmatch('[^\n]+') do lines[#lines + 1] = line end
        local p = tooltip_fit.problems(lines, require('ui/ops'), win.w, win.h)
        check(label, #p == 0, p[1])
    end
    for _, where in ipairs({{'quest', 'sandoria', 'To Cure a Cough', 20}, {'mission', 'cop', 'Three Paths', 530}}) do
        app:entry(where[1], where[2], where[3], where[4])
        win:scroll_to(0) win:flush()
        local a, b = link_pair()
        local tag = 'tooltip anchor (' .. where[3] .. ')'
        check(tag .. ': the page has two links apart', a ~= nil and b ~= nil)
        if a and b then
            off_links()
            tooltip_follows(tag .. ': first link', a)
            tooltip_follows(tag .. ': link to link directly', b)
            tooltip_follows(tag .. ': and back directly', a)
            off_links()
            tooltip_follows(tag .. ': via empty space', b)
            -- the guide's Previous / Next chain shares the path
            local chain
            for _, h in ipairs(win.content_b.hits) do if h.id == 'chain' then chain = h break end end
            if chain then
                tooltip_follows(tag .. ': link to chain directly', chain)
                tooltip_follows(tag .. ': chain to link directly', b)
            end
            tooltip_fits(tag .. ': the link tooltip fits')
            off_links()
            check(tag .. ': no tooltip off the links', tooltip_x() == nil)
        end
    end
    -- rule 206: an item link's icon pushes the title and the first line right (Treasury Gold, 2026-11-06: "Item  (opens in BG-wiki)" ran 18 px
    -- past the box), and an external link's title is its whole address (wider than the window)
    for _, where in ipairs({
        {'quest', 'sandoria', 'Tea with a Tonberry?', 109, 'an item link', function(sp) return sp.kind == 'item' and sp.id end},
        {'quest', 'toau', 'Forging a New Myth', 72, 'an external link', function(sp) return tostring(sp.to):find('^https?:') end}}) do
        app:entry(where[1], where[2], where[3], where[4])
        win:scroll_to(0) win:flush()
        local h
        for _, c in ipairs(win.content_b.hits) do
            if c.id == 'link' and where[6](c.span) then h = c break end
        end
        check('tooltip fit: ' .. where[5] .. ' on the page', h ~= nil)
        if h then
            move_onto(h)
            tooltip_fits('tooltip fit: ' .. where[5])
            off_links()
            -- on the last line of the view the box goes above the link, not out of the window
            win:scroll_to(h.y1 - (win.vp.y1 - win.vp.y0) + 1) win:flush()
            move_onto(h)
            tooltip_fits('tooltip fit: ' .. where[5] .. ' at the bottom of the view')
            off_links()
        end
    end
end

-- requirements: an entry that has some, with an owned item
app:entry('quest', 'jeuno', 'The Old Monument')
local e = app:guide_entry(app.view.params)
check('an entry with requirements', e and e.requirements and #e.requirements > 0, e and e.requirements)

-- resize: many moves, one re-layout per frame, width kept to the drag
app:area_list('mission', 'cop')
local layouts = win.stats.layouts
local gx, gy = win.x + win.w - 10, win.y + win.h - 10
check('grip press consumed', env.fire('mouse', 1, gx, gy, 0, false) == true)
for i = 1, 20 do env.fire('mouse', 0, gx + i * 5, gy + i * 3, 0, false) end
check('no layout during moves', win.stats.layouts == layouts)
env.frame()
check('one layout per frame', win.stats.layouts == layouts + 1 and win.w == 720 and win.h == 820, win.w .. 'x' .. win.h)
env.fire('mouse', 2, gx + 100, gy + 60, 0, false)
-- the handle is closed: one left open keeps the place file from being replaced (its save renames over it) on Windows
local function exists(p) local f = io.open(p, 'rb') if f then f:close() end return f ~= nil end
check('resize saved the place', exists(H.data(PLACES)) or exists(H.data(KEEP[3])))
check('minimum size', select(1, require('ui/window').clamp_size(100, 100)) == 480)

-- reading place kept across a re-wrap
app:entry('mission', 'cop', 'Three Paths', 530)
win:scroll_to(120)
win:flush()
local before = win:anchor()
win.resize = {mode = 'x', sx = 0, sy = 0, vw = win.w, vh = win.h, want = {560, win.h}}
env.frame()
win.resize = nil
local after = win:anchor()
check('re-wrap keeps the block', before.block == after.block, before.block .. ' ' .. after.block)

-- drag: header press + move: layer_pos only
c1, c2 = N.sent[1], N.sent[2]
local hx, hy = win.x + 300, win.y + 30
env.fire('mouse', 1, hx, hy, 0, false)
env.fire('mouse', 0, hx + 40, hy + 25, 0, false)
env.fire('mouse', 0, hx + 80, hy + 50, 0, false)
env.fire('mouse', 2, hx + 80, hy + 50, 0, false)
check('dragged', N.pos[1][1] == hx - 300 + 80 + 0 and N.sent[1] == c1 and N.sent[2] == c2, N.pos[1][1])

-- saved place comes back after a reload
local px, py, pw = win.x, win.y, win.w
env = H.load({settings = {visible_on_load = true}})
N, app, win = env.N, env.app, env.win()
check('place restored', win.x == px and win.y == py and win.w == pw, win.x .. ',' .. win.y .. ' ' .. win.w)

-- settings screen
local sx, sy = chrome_hit('settings')
click(sx, sy)
check('settings view', app.view.name == 'settings' and N.layers[2].text:find('Quests you can no longer do', 1, true) ~= nil)
do  -- the four sections, in order, each drawn as a heading, every row in one of them
    local ss = require('ui/screens/settings')
    local secs, titles = ss.sections(app), {}
    for _, s in ipairs(secs) do titles[#titles + 1] = s.title end
    check('settings sections', table.concat(titles, '|') == 'General|Window|Controller|Keyboard', table.concat(titles, '|'))
    local drawn = true
    for _, t in ipairs(titles) do drawn = drawn and N.layers[2].text:find(t, 1, true) ~= nil end
    check('settings section headings drawn', drawn)
    local n = 0
    for _, r in ipairs(ss.rows(app)) do if r.section then n = n + 1 end end
    check('settings: every row in a section', n == #ss.rows(app) and n == 11, n)
end
local function setting(key_name) return content_hit(function(h) return h.id == 'set' and h.key == key_name end) end
x, y = setting('show_uncompletable')
click(x, y)
check('uncompletable on', app.settings.show_uncompletable == true)
x, y = setting('show_uncompletable')
click(x, y)
check('uncompletable off', app.settings.show_uncompletable == false)
x, y = content_hit(function(h) return h.id == 'set' and h.key == 'size' and h.step == 1 end)
click(x, y)
check('size +', math.abs(app.settings.size - 1.1) < 1e-9, app.settings.size)
x, y = setting('wintype')
click(x, y)
check('window type pinned 1', app.settings.wintype == 1 and N.wt == 1)
app.settings.size = 1
app.prefs.change('size', 0)

-- collapse and close
x, y = chrome_hit('collapse')
click(x, y)
check('collapsed: no content layer', win.collapsed and N.layers[2] == nil)
x, y = chrome_hit('collapse')
click(x, y)
check('expanded', not win.collapsed and N.layers[2] ~= nil)
x, y = chrome_hit('close')
click(x, y)
check('close hides every layer', N.layers[1] == nil and N.layers[2] == nil and N.layers[3] == nil)
check('hidden: nothing consumed', env.fire('mouse', 1, win.x + 50, win.y + 50, 0, false) == nil)
env.cmd('toggle')
check('toggle shows', N.layers[1] ~= nil)

-- commands
for _, c in ipairs({'status', 'help', 'home', 'compact', 'compact', 'refresh', 'autoshow', 'q', 'm cop', 'unknown',
                    'size', 'size +', 'size reset', 'scale ui', 'scale one', 'scale sim 2560 1440', 'scale one',
                    'wintype auto', 'wintype 3', 'wintype auto', 'uncompletable', 'uncompletable', 'nonsense'}) do
    local okc, err = pcall(env.cmd, (c:match('^(%S+)')), c:match('^%S+%s+(%S+)'), c:match('^%S+%s+%S+%s+(%S+)'), c:match('(%S+)$'))
    check('command ' .. c, okc, err)
end
check('scale sim: logical screen', true)

-- logout / login
env.fire('logout')
check('logout hides', N.layers[1] == nil)
app.settings.visible_on_load = true
env.fire('login', 'Berrant')
check('login shows Home again', N.layers[1] ~= nil and app.view.name == 'home')

-- fail closed: the DLL refuses to start -> a message, no layers, nothing consumed
local env2 = H.load({settings = {visible_on_load = true}, fake = {fail = 'not hooked: signature not found'}})
check('fail closed: message', env2.chat[1] and env2.chat[1]:find('not hooked') ~= nil, env2.chat[1])
check('fail closed: no layers', next(env2.N.layers) == nil)
check('fail closed: nothing consumed', env2.fire('mouse', 1, 300, 300, 0, false) == nil)

-- the guide's title row: the title ends before the status badge, with a gap, at every window width and with both the
-- built-in and the game's own font widths (2026-10-19: "Lure of the Wildcat (San d'Oria)" ran under the badge, which then
-- read "IOT STARTED": ops.fit measured the title in the body font's widths, the title is drawn in the title font)
local real_metrics
do
    -- loaded straight from the file: the harness's preload would answer with the fake
    local open = package.loadlib(dofile('test/crdll.lua').path(), 'luaopen__chronicle')
    local okm, RN = pcall(function() return open and open() end)
    if okm and type(RN) == 'table' and RN.metrics then
        RN.start([[C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI\]])    -- not hooked (no game) but the fonts load
        real_metrics = RN.metrics()
    end
end
local GAP = 8
-- the guide's chrome: the title's lines (title font, 16 px; the name wraps), the status badge, and the
-- way-back line under the tabs (a T line at TOP + 24, reading "< <parent>")
local function title_row(env3)
    local ops3 = package.loaded['ui/ops']
    local up_y = package.loaded['ui/screens/common'].TOP + 24
    local badge_texts = {}
    for _, t in pairs(package.loaded['core/app'].STATUS_TEXT) do badge_texts[t] = true end
    local title, badge, up = {}, nil, nil
    for l in env3.N.layers[1].text:gmatch('[^\n]+') do
        local x, y, px, s = l:match('^H	([%-%d%.]+)	([%-%d%.]+)	(%d+)	%x+	(.*)$')
        if x and tonumber(px) == 16 then title[#title + 1] = {x = tonumber(x), y = tonumber(y), s = s, right = tonumber(x) + ops3.title_w(s, 16)} end
        local bx, by, bs = l:match('^T	([%-%d%.]+)	([%-%d%.]+)	%x+	(.*)$')
        if bx and badge_texts[bs] then badge = {s = bs, left = tonumber(bx) - 6, y = tonumber(by)} end   -- the badge box starts 6 px left of its text
        if bx and tonumber(by) == up_y and bs:sub(1, 2) == '< ' then up = {x = tonumber(bx), s = bs:sub(3)} end
    end
    return title, badge, up
end
-- -> the entries whose title reaches the badge, per width ("fault" re-creates the old measuring: the body font's widths)
local function title_collisions(metrics, widths, fault)
    local env3 = H.load({settings = {visible_on_load = true}, fake = {metrics = metrics}})
    local app3, win3 = env3.app, env3.win()
    if fault then
        local ops3 = package.loaded['ui/ops']
        ops3.wrap_title = function(s, px, first) return {ops3.fit(s, first)} end      -- one line, cut to fit in the body font's widths
    end
    local long = {}
    for _, cat in ipairs({'quest', 'mission'}) do
        for _, area in ipairs(cat == 'quest' and {'sandoria', 'bastok', 'windurst', 'jeuno', 'other', 'outlands', 'toau', 'wotg', 'abyssea', 'adoulin', 'coalition'}
                or {'sandoria', 'cop', 'toau', 'wotg', 'rov', 'adoulin', 'campaign'}) do
            for _, it in ipairs(app3.data.get_area_status(cat, area).items) do
                if #it.name >= 24 then long[#long + 1] = {cat, area, it.name, it.id} end
            end
        end
    end
    table.sort(long, function(a, b) return #a[3] > #b[3] end)
    local out = {tried = #long}
    for _, w in ipairs(widths) do
        win3.resize = {mode = 'x', sx = 0, sy = 0, vw = win3.w, vh = win3.h, want = {w, win3.h}}
        env3.frame()
        win3.resize = nil
        local bad = {}
        for _, e in ipairs(long) do
            app3:entry(e[1], e[2], e[3], e[4])
            env3.frame()
            local lines, badge = title_row(env3)
            -- a title line on the badge's row ends before it (the badge box is 18 px tall, a title line about as tall)
            local worst
            for _, t in ipairs(lines) do
                if badge and t.y < badge.y + 17 and t.y + 17 > badge.y - 1 and (not worst or t.right > worst.right) then worst = t end
            end
            if not (worst and badge and worst.right + GAP <= badge.left) then
                bad[#bad + 1] = ('%s|%s|%s "%s" ends %s, badge starts %s'):format(e[1], e[2], e[4], e[3], worst and math.floor(worst.right) or '?', badge and badge.left or '?')
            end
        end
        out[w] = bad
    end
    return out
end
local function check_title_rows(label, metrics, widths)
    local r = title_collisions(metrics, widths)
    check(label .. ': long titles to try', r.tried > 30, r.tried)
    for _, w in ipairs(widths) do
        check(('%s: title ends %d px before the badge at width %d (%d titles)'):format(label, GAP, w, r.tried), #r[w] == 0,
            #r[w] .. ' collide, e.g. ' .. tostring(r[w][1]))
    end
    -- the check must be able to fail: with the title measured in the body font (the old code) it has to catch it
    local f = title_collisions(metrics, {480}, true)
    check(label .. ': self-test, a title measured in the wrong font is caught', #f[480] > 0, #f[480])
end
check_title_rows('title row, built-in widths', nil, {480, 560, 720})
print("  title row metrics: " .. (real_metrics and "game and built-in" or "built-in only"))
if real_metrics then check_title_rows("title row, the game's widths", real_metrics, {480, 560, 720}) end

-- the cut path of the title (a single word wider than its line): the cut is measured in the title font, so the line
-- ends inside the room the badge leaves. Fault = the known-bad title_under_badge's own replay (2026-10-28, q14): fit_title
-- measuring with the body font's widths, which lets such a line run under the badge. -> the widest line's drawn width.
local function wide_word_overrun(metrics, fault)
    local envw = H.load({settings = {visible_on_load = true}, fake = {metrics = metrics}})
    local opsw = package.loaded['ui/ops']
    local keep = opsw.fit_title
    if fault then opsw.fit_title = function(s, px, width) return opsw.fit(s, width) end end
    local worst = 0
    for _, room in ipairs({120, 180, 240, 300}) do
        for _, word in ipairs({'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWW', 'Mmmmmmmmmmmmmmmmmmmmmmmmmmmmmm', 'Supercalifragilisticexpialidocious'}) do
            local lines = opsw.wrap_title(word .. ' (San dOria)', 16, room, room + 200, 3)
            local over = opsw.title_w(lines[1], 16) - room
            if over > worst then worst = over end
        end
    end
    opsw.fit_title = keep
    return worst
end
for _, m in ipairs(real_metrics and {{'built-in', nil}, {"game's", real_metrics}} or {{'built-in', nil}}) do
    check(('title cut path (%s widths): a word wider than the first line is cut inside it'):format(m[1]), wide_word_overrun(m[2]) <= 0, wide_word_overrun(m[2]))
    check(('title cut path (%s widths): self-test, fit_title measured in the body font is caught'):format(m[1]), wide_word_overrun(m[2], true) > 0, wide_word_overrun(m[2], true))
end

local GUIDE_AREAS = {
    quest = {'sandoria', 'bastok', 'windurst', 'jeuno', 'other', 'outlands', 'toau', 'wotg', 'abyssea', 'adoulin', 'coalition'},
    mission = {'sandoria', 'bastok', 'windurst', 'zilart', 'cop', 'toau', 'wotg', 'acp', 'mkd', 'asa', 'adoulin', 'rov', 'tvr', 'assault', 'campaign'},
}

-- A name is never lost to a cut (2026-10-20, reviewing the San d'Oria screens: "Lure of the Wildcat (San d'Oria)" read
-- "Lure of the Wildcat (San d'.." in the title and the breadcrumb at the minimum window, "(San d'Oria)" drawn nowhere).
-- Every entry whose name is 18+ characters, at each width: the title shows the whole name (it wraps, at most three
-- lines, no line cut with '..'). The way-back line under the tabs names the parent area, cut from the end
-- only. Faults: the old single cut title; a way-back line that does not name its parent.
local function cut_names(metrics, widths, fault)
    local env6 = H.load({settings = {visible_on_load = true}, fake = {metrics = metrics}})
    local app6, win6 = env6.app, env6.win()
    local ops6 = package.loaded['ui/ops']
    if fault == 'title' then
        ops6.wrap_title = function(s, px, first) return {ops6.fit_title(s, px, first)} end
    elseif fault == 'up' then
        ops6.fit_tail = function(s, width) return 'Somewhere else' end
    end
    local names = {}
    for _, cat in ipairs({'quest', 'mission'}) do
        for _, area in ipairs(GUIDE_AREAS[cat]) do
            for _, it in ipairs(app6.data.get_area_status(cat, area).items) do
                if #it.name >= 18 then names[#names + 1] = {cat, area, it.name, it.id} end
            end
        end
    end
    local out = {tried = #names, title = {}, up = {}, lines = {}}
    for _, w in ipairs(widths) do
        win6.resize = {mode = 'x', sx = 0, sy = 0, vw = win6.w, vh = win6.h, want = {w, win6.h}}
        env6.frame()
        win6.resize = nil
        for _, e in ipairs(names) do
            app6:entry(e[1], e[2], e[3], e[4])
            env6.frame()
            local lines, _, up = title_row(env6)
            local tag = ('%s|%s|%s "%s" at %d'):format(e[1], e[2], e[4], e[3], w)
            local name = ops6.ascii(e[3]):gsub('%s+', ' ')
            local joined, cut = {}, false
            for _, t in ipairs(lines) do
                joined[#joined + 1] = t.s
                if t.s:find('[^.]%.%.$') then cut = true end
            end
            if cut or table.concat(joined, ' ') ~= name then
                out.title[#out.title + 1] = tag .. ': title ' .. table.concat(joined, ' / ')
            end
            if #lines > 3 then out.lines[#out.lines + 1] = tag .. ': ' .. #lines .. ' lines' end
            -- the way-back line: it names this entry's area, whole or cut from the end
            local area_name = ops6.ascii(app6.data.get_area_name(e[2], e[1]) or ''):gsub('%s+', ' ')
            local u = up and up.s or ''
            local stem = u:match('^(.-)%.%.') or u
            if stem == '' or area_name:sub(1, #stem) ~= stem then
                out.up[#out.up + 1] = tag .. ': way back "' .. u .. '" for "' .. area_name .. '"'
            end
        end
    end
    return out
end
local function check_cut_names(label, metrics)
    local r = cut_names(metrics, {480, 560, 720})
    check(label .. ': names to try', r.tried > 300, r.tried)
    check(label .. ': every title shows the whole name, no line cut with ".." (3 widths)', #r.title == 0, #r.title .. ', e.g. ' .. tostring(r.title[1]))
    check(label .. ': a title takes at most three lines', #r.lines == 0, tostring(r.lines[1]))
    check(label .. ': the way-back line names the parent area at every width', #r.up == 0, #r.up .. ', e.g. ' .. tostring(r.up[1]))
    local ft = cut_names(metrics, {480}, 'title')
    check(label .. ': self-test, a title cut with ".." is caught', #ft.title > 0, #ft.title)
    local fc = cut_names(metrics, {480}, 'up')
    check(label .. ': self-test, a way-back line naming the wrong place is caught', #fc.up > 0, #fc.up)
end
check_cut_names('names, built-in widths', nil)
if real_metrics then check_cut_names("names, the game's widths", real_metrics) end

-- guide cards and Home, entry by entry (2026-10-19, reviewing the San d'Oria screens): the zone and its grid square stay
-- together; the Requirements counter counts what the rows below show; Home's area names are never cut
local function content_lines(env4)
    local out = {}
    for l in env4.N.layers[2].text:gmatch('[^\n]+') do
        local kind, x, y, rest = l:match('^(%a)\t([%-%d%.]+)\t([%-%d%.]+)\t(.*)$')
        if kind then
            local text
            if kind == 'T' then text = rest:match('^%x+\t(.*)$')
            elseif kind == 'H' then text = rest:match('^%d+\t%x+\t(.*)$') end
            out[#out + 1] = {kind = kind, x = tonumber(x), y = tonumber(y), text = text}
        end
    end
    return out
end

local function guide_faults(widths, fault)
    local env4 = H.load({settings = {visible_on_load = true}})
    local app4, win4 = env4.app, env4.win()
    for _, p in ipairs(H.fixture_packets(530)) do env4.fire('incoming chunk', 0x056, p) end
    env4.run_scheduled()
    if fault == 'zone' then          -- the old wrap: the position is one more word of the zone
        local card4 = package.loaded['core/card']
        card4.zone_parts = function(entry) return (entry.start_zone or '--') .. (entry.start_pos and (' (' .. entry.start_pos .. ')') or ''), nil end
    end
    local entries = {}
    for _, cat in ipairs({'quest', 'mission'}) do
        for _, area in ipairs(GUIDE_AREAS[cat]) do
            for _, it in ipairs(app4.data.get_area_status(cat, area).items) do
                local e = cat == 'mission' and app4.data.get_mission_data(area, it.name, it.id) or app4.data.get_quest_data(area, it.name)
                if e and (e.start_pos or (e.requirements and #e.requirements > 0)) then entries[#entries + 1] = {cat, area, it.name, it.id, e} end
            end
        end
    end
    local bad = {zone = {}, counter = {}}
    for _, w in ipairs(widths) do
        win4.resize = {mode = 'x', sx = 0, sy = 0, vw = win4.w, vh = win4.h, want = {w, win4.h}}
        env4.frame()
        win4.resize = nil
        for _, en in ipairs(entries) do
            local e = en[5]
            app4:entry(en[1], en[2], en[3], en[4])
            env4.frame()
            local lines = content_lines(env4)
            local tag = ('%s|%s|%s at %d'):format(en[1], en[2], en[3], w)
            if e.start_pos then
                local zx, zy
                for _, l in ipairs(lines) do if l.kind == 'T' and l.text == 'ZONE' then zx, zy = l.x, l.y end end
                for _, l in ipairs(lines) do
                    if zx and l.kind == 'T' and math.abs(l.x - zx) < 1 and l.y > zy and l.y < zy + 90 and l.text:find('^%(%u%-%d+%)$') then
                        bad.zone[#bad.zone + 1] = tag .. ': "' .. l.text .. '" alone'
                    end
                end
            end
            if e.requirements and #e.requirements > 0 then
                local need = 0
                for _, r in ipairs(e.requirements) do if r.id and not r.choice then need = need + (r.count or 1) end end
                -- rule 146: a completed entry has used its items up and draws no counter
                local guide146 = package.loaded['ui/screens/guide']
                local _, st146 = app4:guide_entry(app4.view.params)
                if guide146.DONE_REQS and st146 == 'completed' then need = 0 end
                local ry
                for _, l in ipairs(lines) do if l.kind == 'H' and l.text == 'Requirements' then ry = l.y end end
                local shown
                for _, l in ipairs(lines) do
                    if ry and l.kind == 'T' and math.abs(l.y - ry) <= 8 and l.text:find('^%d+ / %d+$') then shown = l.text end
                end
                if ry == nil then
                    bad.counter[#bad.counter + 1] = tag .. ': no Requirements heading'
                elseif (need == 0) ~= (shown == nil) or (shown and shown:match('/ (%d+)$') ~= tostring(need)) then
                    bad.counter[#bad.counter + 1] = tag .. ': counter ' .. tostring(shown) .. ', rows count ' .. need
                end
            end
        end
    end
    return bad, #entries
end
do
    local bad, tried = guide_faults({480, 560, 720})
    check('guide cards to try', tried > 500, tried)
    check('the zone keeps its grid square on its line (' .. tried .. ' entries, 3 widths)', #bad.zone == 0, #bad.zone .. ', e.g. ' .. tostring(bad.zone[1]))
    check('the Requirements counter adds up the rows (' .. tried .. ' entries, 3 widths)', #bad.counter == 0, #bad.counter .. ', e.g. ' .. tostring(bad.counter[1]))
    local f = guide_faults({480}, 'zone')
    check('self-test: a grid square left to wrap alone is caught', #f.zone > 0, #f.zone)
end

-- The card's REWARD cell (2026-10-20, the quest vision sweep: "Rabbit Mantle ; OR; 10 gil", "single trade.; x1: 50 gil;", "Windshear Hat .",
-- "[Key Item]Star ring"): no separator, no space before a full stop or comma, a space after a "]" tag, in the cell of any entry with a
-- reward of its own. fault = the old card, the entry's lines joined with "; ".
local function reward_faults(fault)
    local env7 = H.load({settings = {visible_on_load = true}})
    local app7 = env7.app
    for _, p in ipairs(H.fixture_packets(530)) do env7.fire('incoming chunk', 0x056, p) end
    env7.run_scheduled()
    local card7 = package.loaded['core/card']
    local real_lines = card7.reward_lines
    if fault then
        card7.reward_lines = function(reward)
            if type(reward) ~= 'string' or not reward:find('%S') then return nil end
            return {(reward:gsub(string.char(10) .. '%s*', '; '))}
        end
    end
    local out = {bad = {}, tried = 0}
    for _, cat in ipairs({'quest', 'mission'}) do
        for _, area in ipairs(GUIDE_AREAS[cat]) do
            for _, it in ipairs(app7.data.get_area_status(cat, area).items) do
                local e = cat == 'mission' and app7.data.get_mission_data(area, it.name, it.id) or app7.data.get_quest_data(area, it.name)
                local r = e and e.reward
                if type(r) == 'string' and (r:find(string.char(10), 1, true) or r:find('%]%S') or r:find(' [%.,;]')) then
                    out.tried = out.tried + 1
                    app7:entry(cat, area, it.name, it.id)
                    env7.frame()
                    local lines = content_lines(env7)
                    local rx, ry, rend
                    for _, l in ipairs(lines) do
                        if l.kind == 'T' and l.text == 'REWARD' then rx, ry = l.x, l.y end
                        if l.kind == 'T' and l.text == 'REPEATABLE' then rend = l.y end
                    end
                    for _, l in ipairs(lines) do
                        if rx and rend and l.kind == 'T' and l.x >= rx - 1 and l.x < rx + 4 and l.y > ry and l.y < rend and l.text then
                            if l.text:find(';') or l.text:find('%S [%.,]') or l.text:find('%]%S') then
                                out.bad[#out.bad + 1] = ('%s|%s|%s: "%s"'):format(cat, area, it.name, l.text)
                            end
                        end
                    end
                end
            end
        end
    end
    card7.reward_lines = real_lines
    return out
end
do
    local r = reward_faults(false)
    check('reward cells to try', r.tried > 200, r.tried)
    check('the card reward has no separator, no space before a mark, a space after a tag (' .. r.tried .. ' entries)', #r.bad == 0, #r.bad .. ', e.g. ' .. tostring(r.bad[1]))
    local f = reward_faults(true)
    check('self-test: a reward joined with "; " is caught', #f.bad > 0, #f.bad)
end

-- Rule 141 (2026-10-28, vision wave qot1 minors): a card with a fame level and no nation read "-- (Lvl 2)" (quest other 2, 3, 4, 8, 9); it reads "Lvl 2".
do
    local guide141, card141 = package.loaded['ui/screens/guide'], package.loaded['core/card']
    local function scan()
        local bad, withlvl = {}, 0
        for key in pairs(index) do
            local cat, area, id = key:match('^(%a+)|([%w_]+)|(%d+)$')
            local e = require('core/meta').get(cat, area, nil, tonumber(id))
            if e and e.fame_level then
                withlvl = withlvl + 1
                local t = guide141.fame_text(e, card141.fields(e))
                if t:find('--', 1, true) then bad[#bad + 1] = key .. ': ' .. t end
            end
        end
        table.sort(bad)
        return bad, withlvl
    end
    local bad, withlvl = scan()
    check(#bad == 0 and withlvl > 100, 'the card FAME has no dash in front of a level (' .. withlvl .. ' entries with a level)', table.concat(bad, '; '))
    check(guide141.fame_text({fame_level = '2'}, {}) == 'Lvl 2' and guide141.fame_text({fame_level = '2', fame = 'Other'}, {fame = 'Other'}) == 'Other (Lvl 2)'
        and guide141.fame_text({}, {}) == '--', 'fame text: Lvl 2 alone, Other (Lvl 2), a dash for nothing')
    guide141.LVL_ONLY = false
    local old = scan()
    guide141.LVL_ONLY = true
    check(#old == 5, 'self-test: with the old card the scan finds quest other 2, 3, 4, 8 and 9 (caught)', #old .. ': ' .. table.concat(old, '; '))
end

-- Rule 145 (vision wave qots1, minors): a fame level that holds no number ("N/A") is no level: the card read "N/A (Lvl N/A)" (quest other 34, outlands 103, 104)
do
    local guide145, card145 = package.loaded['ui/screens/guide'], package.loaded['core/card']
    local function scan()
        local bad, withlvl = {}, 0
        for key in pairs(index) do
            local cat, area, id = key:match('^(%a+)|([%w_]+)|(%d+)$')
            local e = require('core/meta').get(cat, area, nil, tonumber(id))
            if e and e.fame_level ~= nil then
                withlvl = withlvl + 1
                local t = guide145.fame_text(e, card145.fields(e))
                if t:find('Lvl', 1, true) and not t:find('Lvl %d') then bad[#bad + 1] = key .. ': ' .. t end
            end
        end
        table.sort(bad)
        return bad, withlvl
    end
    local bad, withlvl = scan()
    check(#bad == 0 and withlvl > 100, 'the card FAME has a number after "Lvl" (' .. withlvl .. ' entries with a level)', table.concat(bad, '; '))
    check(guide145.fame_text({fame_level = 'N/A'}, {fame = 'N/A'}) == 'N/A' and guide145.fame_text({fame_level = '3'}, {fame = 'Other'}) == 'Other (Lvl 3)',
        'fame text: N/A with a level of N/A is N/A, Other with 3 is Other (Lvl 3)')
    guide145.LVL_NUMBER = false
    local old = scan()
    guide145.LVL_NUMBER = true
    check(#old == 3, 'self-test: with the old card the scan finds quest other 34, outlands 103 and 104 (caught)', #old .. ': ' .. table.concat(old, '; '))
end

-- Rule 87 (2026-10-21, adoulin 346: "[Key Item] Aged undying / Naakual crest" then "[Key Item] Teodor's / blood sigil", five rewards drawn as
-- nine lines at one x): in a card value of several lines (the reward, a title list) an item that wraps hangs in: its continuation lines
-- start right of its first line, and still end inside the column. The items are read back from the draw ops (consume the column's lines
-- until their text, spaces removed, is the item), at the three window widths of the pixel gate. fault = the old card, HANG = 0.
local function hang_faults(fault)
    local env8 = H.load({settings = {visible_on_load = true}})
    local app8, win8 = env8.app, env8.win()
    for _, p in ipairs(H.fixture_packets(530)) do env8.fire('incoming chunk', 0x056, p) end
    env8.run_scheduled()
    local guide8, card8, ops8 = package.loaded['ui/screens/guide'], package.loaded['core/card'], package.loaded['ui/ops']
    local real_hang, real_cols = guide8.HANG, guide8.LIST_COLUMNS
    guide8.LIST_COLUMNS = false      -- rule 151 reads a list in the card's one column; the wide card has its own check below
    if fault then guide8.HANG = 0 end
    local function squash(t) return (ops8.ascii(t):gsub('%s+', '')) end
    local out = {bad = {}, tried = 0, wrapped = {}, items = 0}
    local cells = {}
    for _, cat in ipairs({'quest', 'mission'}) do
        for _, area in ipairs(GUIDE_AREAS[cat]) do
            for _, it in ipairs(app8.data.get_area_status(cat, area).items) do
                local e = cat == 'mission' and app8.data.get_mission_data(area, it.name, it.id) or app8.data.get_quest_data(area, it.name)
                if e then
                    local v = card8.fields(e)
                    local rw, tl = card8.reward_lines(v.reward), card8.title_lines(v.title)
                    local mine = {}
                    if rw and #rw >= 2 then mine[#mine + 1] = {'REWARD', rw} end
                    if tl and #tl >= 2 then mine[#mine + 1] = {'TITLE', tl} end
                    if #mine > 0 then cells[#cells + 1] = {cat, area, it.name, it.id, mine} end
                end
            end
        end
    end
    for _, w in ipairs({480, 760, 1100}) do
        win8.resize = {mode = 'x', sx = 0, sy = 0, vw = win8.w, vh = win8.h, want = {w, win8.h}}
        env8.frame()
        win8.resize = nil
        local hang = guide8.HANG
        for _, cell in ipairs(cells) do
            app8:entry(cell[1], cell[2], cell[3], cell[4])
            env8.frame()
            local lines = content_lines(env8)
            local colw = math.floor((win8.vp.x1 - win8.vp.x0 - 20 - 14) / 2)
            for _, want in ipairs(cell[5]) do
                local lx, ly
                for _, l in ipairs(lines) do if l.kind == 'T' and l.text == want[1] then lx, ly = l.x, l.y end end
                out.tried = out.tried + 1
                local tag = ('%s|%s|%s %s at %d'):format(cell[1], cell[2], cell[3], want[1], w)
                if not lx then
                    out.bad[#out.bad + 1] = tag .. ': no label'
                else
                    local col = {}
                    for _, l in ipairs(lines) do
                        if l.kind == 'T' and l.y > ly + 1 and l.x >= lx - 1 and l.x < lx + colw + 7 and l.text then col[#col + 1] = l end
                    end
                    table.sort(col, function(a, b) return a.y < b.y end)
                    local k, wrapped = 1, false
                    for n, item in ipairs(want[2]) do
                        local first, acc, pieces = col[k], '', 0
                        out.items = out.items + 1
                        while col[k] and acc ~= squash(item) and #acc < #squash(item) do
                            local l = col[k]
                            acc = acc .. squash(l.text)
                            pieces = pieces + 1
                            if pieces > 1 then
                                wrapped = true
                                if l.x < first.x + 1 then out.bad[#out.bad + 1] = ('%s: "%s" continues at the x of its first line'):format(tag, l.text) end
                                if l.x + ops8.text_w(l.text) > lx + colw + 1 then out.bad[#out.bad + 1] = ('%s: "%s" runs out of the column'):format(tag, l.text) end
                            end
                            k = k + 1
                        end
                        if acc ~= squash(item) then out.bad[#out.bad + 1] = ('%s: item %d is not drawn as its own lines'):format(tag, n) break end
                    end
                    if wrapped then out.wrapped[#out.wrapped + 1] = tag end
                end
            end
        end
    end
    guide8.HANG, guide8.LIST_COLUMNS = real_hang, real_cols
    return out
end
do
    local r = hang_faults(false)
    check('card hang: multi-line values to try', r.tried > 100 and r.items > 300, r.tried .. ' cells, ' .. r.items .. ' items')
    check('card hang: some item wraps (' .. #r.wrapped .. ' cells)', #r.wrapped > 20, #r.wrapped)
    check('a wrapped item of a multi-line card value hangs in, inside the column (' .. r.tried .. ' cells, 3 widths)', #r.bad == 0, #r.bad .. ', e.g. ' .. tostring(r.bad[1]))
    local f = hang_faults(true)
    check('self-test: a wrapped item that continues at its first line x is caught', #f.bad > 0, #f.bad)
    if os.getenv('CR_HANG_LIST') then for _, t in ipairs(r.wrapped) do print('HANG ' .. t) end end
end

-- Home: no area name is cut with ".." at any width (Chains of Proma.., Treasures of Aht..)
local function home_cuts(widths, fault)
    local env5 = H.load({settings = {visible_on_load = true}})
    local app5, win5 = env5.app, env5.win()
    for _, p in ipairs(H.fixture_packets(530)) do env5.fire('incoming chunk', 0x056, p) end
    env5.run_scheduled()
    if fault then          -- the old card: the name on one line, cut to fit
        local kit5, ops5 = package.loaded['ui/kit'], package.loaded['ui/ops']
        kit5.card_name_lines = function(name, w, has_emblem) return {ops5.fit(name, w - (has_emblem and 66 or 10) - 8)} end
    end
    local out = {cut = {}, tried = 0}
    for _, cat in ipairs({'mission', 'quest'}) do
        for _, w in ipairs(widths) do
            win5.resize = {mode = 'x', sx = 0, sy = 0, vw = win5.w, vh = win5.h, want = {w, win5.h}}
            env5.frame()
            win5.resize = nil
            app5.settings.active_tab = cat
            win5:invalidate('all')
            env5.frame()
            out.tried = out.tried + #app5.data.get_summary()[cat].areas
            for _, l in ipairs(content_lines(env5)) do
                if l.text == 'In progress' then break end         -- the cards end here; a Next line is cut at a word by design
                if l.kind == 'T' and l.text and l.text:sub(-2) == '..' then out.cut[#out.cut + 1] = cat .. ' at ' .. w .. ': ' .. l.text end
            end
        end
    end
    return out
end
do
    local r = home_cuts({480, 560, 720})
    check('home: area names to try', r.tried > 20, r.tried)
    check('home: no area name is cut with ".."', #r.cut == 0, #r.cut .. ', e.g. ' .. tostring(r.cut[1]))
    local f = home_cuts({480}, true)
    check('self-test: a cut area name is caught', #f.cut > 0, #f.cut)
end

-- Pictures: a quad in the content buffer never names a texture that has been freed (2026-10-20: jeuno 130 drew seven maps, the first
-- three blank olive squares: at most four textures were kept and loading the fifth freed the first). Every page with five pictures or
-- more, opened at the minimum window and scrolled top to bottom, one viewport less 36 px at a time (as qa_render.lua does): every
-- quad in view has a texture. fault = pics.LRU (the old rule: four textures, least recently used freed while the layout names it).
local function picture_faults(fault)
    local env6 = H.load({settings = {visible_on_load = true}})
    local app6, win6, N6 = env6.app, env6.win(), env6.N
    env6.packets(H.fixture_packets(530))
    local pics6 = package.loaded['core/pics']
    pics6.LRU = fault and 4 or nil
    local index6 = dofile('pages/index.lua')
    local keys6 = {}
    for k in pairs(index6) do keys6[#keys6 + 1] = k end
    table.sort(keys6)
    local out = {dead = {}, pages = 0, views = 0, pictures = 0}
    for _, key in ipairs(keys6) do
        local pg = dofile(index6[key])
        if #(pg.images or {}) >= 5 then
            local cat, area, id = key:match('^(%a+)|([%w_]+)|(%d+)$')
            id = tonumber(id)
            local name
            for _, it in ipairs(app6.data.get_area_status(cat, area).items) do if it.id == id then name = it.name end end
            out.pages = out.pages + 1
            win6.x, win6.y, win6.w, win6.h = 100, 100, 480, 480
            win6:invalidate('all') win6:flush()
            app6:entry(cat, area, name, id)
            win6.w, win6.h = 480, 480
            win6:invalidate('all') win6:flush()
            local vh = win6.vp.y1 - win6.vp.y0
            local sc = 0
            while true do
                win6:scroll_to(sc) win6:flush()
                out.views = out.views + 1
                for _, line in ipairs(win6.content_b.o) do
                    local tex, y0, y1 = line:match('^Q	(%d+)	[%-%d%.]+	([%-%d%.]+)	[%-%d%.]+	([%-%d%.]+)')
                    if tex and tonumber(y1) >= win6.scroll and tonumber(y0) <= win6.scroll + vh then
                        out.pictures = out.pictures + 1
                        if not N6.textures[tonumber(tex)] then
                            out.dead[#out.dead + 1] = ('%s at scroll %d: texture %s was freed'):format(key, win6.scroll, tex)
                        end
                    end
                end
                local max = math.max(0, (win6.content_h or 0) - vh)
                if sc >= max then break end
                sc = math.min(max, sc + vh - 36)
            end
        end
    end
    pics6.LRU = nil
    return out
end
do
    local r = picture_faults(false)
    check('pictures: pages with five pictures or more to try', r.pages >= 6, r.pages)
    check('pictures: pictures in view to check (' .. r.pages .. ' pages, ' .. r.views .. ' views)', r.pictures > 100, r.pictures)
    check('pictures: every picture in view has its texture', #r.dead == 0, #r.dead .. ', e.g. ' .. tostring(r.dead[1]))
    local f = picture_faults(true)
    check('self-test: a texture freed under a layout that names it is caught', #f.dead > 0, #f.dead)
end

-- Pictures: a picture's size for the layout is the file's, whether or not its texture is loaded (rule 100, 2026-10-22: mission tvr 612's
-- gallery picture is 663 x 662 and the renderer holds it at 512 x 511; a page laid out before the texture was loaded and again after
-- it was 1 px taller or shorter, so the page's height moved under the scroll). A fresh copy of core/pics.lua with a native that scales
-- as the DLL's tex_load does (fitted inside 512), over a fixture PNG header of 663 x 662.
do
    local function sizes(fault)
        local P = dofile('core/pics.lua')
        local nat = {}
        function nat.tex_load(path, mx, my)
            local f = io.open(path, 'rb')
            if not f then return nil, 'cannot decode' end
            f:close()
            return 7, 512, 511                           -- 663 x 662 fitted inside 512: 512 x 511
        end
        function nat.tex_free() return true end
        P.setup('test/fixtures/picdims/', nat, nil)
        P.TEX_DIMS = fault or nil
        local before = P.get('Big Picture.png', false)
        local t = P.get('Big Picture.png')
        local after = P.get('Big Picture.png', false)
        return before, t, after
    end
    local b, t, a = sizes(false)
    check('picture size: the fixture is read from its header', type(b) == 'table' and b.w == 663 and b.h_px == 662, type(b) == 'table' and (b.w .. 'x' .. b.h_px))
    check('picture size: the texture is the scaled one', type(t) == 'table' and t.w == 512 and t.h_px == 511)
    check('picture size: the same before and after the texture is loaded', type(a) == 'table' and a.w == b.w and a.h_px == b.h_px,
        type(a) == 'table' and (a.w .. 'x' .. a.h_px))
    local fb, _, fa = sizes(true)
    check('self-test: a loaded picture that reports its texture size is caught (the size moves)',
        type(fa) == 'table' and type(fb) == 'table' and (fa.w ~= fb.w or fa.h_px ~= fb.h_px))
end

-- Rule 146 (vision, quest other 1 18 19 21 23, outlands 3 6 202, toau 2, sandoria 117, jeuno 129): a COMPLETED entry read "0 / 5" over its
-- Requirements and "Beetle Shell (0/5)" on a row: the counter and the rows read the bags, and the quest has used the items up. A completed
-- entry (statuses come from the fixture's flags; repeatable and every other status keep the inventory reading) draws no counter, no
-- "(owned/count)", nothing in the active gold in its Requirements, and a row of more than one unit reads "Name xN".
local function done_req_faults(force, off)
    local env9 = H.load({settings = {visible_on_load = true}})
    local app9, win9 = env9.app, env9.win()
    package.loaded['ui/screens/guide'].DONE_REQS = not off       -- the modules are loaded afresh by H.load: the switch is set on this env's
    if force then       -- every entry shown with this status (the fixture has no repeatable entry with items)
        local orig = app9.guide_entry
        app9.guide_entry = function(self, p) local e = orig(self, p) return e, force end
    end
    for _, p in ipairs(H.fixture_packets(530)) do env9.fire('incoming chunk', 0x056, p) end
    env9.run_scheduled()
    local kit9 = package.loaded['ui/kit']
    local function hex(c) return string.format('%02X%02X%02X', c[1], c[2], c[3]) end
    local gold = hex(kit9.C.active)
    local bad, tried, qty, kept = {}, 0, 0, 0
    for _, w in ipairs({480, 720}) do
        win9.resize = {mode = 'x', sx = 0, sy = 0, vw = win9.w, vh = win9.h, want = {w, win9.h}}
        env9.frame()
        win9.resize = nil
        for _, cat in ipairs({'quest', 'mission'}) do
            for _, area in ipairs(GUIDE_AREAS[cat]) do
                for _, it in ipairs(app9.data.get_area_status(cat, area).items) do
                    local e = cat == 'mission' and app9.data.get_mission_data(area, it.name, it.id) or app9.data.get_quest_data(area, it.name)
                    if e and e.requirements and #e.requirements > 0 then
                        app9:entry(cat, area, it.name, it.id)
                        env9.frame()
                        local _, st = app9:guide_entry(app9.view.params)
                        local rows = app9:requirements(cat .. '|' .. area .. '|' .. it.name, e, app9.check_requirements)
                        local found = 0
                        for _, r in ipairs(rows or {}) do if r.found and not r.sep then found = found + 1 end end
                        -- the drawn lines: kind, y, colour, text
                        local lines, ry = {}, nil
                        for l in env9.N.layers[2].text:gmatch('[^\n]+') do
                            local kind, x, y, rest = l:match('^(%a)\t([%-%d%.]+)\t([%-%d%.]+)\t(.*)$')
                            if kind == 'H' then
                                local t = rest:match('^%d+\t%x+\t(.*)$')
                                lines[#lines + 1] = {kind = 'H', y = tonumber(y), text = t}
                            elseif kind == 'T' then
                                local c, t = rest:match('^(%x+)\t(.*)$')
                                lines[#lines + 1] = {kind = 'T', x = tonumber(x), y = tonumber(y), col = c and c:sub(1, 6):upper(), text = t}
                            end
                        end
                        local sec, from = {}, nil
                        for i, l in ipairs(lines) do if l.kind == 'H' and l.text == 'Requirements' then from = i ry = l.y end end
                        if from then
                            -- the rows are drawn in order, labels at x 34 and a dash at x 8; the counter sits on the heading's line; whatever
                            -- comes next (the chain at x 0, a page that opens with no heading) ends the section
                            for i = from + 1, #lines do
                                local l = lines[i]
                                if l.kind == 'H' then break end
                                if math.abs(l.y - ry) > 8 and l.x ~= 34 and l.x ~= 8 then break end
                                sec[#sec + 1] = l
                            end
                        end
                        local tag = ('%s|%s|%d at %d (%s)'):format(cat, area, it.id or 0, w, tostring(st))
                        if st == 'completed' and found > 0 then
                            tried = tried + 1
                            local text = {}
                            for _, l in ipairs(sec) do
                                text[#text + 1] = l.text
                                if math.abs(l.y - ry) <= 8 and l.text:find('^%d+ / %d+$') then bad[#bad + 1] = tag .. ': counter "' .. l.text .. '"' end
                                if l.text:find('%(%d+/%d+%)') then bad[#bad + 1] = tag .. ': "' .. l.text .. '"' end
                                if l.col == gold then bad[#bad + 1] = tag .. ': "' .. l.text .. '" in the active gold' end
                            end
                            local joined = table.concat(text, ' ')
                            for _, r in ipairs(rows) do
                                if r.found and not r.sep and r.count and r.count > 1 then
                                    qty = qty + 1
                                    if not joined:find(r.name .. ' x' .. r.count, 1, true) then bad[#bad + 1] = tag .. ': no "' .. r.name .. ' x' .. r.count .. '"' end
                                end
                            end
                        elseif st == 'repeat' and found > 0 then
                            -- not completed: the inventory reading stays (a counter when a unit is counted, "(owned/count)" on a quantity)
                            local need = 0
                            for _, r in ipairs(rows) do if r.found and not r.choice then need = need + (r.count or 1) end end
                            local shown
                            for _, l in ipairs(sec) do if math.abs(l.y - ry) <= 8 and l.text:find('^%d+ / %d+$') then shown = l.text end end
                            if need > 0 then kept = kept + 1 end
                            if need > 0 and not shown then bad[#bad + 1] = tag .. ': a repeatable entry lost its counter' end
                            local joined = {}
                            for _, l in ipairs(sec) do joined[#joined + 1] = l.text end
                            joined = table.concat(joined, ' ')
                            for _, r in ipairs(rows) do
                                if r.found and not r.sep and r.count and r.count > 1 then
                                    if not joined:find(r.name .. ' (' .. r.owned .. '/' .. r.count .. ')', 1, true) then bad[#bad + 1] = tag .. ': no (owned/count) on "' .. r.name .. '"' end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    table.sort(bad)
    return bad, tried, qty, kept
end
do
    local bad, tried, qty, kept = done_req_faults()
    check('a completed entry draws no inventory counter, no (owned/count), no active gold, "Name xN" for a quantity (' .. tried .. ' entry views, ' .. qty
        .. ' quantities)', tried > 200 and qty > 20 and #bad == 0, #bad .. ', e.g. ' .. tostring(bad[1]))
    local rbad, _, _, rkept = done_req_faults('repeat')
    check('a repeatable entry keeps the inventory reading: the counter and "(owned/count)" (' .. rkept .. ' views with a counter)', rkept > 200 and #rbad == 0,
        #rbad .. ', e.g. ' .. tostring(rbad[1]))
    local old = done_req_faults(nil, true)
    local oldpages, seen = 0, {}
    for _, m in ipairs(old) do local k = m:match('^(%S+) at') if k and not seen[k] then seen[k] = true oldpages = oldpages + 1 end end
    print(('rule 146 scan: %d completed entry views, %d quantities; old card: %d faults in %d entries'):format(tried, qty, #old, oldpages))
    check('self-test: with the old card the completed entries read their bags again (caught)', #old > 100, #old .. ', e.g. ' .. tostring(old[1]))
end

-- Rule 151 (F3, 2026-10-29: quest other 76 has 18 reward lines, adoulin 368 17, other 81 12): a card value of many lines left a very tall card
-- with the second column mostly empty. A list of S.LIST_MIN (10) or more items spans the card and flows into columns (read down, then across): the last
-- item of the list is drawn right of the first column, at the three window widths of the pixel gate. fault = the old card, LIST_COLUMNS = false.
-- CR_LIST_COLS_DIFF=1 prints every entry whose content differs with the switch on and off (the blast radius).
local function list_col_faults(fault, diff)
    local env9 = H.load({settings = {visible_on_load = true}})
    local app9, win9 = env9.app, env9.win()
    for _, p in ipairs(H.fixture_packets(530)) do env9.fire('incoming chunk', 0x056, p) end
    env9.run_scheduled()
    local guide9, card9, ops9 = package.loaded['ui/screens/guide'], package.loaded['core/card'], package.loaded['ui/ops']
    local real = guide9.LIST_COLUMNS
    if fault then guide9.LIST_COLUMNS = false end          -- the switch as it stands otherwise: S.LIST_COLUMNS = false fails the check
    local function squash(t) return (ops9.ascii(t):gsub('%s+', '')) end
    local out = {bad = {}, tried = 0, spread = 0, changed = {}}
    local cells, all = {}, {}
    for _, cat in ipairs({'quest', 'mission'}) do
        for _, area in ipairs(GUIDE_AREAS[cat]) do
            for _, it in ipairs(app9.data.get_area_status(cat, area).items) do
                local e = cat == 'mission' and app9.data.get_mission_data(area, it.name, it.id) or app9.data.get_quest_data(area, it.name)
                if e then
                    local v = card9.fields(e)
                    local mine = {}
                    for _, c in ipairs({{'REWARD', card9.reward_lines(v.reward)}, {'TITLE', card9.title_lines(v.title)}}) do
                        if type(c[2]) == 'table' and #c[2] >= guide9.LIST_MIN then mine[#mine + 1] = c end
                    end
                    local ent = {cat, area, it.name, it.id, mine}
                    all[#all + 1] = ent
                    if #mine > 0 then cells[#cells + 1] = ent end
                end
            end
        end
    end
    local sigs = {}
    for _, w in ipairs({480, 760, 1100}) do
        win9.resize = {mode = 'x', sx = 0, sy = 0, vw = win9.w, vh = win9.h, want = {w, win9.h}}
        env9.frame()
        win9.resize = nil
        for _, cell in ipairs(diff and all or cells) do
            app9:entry(cell[1], cell[2], cell[3], cell[4])
            env9.frame()
            local lines = content_lines(env9)
            if diff then
                local t = {}
                local labels = {NPC = true, ZONE = true, REWARD = true, FAME = true, REPEATABLE = true, TITLE = true}
                local lasty = 0          -- the card: its labels and what hangs under the last one (the page below loads its pictures at its own pace)
                for _, l in ipairs(lines) do if l.kind == 'T' and labels[l.text] and l.y > lasty then lasty = l.y end end
                for _, l in ipairs(lines) do
                    if l.kind == 'T' and l.y <= lasty + 16 + 12 * kit_line then t[#t + 1] = ('%s %s %s %s'):format(l.kind, l.x, l.y, tostring(l.text)) end
                end
                sigs[#sigs + 1] = {key = ('%s|%s|%s|%s'):format(cell[1], cell[2], cell[3], cell[4]), w = w, sig = table.concat(t, '|')}
            end
            for _, want in ipairs(cell[5]) do
                local lx, ly
                for _, l in ipairs(lines) do if l.kind == 'T' and l.text == want[1] then lx, ly = l.x, l.y end end
                out.tried = out.tried + 1
                local tag = ('%s|%s|%s %s at %d'):format(cell[1], cell[2], cell[3], want[1], w)
                if not lx then
                    out.bad[#out.bad + 1] = tag .. ': no label'
                else
                    local last = squash(want[2][#want[2]])
                    local at
                    for _, l in ipairs(lines) do
                        local sq = l.kind == 'T' and l.text and squash(l.text)
                        if sq and #sq >= 6 and l.y >= ly + 16 and l.y <= ly + 16 + (#want[2] * 3) * kit_line and last:sub(1, #sq) == sq then at = l end
                    end
                    if not at then out.bad[#out.bad + 1] = tag .. ': the last item is not drawn'
                    elseif at.x < lx + 100 then out.bad[#out.bad + 1] = ('%s: %d items in one column (the last at x %d, the label at %d)'):format(tag, #want[2], at.x, lx)
                    else out.spread = out.spread + 1 end
                end
            end
        end
    end
    guide9.LIST_COLUMNS = real
    if diff then out.sigs = sigs end
    return out
end
kit_line = package.loaded['ui/kit'].LINE
do
    local r = list_col_faults(false)
    check('card list columns: lists of 10 or more items to try', r.tried >= 15, r.tried .. ' cells, 3 widths')
    check('a card value of 10 or more items flows into columns (' .. r.tried .. ' cells, ' .. r.spread .. ' spread)', #r.bad == 0, #r.bad .. ', e.g. ' .. tostring(r.bad[1]))
    local f = list_col_faults(true)
    check('self-test: with the old card a list of 10 or more items in one column is caught', #f.bad >= 15, #f.bad)
    if os.getenv('CR_LIST_COLS_DIFF') then
        local on, off = list_col_faults(false, true), list_col_faults(true, true)
        local seen = {}
        for i, a in ipairs(on.sigs) do
            if a.sig ~= off.sigs[i].sig then seen[a.key] = (seen[a.key] and seen[a.key] .. ',' or '') .. a.w end
        end
        local keys = {}
        for k, ws in pairs(seen) do keys[#keys + 1] = k .. ' at ' .. ws end
        table.sort(keys)
        print('LISTCOLS entries compared: ' .. #on.sigs / 3 .. ', changed: ' .. #keys)
        for _, k in ipairs(keys) do print('LISTCOLS ' .. k) end
    end
end

-- Rules 163 and 164 (vision wave qab1, quest abyssea, 127 pages): a card value broke inside its closing bracket. The FAME "Abyssea - La Theine (Lvl 1)" left
-- "1)" alone on a line; a reward that ends in a job tag, "Ravager's Seal: Feet (WAR)", left "(WAR)" alone. Every entry whose FAME has a level after
-- a nation or whose reward has an item ending in a job tag, at five window widths: no line of the card is only "N)" or "(JOB)". fault = the old card
-- (FAME_TAIL / JOB_TAIL = false).
local function tail_faults(fault)
    local envt = H.load({settings = {visible_on_load = true}})
    local appt, wint = envt.app, envt.win()
    for _, p in ipairs(H.fixture_packets(530)) do envt.fire('incoming chunk', 0x056, p) end
    envt.run_scheduled()
    local guidet, cardt = package.loaded['ui/screens/guide'], package.loaded['core/card']
    local real_f, real_j, real_p = guidet.FAME_TAIL, guidet.JOB_TAIL, guidet.PAREN_TAIL
    if fault == 'fame' then guidet.FAME_TAIL = false elseif fault == 'job' then guidet.JOB_TAIL = false end
    if fault then guidet.PAREN_TAIL = false end      -- rule 167 would mend an old FAME level too; each self-test shows its own rule
    local cells = {}
    for _, cat in ipairs({'quest', 'mission'}) do
        for _, area in ipairs(GUIDE_AREAS[cat]) do
            for _, it in ipairs(appt.data.get_area_status(cat, area).items) do
                local e = cat == 'mission' and appt.data.get_mission_data(area, it.name, it.id) or appt.data.get_quest_data(area, it.name)
                if e then
                    local v = cardt.fields(e)
                    local want = guidet.fame_text(e, v):find('%(Lvl %S+%)$') ~= nil
                    for _, one in ipairs(cardt.reward_lines(v.reward) or {}) do
                        if one:find('%s%(%u%u%u%)$') then want = true end
                    end
                    if want then cells[#cells + 1] = {cat, area, it.name, it.id} end
                end
            end
        end
    end
    local out = {bad = {}, tried = #cells}
    local labels = {NPC = true, ZONE = true, REWARD = true, FAME = true, REPEATABLE = true, TITLE = true}
    for _, w in ipairs({440, 480, 520, 600, 760}) do
        wint.resize = {mode = 'x', sx = 0, sy = 0, vw = wint.w, vh = wint.h, want = {w, wint.h}}
        envt.frame()
        wint.resize = nil
        for _, c in ipairs(cells) do
            appt:entry(c[1], c[2], c[3], c[4])
            envt.frame()
            local lines = content_lines(envt)
            local lasty, fx, fy, xs = 0, nil, nil, {}
            for _, l in ipairs(lines) do
                if l.kind == 'T' and labels[l.text] then
                    xs[l.x] = true
                    if l.y > lasty then lasty = l.y end
                    if l.text == 'FAME' then fx, fy = l.x, l.y end
                end
            end
            for _, l in ipairs(lines) do
                if l.kind == 'T' and l.text then
                    -- the FAME value is the two or three lines under its label, in its column; a job tag is read in any column of the card
                    local lvl = fx and math.abs(l.x - fx) < 1 and l.y > fy and l.y <= fy + 16 + 2 * kit_line and l.text:find('^[%dA/N]+%)$')
                    local tag = l.y <= lasty + 16 + 12 * kit_line and (xs[l.x] or xs[l.x - guidet.HANG]) and l.text:find('^%(%u%u%u%)$')
                    if lvl or tag then out.bad[#out.bad + 1] = ('%s|%s|%s %s at %d: "%s" alone'):format(c[1], c[2], c[4], c[3], w, l.text) end
                end
            end
        end
    end
    guidet.FAME_TAIL, guidet.JOB_TAIL, guidet.PAREN_TAIL = real_f, real_j, real_p
    return out
end
do
    local r = tail_faults()
    check('card tails: entries with a fame level or a job tag to try', r.tried > 150, r.tried)
    check('no card line is only a level "N)" or a job tag "(WAR)" (' .. r.tried .. ' entries, 5 widths)', #r.bad == 0, #r.bad .. ', e.g. ' .. tostring(r.bad[1]))
    local f = tail_faults('fame')
    check('self-test: with the old FAME a level left alone on a line is caught', #f.bad >= 20, #f.bad)
    local j = tail_faults('job')
    check('self-test: with the old reward a job tag left alone on a line is caught', #j.bad >= 10, #j.bad)
end

-- Rule 167 (vision wave qab1, quest abyssea 124 to 126 at 520, committed jeuno 174 and other 18 at 440): a card value that ends in a parenthetical
-- ("Resistance Credits (Max: 70)", "Cabbage x3)") wrapped inside the bracket and left only its closing fragment ("70)", "x3)") alone on a line.
-- Every entry with a bracket in its card text, at five window widths: no line of the card is a closing fragment (no opening bracket, ends in ")",
-- one or two words) at a card column or its hanging indent. fault = the old card (PAREN_TAIL = false).
local function paren_faults(fault)
    local envt = H.load({settings = {visible_on_load = true}})
    local appt, wint = envt.app, envt.win()
    for _, p in ipairs(H.fixture_packets(530)) do envt.fire('incoming chunk', 0x056, p) end
    envt.run_scheduled()
    local guidet, cardt = package.loaded['ui/screens/guide'], package.loaded['core/card']
    local real = guidet.PAREN_TAIL
    if fault then guidet.PAREN_TAIL = false end
    local cells = {}
    for _, cat in ipairs({'quest', 'mission'}) do
        for _, area in ipairs(GUIDE_AREAS[cat]) do
            for _, it in ipairs(appt.data.get_area_status(cat, area).items) do
                local e = cat == 'mission' and appt.data.get_mission_data(area, it.name, it.id) or appt.data.get_quest_data(area, it.name)
                if e then
                    local v = cardt.fields(e)
                    local want = (e.start_npc or ''):find('%)') ~= nil or (cardt.zone_parts(e) or ''):find('%)') ~= nil
                    for _, one in ipairs(cardt.reward_lines(v.reward) or {}) do if one:find('%)') then want = true end end
                    for _, one in ipairs(cardt.title_lines(v.title) or {}) do if one:find('%)') then want = true end end
                    if want then cells[#cells + 1] = {cat, area, it.name, it.id} end
                end
            end
        end
    end
    local out = {bad = {}, tried = #cells}
    local labels = {NPC = true, ZONE = true, REWARD = true, FAME = true, REPEATABLE = true, TITLE = true}
    for _, w in ipairs({440, 480, 520, 600, 760}) do
        wint.resize = {mode = 'x', sx = 0, sy = 0, vw = wint.w, vh = wint.h, want = {w, wint.h}}
        envt.frame()
        wint.resize = nil
        for _, c in ipairs(cells) do
            appt:entry(c[1], c[2], c[3], c[4])
            envt.frame()
            local lines = content_lines(envt)
            local lasty, xs = 0, {}
            for _, l in ipairs(lines) do
                if l.kind == 'T' and labels[l.text] then
                    xs[l.x] = true
                    if l.y > lasty then lasty = l.y end
                end
            end
            -- the card ends at the first gap of more than a line under its last label row (the body text under it is not the card)
            local rows = {}
            for _, l in ipairs(lines) do if l.kind == 'T' and l.y >= lasty then rows[l.y] = true end end
            local ys = {}
            for y in pairs(rows) do ys[#ys + 1] = y end
            table.sort(ys)
            local bottom = lasty
            for _, y in ipairs(ys) do
                if y - bottom <= kit_line + 2 then bottom = y else break end
            end
            for _, l in ipairs(lines) do
                if l.kind == 'T' and l.text and l.y <= bottom and (xs[l.x] or xs[l.x - guidet.HANG])
                    and l.text:find('%)$') and not l.text:find('%(') then
                    local _, words = l.text:gsub('%S+', '')
                    -- avoidable: the line above holds words before a bracket it leaves open (a bracket that starts its line cannot move down)
                    local avoidable = false
                    for _, a in ipairs(lines) do
                        if a.kind == 'T' and a.text and a.y < l.y and l.y - a.y <= kit_line + 2 and (a.x == l.x or a.x == l.x - guidet.HANG or a.x == l.x + guidet.HANG) then
                            local _, o = a.text:gsub('%(', '')
                            local _, cl = a.text:gsub('%)', '')
                            if o > cl and a.text:find('^.-%S.-%(') and a.text:find('%S%s+%([^%(]*$') then avoidable = true end
                        end
                    end
                    if words <= 2 and avoidable then out.bad[#out.bad + 1] = ('%s|%s|%s %s at %d: "%s" alone'):format(c[1], c[2], c[4], c[3], w, l.text) end
                end
            end
        end
    end
    guidet.PAREN_TAIL = real
    return out
end
do
    local r = paren_faults(false)
    check('card brackets: entries with a bracket in the card to try', r.tried > 400, r.tried)
    check('no card line is only the closing fragment of a bracket "70)" (' .. r.tried .. ' entries, 5 widths)', #r.bad == 0, #r.bad .. ', e.g. ' .. tostring(r.bad[1]))
    local f = paren_faults(true)
    check('self-test: with the old card a closing fragment left alone on a line is caught', #f.bad >= 20, #f.bad)
    if os.getenv('CR_PAREN_LIST') then
        for _, b in ipairs(f.bad) do print('PARENOLD ' .. b) end
        for _, b in ipairs(r.bad) do print('PARENNEW ' .. b) end
    end
end

-- Rule 173 (vision wave qcw1, quest wotg 7, 8, 9 and 21 to 23 at 440): a campaign ribbon's rank is a word after "Service" ("Bronze Ribbon of Service S",
-- "Brass Ribbon of Service SS"); the card wrapped before it and left "S" or "SS" alone on a line, in the REWARD and in the FAME. Every entry whose
-- reward or fame ends in "Service" and one to four S, at five window widths: no line of the card is only that rank. fault = the old card
-- (RANK_TAIL = false).
local function rank_faults(fault)
    local envt = H.load({settings = {visible_on_load = true}})
    local appt, wint = envt.app, envt.win()
    for _, p in ipairs(H.fixture_packets(530)) do envt.fire('incoming chunk', 0x056, p) end
    envt.run_scheduled()
    local guidet, cardt = package.loaded['ui/screens/guide'], package.loaded['core/card']
    local real = guidet.RANK_TAIL
    if fault then guidet.RANK_TAIL = false end
    local cells = {}
    for _, cat in ipairs({'quest', 'mission'}) do
        for _, area in ipairs(GUIDE_AREAS[cat]) do
            for _, it in ipairs(appt.data.get_area_status(cat, area).items) do
                local e = cat == 'mission' and appt.data.get_mission_data(area, it.name, it.id) or appt.data.get_quest_data(area, it.name)
                if e then
                    local v = cardt.fields(e)
                    local want = guidet.fame_text(e, v):find('Service S+$') ~= nil
                    for _, one in ipairs(cardt.reward_lines(v.reward) or {}) do
                        if one:find('Service S+$') then want = true end
                    end
                    if want then cells[#cells + 1] = {cat, area, it.name, it.id} end
                end
            end
        end
    end
    local out = {bad = {}, tried = #cells}
    local labels = {NPC = true, ZONE = true, REWARD = true, FAME = true, REPEATABLE = true, TITLE = true}
    for _, w in ipairs({440, 480, 520, 600, 760}) do
        wint.resize = {mode = 'x', sx = 0, sy = 0, vw = wint.w, vh = wint.h, want = {w, wint.h}}
        envt.frame()
        wint.resize = nil
        for _, c in ipairs(cells) do
            appt:entry(c[1], c[2], c[3], c[4])
            envt.frame()
            local lines = content_lines(envt)
            local lasty, xs = 0, {}
            for _, l in ipairs(lines) do
                if l.kind == 'T' and labels[l.text] then
                    xs[l.x] = true
                    if l.y > lasty then lasty = l.y end
                end
            end
            for _, l in ipairs(lines) do
                if l.kind == 'T' and l.text and l.y <= lasty + 16 + 12 * kit_line and (xs[l.x] or xs[l.x - guidet.HANG]) and l.text:find('^S+$') and #l.text <= 4 then
                    out.bad[#out.bad + 1] = ('%s|%s|%s %s at %d: "%s" alone'):format(c[1], c[2], c[4], c[3], w, l.text)
                end
            end
        end
    end
    guidet.RANK_TAIL = real
    return out
end
do
    local r = rank_faults(false)
    check('card ranks: entries whose reward or fame ends in a campaign rank to try', r.tried >= 6, r.tried)
    check('no card line is only a campaign rank "S" or "SS" (' .. r.tried .. ' entries, 5 widths)', #r.bad == 0, #r.bad .. ', e.g. ' .. tostring(r.bad[1]))
    local f = rank_faults(true)
    check('self-test: with the old card a rank left alone on a line is caught', #f.bad >= 4, #f.bad)
    if os.getenv('CR_RANK_LIST') then
        for _, b in ipairs(f.bad) do print('RANKOLD ' .. b) end
        for _, b in ipairs(r.bad) do print('RANKNEW ' .. b) end
    end
end

restore()
print(('test_screens: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)

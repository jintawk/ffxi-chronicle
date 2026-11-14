--[[
    test_progress_lists.lua - step progress on Home and the area lists: the real chronicle.lua, screens and core/progress.lua
    driven through Windower events with the recording fake of the DLL.
      - Home: "In progress" under the cards, each entry with its short name, segments, count and Next line; no "Last updated";
        most recently advanced first; a click opens the entry; an entry without step data is the name line alone
      - the area list: a "Next:" line and the count under an active row with a next step, and only there
      - nothing on either goes past the width, at 480 and 620, whatever the number of steps
      - core/progress.lua summary: the path's row on a page with paths, dropped when the log moves; kit.seg_w

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_progress_lists.lua
        ... test/test_progress_lists.lua --selftest   the checks below must catch the faults injected into a copy of a draw
]]

local H = dofile('test/harness.lua')

local SELFTEST = arg and arg[1] == '--selftest'
local pass, fail = 0, 0
local function check(name, cond, detail)
    if cond then pass = pass + 1 else
        fail = fail + 1
        print('FAIL ' .. name .. (detail ~= nil and (': ' .. tostring(detail)) or ''))
    end
end

local KEEP = {'data/places_berrant.lua', 'data/pages_berrant.lua', 'data/places.lua', 'data/pages.lua'}
local restore = H.protect(KEEP)   -- the run's own data folder; the player's data/ is never touched

local env = H.load({settings = {visible_on_load = false}})
local N, app = env.N, env.app
env.cmd('show')
local win = env.win()
env.packets(H.fixture_packets(530))
local kit = require('ui/kit')
local ops = require('ui/ops')
local Home = package.loaded['ui/screens/home']
local progress = app.progress
check('the app has the progress module', progress and progress.summary and progress.code)

local function redraw() win:invalidate('all') win:flush() end
local function hits(id)
    local out = {}
    for _, h in ipairs(win.content_b.hits) do if h.id == id then out[#out + 1] = h end end
    return out
end
local function tab(cat) app.settings.active_tab = cat app:home() redraw() end
local function text() return N.layers[2].text end

---------------------------------------------------------------------------
-- Home
---------------------------------------------------------------------------

tab('mission')
check('In progress under the cards', text():find('In progress', 1, true) ~= nil)
check('Last updated is gone', not text():find('Last updated', 1, true) and not N.layers[1].text:find('Last updated', 1, true))
local rows = hits('progress')
local active = app.data.get_summary().mission.active
check('a row per entry in progress', #rows == #app:in_progress('mission', app.data.get_summary().mission) and #rows > 0, #rows .. ' rows, ' .. #active .. ' active')
local lowest_card = 0
for _, h in ipairs(hits('card')) do lowest_card = math.max(lowest_card, h.y1) end
for _, h in ipairs(rows) do check('row under the cards: ' .. h.name, h.y0 > lowest_card) end
for i = 2, #rows do check('rows do not overlap', rows[i].y0 >= rows[i - 1].y1, rows[i].name) end

local paths
for _, e in ipairs(app:in_progress('mission', app.data.get_summary().mission)) do if e.id == 530 then paths = e end end
check('Three Paths is in progress', paths ~= nil)
if paths then
    check('Three Paths has its series number and the open path', paths.where == 'CoP 5-3, ' .. tostring(paths.steps and paths.steps.label), paths.where)
    check('its step data is that path, not the whole page', paths.steps and paths.steps.total > 0 and paths.steps.total < 20, paths.steps and paths.steps.total)
    check('its next step is on that path, not the last visit to Cid', paths.steps and paths.steps.text and not paths.steps.text:find('all three paths', 1, true), paths.steps and paths.steps.text)
    for _, e in ipairs(app:in_progress('mission', app.data.get_summary().mission)) do
        check('its paths have no rows of their own', not (e.area == 'cop' and (e.id == 540 or e.id == 550 or e.id == 560)), e.name)
    end
    check('its row is drawn', text():find('Three Paths', 1, true) ~= nil)
    check('"Next:" drawn', not paths.steps.text or text():find('Next:', 1, true) ~= nil)
end

-- a click opens the entry, right click comes back
local h = rows[1]
win:scroll_to(h.y0 - 40) win:flush()
local x, y = win:to_win((h.x0 + h.x1) / 2, (h.y0 + h.y1) / 2)
local f = package.loaded['core/nui'].view.f
env.fire('mouse', 1, (win.x + x) * f, (win.y + y) * f, 0, false)
env.fire('mouse', 2, (win.x + x) * f, (win.y + y) * f, 0, false)
check('a click opens the entry', app.view.name == 'guide' and app.view.params.id == h.entry and app.view.params.area == h.area, app.view.name)
app:back()
check('back to Home', app.view.name == 'home')

-- order: the last entry advanced comes first; the rest stay in area order. Stubbed: the log's times are core/progress's own test
local real_summary, real_code = progress.summary, progress.code
local function stubbed(fn)
    local out = {}
    progress.summary = function(key) return fn(key) end
    progress.code = function() return nil end
    return out
end
local function unstub() progress.summary, progress.code = real_summary, real_code end

local sum = {active = {{id = 1, name = 'One', area = 'bastok', area_name = 'Bastok'}, {id = 2, name = 'Two', area = 'bastok', area_name = 'Bastok'},
                       {id = 3, name = 'Three', area = 'jeuno', area_name = 'Jeuno'}, {id = 4, name = 'Four', area = 'jeuno', area_name = 'Jeuno'}}}
stubbed(function(key)
    local id = tonumber(key:match('(%d+)$'))
    if id == 1 then return nil end
    return {states = {'done', 'next'}, done = 1, total = 2, text = 'Go', last = ({[2] = 100, [3] = 300})[id]}
end)
local order = {}
for i, e in ipairs(app:in_progress('quest', sum)) do order[i] = e.name end
check('most recently advanced first, the rest in area order', table.concat(order, ' ') == 'Three Two One Four', table.concat(order, ' '))
unstub()

-- a mission named after its series does not say it twice
stubbed(function() return nil end)
local same = app:in_progress('mission', {active = {{id = 1, name = 'Rhapsodies', area = 'rov', area_name = 'Rhapsodies'}}})
check('the name is not repeated as where', same[1].where == nil, same[1].where)
unstub()

-- the draw itself, against a recording builder: every text and rect inside the width
local function draw_rows(w, summaries)
    local b = ops.new()
    local items = {}
    for i, s in ipairs(summaries) do items[i] = {id = i, name = s.name or 'A Quest With Rather a Long Name Indeed', area = 'bastok', area_name = 'Bastok'} end
    local a = {in_progress = function()
        local out = {}
        for i, s in ipairs(summaries) do
            out[i] = {id = i, name = items[i].name, area = 'bastok', cat = 'quest', where = 'Bastok', steps = s.steps}
        end
        return out
    end}
    local h = Home.in_progress(b, a, 'quest', {active = items}, 0, w)
    return b, h
end
-- every rect and text of a recorded draw inside 0..w -> ok, the first one that is not
local function bounds_ok(b, w)
    for _, o in ipairs(b.o) do
        local x0, x1 = o:match('^R\t(%-?[%d.]+)\t%-?[%d.]+\t(%-?[%d.]+)\t')
        if x0 then
            if tonumber(x0) < 0 or tonumber(x1) > w then return false, o end
        else
            local x, s = o:match('^T\t(%-?[%d.]+)\t%-?[%d.]+\t%x+\t(.*)$')
            if x and (tonumber(x) < 0 or tonumber(x) + ops.text_w(s) > w) then return false, o end
        end
    end
    return true
end
local function states(n, done)
    local t = {}
    for i = 1, n do t[i] = i <= done and 'done' or (i == done + 1 and 'next' or 'todo') end
    return t
end
local LONG = ('Speak to the guard at the gate of the city and then walk all the way back to the very far end of the zone '):rep(3)
for _, w in ipairs({480, 620, 1060}) do
    for _, n in ipairs({1, 5, 13, 40, 131}) do
        local b, h = draw_rows(w, {{steps = {states = states(n, 0), done = 0, total = n, text = LONG}}})
        local ok, worst = bounds_ok(b, w)
        check(('%d steps at %d stay inside'):format(n, w), ok and h > 0, worst)
    end
end
local _, h1 = draw_rows(620, {{steps = {states = {'todo'}, done = 0, total = 1}}})
local _, h2 = draw_rows(620, {{steps = {states = {'next'}, done = 0, total = 1, text = 'Go'}}})
local _, h3 = draw_rows(620, {{steps = nil}})
check('no next step: the name line alone', h2 - h1 == 18 and h1 == h3, h1 .. ' ' .. h2 .. ' ' .. h3)

-- nothing in progress: no heading
local b0, y0 = ops.new(), nil
y0 = Home.in_progress(b0, {in_progress = function() return {} end}, 'quest', {active = {}}, 50, 620)
check('nothing in progress: nothing drawn', y0 == 50)

---------------------------------------------------------------------------
-- the area list
---------------------------------------------------------------------------

app:area_list('mission', 'cop')
app.settings.filter_mode = 1
redraw()
local list = hits('row')
check('rows listed', #list > 0)
local tall, plain = 0, 0
for i, r in ipairs(list) do
    local height = r.y1 - r.y0 + 2
    local st = r.item.status == 'active' and app:step_summary('mission', 'cop', r.item.id) or nil
    if st and st.text then
        tall = tall + 1
        check('an active row with a next step has the third line: ' .. r.item.name, height == kit.ROW_H + 18, height)
    else
        plain = plain + 1
        check('any other row keeps its height: ' .. r.item.name, height == kit.ROW_H, height)
    end
    if i > 1 then check('list rows do not overlap', r.y0 >= list[i - 1].y1, r.item.name) end
end
check('the fixture has a row of each kind', tall > 0 and plain > 0, tall .. ' tall, ' .. plain .. ' plain')
check('"Next:" drawn in the list', text():find('Next:', 1, true) ~= nil)

---------------------------------------------------------------------------
-- core/progress.lua summary, kit.seg_w
---------------------------------------------------------------------------

check('seg_w: they fit', kit.seg_w(5, 100, 9, 2) == 9)
check('seg_w: narrower', kit.seg_w(40, 200, 9, 2) == 3, kit.seg_w(40, 200, 9, 2))
check('seg_w: too many', kit.seg_w(131, 200, 9, 2) == nil)

local s1 = progress.summary('mission|cop|530')
check('summary is memoised', s1 ~= nil and progress.summary('mission|cop|530') == s1)
progress.on_log()
check('the log moving drops it', progress.summary('mission|cop|530') ~= s1)
check('no mapping: nil', progress.summary('quest|bastok|999999') == nil)
check('code from the page title', progress.code('mission|cop|530') == 'CoP 5-3', progress.code('mission|cop|530'))
check('no code outside the numbered series', progress.code('quest|bastok|0') == nil)

if SELFTEST then
    -- the width check must see a segment run past the row
    local real_seg = kit.seg_w
    kit.seg_w = function() return 9 end
    local b = draw_rows(480, {{steps = {states = states(131, 0), done = 0, total = 131, text = 'Go'}}})
    local ok = bounds_ok(b, 480)
    kit.seg_w = real_seg
    check('selftest: 131 full segments are caught', ok == false)
end

restore()
print(('test_progress_lists: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)

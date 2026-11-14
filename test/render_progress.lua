--[[
    test/render_progress.lua - MOCK-UPS ONLY: quest / mission step progress drawn three ways (test/mock_progress.lua)
    through the same path as test/render.lua: the real chronicle.lua, the real _chronicle.dll and a real D3D8 device
    through the patched EndScene wrapper of a FFXiMain.dll copy, over a 4K screenshot. Driven by
    the mock renderer:

        lua test/render_progress.lua <FFXiMain.dll copy> <dir with cr_testhost.dll> <bg.raw (3840x2160 BGRA)> <out dir>

    Writes <out>/<frame>.raw, <out>/states.lua (for raw_to_png.py) and <out>/frames.json.
]]

local copy, hostdir, bg, out = arg[1], arg[2], arg[3], arg[4]
package.cpath = './libs/?.dll;' .. hostdir .. '/?.dll;' .. package.cpath
local FFXI = [[C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI\]]

package.loadlib(copy, 'luaopen_none')              -- loads and unpacks the copy
package.preload['_chronicle'] = dofile('test/crdll.lua').loader()
local T = require('cr_testhost')
assert(T.make_device())

local H = dofile('test/harness.lua')
local KEEP = {'data/places.lua', 'data/pages.lua'}
local restore = H.protect(KEEP)   -- the run's own data folder; the player's data/ is never touched

local env = H.load({native = 'real', settings = {visible_on_load = false},
    items = {inventory = {{id = 1012, count = 1}}}, key_items = {}})
package.loaded['core/nui'].ffxi_dir = FFXI
env.cmd('show')
local app = env.app
local win = env.win()
assert(win, 'the window did not open: ' .. tostring(env.chat[#env.chat]))
local N = env.N
local site = N.status().site
local nui = package.loaded['core/nui']
local pages = package.loaded['core/pages']

local P = dofile('test/mock_progress.lua')
P.install(env)

local frames = {}
local function shoot(name, dir, caption)
    env.fire('mouse', 0, 5, 5, 0, false)          -- no hover
    win:invalidate('all') win:flush()
    T.bg(bg)
    T.frame(site)
    local f = nui.view.f
    local m = 24
    local x0, y0 = math.max(0, math.floor((win.x - m) * f)), math.max(0, math.floor((win.y - m) * f))
    local x1 = math.min(3840, math.floor((win.x + win.w + m) * f))
    local y1 = math.min(2160, math.floor((win.y + win.h + m) * f))
    T.dump(out .. '/' .. name .. '.raw')
    frames[#frames + 1] = {name = name, x0 = x0, y0 = y0, x1 = x1, y1 = y1, dir = dir, caption = caption,
                           w = win.w, h = win.h}
    local s = N.status()
    print(('%-18s %5d quads %3d batches  %s'):format(name, s.quads, s.batches, caption))
end

local function size(w, h) win.w, win.h = w, h win:invalidate('all') win:flush() end
local function tab(i)
    local cur = pages.current()
    if (cur.tabs[1] or 1) ~= i then pages.set_tab(1, i) end
    win:invalidate('all') win:flush()
end
-- scroll so the first "Walkthrough" heading sits `above` px under the viewport's top
local function to_walkthrough(above)
    win:invalidate('all') win:flush()
    local y = P.record.walk_y or 0
    win:scroll_to(math.max(0, y - (above or 10)))
    win:invalidate('all') win:flush()
end

win.x, win.y = 160, 130
win:invalidate('all') win:flush()
env.packets(H.fixture_packets(530))

local SIREN = {'quest', 'bastok', 'The Siren\'s Tear', 0}
local PATHS = {'mission', 'cop', 'Three Paths', 530}

local function three_paths(w, h, t, above)
    app:entry(unpack(PATHS))
    size(w, h)
    tab(t)
    if above == 'strip' then              -- the path tabs at the top of the view
        win:invalidate('all') win:flush()
        win:scroll_to(math.max(0, pages.current().strip[1] - 6))
        win:invalidate('all') win:flush()
    else
        to_walkthrough(above)
    end
end
local function siren(w, h, above)
    app:entry(unpack(SIREN))
    size(w, h)
    to_walkthrough(above)
end

-- the chosen design (round 2): checkboxes on the step bullets + the step strip under the title; Home's in-progress
-- entries under the area cards; the area list's Next line
P.mode = 'on'
three_paths(760, 1100, 1, 10)
shoot('page_530_tab1', 'page', 'Three Paths, Louverance open: every step done (ticked boxes), path counts on the tabs, one strip row per path with the next step of the first path that has one')
three_paths(760, 1100, 3, 10)
shoot('page_530_tab3', 'page', 'Ulmia open: two unknown steps before a seen one collapse to done, then the next step (gold box) and steps to do (dim boxes)')
siren(620, 760, 140)
shoot('page_siren', 'page', "The Siren's Tear: four steps done, the next one in gold, the strip with Step 5 of 5; the last bullet is not a step and keeps its bullet")
three_paths(480, 900, 2, 'strip')
shoot('page_530_narrow', 'page', 'Three Paths at 480 px, Tenzen open: the tabs wrap with their counts, the strip segments shrink, the step text is cut')
siren(480, 760, 140)
shoot('page_siren_narrow', 'page', "The Siren's Tear at 480 px")
local function home(tabname, w, h)
    app:home()
    app.settings.active_tab = tabname
    size(w, h)
    win:scroll_to(1e6)                    -- the cards fill the window: scrolled to the bottom, where the list sits
    win:invalidate('all') win:flush()
end
home('mission', 620, 760)
shoot('home_missions', 'home', 'Home, Missions tab (fits without scrolling at 620 x 760): In progress under the area cards, each entry with its segments, count and next step')
home('quest', 620, 760)
shoot('home_quests', 'home', 'Home, Quests tab (fits without scrolling): the quests in progress under the area cards')
home('mission', 480, 760)
shoot('home_missions_narrow', 'home', 'Home, Missions tab at 480 px: the cards fill the window, so it is scrolled to the bottom to show In progress')
app.settings.active_tab = 'mission'
app.settings.sort_mode = 3                -- Sort: Status, the active rows first
app:area_list('quest', 'bastok')
size(620, 760)
win:scroll_to(0)
shoot('area_list', 'list', 'Bastok quests sorted by Status: a Next line and count under each active row with progress; an active row with no step data has none')
app:area_list('quest', 'bastok')
size(480, 560)
win:scroll_to(0)
shoot('area_list_narrow', 'list', 'The same list at 480 x 560')
P.mode = nil

local f = assert(io.open(out .. '/states.lua', 'w'))
f:write('return {\n')
for _, s in ipairs(frames) do
    f:write(('  {name = %q, x0 = %d, y0 = %d, x1 = %d, y1 = %d, note = %q},\n'):format(s.name, s.x0, s.y0, s.x1, s.y1, s.caption))
end
f:write('}\n')
f:close()
local function js(s) return '"' .. s:gsub('\\', '\\\\'):gsub('"', '\\"') .. '"' end
f = assert(io.open(out .. '/frames.json', 'w'))
f:write('[\n')
for i, s in ipairs(frames) do
    f:write(('  {"file": %s, "crop": [%d, %d, %d, %d], "window": [%d, %d], "direction": %s, "caption": %s}%s\n'):format(
        js(s.name .. '.png'), s.x0, s.y0, s.x1, s.y1, s.w, s.h, js(s.dir), js(s.caption), i < #frames and ',' or ''))
end
f:write(']\n')
f:close()
N.stop()
restore()
print('rendered ' .. #frames .. ' frames')

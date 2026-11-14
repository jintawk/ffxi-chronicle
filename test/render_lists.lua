--[[
    test/render_lists.lua - Home and the area list with step progress, drawn the way the approved mock-ups were (test/render_progress.lua:
    the same window sizes and scrolls) but by the real screens and core/progress.lua, on real step data. For comparing by eye
    against the mock-ups; the gate's own frames come from test/qa_render.lua.

        lua test/render_lists.lua <FFXiMain.dll copy> <dir with cr_testhost.dll> <bg.raw (3840x2160 BGRA)> <out dir>
]]

local copy, hostdir, bg, out = arg[1], arg[2], arg[3], arg[4]
package.cpath = './libs/?.dll;' .. hostdir .. '/?.dll;' .. package.cpath
local FFXI = [[C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI\]]

package.loadlib(copy, 'luaopen_none')
package.preload['_chronicle'] = dofile('test/crdll.lua').loader()
local T = require('cr_testhost')
assert(T.make_device())

local H = dofile('test/harness.lua')
local env = H.load({native = 'real', settings = {visible_on_load = false},
    items = {inventory = {{id = 1012, count = 1}}}, key_items = {}})
package.loaded['core/nui'].ffxi_dir = FFXI
env.cmd('show')
local app, win, N = env.app, env.win(), env.N
local site = N.status().site
local nui = package.loaded['core/nui']

local frames = {}
local function shoot(name, dir, caption)
    env.fire('mouse', 0, 5, 5, 0, false)
    win:invalidate('all') win:flush()
    T.bg(bg)
    T.frame(site)
    local f = nui.view.f
    local m = 24
    local x0, y0 = math.max(0, math.floor((win.x - m) * f)), math.max(0, math.floor((win.y - m) * f))
    local x1 = math.min(3840, math.floor((win.x + win.w + m) * f))
    local y1 = math.min(2160, math.floor((win.y + win.h + m) * f))
    T.dump(out .. '/' .. name .. '.raw')
    frames[#frames + 1] = {name = name, x0 = x0, y0 = y0, x1 = x1, y1 = y1, dir = dir, caption = caption, w = win.w, h = win.h}
    print(name)
end
local function size(w, h) win.w, win.h = w, h win:invalidate('all') win:flush() end

win.x, win.y = 160, 130
win:invalidate('all') win:flush()
env.packets(H.fixture_packets(530))

local function home(tabname, w, h)
    app:home()
    app.settings.active_tab = tabname
    size(w, h)
    win:scroll_to(1e6)
    win:invalidate('all') win:flush()
end
home('mission', 620, 760)
shoot('home_missions', 'home', 'Home, Missions')
home('quest', 620, 760)
shoot('home_quests', 'home', 'Home, Quests, scrolled to the bottom')
home('mission', 480, 760)
shoot('home_missions_narrow', 'home', 'Home, Missions at 480')

app.settings.sort_mode = 3
app:area_list('quest', 'bastok')
size(620, 760)
win:scroll_to(0)
shoot('area_list', 'list', 'Bastok quests sorted by Status')
app:area_list('quest', 'bastok')
size(480, 560)
win:scroll_to(0)
shoot('area_list_narrow', 'list', 'The same list at 480 x 560')

local f = assert(io.open(out .. '/states.lua', 'w'))
f:write('return {\n')
for _, s in ipairs(frames) do
    f:write(('  {name = %q, x0 = %d, y0 = %d, x1 = %d, y1 = %d, note = %q},\n'):format(s.name, s.x0, s.y0, s.x1, s.y1, s.caption))
end
f:write('}\n')
f:close()
os.exit(0)

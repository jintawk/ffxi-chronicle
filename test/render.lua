--[[
    test/render.lua - mock-ups: the real chronicle.lua, the real _chronicle.dll and a real D3D8
    device, through the patched EndScene wrapper of a FFXiMain.dll copy (as test_e2e.lua), so every
    picture is exactly what the game would show. Driven by the screen renderer:

        lua test/render.lua <FFXiMain.dll copy> <dir with cr_testhost.dll> <bg.raw (3840x2160 BGRA)> <out dir>

    Writes <out>/<state>.raw (whole back buffer) and <out>/states.lua ({name, x0, y0, x1, y1, note}).
]]

local copy, hostdir, bg, out = arg[1], arg[2], arg[3], arg[4]
package.cpath = './libs/?.dll;' .. hostdir .. '/?.dll;' .. package.cpath
local FFXI = [[C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI\]]

package.loadlib(copy, 'luaopen_none')              -- loads and unpacks the copy
package.preload['_chronicle'] = dofile('test/crdll.lua').loader()      -- CR_DLL: a build other than libs/_chronicle.dll
local T = require('cr_testhost')
assert(T.make_device())

local H = dofile('test/harness.lua')
-- keep the user's saved places and page state out of the way
local KEEP = {'data/places.lua', 'data/pages.lua'}
local restore = H.protect(KEEP)   -- the run's own data folder; the player's data/ is never touched
local PLACES = KEEP[1]

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

local states = {}
local function shoot(name, note, pad)
    if not name:find('hover') and not name:find('tip') and not name:find('link') and not name:find('chain')
        and not name:find('area_list') then
        env.fire('mouse', 0, 5, 5, 0, false)          -- no stale hover
    end
    T.bg(bg)
    T.frame(site)
    local f = nui.view.f
    pad = pad or {40, 40, 420, 120}
    local x0, y0 = math.max(0, math.floor((win.x - pad[1]) * f)), math.max(0, math.floor((win.y - pad[2]) * f))
    local x1 = math.min(3840, math.floor((win.x + win.w + pad[3]) * f))
    local y1 = math.min(2160, math.floor((win.y + (win.collapsed and 46 or win.h) + pad[4]) * f))
    T.dump(out .. '/' .. name .. '.raw')
    states[#states + 1] = {name = name, x0 = x0, y0 = y0, x1 = x1, y1 = y1, note = note}
    local s = N.status()
    print(('%-22s %5d quads %3d batches %5.0f us  %s'):format(name, s.quads, s.batches, s.last_us, note))
end

local function hit_center(list, pred, content)
    for _, h in ipairs(list) do
        if pred(h) then
            if content then
                local x, y = win:to_win((h.x0 + h.x1) / 2, (h.y0 + h.y1) / 2)
                return win.x + x, win.y + y
            end
            return win.x + (h.x0 + h.x1) / 2, win.y + (h.y0 + h.y1) / 2
        end
    end
end
local function move(x, y) local f = nui.view.f env.fire('mouse', 0, x * f, y * f, 0, false) end
local function click(x, y)
    local f = nui.view.f
    env.fire('mouse', 1, x * f, y * f, 0, false)
    env.fire('mouse', 2, x * f, y * f, 0, false)
end
local function key(dik) env.fire('keyboard', dik, true, 0, false) env.fire('keyboard', dik, false, 0, false) end

win.x, win.y = 160, 130
win:invalidate('all') win:flush()

shoot('home_waiting', 'Home before the first 0x056 packet')
env.packets(H.fixture_packets(530))
shoot('home_missions', 'Home: Missions tab, cards with emblems and gauges')
move(hit_center(win.content_b.hits, function(h) return h.area == 'cop' end, true))
shoot('home_hover', 'Card hover')
move(hit_center(win.chrome_b.hits, function(h) return h.id == 'settings' end))
shoot('home_tip', 'Control tooltip')
click(hit_center(win.chrome_b.hits, function(h) return h.id == 'navtab' and h.i == 2 end))
shoot('home_quests', 'Quests tab')
click(hit_center(win.chrome_b.hits, function(h) return h.id == 'navtab' and h.i == 1 end))
click(hit_center(win.content_b.hits, function(h) return h.area == 'cop' end, true))
move(hit_center(win.content_b.hits, function(h) return h.id == 'row' and h.item.name == 'Desires of Emptiness' end, true))
shoot('area_list', 'Chains of Promathia: list, row hover')
click(hit_center(win.chrome_b.hits, function(h) return h.id == 'search' end))
key(0x14) key(0x23) key(0x13)
shoot('area_search', 'Search typed: "thr"')
key(0x01)
click(hit_center(win.chrome_b.hits, function(h) return h.id == 'sort' end))
click(hit_center(win.chrome_b.hits, function(h) return h.id == 'sort' end))
shoot('area_sorted', 'Sort: Status')
click(hit_center(win.chrome_b.hits, function(h) return h.id == 'sort' end))
click(hit_center(win.chrome_b.hits, function(h) return h.id == 'sort' end))
app:entry('mission', 'cop', 'Three Paths', 530)
win:flush()
shoot('guide', 'Guide: Three Paths')
move(hit_center(win.content_b.hits, function(h) return h.id == 'chain' and h.dir == 'next' end, true))
shoot('guide_chain', 'Chain link hover')
-- Three Paths: the page, its tabs, a link, the sticky bar, a picture
local pages = package.loaded['core/pages']
win.w, win.h = 760, 1100
win:invalidate('all') win:flush()
local function tab_hit(i)
    return hit_center(win.content_b.hits, function(h) return h.id == 'tab' and h.i == i end, true)
end
win:scroll_to(0) win:flush()
shoot('page_top', 'Three Paths: the page header, the three paths as tabs, the first path')
for _, i in ipairs({2, 3}) do
    win:scroll_to(0) win:flush()
    click(tab_hit(i))
    win:scroll_to(0) win:flush()
    shoot('page_tab' .. i, 'Tab ' .. i)
end
win:scroll_to(0) win:flush()
click(tab_hit(1))
win:scroll_to(520) win:flush()
move(hit_center(win.content_b.hits, function(h)
    if h.id ~= 'link' or h.span.kind ~= 'npc' then return false end
    local _, y = win:to_win(0, h.y0)
    return y > win.vp.y0 + 60 and y < win.vp.y1 - 120
end, true))
shoot('page_link', 'Link hover: underline and tooltip')
win:scroll_to(1400) win:flush()
move(win.x + 20, win.y + 20)
shoot('page_sticky', 'Scrolled down: the sticky tab bar')
local pic = nil
for _, h in ipairs(win.content_b.hits) do if h.id == 'picture' and not h.missing then pic = h break end end
if pic then
    win:scroll_to(math.max(0, pic.y0 - 200)) win:flush()
    shoot('page_picture', 'A map from BG-wiki, from the cache')
    click(hit_center({pic}, function() return true end, true))
    shoot('page_enlarged', 'The map enlarged', {40, 40, 600, 120})
    click(win.x + 10, win.y + 10)
end
win.w, win.h = 620, 760
win:invalidate('all') win:flush()

app:entry('quest', 'jeuno', 'Fistful of Fury')
win:flush()
shoot('guide_reqs', 'Guide with requirements (one item owned)')
app:go('settings', {}, 0)
shoot('settings', 'Settings')
app:home()
win:toggle_collapse()
shoot('collapsed', 'Collapsed', {40, 40, 420, 40})
win:toggle_collapse()
app:area_list('mission', 'cop')
win.w, win.h = 480, 560
win:invalidate('all') win:flush()
shoot('narrow', 'Resized to the minimum width')
win.w, win.h = 620, 760
win:invalidate('all') win:flush()
for _, t in ipairs({1, 3, 8}) do
    env.cmd('wintype', tostring(t))
    shoot('wintype_' .. t, 'Window type ' .. t)
end
env.cmd('wintype', 'auto')
env.cmd('wintype', '6')
T.fake_ui(N.status().ui_ptr, 2560, 1440)
env.cmd('scale', 'ui')
shoot('scale_ui', 'scale ui: a 2560x1440 game UI on the 4K screen (x1.5)', {20, 20, 300, 60})
env.cmd('scale', 'one')

local f = assert(io.open(out .. '/states.lua', 'w'))
f:write('return {\n')
for _, s in ipairs(states) do
    f:write(('  {name = %q, x0 = %d, y0 = %d, x1 = %d, y1 = %d, note = %q},\n'):format(s.name, s.x0, s.y0, s.x1, s.y1, s.note))
end
f:write('}\n')
f:close()
N.stop()
restore()
print('rendered ' .. #states .. ' states')

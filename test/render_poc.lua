--[[
    test/render_poc.lua - the step progress proof of concept as built (ui/doc.lua checkboxes, ui/screens/guide.lua strip) on
    A Purchase of Arms in three states, from a stub of core/progress.lua's for_page, through the same path as test/render.lua: the real chronicle.lua, the real _chronicle.dll and a real D3D8 device
    through the patched EndScene wrapper of a FFXiMain.dll copy, over a 4K screenshot. Driven by
    the mock renderer:

        CR_RENDER_SCRIPT=test/render_poc.lua sh the mock renderer  
        lua test/render_poc.lua <FFXiMain.dll copy> <dir with cr_testhost.dll> <bg.raw (3840x2160 BGRA)> <out dir>

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
    frames[#frames + 1] = {name = name, x0 = x0, y0 = y0, x1 = x1, y1 = y1, dir = dir, caption = caption, w = win.w, h = win.h}
    local s = N.status()
    print(('%-22s %5d quads %3d batches  %s'):format(name, s.quads, s.batches, caption))
end

win.x, win.y = 160, 130
win:invalidate('all') win:flush()
env.packets(H.fixture_packets(530))

local KEY = 'quest|sandoria|27'
local FP = {'speak to helbort in southern', 'bring the weapons order to alexius', 'return to helbort to complete'}
local state
app.progress = {for_page = function(k)
    if k ~= KEY or not state then return nil end
    local p = {steps = {}, rows = {{steps = {}}}}
    for i, s in ipairs(state) do
        p.steps[i] = {n = i, fp = FP[i], shown = s}
        p.rows[1].steps[i] = i
    end
    return p
end}

local STATES = {
    {'none', nil, 'No step mapping: the page as before'},
    {'accepted', {'done', 'next', 'todo'}, 'Accepted: step 1 done, step 2 next, step 3 to do'},
    {'receipt', {'done', 'done', 'next'}, 'Weapons receipt held: steps 1 and 2 done, step 3 next'},
    {'complete', {'done', 'done', 'done'}, 'Complete: every step done, the strip shows the count'},
}
for _, wh in ipairs({{620, 760}, {480, 600}}) do
    for _, s in ipairs(STATES) do
        state = s[2]
        app:entry('quest', 'sandoria', 'A Purchase of Arms', 27)
        win.w, win.h = wh[1], wh[2]
        win:invalidate('all') win:flush()
        win:scroll_to(1e6)                -- the walkthrough is at the end of the guide
        win:invalidate('all') win:flush()
        shoot(('poc_%s_%d'):format(s[1], wh[1]), s[1], s[3] .. (' (%d x %d; the whole guide fits)'):format(wh[1], wh[2]))
    end
end

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

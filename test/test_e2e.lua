--[[
    test_e2e.lua - the whole in-game path, offline, in the stock 32-bit Lua 5.1:

      a COPY of FFXiMain.dll (its DllMain unpacks the real code)  ->  _chronicle.start() patches its
      real EndScene wrapper through UiHook  ->  cr_testhost.dll calls that wrapper with a fake
      renderer whose +0x0C is a REAL D3D8 device  ->  UiHook thunk -> dispatcher -> _chronicle's
      draw -> the real EndScene  ->  pixels read back from the device's back buffer.

    Never loads the game install's DLL. Built and run by plugin/test/build_test.sh:
        lua test/test_e2e.lua <FFXiMain.dll copy> <folder holding cr_testhost.dll>
]]

local copy, hostdir = arg[1], arg[2]
package.cpath = './libs/?.dll;' .. (os.getenv('CR_SECOND_MODULE') or '.') .. '/?.dll;' .. hostdir .. '/?.dll;' .. package.cpath
local FFXI = [[C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI\]]

local pass, fail = 0, 0
local function check(name, cond, detail)
    if cond then pass = pass + 1 else
        fail = fail + 1
        print('FAIL ' .. name .. (detail ~= nil and (': ' .. tostring(detail)) or ''))
    end
end
local function done()
    print(('test_e2e: %d passed, %d failed'):format(pass, fail))
    os.exit(fail == 0 and 0 or 1)
end

package.loadlib(copy, 'luaopen_none')              -- loads and unpacks; the symbol lookup fails
package.preload['_chronicle'] = dofile('test/crdll.lua').loader()      -- CR_DLL: a build other than libs/_chronicle.dll
local N = require('_chronicle')
local T = require('cr_testhost')

-- A pre-release UiHook ABI 1 module: nui's own hook_mod.cpp built from the frozen ABI 1 header
-- (mods/mod_x0.dll in the test folder, built by the library's build_test.sh), driven through cr_testhost.
local ABI1 = hostdir .. '/mods/mod_x0.dll'

-- mode abi1_first (a process of its own: the patch is permanent per process): the ABI 1 module
-- patches first; Chronicle must fail for good (no retry), say why, and leave the frame to it
if arg[3] == 'abi1_first' then
    local slot = T.abi1_start(ABI1)
    if slot == nil then
        print('  (' .. ABI1 .. ' not found: the ABI 1 first check is skipped)')
        done()
    end
    check('ABI 1 module patches first', slot >= 0, slot)
    local ok, msg, retry = N.start(FFXI)
    print('  start(): ' .. tostring(msg))
    check('blocked: start fails', ok == false and tostring(msg):find('ABI 1') ~= nil, msg)
    check('blocked: no retry', retry == nil, retry)
    local st = N.status()
    check('status: blocked', st.hook_state == 'blocked' and tostring(st.describe):find('^blocked') ~= nil, st.describe)
    check('status: not running, no slot, nothing installed', st.running == false and st.slot == -1 and st.installs == 0)
    ok, msg, retry = N.start(FFXI)
    check('blocked again on a second start', ok == false and retry == nil, msg)
    check('real D3D8 device', T.make_device() == true)
    local site1 = T.abi1_site()
    T.fill(0x203040)
    check('ABI 1 patch still runs EndScene', T.frame(site1) == 0)
    check('the ABI 1 module draws', T.abi1_calls() >= 1, T.abi1_calls())
    check('Chronicle drew nothing', N.status().calls == 0)
    T.abi1_stop()
    N.stop()
    done()
end

local ok, msg = N.start(FFXI)
check('start hooks the real wrapper', ok == true, msg)
local st = N.status()
print('  start(): ' .. tostring(msg) .. ' | ' .. tostring(st.hook) .. ' | site ' .. tostring(st.site))
check('hook installed once', st.installs == 1, st.installs)
check('this module owns the frame', st.owner == true)
if not ok then done() end
local site = st.site
check('real D3D8 device', T.make_device() == true)

local BG = 0x203040
local function same_bg(x, y) local r, g, b = T.pixel(x, y) return r == 0x20 and g == 0x30 and b == 0x40 end
local function px(x, y) local r, g, b = T.pixel(x, y) return r .. ',' .. g .. ',' .. b end
local function frame() T.fill(BG) return T.frame(site) end

-- 1. a window layer: drawn, states restored, nothing outside
local X, Y = 1000, 500
check('layer 1', N.layer(1, 0, table.concat({'W\t1000\t500\t600\t400\tChronicle', 'T\t1030\t540\tFFFFFFFF\tThree Paths'}, '\n')) == 2)
T.fill(BG)
T.set_game_state()
local before = T.game_state()
local hr = T.frame(site)
check('EndScene result passed through', hr == 0, hr)
check('render states restored', before == T.game_state())
st = N.status()
check('drawn once, atlas uploaded once', st.drawn == 1 and st.uploads == 1, st.uploads)
check('atlas CPU copy dropped after upload', st.cpu_pixels_kb < 64, st.cpu_pixels_kb)
check('window body drawn', not same_bg(X + 300, Y + 100), px(X + 300, Y + 100))
check('outside untouched', same_bg(X - 40, Y + 100) and same_bg(X + 640, Y + 100) and same_bg(X + 100, Y + 440))
for _ = 1, 100 do T.frame(site) end
st = N.status()
check('steady frames: no rebuild, no upload', st.rebuilds == 1 and st.uploads == 1 and st.drawn == 101)
print(('  window: %d quads, %d batches, draw %.0f us'):format(st.quads, st.batches, st.last_us))

-- 2. z order: layer 3 (z 10) red over layer 2 (z 5) green, whatever the ids
check('layer 3 red', N.layer(3, 10, 'R\t1100\t600\t1200\t700\tFF0000FF') == 1)
check('layer 2 green', N.layer(2, 5, 'R\t1150\t650\t1250\t750\t00FF00FF') == 1)
frame()
check('higher z on top', px(1175, 675) == '255,0,0', px(1175, 675))
check('lower z shows beside it', px(1225, 725) == '0,255,0', px(1225, 725))
N.layer(3, -5, 'R\t1100\t600\t1200\t700\tFF0000FF')
frame()
check('re-sent with a lower z: now under', px(1175, 675) == '0,255,0', px(1175, 675))

-- 3. layer_pos: move and clip without re-sending
local rb = N.status().rebuilds
check('move layer 2', N.layer_pos(2, 500, 0) == true)
frame()
check('moved', px(1675, 675) == '0,255,0' and px(1225, 725) ~= '0,255,0')
check('clip layer 2 to its left half', N.layer_pos(2, 500, 0, 1150, 650, 1200, 750) == true)
frame()
check('clipped half shows', px(1675, 700) == '0,255,0', px(1675, 700))
check('clipped half gone', same_bg(1725, 700), px(1725, 700))
check('layer_pos parses nothing', N.status().rebuilds == rb)
check('a re-sent layer keeps its place', N.layer(2, 5, 'R\t1150\t650\t1250\t750\t0000FFFF') == 1)
frame()
check('kept', px(1675, 700) == '0,0,255' and same_bg(1725, 700), px(1675, 700))
N.layer(2) N.layer(3)

-- 4. textures: a picture by handle, an item icon from the DATs
local h, w, hh = N.tex_load('assets/cop.png', 64, 64)
check('tex_load', type(h) == 'number' and w <= 64 and hh <= 64, w)
check('picture layer', N.layer(4, 1, ('Q\t%d\t2000\t500\t%d\t%d\t0\t0\t%d\t%d\tFFFFFFFF\t1'):format(h, 2000 + w, 500 + hh, w, hh)) == 1)
check('icon layer', N.layer(5, 1, 'I\t2200\t500\t32\t4165\tFFFFFFFF') == 1)
local up0 = N.status().uploads
frame()
st = N.status()
check('picture and icon sheet uploaded', st.uploads == up0 + 2, st.uploads - up0)
check('picture drawn', not same_bg(2000 + math.floor(w / 2), 500 + math.floor(hh / 2)))
local icon_px = 0
for yy = 500, 531 do for xx = 2200, 2231 do if not same_bg(xx, yy) then icon_px = icon_px + 1 end end end
check('icon drawn', icon_px > 100, icon_px)
check('CPU copies dropped after upload', st.cpu_pixels_kb < 64, st.cpu_pixels_kb)
frame()
check('no re-upload next frame', N.status().uploads == up0 + 2)
check('tex_free', N.tex_free(h) == true)
frame()
check('freed picture no longer drawn', same_bg(2000 + math.floor(w / 2), 500 + math.floor(hh / 2)))
N.layer(4) N.layer(5)

-- 5. other native-UI modules on the same patch: a second module (built against UiHook 2) joins and draws
-- beside Chronicle; a pre-release ABI 1 module (the frozen header) is refused, patches nothing, draws
-- nothing and crashes nothing (the other order, ABI 1 first, is mode abi1_first, and hook_matrix's)
local nui_ok, NU = pcall(require, '_nui')
if nui_ok and type(NU) == 'table' then
    local ok2, m2 = NU.start(FFXI)
    print('  second module start(): ' .. tostring(m2))
    check('a second module (UiHook 2) joins', ok2 == true, m2)
    st = N.status()
    check('one patch, two clients', st.installs == 1 and st.clients == 2, st.installs .. ' ' .. tostring(st.clients))
    check('Chronicle still drives the same site', st.owner == true and st.site == site and st.hook_state == 'live', st.site)
    NU.state({x = 2600, y = 1200})
    check('EndScene result passed through', frame() == 0)
    check('both draw', not same_bg(X + 300, Y + 100) and not same_bg(2600 + 200, 1200 + 40), px(2600 + 200, 1200 + 40))
    NU.stop()
    check('after the second module stops: EndScene runs', frame() == 0)
    st = N.status()
    check('second module stopped: Chronicle unaffected', not same_bg(X + 300, Y + 100) and same_bg(2600 + 200, 1200 + 40)
        and st.installs == 1 and st.clients == 1)
else
    print('  (no second module _nui.dll found: the second-module check is skipped)')
end
local slot = T.abi1_start(ABI1)
if slot ~= nil then
    check('ABI 1 module refused: not hooked', slot < 0, slot)
    st = N.status()
    check('still one patch, one client', st.installs == 1 and st.clients == 1, st.installs .. ' ' .. tostring(st.clients))
    check('EndScene result passed through', frame() == 0)
    check('Chronicle draws, the ABI 1 module does not', not same_bg(X + 300, Y + 100) and T.abi1_calls() == 0, T.abi1_calls())
    T.abi1_stop()
else
    print('  (' .. ABI1 .. ' not found: the ABI 1 refusal check is skipped)')
end
st = N.status()
print('  UiHook: ' .. tostring(st.describe) .. ' | driver rev ' .. tostring(st.owner_rev))
check('describe names chronicle as the driver', tostring(st.describe):find('chronicle r1 %(drives%)') ~= nil, st.describe)
check('owner_rev 1', st.owner_rev == 1, st.owner_rev)

-- 6. stop: the hook stays, pure pass-through; nosig fails closed; restart reuses the patch
check('stop', N.stop() == 'stopped')
hr = frame()
check('after stop: EndScene runs, nothing drawn', hr == 0 and same_bg(X + 300, Y + 100))
local retry
ok, msg, retry = N.start(FFXI, 'nosig')
check('nosig: start fails', ok == false and tostring(msg):find('not found') ~= nil, msg)
check('nosig: retry in 5 s', retry == 5000, retry)
frame()
check('nosig: nothing drawn', same_bg(X + 300, Y + 100) and N.status().running == false)
ok, msg = N.start(FFXI)
check('restart', ok == true, msg)
N.layer(1, 0, 'W\t1000\t500\t600\t400\tChronicle')
frame()
st = N.status()
check('restart: one patch, drawn again', st.installs == 1 and not same_bg(X + 300, Y + 100))

-- 7. client facts: both signatures in the real code; fake tables as the running game builds them
print(('  config manager global %s, UI size global %s'):format(st.cfg_ptr, st.ui_ptr))
check('config signature found', st.cfg_ptr ~= '00000000', st.cfg_ptr)
check('UI size signature found', st.ui_ptr ~= '00000000', st.ui_ptr)
check('uninitialised: fails closed', st.config_read == false and N.wtread() == nil and st.ui_found == false)
T.fake_config(st.cfg_ptr, 18, 2)
local t, src = N.wtread()
check('config id 18 = 2 -> window type 3', t == 3 and src == 'config', tostring(t))
T.fake_config(st.cfg_ptr, 18, 9)
check('out of range -> nil', N.wtread() == nil)
T.fake_ui(st.ui_ptr, 2560, 1440)
st = N.status()
check('UI size read', st.ui_found and st.ui_w == 2560 and st.ui_h == 1440)

-- 8. window types: each re-uploads and rebuilds every layer in its own look
local looks, distinct = {}, 0
for n = 1, 8 do
    local u0 = N.status().uploads
    check('wintype ' .. n, N.wintype(n) == true)
    frame()
    check('wintype ' .. n .. ': re-uploaded', N.status().uploads > u0)
    local key = px(X + 300, Y + 100)
    if not looks[key] then looks[key] = n distinct = distinct + 1 end
end
check('window types differ (>= 5 distinct bodies)', distinct >= 5, distinct)
N.wintype(6)

-- 9. scale: one Lua unit = 1.5 render-target px
N.screen(3840, 2160, false, 1.5)
frame()
check('scale 1.5: drawn 1.5x as far', not same_bg(math.floor((X + 580) * 1.5), math.floor((Y + 100) * 1.5)))
check('scale 1.5: starts 1.5x as far', same_bg(X + 300, Y + 100) and math.abs(N.status().scale - 1.5) < 1e-6)
N.screen(3840, 2160, false, 1)
N.stop()
done()

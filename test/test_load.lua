--[[
    test_load.lua - loads libs/_chronicle.dll into the stock 32-bit Lua 5.1 interpreter (no game, no
    FFXiMain.dll): it binds the Lua API, exposes its functions, fails closed without the game,
    refuses bad arguments without crashing, and (with the install present, read-only) loads every
    window type, the fonts' metrics, item icons and picture files.

    Run from addons/chronicle:
        "C:\Program Files (x86)\Lua\5.1\lua.exe" test/test_load.lua
]]

package.cpath = './libs/?.dll;' .. package.cpath
package.preload['_chronicle'] = dofile('test/crdll.lua').loader()      -- CR_DLL: a build other than libs/_chronicle.dll

local pass, fail = 0, 0
local function check(name, cond, detail)
    if cond then pass = pass + 1 else
        fail = fail + 1
        print('FAIL ' .. name .. (detail ~= nil and (': ' .. tostring(detail)) or ''))
    end
end
local function done()
    print(('test_load: %d passed, %d failed'):format(pass, fail))
    os.exit(fail == 0 and 0 or 1)
end

local ok, N = pcall(require, '_chronicle')
check('require', ok and type(N) == 'table', N)
if not (ok and type(N) == 'table') then done() end

for _, f in ipairs({'version', 'start', 'stop', 'status', 'screen', 'layer', 'layer_pos', 'tex_load', 'tex_free',
                    'icon', 'icon_pixels', 'metrics', 'wintype', 'wtfind', 'wtwatch', 'wtread'}) do
    check('function ' .. f, type(N[f]) == 'function')
end
-- the drawing layer's own version, which moves when the drawing does, not with the addon's
check('version', N.version() == '2.1.1', N.version())

-- fails closed without the game
local good, msg = N.start()
check('start fails closed', good == false and tostring(msg):find('FFXiMain.dll is not loaded') ~= nil, msg)
local st = N.status()
check('status: not running', st.running == false and st.slot == -1 and st.drawn == 0)
check('status: assets not loaded', st.assets == 'not loaded', st.assets)
check('metrics nil before start', N.metrics() == nil)
local r, why = N.layer(1, 0, 'R\t0\t0\t1\t1\tFFFFFFFF')
check('layer before start refused', r == nil and tostring(why):find('start') ~= nil, why)

-- argument checks
for _, b in ipairs({{'id 0', {0, 0, ''}}, {'id 17', {17, 0, ''}}, {'id 1.5', {1.5, 0, ''}}, {'id string', {'x', 0, ''}},
                    {'z string', {1, 'a', ''}}, {'z 2000', {1, 2000, ''}}, {'text number', {1, 0, 5}}}) do
    local a = b[2]
    r, why = N.layer(a[1], a[2], a[3])
    check('layer refuses ' .. b[1], r == nil and type(why) == 'string', why)
end
r, why = N.layer_pos(1, 0, 0)
check('layer_pos on no layer', r == nil, why)
r, why = N.layer_pos(1, 0)
check('layer_pos needs ox, oy', r == nil, why)
r, why = N.tex_free(1)
check('tex_free refuses the icon cache', r == nil, why)
r, why = N.tex_load('no/such/file.png')
check('tex_load of a missing file', r == nil and tostring(why):find('cannot decode') ~= nil, why)
r, why = N.tex_load(5)
check('tex_load refuses a number', r == nil, why)
check('icon without the install', N.icon(16384) == false)
check('icon_pixels without the install', N.icon_pixels(16384) == nil)
for _, b in ipairs({{'0', 0}, {'9', 9}, {'2.5', 2.5}, {'string', 'x'}}) do
    r, why = N.wintype(b[2])
    check('wintype refuses ' .. b[1], r == nil and type(why) == 'string', why)
end
check('wtread fails closed', N.wtread() == nil)
r = N.screen(3840, 2160, false, 1)
check('screen accepted', r == true)
r, why = N.screen(-1, 5)
check('screen refuses a negative size', r == nil, why)
good, msg = N.start(42)
check('start(42) refused', good == false and tostring(msg):find('expects') ~= nil, msg)

-- with the game folder given (read-only) but no FFXiMain: assets load, the hook refuses
local FFXI = [[C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI\]]
local f = io.open(FFXI .. 'FTABLE.DAT', 'rb')
if not f then
    print('  (skipped the install checks: no game install at ' .. FFXI .. ')')
    done()
end
f:close()
good, msg = N.start(FFXI)
check('start(dir) without FFXiMain: not hooked', good == false and tostring(msg):find('not hooked') ~= nil, msg)
local retry
good, msg, retry = N.start(FFXI)
check('not hooked: start again in 5 s', good == false and retry == 5000, retry)
st = N.status()
check('status: hook waiting', st.hook_state == 'waiting' and tostring(st.describe):find('^waiting') ~= nil, st.describe)
st = N.status()
check('assets loaded from the install', tostring(st.assets):find('window type 6') ~= nil, st.assets)
print('  assets: ' .. tostring(st.assets))

local M = N.metrics()
check('metrics', type(M) == 'table' and #M.moji == 96 and #M.title == 95 and M.from_game == true)
check('metrics: moji widths', M and M.moji[1] == 7 and M.moji[('M'):byte() - 31] > 8, M and M.moji[1])
check('metrics: title glyphs', M and M.title[('M'):byte() - 31][2] > 0)

for n = 1, 8 do
    local wok, werr = N.wintype(n)
    check('wintype ' .. n .. ' loads', wok == true, werr)
    check('status: window type ' .. n, N.status().window_type == n)
end
N.wintype(6)

-- layers build without a device: parsed, kept, replayed by layer_pos
local ops = table.concat({'W\t100\t100\t400\t300\tChronicle', 'T\t120\t140\tFFFFFFFF\tHello', 'H\t120\t170\t13\tFFFFFFFF\tTitle',
    'R\t120\t200\t200\t210\t40CEF3FF', 'I\t120\t220\t32\t16384\tFFFFFFFF', 'G\t120\t260\t200\t7\t0.5\t50DC78FF',
    'C\t110\t110\t300\t300', 'T\t120\t280\tFFFFFFFF\tclipped', 'c'}, '\n')
r, why = N.layer(1, 0, ops)
check('layer accepted', r == 9, why)
st = N.status()
check('status: one layer with quads', st.layers == 1 and st.quads > 50, st.quads)
local q0 = st.quads
check('layer_pos moves it', N.layer_pos(1, 50, 20) == true)
check('layer_pos clips it', N.layer_pos(1, 0, 0, 0, 0, 200, 150) == true)
st = N.status()
check('a clip removes quads', st.quads < q0, st.quads .. ' < ' .. q0)
check('layer_pos with no clip', N.layer_pos(1, 0, 0) == true and N.status().quads == q0)
r, why = N.layer(2, 5, 'Z\t1')
check('unknown command refused', r == nil and tostring(why):find('line 1') ~= nil, why)
r, why = N.layer(2, 5, 'T\t1\t2')
check('short command refused', r == nil and tostring(why):find('needs') ~= nil, why)
check('second layer', N.layer(2, -1, 'R\t0\t0\t10\t10\tFF0000FF') == 1 and N.status().layers == 2)
check('layer removed', N.layer(2) == true and N.status().layers == 1)

-- item icons from the DATs
check('icon: Silent Oil has one', N.icon(4165) == true)
local px = N.icon_pixels(4165)
check('icon_pixels: 32 x 32 BGRA', type(px) == 'string' and #px == 4096, px and #px)
local opaque = 0
for i = 4, #px, 4 do if px:byte(i) > 0 then opaque = opaque + 1 end end
check('icon_pixels: has opaque pixels', opaque > 100, opaque)
check('icon: id 0 has none', N.icon(0) == false)
-- 64 cells: more distinct icons than that recycle cells instead of failing
local okn = 0
for id = 4096, 4096 + 80 do if N.icon(id) then okn = okn + 1 end end
check('icon cache recycles cells', okn > 64, okn)

-- pictures: any PNG/JPEG on disk; fitted inside the limits
local png = 'assets/trophy.png'
local h, w, hh = N.tex_load(png, 8, 8)
check('tex_load a PNG', type(h) == 'number' and h >= 2 and w <= 8 and hh <= 8, w)
local h2 = N.tex_load(png)
check('tex_load gives a new handle', h2 == h + 1)
st = N.status()
check('status: pictures counted', st.pictures == 2, st.pictures)
check('tex_free', N.tex_free(h) == true and N.tex_free(h2) == true and N.status().pictures == 0)
check('tex_free twice refused', N.tex_free(h) == nil)

check('stop', N.stop() == 'stopped')
st = N.status()
check('stop clears layers and textures', st.layers == 0 and st.pictures == 0 and st.assets == 'not loaded')
done()

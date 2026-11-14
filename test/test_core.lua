--[[
    test_core.lua - core/ fixes from the 2026-11-07 review, offline, in a temp folder:

      LIFE-6   core/places.lua: one file per character, saved through a temp file, the old shared file migrated
      LIFE-12  no shell for a missing folder (places, pages, pictures): windower.create_dir
      CORE-12  core/pages.lua: tab and scroll state per character; one client's save keeps the others'
      CORE-3   core/pics.lua + core/net.lua: a cut or non-picture download is never written; a file that does not decode is
               fetched again once; a body shorter than its Content-Length is an error
      CORE-4   core/net.lua: a failed DNS lookup is remembered; core/pics.lua fails the queue after one
      CORE-10  core/gif.lua: a cut GIF is nil, not an error; a cap of 2048 a side; a downloaded GIF converted in the download
               coroutine, sleeping between pieces
      CORE-16  core/pics.lua: an error in on_ready, or a dead download coroutine, does not stop every later download
      CORE-15  core/wiki.lua: items in Wardrobe 5-8 count
      CORE-8   core/meta.lua: pages/index.lua read once, however many areas load
      CORE-20  core/meta.lua: a stub entry with no page header does not throw

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_core.lua
]]

package.path = './?.lua;' .. package.path

local pass, fail = 0, 0
local function check(cond, what)
    if cond then pass = pass + 1 else fail = fail + 1 print('FAIL ' .. what) end
end

-- each section runs on its own: an error in one is a failure, the rest still run
local function section(fn)
    local ok, err = pcall(fn)
    if not ok then check(false, 'section error: ' .. tostring(err)) end
end

local real_execute = os.execute
local shell_calls = 0
os.execute = function(...) shell_calls = shell_calls + 1 return real_execute(...) end

local function winpath(p) return (p:gsub('/', '\\')) end
local function rmtree(p) real_execute('rmdir /s /q "' .. winpath(p) .. '" 2>nul') end
local function mkdir(p) real_execute('mkdir "' .. winpath(p) .. '" 2>nul') end
local function readf(p) local f = io.open(p, 'rb') if not f then return nil end local s = f:read('*a') f:close() return s end
local function writef(p, s) local f = assert(io.open(p, 'wb')) f:write(s) f:close() end
local function exists(p) local f = io.open(p, 'rb') if f then f:close() return true end return false end
local function leftovers(d)
    local n = 0
    for l in io.popen('dir /b "' .. winpath(d) .. '" 2>nul'):lines() do if l:find('%.tmp$') then n = n + 1 end end
    return n
end

local base = (os.getenv('TEMP') or '.'):gsub('\\', '/') .. '/cr_core_test/'
rmtree(base)
mkdir(base)

local player = 'Berrant'
local items = {}
local created = {}
windower = {
    addon_path = base,
    create_dir = function(p) created[#created + 1] = p mkdir(p) return true end,
    ffxi = {
        get_player = function() return player and {name = player} or nil end,
        get_items = function(bag) return items[bag] or {} end,
        get_key_items = function() return {} end,
    },
}

---------------------------------------------------------------------------
-- core/fsave.lua
---------------------------------------------------------------------------
section(function()
    local fsave = require('core/fsave')
    local d = base .. 'fsave/'
    mkdir(d)
    check(fsave.write(d .. 'a.lua', 'one') and readf(d .. 'a.lua') == 'one', 'fsave: a new file is written')
    check(fsave.write(d .. 'a.lua', 'two') and readf(d .. 'a.lua') == 'two', 'fsave: an existing file is replaced')
    fsave.FAIL_WRITE = true
    check(not fsave.write(d .. 'a.lua', 'three') and readf(d .. 'a.lua') == 'two', 'fsave: a failed write leaves the old file whole')
    fsave.FAIL_WRITE = nil
    check(leftovers(d) == 0, 'fsave: no temp file left behind')
end)

---------------------------------------------------------------------------
-- LIFE-6 + LIFE-12: core/places.lua
---------------------------------------------------------------------------
section(function()
    local places = require('core/places')
    local d = base .. 'places/'
    mkdir(d)
    shell_calls = 0
    -- a fresh install: no data/ folder yet
    check(places.save(d, 'berrant', 3840, 2160, {x = 1, y = 2, w = 300, h = 400}), 'places: saved with no data/ folder')
    check(shell_calls == 0, 'places: no shell started for the folder (review LIFE-12); started ' .. shell_calls)
    local p = places.load(d, 'berrant', 3840, 2160)
    check(p and p.x == 1 and p.h == 400, 'places: read back')
    check(exists(d .. 'data/places_berrant.lua') and not exists(d .. 'data/places.lua'), 'places: one file per character')

    -- the old shared file: read for a character with no file of its own, carried over on its first save, never rewritten
    local d2 = base .. 'places2/'
    mkdir(d2 .. 'data')
    local legacy = '-- old\nreturn {\n    ["player1"] = {["3840x2160"] = {x = 10, y = 20, w = 600, h = 700}},\n'
        .. '    ["aldreth"] = {["3840x2160"] = {x = 11, y = 21, w = 601, h = 701}, ["2560x1440"] = {x = 5, y = 6, w = 400, h = 500}},\n}\n'
    writef(d2 .. 'data/places.lua', legacy)
    local j = places.load(d2, 'player1', 3840, 2160)
    check(j and j.x == 10, 'places: an old shared entry is still read')
    places.save(d2, 'aldreth', 1920, 1080, {x = 7, y = 8, w = 300, h = 300})
    check(readf(d2 .. 'data/places.lua') == legacy, 'places: the old shared file is not rewritten')
    local l1, l2, l3 = places.load(d2, 'aldreth', 3840, 2160), places.load(d2, 'aldreth', 2560, 1440), places.load(d2, 'aldreth', 1920, 1080)
    check(l1 and l1.x == 11 and l2 and l2.x == 5 and l3 and l3.x == 7, 'places: the old entries are carried into the new file')
    places.save(d2, 'player1', 1920, 1080, {x = 9, y = 9, w = 300, h = 300})
    local again = places.load(d2, 'aldreth', 2560, 1440)
    check(again and again.x == 5, "places: another character's save keeps this character's places")
    check(leftovers(d2 .. 'data') == 0, 'places: no temp file left behind')
end)

---------------------------------------------------------------------------
-- CORE-12: core/pages.lua page state
---------------------------------------------------------------------------
section(function()
    local pages = require('core/pages')
    local d = base .. 'pages/'
    mkdir(d .. 'data')
    local legacy = 'return {\n    ["quest|bastok|1"] = {tabs = {[1] = 2}, scroll = {["page"] = 50}},\n}\n'
    writef(d .. 'data/pages.lua', legacy)
    shell_calls = 0
    player = 'Berrant'
    pages._forget(d)
    check(pages._saved()['quest|bastok|1'] ~= nil, 'pages: the old shared state is read')
    pages._save_entry('quest|bastok|2', {[1] = 1}, {page = 10})
    -- a second client, another character, saves too: it read the file before the first one saved
    player = 'Player1'
    pages._forget(d)
    pages._save_entry('quest|bastok|3', {}, {page = 30})
    player = 'Berrant'
    pages._forget(d)
    local k = pages._saved()
    check(k['quest|bastok|1'] and k['quest|bastok|2'] and k['quest|bastok|2'].scroll.page == 10 and not k['quest|bastok|3'],
        "pages: one client's save keeps this character's state")
    player = 'Player1'
    pages._forget(d)
    local j = pages._saved()
    check(j['quest|bastok|3'] and j['quest|bastok|1'] and not j['quest|bastok|2'], 'pages: and the other character keeps its own')
    check(readf(d .. 'data/pages.lua') == legacy, 'pages: the old shared file is not rewritten')
    check(shell_calls == 0, 'pages: no shell started (review LIFE-12)')
    player = 'Berrant'
    -- a fresh install with no data/ folder
    local d2 = base .. 'pages2/'
    mkdir(d2)
    pages._forget(d2)
    check(pages._save_entry('quest|bastok|4', {}, {page = 1}) and exists(d2 .. 'data/pages_berrant.lua') and shell_calls == 0,
        'pages: saved with no data/ folder, through windower.create_dir')
end)

---------------------------------------------------------------------------
-- CORE-3 + CORE-4: core/net.lua
---------------------------------------------------------------------------
local reply = ''
local toip_calls = 0
local toip_result = nil
package.loaded['socket'] = {
    dns = {toip = function() toip_calls = toip_calls + 1 return toip_result end},
    tcp = function() return {settimeout = function() end, connect = function() end, close = function() end} end,
    select = function(_, w) return nil, w end,
}
local wrap_params, peer_ok, peer_names = nil, true, {'host.test'}
package.loaded['ssl'] = {
    wrap = function(_, params)
        wrap_params = params
        local sent = false
        return {
            settimeout = function() end, close = function() end,
            dohandshake = function() return true end,
            getpeerverification = function() if peer_ok then return true end return false, {{'certificate has expired'}} end,
            getpeercertificate = function()
                return {extensions = function() return {['2.5.29.17'] = {dNSName = peer_names}} end, subject = function() return {} end}
            end,
            send = function(_, blob) return #blob end,
            receive = function()
                if not sent then sent = true return reply end
                return nil, 'closed'
            end,
        }
    end,
}
section(function()
    package.loaded['core/net'] = nil
    local net = require('core/net')
    net.cafile = 'certs/cacert.pem'
    local now = 1000
    net.clock = function() return now end
    toip_result = nil
    local r, err, kind = net.get('host.test', '/a')
    check(r == nil and kind == 'dns', 'net: a failed lookup says dns: ' .. tostring(err))
    net.get('host.test', '/b') net.get('host.test', '/c')
    check(toip_calls == 1, 'net: a failed lookup is remembered (review CORE-4); looked up ' .. toip_calls .. ' times')
    now = now + 61
    net.get('host.test', '/d')
    check(toip_calls == 2, 'net: and tried again after a minute')
    toip_result = '127.0.0.1'
    now = now + 61
    reply = 'HTTP/1.1 200 OK\r\nContent-Length: 100\r\n\r\n' .. string.rep('x', 50)
    local r2, err2 = net.get('host.test', '/e')
    check(r2 == nil and tostring(err2):find('short'), 'net: a body shorter than its Content-Length is an error (review CORE-3)')
    reply = 'HTTP/1.1 200 OK\r\nContent-Length: 50\r\n\r\n' .. string.rep('x', 50)
    local r3 = net.get('host.test', '/f')
    check(r3 and r3.status == 200 and #r3.body == 50, 'net: a whole body is returned')
    -- review CORE-6: the certificate is checked against the shipped bundle and must name the host
    check(type(wrap_params.verify) == 'table' and wrap_params.verify[1] == 'peer' and wrap_params.cafile == net.cafile,
        'net: TLS verifies the peer against the shipped CA bundle (review CORE-6)')
    local bundle = io.open(net.cafile, 'rb')
    check(bundle and bundle:read('*a'):find('BEGIN CERTIFICATE', 1, true) ~= nil, 'net: the CA bundle ships with the addon')
    if bundle then bundle:close() end
    peer_ok = false
    local r4, err4 = net.get('host.test', '/g')
    check(r4 == nil and tostring(err4):find('not trusted'), 'net: an untrusted certificate is refused: ' .. tostring(err4))
    peer_ok, peer_names = true, {'other.test'}
    local r5, err5 = net.get('host.test', '/h')
    check(r5 == nil and tostring(err5):find('not host.test'), 'net: a certificate for another host is refused: ' .. tostring(err5))
    peer_names = {'*.host.test'}
    local r6 = net.get('host.test', '/i')
    check(r6 == nil, 'net: a wildcard covers one label only (*.host.test is not host.test)')
    peer_names = {'host.test'}
    check(net.get('host.test', '/j') ~= nil, 'net: a certificate naming the host is accepted')
    package.loaded['core/net'] = nil
    local net2 = require('core/net')
    net2.cafile = 'certs/no_such_bundle.pem'
    local r7, err7 = net2.get('host.test', '/k')
    check(r7 == nil and tostring(err7):find('no CA bundle'), 'net: without the bundle nothing is downloaded')
end)

---------------------------------------------------------------------------
-- CORE-10: core/gif.lua
---------------------------------------------------------------------------
local function le16(n) return string.char(n % 256, math.floor(n / 256) % 256) end
-- a GIF of w x h, 8-bit LZW written as 9-bit literal codes with a clear code every 200 (the dictionary never grows past 9 bits)
local function make_gif(w, h)
    local codes, since = {256}, 0
    for i = 1, w * h do
        codes[#codes + 1] = (i % 7) * 30
        since = since + 1
        if since >= 200 then codes[#codes + 1] = 256 since = 0 end
    end
    codes[#codes + 1] = 257
    local bytes, acc, nacc = {}, 0, 0
    for _, c in ipairs(codes) do
        acc = acc + c * 2 ^ nacc
        nacc = nacc + 9
        while nacc >= 8 do
            bytes[#bytes + 1] = string.char(acc % 256)
            acc = math.floor(acc / 256)
            nacc = nacc - 8
        end
    end
    if nacc > 0 then bytes[#bytes + 1] = string.char(acc % 256) end
    local data = table.concat(bytes)
    local blocks = {}
    for i = 1, #data, 255 do
        local b = data:sub(i, i + 254)
        blocks[#blocks + 1] = string.char(#b) .. b
    end
    local pal = {}
    for i = 0, 255 do pal[#pal + 1] = string.char(i, i, i) end
    return 'GIF89a' .. le16(w) .. le16(h) .. string.char(0xF7, 0, 0) .. table.concat(pal)
        .. ',' .. le16(0) .. le16(0) .. le16(w) .. le16(h) .. '\0' .. '\8' .. table.concat(blocks) .. '\0;'
end

section(function()
    local gif = require('core/gif')
    local g = make_gif(8, 4)
    local bmp = gif.to_bmp(g)
    check(bmp and bmp:sub(1, 2) == 'BM', 'gif: the test GIF converts')
    -- cut straight after a graphic control extension's "21 F9 04"
    local cut = g:sub(1, 13 + 768) .. string.char(0x21, 0xF9, 0x04)
    local ok, r, why = pcall(gif.to_bmp, cut)
    check(ok and r == nil, 'gif: a GIF cut after 21 F9 04 is nil, not an error (review CORE-10): ' .. tostring(ok and why or r))
    local ok2, r2 = pcall(gif.to_bmp, g:sub(1, 11))
    check(ok2 and r2 == nil, 'gif: a GIF cut in its header is nil')
    local ok3, r3 = pcall(gif.to_bmp, g:sub(1, 13 + 768 + 1))
    check(ok3 and r3 == nil, 'gif: a GIF cut at an extension label is nil')
    local big = 'GIF89a' .. le16(2049) .. le16(1) .. string.char(0, 0, 0) .. ',' .. string.rep('\0', 9) .. '\2\0;'
    local _, why4 = gif.to_bmp(big)
    check(why4 == 'too large', 'gif: wider than 2048 is refused: ' .. tostring(why4))
    local yields = 0
    local b2 = gif.to_bmp(make_gif(512, 512), function() yields = yields + 1 end)
    check(b2 and yields >= 4, 'gif: a 512 x 512 picture yields while decoding; ' .. yields .. ' times')
end)

---------------------------------------------------------------------------
-- CORE-3, CORE-4, CORE-10, CORE-16, LIFE-12: core/pics.lua
---------------------------------------------------------------------------
local jobs, job_errors, sleeps = {}, {}, 0
coroutine.schedule = function(fn) jobs[#jobs + 1] = fn end
coroutine.sleep = function() sleeps = sleeps + 1 coroutine.yield() end
local function run_jobs()
    while #jobs > 0 do
        local co = coroutine.create(table.remove(jobs, 1))
        while true do
            local ok, err = coroutine.resume(co)
            if not ok then job_errors[#job_errors + 1] = err break end
            if coroutine.status(co) == 'dead' then break end
        end
    end
end

local function u32be(n) return string.char(math.floor(n / 16777216) % 256, math.floor(n / 65536) % 256, math.floor(n / 256) % 256, n % 256) end
local PNG = string.char(137, 80, 78, 71, 13, 10, 26, 10) .. u32be(13) .. 'IHDR' .. u32be(64) .. u32be(64) .. string.rep('\0', 80)
    .. u32be(0) .. 'IEND' .. string.char(174, 66, 96, 130)

local fakeN = {fail = {}, loads = 0}
function fakeN.tex_load(path)
    fakeN.loads = fakeN.loads + 1
    if fakeN.fail[path] then fakeN.fail[path] = nil return nil end
    if not exists(path) then return nil end
    return fakeN.loads, 64, 64
end
function fakeN.tex_free() return true end

local function new_pics(d, handler)
    package.loaded['core/pics'] = nil
    local pics = require('core/pics')
    local net = {available = true, calls = 0}
    function net.get(host, path)
        net.calls = net.calls + 1
        return handler(path, net.calls)
    end
    pics.setup(d, fakeN, net)
    jobs, job_errors = {}, {}
    return pics, net
end

section(function()
    -- a fresh install: no data/ folder; a cut PNG is never written, a whole one is
    local d = base .. 'pics/'
    mkdir(d)
    shell_calls = 0
    local pics = new_pics(d, function(path)
        if path:find('Cut') then return {status = 200, body = PNG:sub(1, #PNG - 12)} end
        if path:find('Html') then return {status = 200, body = '<html>' .. string.rep(' ', 100) .. '</html>'} end
        return {status = 200, body = PNG}
    end)
    check(pics.get('Cut.png') == 'loading', 'pics: a missing picture is fetched')
    pics.get('Html.png')
    pics.get('Whole.png')
    run_jobs()
    check(#job_errors == 0, 'pics: no error in the download coroutine: ' .. tostring(job_errors[1]))
    check(not exists(pics.local_name('Cut.png')) and pics.get('Cut.png') == 'failed', 'pics: a cut PNG is not written (review CORE-3)')
    check(not exists(pics.local_name('Html.png')), 'pics: a page that is not a picture is not written')
    check(exists(pics.local_name('Whole.png')) and type(pics.get('Whole.png')) == 'table', 'pics: a whole PNG is written and loads')
    check(leftovers(d .. 'data/pics') == 0, 'pics: no temp file left behind')
    check(shell_calls == 0, 'pics: no shell started for data/pics (review LIFE-12); started ' .. shell_calls)
end)

section(function()
    -- a file on disk that does not decode (cut by an older version) is deleted and fetched again, once
    local d = base .. 'pics2/'
    mkdir(d .. 'data/pics')
    local pics, net = new_pics(d, function() return {status = 200, body = PNG} end)
    writef(pics.local_name('Old.png'), PNG:sub(1, 40))
    fakeN.fail[pics.local_name('Old.png')] = true
    local first = pics.get('Old.png')
    check(first == 'loading', 'pics: a file that does not decode is fetched again (review CORE-3): ' .. tostring(first))
    run_jobs()
    check(net.calls == 1 and type(pics.get('Old.png')) == 'table', 'pics: and loads once fetched again')
    fakeN.fail[pics.local_name('Old.png')] = true
    pics.release()
    check(pics.get('Old.png') == 'failed', 'pics: only once a session')
end)

section(function()
    -- review CORE-4: a failed DNS lookup fails the queue, the resolver is not asked once a picture
    local d = base .. 'pics3/'
    mkdir(d .. 'data/pics')
    local pics, net = new_pics(d, function() return nil, 'dns lookup failed for host', 'dns' end)
    pics.get('A.png') pics.get('B.png') pics.get('C.png')
    run_jobs()
    check(net.calls == 1, 'pics: one failed lookup fails the queue (review CORE-4); asked ' .. net.calls .. ' times')
    check(pics.get('B.png') == 'failed' and pics.get('C.png') == 'failed', 'pics: the rest are failed')
end)

section(function()
    -- review CORE-16: an error in on_ready does not stop later downloads; nor does a dead download coroutine
    local d = base .. 'pics4/'
    mkdir(d .. 'data/pics')
    local die = false
    local pics, net = new_pics(d, function() if die then error('boom') end return {status = 200, body = PNG} end)
    pics.on_ready = function() error('layout failed') end
    pics.get('One.png')
    run_jobs()
    pics.get('Two.png')
    run_jobs()
    check(net.calls == 2 and exists(pics.local_name('Two.png')), 'pics: an error in on_ready does not stop later downloads; fetched ' .. net.calls)
    pics.on_ready = nil
    die = true
    pics.get('Three.png')
    run_jobs()
    check(#job_errors == 1, 'pics: the download coroutine died (the case being tested)')
    die = false
    pics.get('Four.png')
    run_jobs()
    check(net.calls == 3, 'pics: a dead download coroutine waits for its stall time')
    local t = os.time() + pics.STALL + 1
    pics.clock = function() return t end
    pics.get('Five.png')
    run_jobs()
    check(net.calls >= 4 and exists(pics.local_name('Five.png')), 'pics: then a new one starts')
end)

section(function()
    -- review CORE-10: a downloaded GIF is converted in the download coroutine, sleeping between pieces, not in a page layout
    local d = base .. 'pics5/'
    mkdir(d .. 'data/pics')
    local g = make_gif(512, 512)
    local pics = new_pics(d, function() return {status = 200, body = g} end)
    sleeps = 0
    pics.get('Map.gif')
    run_jobs()
    check(#job_errors == 0, 'pics: no error converting: ' .. tostring(job_errors[1]))
    check(exists(pics.local_name('Map.gif') .. '.bmp') and sleeps >= 4, 'pics: the GIF is converted while downloading, sleeping ' .. sleeps .. ' times')
end)

---------------------------------------------------------------------------
-- CORE-15: core/wiki.lua
---------------------------------------------------------------------------
section(function()
    package.loaded['core/wiki'] = nil
    local wiki = require('core/wiki')
    items = {wardrobe5 = {{id = 4351, count = 1}}, wardrobe8 = {{id = 4351, count = 2}}, inventory = {{id = 4351, count = 1}}}
    local r = wiki.check_requirements({{name = 'Giddeus Water', count = 4, id = 4351}})
    check(r and r[1].owned == 4, 'wiki: items in Wardrobe 5-8 count (review CORE-15); owned ' .. tostring(r and r[1].owned))
    items = {}
end)

---------------------------------------------------------------------------
-- CORE-8 + CORE-20: core/meta.lua
---------------------------------------------------------------------------
section(function()
    package.loaded['core/meta'] = nil
    local meta = require('core/meta')
    meta.set_root('./')
    local index_reads = 0
    local lf = loadfile
    loadfile = function(p, ...) if tostring(p):find('pages/index%.lua$') then index_reads = index_reads + 1 end return lf(p, ...) end
    for _, a in ipairs({'jeuno', 'bastok', 'windurst', 'jeuno', 'sandoria', 'bastok'}) do meta.get('quest', a, nil, 1) end
    loadfile = lf
    check(index_reads <= 1, 'meta: pages/index.lua is read once however many areas load (review CORE-8); read ' .. index_reads .. ' times')

    -- a stub entry (an id and nothing else) whose page has no header, and one with no page at all
    local d = base .. 'meta/'
    mkdir(d .. 'meta/quests')
    mkdir(d .. 'pages/quests/testarea')
    writef(d .. 'meta/quests/testarea.lua', "return {['Stub One'] = {id = 1}, ['Stub Two'] = {id = 2}}")
    writef(d .. 'pages/index.lua', "return {['quest|testarea|1'] = 'pages/quests/testarea/1.lua'}")
    writef(d .. 'pages/quests/testarea/1.lua', "return {page = 'Stub One', body = ''}")
    package.loaded['core/meta'] = nil
    local m2 = require('core/meta')
    m2.set_root(d)
    local ok, e = pcall(m2.get, 'quest', 'testarea', 'Stub One')
    local ok2 = pcall(m2.get, 'quest', 'testarea', 'Stub Two')
    check(ok and ok2 and e and e.id == 1, 'meta: a stub entry with no page header does not throw (review CORE-20): ' .. tostring(ok and '' or e))
end)

os.execute = real_execute
rmtree(base)
print(('test_core: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)

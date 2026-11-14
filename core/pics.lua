--[[
    Chronicle: walkthrough pictures from BG-wiki, fetched the first time a page shows them and kept
    in data/pics/ (nothing from BG-wiki is shipped with the addon). One download at a time, in a
    Windower coroutine (core/net.lua never blocks the game). Decoded by the DLL at most 512 px and
    held as textures only while their page is open.

        pics.setup(dir, native, net)
        pics.get(file) -> {h, w, h_px} | 'loading' | 'failed'        -- a texture, held until the pass ends
        pics.get(file, false) -> {w, h_px} | 'loading' | 'failed'    -- the size only (a picture out of view)
        pics.begin_pass() / pics.end_pass()      -- one layout of a page: what it asked for stays, the rest is freed
        pics.on_ready = function(file) end      -- a picture arrived (re-lay the page out)
        pics.live(h) -> bool                     -- is this texture handle still held (tests)
        pics.release()                           -- free every texture (the page closed)
        pics.rev                                 -- bumped by every change that can change an answer of pics.get (core/pages.lua's
                                                 -- page memo: a layout's pictures answer the same while it is unchanged)

    A page's layout is one buffer of drawing commands, each picture a command naming a texture, and the buffer is scrolled, not
    redrawn. A texture freed while a buffer still names it draws blank (2026-10-20: jeuno 130, 77 and windurst 83: seven maps in
    view, the first three flat olive squares, because at most four textures were kept and loading the fifth freed the least
    recently used). So the textures of a pass are held until the pass ends, a layout asks for textures only for the pictures near
    the view (D.draw's opts.view), and core/pages.lua lays the page out again when the reader scrolls to a picture it has no
    texture for.
]]

local gif = require('core/gif')
local fsave = require('core/fsave')

local pics = {}

local EXTRA = 2         -- textures of earlier passes kept: a picture the reader just opened is still open
local CAP = 48          -- textures one pass may hold: a window's worth of thumbnails, never a page of a hundred
local MAX = 512
local HOST = 'www.bg-wiki.com'

local dir, N, net = '', nil, nil
local tex = {}          -- file -> {h, w, h_px, used, pass}
local dimcache = {}     -- file -> {w, h_px}
local state = {}        -- file -> 'loading' | 'failed'
local queue, busy = {}, false
local tick = 0
local pass = 0
pics.on_ready = nil
pics.NO_GIF = nil       -- only the tests and qa_render set it (CR_QA_FAULT=nogif): a GIF handed to the renderer as it is, which cannot decode it
pics.TEX_DIMS = nil     -- only the tests set it (true = rule 100's fault: a loaded picture reports its texture's size, which the renderer scaled to 512 px, not the file's)
pics.fetches = 0        -- downloads made (tests: a cached picture makes none)
pics.clock = os.time    -- tests replace it
pics.STALL = 180        -- seconds without a sign of life before the download queue counts as dead (review CORE-16)
local refetched = {}    -- file -> true once a file that did not decode was deleted and fetched again (review CORE-3)
local runner = nil      -- the download coroutine's token; a new one replaces a dead one
local beat = 0          -- when the download coroutine last showed life
pics.rev = 0            -- see the header
local function bump() pics.rev = pics.rev + 1 end

function pics.setup(d, native, n)
    dir, N, net = d, native, n
end

-- a file name safe on disk
local function local_name(file)
    return dir .. 'data/pics/' .. file:gsub('[^%w%.%-_]', '_')
end
pics.local_name = local_name

local function exists(path)
    local f = io.open(path, 'rb')
    if f then f:close() return true end
    return false
end

local function urlencode(s)
    return (s:gsub(' ', '_'):gsub("[^%w_%-%.~'%(%)]", function(c) return string.format('%%%02X', c:byte()) end))
end

-- pics.LRU = 4: the old behaviour, at most that many textures, the least recently used freed when another is loaded, whether a layout
-- still names it or not. Only the tests set it (to see their check for a buffer naming a freed texture catch it).
pics.LRU = nil

local resident
local function free_lru()
    while pics.LRU and resident() >= pics.LRU do
        local oldest, of
        for f, t in pairs(tex) do
            if not oldest or t.used < oldest then oldest, of = t.used, f end
        end
        N.tex_free(tex[of].h)
        tex[of] = nil
        bump()
    end
end

-- The file the renderer can decode. It reads PNG, JPEG and BMP; a GIF (BG-wiki has pictures in no other format: adoulin 280's two floor
-- maps) is converted once, to a BMP beside it (core/gif.lua), and that is what is loaded. The converted file is written under a name of
-- its own and renamed into place, so two processes sharing data/pics (the gate's shards) never read a half-written one.
local function readable(path, yield)
    if pics.NO_GIF then return path end
    local f = io.open(path, 'rb')
    if not f then return path end
    local head = f:read(6)
    if head ~= 'GIF87a' and head ~= 'GIF89a' then f:close() return path end
    local out = path .. '.bmp'
    if exists(out) then f:close() return out end
    local bmp = gif.to_bmp(head .. (f:read('*a') or ''), yield)
    f:close()
    if not bmp then return path end
    local tmp = ('%s.%d.%d.tmp'):format(out, os.time(), math.floor(os.clock() * 1000000) % 1000000)
    local w = io.open(tmp, 'wb')
    if not w then return path end
    w:write(bmp)
    w:close()
    if not os.rename(tmp, out) then os.remove(tmp) end         -- the other process got there first
    return exists(out) and out or path
end
pics.readable = readable

local header_size, too_big        -- below
local queue_fetch                 -- below

-- A file on disk the renderer cannot decode is most likely cut short (a crash or a full disk while an older version wrote it
-- straight into place): it is deleted, with its converted BMP, and fetched again, once a session (review CORE-3).
-- -> true when a new download was queued
local function refetch(file)
    if pics.refetch_disabled or refetched[file] or not net then return false end   -- refetch_disabled: the QA harness has no live downloads
    refetched[file] = true
    local path = local_name(file)
    os.remove(path)
    os.remove(path .. '.bmp')
    dimcache[file] = nil
    queue_fetch(file)
    return true
end

local function load_tex(file)
    free_lru()
    if too_big(header_size(local_name(file))) then  -- before readable(): a GIF would be converted first
        state[file] = 'failed'
        bump()
        return nil
    end
    local h, w, hh = N.tex_load(readable(local_name(file)), MAX, MAX)
    bump()
    if not h then
        if not refetch(file) then state[file] = 'failed' end
        return nil
    end
    tick = tick + 1
    tex[file] = {h = h, w = w, h_px = hh, used = tick, pass = pass}
    return tex[file]
end

local function u16(s, i) return s:byte(i) * 256 + s:byte(i + 1) end
local function u32(s, i) return s:byte(i) * 16777216 + s:byte(i + 1) * 65536 + s:byte(i + 2) * 256 + s:byte(i + 3) end

-- Pictures over 16 megapixels are never decoded: the DLL decodes at full size before it scales down, so a small file that
-- declares 15000 x 15000 would ask the game for about 1.8 GB (review REND-1; nui 1.2.4 refuses them too). The largest
-- picture the pages use is 2133 x 2133 (4.5 MP).
local MAX_PIXELS = 16 * 1024 * 1024
too_big = function(w, h) return w ~= nil and h ~= nil and w * h > MAX_PIXELS end

-- the size of a picture file (PNG, GIF, JPEG) read from its header; nil for anything else
header_size = function(path)
    local f = io.open(path, 'rb')
    if not f then return nil end
    local head = f:read(24) or ''
    local w, h
    if head:sub(1, 8) == string.char(137, 80, 78, 71, 13, 10, 26, 10) and #head >= 24 then
        w, h = u32(head, 17), u32(head, 21)
    elseif head:sub(1, 3) == 'GIF' and #head >= 10 then
        w, h = head:byte(7) + head:byte(8) * 256, head:byte(9) + head:byte(10) * 256
    elseif head:byte(1) == 0xFF and head:byte(2) == 0xD8 then
        f:seek('set', 2)
        while true do
            local m = f:read(2)
            if not m or #m < 2 or m:byte(1) ~= 0xFF then break end
            local code = m:byte(2)
            while code == 0xFF do                                   -- fill bytes before a marker
                local c = f:read(1)
                if not c then code = nil break end
                code = c:byte()
            end
            if not code then break end
            if code == 0xD8 or code == 0x01 or (code >= 0xD0 and code <= 0xD7) then
                -- a marker with no length
            else
                local l = f:read(2)
                if not l or #l < 2 then break end
                if code >= 0xC0 and code <= 0xCF and code ~= 0xC4 and code ~= 0xC8 and code ~= 0xCC then
                    local d = f:read(5)
                    if d and #d == 5 then h, w = u16(d, 2), u16(d, 4) end
                    break
                end
                f:seek('cur', u16(l, 1) - 2)
            end
        end
    end
    f:close()
    if w and h and w > 0 and h > 0 then return w, h end
end

-- A picture's size without a texture. A layout needs the ratio of every picture on the page, in view or not, and a decode at MAX
-- would hold a texture for a picture nobody sees: the file's own header gives it; a format it does not know is decoded once and
-- the texture freed.
local function dims_of(file)
    local d = dimcache[file]
    if d then return d end
    local path = local_name(file)
    local w, h = header_size(path)
    if too_big(w, h) then
        state[file] = 'failed'
        bump()
        return 'failed'
    end
    if not w then
        local th, tw, thh = N.tex_load(readable(path), MAX, MAX)
        if not th then
            if refetch(file) then bump() return 'loading' end
            state[file] = 'failed'
            bump()
            return 'failed'
        end
        N.tex_free(th)
        w, h = tw, thh
    end
    d = {w = w, h_px = h}
    dimcache[file] = d
    bump()
    return d
end

local function ensure_dir()
    local f = io.open(dir .. 'data/pics/.keep', 'wb')
    if f then f:close() return end
    fsave.mkdir(dir .. 'data')  -- windower.create_dir, never a shell (review LIFE-12)
    fsave.mkdir(dir .. 'data/pics')
end

-- what a picture file starts with (PNG, GIF, JPEG, BMP: what BG-wiki serves and the renderer decodes); PNG and GIF end with a
-- trailer, so a cut one is caught even when the server sent no Content-Length
local PNG_SIG, PNG_END = string.char(137, 80, 78, 71, 13, 10, 26, 10), 'IEND' .. string.char(174, 66, 96, 130)
local function whole_picture(b)
    if b:sub(1, 8) == PNG_SIG then return b:find(PNG_END, #b - 11, true) ~= nil end
    if b:sub(1, 4) == 'GIF8' then return b:byte(#b) == 0x3B end
    if b:sub(1, 3) == string.char(0xFF, 0xD8, 0xFF) then return true end
    return b:sub(1, 2) == 'BM'
end
pics.whole_picture = whole_picture

-- one download; runs in a coroutine; never pcall around it (it sleeps)
local function fetch(file)
    local path = '/ffxi/Special:Redirect/file/' .. urlencode(file)
    local resp, err, kind
    for _ = 1, 4 do
        resp, err, kind = net.get(HOST, path, nil, 20)
        if not resp then break end
        if resp.status >= 300 and resp.status < 400 and resp.location then
            path = resp.location:match('^https?://[^/]+(/.*)') or resp.location
        else
            break
        end
    end
    pics.fetches = pics.fetches + 1
    if not resp then return false, err, kind end
    if resp.status ~= 200 or #resp.body < 64 then return false, resp.status end
    if not whole_picture(resp.body) then return false, 'not a whole picture' end
    -- written under a name of its own and renamed into place: a crash or a full disk never leaves a cut file that would stay
    -- blank for good (review CORE-3)
    ensure_dir()
    local ok, why = fsave.write(local_name(file), resp.body)
    if not ok then return false, why end
    -- a GIF is converted here, in the download coroutine, sleeping between pieces, rather than in a page layout (review CORE-10)
    if resp.body:sub(1, 4) == 'GIF8' and coroutine.running() and coroutine.sleep then
        readable(local_name(file), function() beat = pics.clock() coroutine.sleep(0) end)
    end
    return true
end

-- One download coroutine at a time. It cannot be wrapped in pcall (it sleeps), so an error in it would leave `busy` set and no
-- picture would download again that session (review CORE-16): on_ready (a whole page layout) is called under pcall, and a
-- coroutine with no sign of life for STALL seconds is taken as dead and replaced. A failed DNS lookup fails the whole queue:
-- every picture would wait on the same resolver (review CORE-4).
local function pump()
    if busy and pics.clock() - beat > pics.STALL then busy = false end
    if busy or #queue == 0 then return end
    busy = true
    beat = pics.clock()
    local me = {}
    runner = me
    coroutine.schedule(function()
        while #queue > 0 and runner == me do
            beat = pics.clock()
            local file = table.remove(queue, 1)
            local ok, _, kind = false, nil, nil
            if net and net.available then ok, _, kind = fetch(file) end
            beat = pics.clock()
            bump()
            if ok then
                state[file] = nil
                if pics.on_ready then pcall(pics.on_ready, file) end
            else
                state[file] = 'failed'
                if kind == 'dns' then
                    for _, f in ipairs(queue) do state[f] = 'failed' end
                    queue = {}
                end
            end
        end
        if runner == me then busy = false end
    end, 0)
end

queue_fetch = function(file)
    state[file] = 'loading'
    bump()
    queue[#queue + 1] = file
    pump()
end

resident = function()
    local n = 0
    for _ in pairs(tex) do n = n + 1 end
    return n
end
pics.resident = resident

-- The picture files known to be on disk (2026-10-22 perf pass): pics.get opened every out-of-view picture's file on every layout
-- (42 opens, about 2 ms a layout on jeuno 130). A file Chronicle has seen is not looked for again while its page is open (Chronicle
-- never deletes one; the cache goes with pics.release). Only "there" is remembered: a missing file is looked for each time, as before.
local known, known_n = {}, 0
local KNOWN_MAX = 4096
local function on_disk(file)
    if known[file] then return true end
    if not exists(local_name(file)) then return false end
    if known_n >= KNOWN_MAX then known, known_n = {}, 0 end
    known[file] = true
    known_n = known_n + 1
    return true
end
pics.KNOWN = true       -- false: look every time (the behaviour before; test/test_perf.lua)

function pics.get(file, want)
    local here = pics.KNOWN and on_disk or function(f) return exists(local_name(f)) end
    if want == false then
        if state[file] then return state[file] end
        local t0 = tex[file]
        if t0 and pics.TEX_DIMS then return {w = t0.w, h_px = t0.h_px} end
        if here(file) then return dims_of(file) end
        if t0 then return {w = t0.w, h_px = t0.h_px} end
        state[file] = 'loading'
        bump()
        queue[#queue + 1] = file
        pump()
        return 'loading'
    end
    local t = tex[file]
    if t then
        tick = tick + 1
        t.used = tick
        t.pass = pass
        return t
    end
    if state[file] then return state[file] end
    if here(file) then
        local n = 0
        for _, x in pairs(tex) do if x.pass == pass then n = n + 1 end end
        if n >= CAP then return dims_of(file) end
        return load_tex(file) or state[file] or 'failed'          -- 'loading' when it is being fetched again
    end
    state[file] = 'loading'
    bump()
    queue[#queue + 1] = file
    pump()
    return 'loading'
end

-- A page's layout is a pass: the textures it asks for are held until it ends. Then the ones it did not ask for are freed, all but
-- the EXTRA most recently used (a picture the reader has just opened).
function pics.begin_pass()
    pass = pass + 1
end

function pics.end_pass()
    local old = {}
    for f, t in pairs(tex) do
        if t.pass ~= pass then old[#old + 1] = f end
    end
    table.sort(old, function(a, c) return tex[a].used > tex[c].used end)
    for i = EXTRA + 1, #old do
        N.tex_free(tex[old[i]].h)
        tex[old[i]] = nil
        bump()
    end
end

-- the pictures the renderer could not decode (or that never arrived): tests and qa_render say so when a page's picture is among them
function pics.failed()
    local t = {}
    for f, st in pairs(state) do if st == 'failed' then t[#t + 1] = f end end
    table.sort(t)
    return t
end

-- the pictures still being fetched: the QA harness runs no downloads, so one left here after layout never arrives
function pics.loading()
    local t = {}
    for f, st in pairs(state) do if st == 'loading' then t[#t + 1] = f end end
    table.sort(t)
    return t
end

-- is this texture handle still held? (a buffer must never name a freed one)
function pics.live(h)
    for _, t in pairs(tex) do if t.h == h then return true end end
    return false
end

function pics.release()
    for _, t in pairs(tex) do N.tex_free(t.h) end
    tex = {}
    dimcache = {}
    known, known_n = {}, 0
    for f, s in pairs(state) do if s == 'failed' then state[f] = nil end end
    bump()
end

return pics

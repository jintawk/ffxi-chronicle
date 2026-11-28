--[[
    test/harness.lua - loads the real chronicle.lua in stock Lua 5.1 with a fake Windower (events,
    config library, packets, coroutine.schedule) and either a recording fake of _chronicle.dll or the
    real DLL. Used by test_screens.lua and the screen renderer.

        local H = dofile('test/harness.lua')
        local env = H.load({native = 'fake' | 'real', ffxi_dir = ..., player = 'Berrant'})
        env.fire('mouse', 0, x, y, 0, false) -> handler's return
        env.cmd('show')   env.run_scheduled()   env.packets(list)   env.chat   env.N (native)
]]

local H = {}

-- Windower's bit library, for core/data.lua
bit = bit or {
    band = function(a, b)
        local r, p = 0, 1
        while a > 0 and b > 0 do
            if a % 2 == 1 and b % 2 == 1 then r = r + p end
            a, b, p = math.floor(a / 2), math.floor(b / 2), p * 2
        end
        return r
    end,
    lshift = function(a, n) return a * 2 ^ n end,
}

-- The player's own files the addon writes (places, page state, the progress log; not the picture cache) go under H.DATA_DIR, a temp folder of this run's own (windower.chronicle_data_dir, read by
-- core/fsave.data_dir and core/progress.lua). A test never reads or writes a player's data/ folder, so a run that is killed,
-- or two runs at once, cannot lose anything. (Moving the player's files aside and back lost them twice on 2026-11-07.)
local function fresh_data_dir()
    local base = (os.getenv('TEMP') or os.getenv('TMP') or '.'):gsub('\\', '/')
    local id = ('%d_%d_%s'):format(os.time(), math.floor((os.clock() % 1) * 1000000), tostring({}):gsub('%W', ''))
    local d = base .. '/chronicle_testdata/' .. id .. '/'
    for _, sub in ipairs({'data', 'data/pics', 'data/progress'}) do
        os.execute(('mkdir "%s" >nul 2>&1'):format((d .. sub):gsub('/', '\\')))
    end
    return d
end
H.DATA_DIR = fresh_data_dir()
function H.data(rel) return H.DATA_DIR .. rel end         -- where 'data/<file>' of the addon is during this run

-- A fake _chronicle.dll: records what it is sent; parses the commands enough to catch broken lines.
function H.fake_native(opts)
    opts = opts or {}
    local N = {layers = {}, pos = {}, sent = {}, textures = {}, next_tex = 2, started = false, wt = 6, opts = opts,
               starts = 0, wintypes = 0, statuses = 0}
    local need = {W = 7, T = 5, H = 6, R = 6, Q = 12, I = 6, G = 7, C = 5, c = 1}
    function N.version() return '2.1.1' end
    -- opts.fail: start() fails with that message (and opts.retry_ms: retry after that many ms, as while the hook is missing)
    function N.start()
        N.starts = N.starts + 1
        if opts.fail then return false, opts.fail, opts.retry_ms end
        N.started = true
        return true, 'hooked'
    end
    function N.stop() N.started = false N.layers = {} return 'stopped' end
    function N.status()
        N.statuses = N.statuses + 1
        local n = 0
        for _ in pairs(N.layers) do n = n + 1 end
        return {version = '2.1.1', running = N.started, message = 'fake', hook = 'fake', layers = n, quads = 0,
                batches = 0, last_us = 0, max_us = 0, build_us = 0, uploads = 0, texture_kb = 0, cpu_pixels_kb = 0,
                vertex_kb = 0, pictures = 0, rt_w = 3840, rt_h = 2160, ui_found = opts.ui_w ~= nil,
                ui_w = opts.ui_w or 0, ui_h = opts.ui_h or 0, window_type = N.wt, drawing = opts.drawing,
                -- the asset log the DLL reports; a piece that could not be read says 'missing' in it
                assets = opts.assets}
    end
    function N.screen() return true end
    function N.layer(id, z, text)
        if z == nil then N.layers[id] = nil return true end
        local n = 0
        for line in (text .. '\n'):gmatch('([^\n]*)\n') do
            if line ~= '' then
                n = n + 1
                local f = 1
                for _ in line:gmatch('\t') do f = f + 1 end
                local k = line:sub(1, 1)
                if not need[k] or f < need[k] then error('bad command line: ' .. line) end
            end
        end
        N.layers[id] = {z = z, text = text}
        N.sent[id] = (N.sent[id] or 0) + 1
        return n
    end
    function N.layer_pos(id, ox, oy, x0, y0, x1, y1)
        if not N.layers[id] then return nil, 'no such layer' end
        N.pos[id] = {ox, oy, x0, y0, x1, y1}
        return true
    end
    function N.tex_load(path)
        local f = io.open(path, 'rb')
        if not f then return nil, 'cannot decode' end
        f:close()
        local h = N.next_tex
        N.next_tex = h + 1
        N.textures[h] = path
        return h, 64, 64
    end
    function N.tex_free(h) N.textures[h] = nil return true end
    function N.icon() return true end
    function N.metrics() return opts.metrics end
    function N.wintype(n) N.wt = n N.wintypes = N.wintypes + 1 return true end
    function N.wtread() return opts.game_type end
    function N.wtfind() return 0, {} end
    function N.wtwatch() return true end
    -- the controller (nui 1.3.0): N.padstate is what the game "read" (set its fields and bump seq), N.pad_holding the capture.
    -- opts.pad_fail: pad_start fails with that message (opts.pad_retry_ms: and asks to be retried); opts.pad_config: pad_config()
    N.padstate = {seq = 1, buttons = 0, lt = 0, rt = 0, lx = 0, ly = 0, rx = 0, ry = 0}
    N.pad_holding, N.pad_joined, N.captures, N.pad_starts = false, false, 0, 0
    function N.pad_start()
        N.pad_starts = N.pad_starts + 1
        if opts.pad_fail then return false, opts.pad_fail, opts.pad_retry_ms end
        N.pad_joined = true
        return true, 'hook installed'
    end
    function N.pad()
        if not N.pad_joined then return nil end
        local p = N.padstate
        return p.seq, p.buttons, p.lt, p.rt, p.lx, p.ly, p.rx, p.ry, 0, N.pad_holding
    end
    function N.pad_capture(on) N.pad_holding = on and true or false N.captures = N.captures + 1 return true end
    function N.pad_chord(b) N.chord = b return true end
    function N.pad_config() return opts.pad_config end
    function N.pad_status() return {state = 'live', describe = 'fake pad', reads = 0, holding = N.pad_holding} end
    function N.pad_stop() N.pad_joined, N.pad_holding = false, false return 'stopped' end
    return N
end

function H.load(opts)
    opts = opts or {}
    local here = (opts.dir or '.'):gsub('\\', '/')
    if here:sub(-1) ~= '/' then here = here .. '/' end
    local env = {events = {}, chat = {}, urls = {}, scheduled = {}, saves = 0}
    local now = 0
    env.clock = function() return now end
    env.advance = function(dt) now = now + dt end

    windower = {
        addon_path = here,
        chronicle_data_dir = opts.data_dir or H.DATA_DIR,
        windower_path = here .. '../../',
        register_event = function(name, fn)
            env.events[name] = env.events[name] or {}
            table.insert(env.events[name], fn)
        end,
        add_to_chat = function(col, s) env.chat[#env.chat + 1] = s end,
        -- ui_w/ui_h stand in for the game's UI scale: Windower reports the window in x_res and the UI it
        -- draws in it in ui_x_res, and the mouse event speaks UI px (core/nui.lua, nui.uiscale)
        get_windower_settings = function()
            local w, h = opts.screen_w or 3840, opts.screen_h or 2160
            return {x_res = w, y_res = h, ui_x_res = opts.ui_w or w, ui_y_res = opts.ui_h or h}
        end,
        open_url = function(u) env.urls[#env.urls + 1] = u end,
        ffxi = {
            get_player = function() return {name = opts.player or 'Berrant'} end,
            get_info = function() return {logged_in = opts.logged_in ~= false, zone = opts.zone or 0} end,
            get_items = function(bag) return (opts.items or {})[bag] or {} end,
            get_key_items = function() return opts.key_items or {} end,
        },
    }
    _addon = {}
    os.clock = env.clock
    coroutine.schedule = function(fn, t) env.scheduled[#env.scheduled + 1] = fn end

    package.preload['config'] = function()
        local config = {}
        -- opts.config_error: load() throws it, as the stock library does on a half-written settings.xml (the first
        -- opts.config_errors loads, default every one)
        local loads = 0
        function config.load(defaults)
            loads = loads + 1
            if opts.config_error and loads <= (opts.config_errors or 1e9) then error(opts.config_error) end
            local s = {}
            for k, v in pairs(defaults) do s[k] = v end
            for k, v in pairs(opts.settings or {}) do s[k] = v end
            function s.save() env.saves = env.saves + 1 end
            return s
        end
        function config.reload() env.reloads = (env.reloads or 0) + 1 end
        return config
    end
    package.preload['packets'] = function()
        return {parse = function(dir, p) return p end}
    end

    for k in pairs(package.loaded) do
        if k:find('^core/') or k:find('^ui/') or k:find('^maps/') or k == '_chronicle' or k == 'config' or k == 'packets' then package.loaded[k] = nil end
    end
    if opts.native == 'real' then
        package.preload['_chronicle'] = dofile(here .. 'test/crdll.lua').loader()      -- CR_DLL, else libs/_chronicle.dll by cpath
    else
        local fake = H.fake_native(opts.fake or {})
        package.preload['_chronicle'] = function() return fake end
        env.N = fake
        env.fake_opts = opts.fake or {}
    end

    CHRONICLE_TEST = {}
    local saved_path = package.path
    local chunk = assert(loadfile(here .. 'chronicle.lua'))
    chunk()
    package.path = saved_path
    if opts.native == 'real' then env.N = require('_chronicle') end
    env.app = CHRONICLE_TEST.app
    env.win = function() return env.app.win end

    function env.fire(name, ...)
        local r
        for _, fn in ipairs(env.events[name] or {}) do
            local x = fn(...)
            if x ~= nil then r = x end
        end
        return r
    end
    function env.cmd(...) return env.fire('addon command', ...) end
    function env.run_scheduled()
        local list = env.scheduled
        env.scheduled = {}
        for _, fn in ipairs(list) do fn() end
    end
    function env.packets(list)
        for _, p in ipairs(list) do env.fire('incoming chunk', 0x056, p) end
        env.run_scheduled()
    end
    function env.frame(dt)
        env.advance(dt or 1 / 60)
        env.fire('prerender')
    end
    return env
end

-- protect(paths) -> restore(): the files a test writes, by their name under the addon ('data/places_berrant.lua'), start
-- absent and are removed again by restore(). Only H.DATA_DIR is touched; the addon's own data/ folder never is.
function H.protect(paths)
    for _, p in ipairs(paths) do os.remove(H.data(p)) end
    return function()
        for _, p in ipairs(paths) do os.remove(H.data(p)) end
    end
end

-- The fixture packets of test_data.lua (deterministic), Berrant-like: CoP current = Three Paths.
function H.fixture_packets(cop)
    local seed = 12345
    local function rnd(n)
        -- seed * 1103515245 + 12345 mod 2^31, exact in doubles: the multiplier split at 2^16
        -- (16838 * 65536 + 20077) keeps every product below 2^46, so no FPU precision changes it
        local hi = (seed * 16838) % 32768
        seed = (hi * 65536 + seed * 20077 + 12345) % 2147483648
        return seed % n
    end
    local function flags(len)
        local b = {}
        for i = 1, len do b[i] = string.char(rnd(256)) end
        return table.concat(b)
    end
    local out = {}
    for _, t in ipairs({0x50, 0x58, 0x60, 0x68, 0x70, 0x78, 0x88, 0xE0, 0xF0, 0x100, 0x110, 0x120, 0x130,
                        0x90, 0x98, 0xA0, 0xA8, 0xB0, 0xB8, 0xC8, 0xE8, 0xF8, 0x108, 0x118, 0x128, 0x138, 0x30, 0x38}) do
        out[#out + 1] = {Type = t, ['Quest Flags'] = flags(128)}
    end
    out[#out + 1] = {Type = 0x80, ['Current TOAU Quests'] = flags(16), ['Current Assault Mission'] = 3,
        ['Current TOAU Mission'] = 20, ['Current WOTG Mission'] = 30, ['Current Campaign Mission'] = 5}
    out[#out + 1] = {Type = 0xC0, ['Completed TOAU Quests'] = flags(16), ['Completed Assaults'] = flags(16)}
    out[#out + 1] = {Type = 0xD0, ["Completed San d'Oria Missions"] = flags(8), ['Completed Bastok Missions'] = flags(8),
        ['Completed Windurst Missions'] = flags(8), ['Completed Zilart Missions'] = flags(8)}
    out[#out + 1] = {Type = 0xD8, ['Completed TOAU Missions'] = flags(16), ['Completed WOTG Missions'] = flags(16)}
    out[#out + 1] = {Type = 0xFFFE, ['Current TVR Mission'] = 12}
    out[#out + 1] = {Type = 0xFFFF, Nation = 1, ['Current Nation Mission'] = 7, ['Current ROZ Mission'] = 20,
        ['Current COP Mission'] = cop or 530, ['Current ACP Mission'] = 4, ['Current MKD Mission'] = 6,
        ['Current ASA Mission'] = 3, ['Current SOA Mission'] = 60, ['Current ROV Mission'] = 100}
    return out
end

-- Records of Eminence: the three packets that carry it, built by hand, so a test and a render
-- share one deterministic state. The pattern of completed records is arbitrary but fixed: enough
-- done to open the tree and to give every category a different percentage.
local function le32(v)
    return string.char(v % 256, math.floor(v / 256) % 256, math.floor(v / 65536) % 256,
                       math.floor(v / 16777216) % 256)
end
H.le32 = le32

function H.roe_110(sparks, deeds, bytes)
    local s = string.rep(' ', 4) .. le32(sparks or 0)
          .. string.char((deeds or 0) % 256, math.floor((deeds or 0) / 256) % 256, 0, 0)
    for i = 0, 7 do s = s .. string.char((bytes or {})[i] or 0) end
    return s
end

-- slots: {[slot index 0-63] = {id, count}}
function H.roe_111(slots)
    local s = string.rep(' ', 4)
    for i = 0, 63 do
        local e = (slots or {})[i]
        s = s .. le32(e and (e[1] + e[2] * 4096) or 0)
    end
    return s
end

-- one quarter of the ever-completed bitfield; ids outside it are ignored
function H.roe_112(quarter, ids)
    local b = {}
    for i = 1, 128 do b[i] = 0 end
    for _, id in ipairs(ids) do
        if math.floor(id / 1024) == quarter then
            local within = id % 1024
            local byte = math.floor(within / 8) + 1
            b[byte] = b[byte] + 2 ^ (within % 8)
        end
    end
    local s = string.rep(' ', 4)
    for i = 1, 128 do s = s .. string.char(b[i]) end
    return s .. string.char(quarter, 0, 0, 0)
end

function H.roe_061(unity)
    return string.rep(' ', 0x58) .. le32(unity or 0) .. string.rep(' ', 4)
end

-- The fixture state: records 1 and 5 (which open ten of the twelve categories) plus every third
-- id up to 1200, Unity 8, the Unity sets at rotation 0, and four slots with counts.
function H.roe_fixture()
    local done = {1, 5}
    for id = 3, 1200, 3 do done[#done + 1] = id end
    local out = {}
    for q = 0, 3 do out[#out + 1] = {0x112, H.roe_112(q, done)} end
    out[#out + 1] = {0x110, H.roe_110(99999, 7, {[0] = 0, [1] = 0})}
    out[#out + 1] = {0x111, H.roe_111({[0] = {16, 121}, [1] = {12, 79}, [2] = {57, 9},
                                       [3] = {137, 1}, [63] = {4018, 2}})}
    out[#out + 1] = {0x061, H.roe_061(8)}
    return out
end

function H.feed_roe(env)
    for _, p in ipairs(H.roe_fixture()) do env.fire('incoming chunk', p[1], p[2]) end
end

return H

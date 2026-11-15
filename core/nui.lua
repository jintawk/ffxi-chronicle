--[[
    Chronicle: the native layer (libs/_chronicle.dll, source plugin/).

    Loads the DLL fail-closed (nothing is drawn or consumed if it, the hook or a signature is
    missing), keeps the view scale (one Lua unit = f screen px: 1, the game's UI size, a simulated
    screen, times the size setting), and follows the game's window type (config id 18) four times a
    second unless a type is pinned.

        local nui = require('core/nui')
        nui.load(dir) -> ok, why          nui.start() -> ok, why [, retry_s]     nui.stop()
        nui.ok()                          -- running and drawing
        nui.N                             -- the DLL's table (nil when it did not load)
        nui.screen()                      -- logical screen w, h (Lua units)
        nui.set_scale(mode, w, h)         -- 'one' | 'ui' | 'sim' | 'auto' | 'off'
        nui.tick(on_type_change)          -- prerender
        nui.poll_drawing(now)             -- prerender: is the module drawing? (input is taken only then)
]]

local nui = {}

nui.N = nil
nui.error = nil
nui.running = false
nui.view = {mode = 'one', f = 1, size = 1, sim_w = nil, sim_h = nil, auto = true}
nui.wt = {follow = true, pinned = 6, type = 6, next_poll = 0, changes = 0, loaded = nil}
-- the module draws (status().drawing; a DLL without the field counts as drawing), read at most once a second (review LIFE-4)
nui.drawing = true
nui.next_draw_poll = 0

function nui.load(dir, name)
    package.cpath = dir .. 'libs/?.dll;' .. package.cpath
    local ok, mod = pcall(require, name)
    if ok and type(mod) == 'table' and type(mod.layer) == 'function' then
        nui.N = mod
        return true
    end
    nui.error = ok and 'the module did not return its table' or tostring(mod):match('^[^\r\n]+')
    return false, nui.error
end

function nui.screen_px()
    local ws = windower.get_windower_settings() or {}
    local w, h = ws.x_res or ws.ui_x_res or 0, ws.y_res or ws.ui_y_res or 0
    if w < 320 or h < 240 then
        -- A Windower that does not report the resolution: the game's own UI size, else a plain
        -- default. A zero screen leaves the window pinned in the corner at its smallest.
        local s = nui.N and nui.N.status()
        if s and s.ui_found and (s.ui_w or 0) >= 320 then w, h = s.ui_w, s.ui_h else w, h = 1920, 1080 end
    end
    return w, h
end

-- The logical screen, in Lua units.
function nui.screen()
    local w, h = nui.screen_px()
    return math.floor(w / nui.view.f), math.floor(h / nui.view.f)
end

local function base_f(v)
    local w = nui.screen_px()
    if v.mode == 'ui' then
        local s = nui.N and nui.N.status()
        if s and s.ui_found and s.ui_w > 0 then return w / s.ui_w end
        return nil, 'the game UI size was not found'
    elseif v.mode == 'sim' then
        if not (v.sim_w and v.sim_w >= 640) then return nil, 'scale sim <w> <h>, e.g. 2560 1440' end
        return w / v.sim_w
    end
    return 1
end

-- Recompute the view factor and hand it to the DLL. -> ok, why
function nui.apply()
    local v = nui.view
    local f, why = base_f(v)
    if not f then v.mode = 'one' f = 1 end
    f = f * (v.size or 1)
    if f < 0.25 or f > 4 then
        v.mode, v.size, f = 'one', 1, 1
        why = 'scale out of range: back to one'
    end
    v.f = f
    if nui.N then
        local w, h = nui.screen_px()
        nui.N.screen(w, h, v.auto, f)
    end
    return why == nil, why
end

function nui.set_scale(mode, a, b)
    local v = nui.view
    if mode == 'auto' or mode == 'off' then
        v.auto = mode == 'auto'
    elseif mode == 'sim' then
        v.mode, v.sim_w, v.sim_h = 'sim', tonumber(a), tonumber(b)
    elseif mode == 'one' or mode == 'ui' then
        v.mode = mode
    else
        return false, 'scale one | ui | sim <w> <h> | auto | off'
    end
    return nui.apply()
end

-- retry_s: the UI hook is not there yet (no module has found the game's EndScene wrapper); start
-- again after that many seconds. Without it the failure is final.
function nui.start(flags)
    if not nui.N then return false, '_chronicle.dll did not load: ' .. tostring(nui.error) end
    nui.apply()
    -- the window type's assets are loaded only when the type is not the one the DLL holds: a start that waits for the hook is
    -- retried, and each wintype() reads the type's art (review LIFE-1). The DLL keeps the type over a failed start or a stop.
    if nui.wt.loaded ~= nui.wt.type and nui.N.wintype(nui.wt.type) then nui.wt.loaded = nui.wt.type end
    local ok, msg, retry_ms = nui.N.start(nui.ffxi_dir or '', flags)       -- ffxi_dir: offline renders only
    nui.running = ok == true
    return nui.running, msg, (not nui.running and type(retry_ms) == 'number') and retry_ms / 1000 or nil
end

function nui.stop()
    nui.running = false
    if nui.N then return nui.N.stop() end
end

function nui.ok() return nui.running end

-- Draw in window type n. -> ok, why
function nui.set_type(n)
    if not nui.N then return false end
    local ok, err = nui.N.wintype(n)
    if not ok then return false, err end
    nui.wt.type, nui.wt.loaded = n, n
    nui.wt.changes = nui.wt.changes + 1
    return true
end

-- Follow the game's Config, or pin a type (nil = follow).
function nui.pin_type(n)
    nui.wt.follow = n == nil
    if n then
        nui.wt.pinned = n
        return nui.set_type(n)
    end
    local t = nui.N and nui.N.wtread()
    if t and t ~= nui.wt.type then return nui.set_type(t) end
    return t ~= nil, t == nil and 'the game window type cannot be read' or nil
end

-- prerender: whether the module is drawing (a failed atlas upload stops its draws until it is retried), asked of the DLL at
-- most once a second, never per event. -> drawing
function nui.poll_drawing(now)
    if now < nui.next_draw_poll then return nui.drawing end
    nui.next_draw_poll = now + 1
    local s = nui.running and nui.N and nui.N.status()
    nui.drawing = not (s and s.drawing == false)
    return nui.drawing
end

-- prerender: follow the game's window type; calls on_change() after a change.
function nui.tick(now, on_change)
    if not nui.running or not nui.wt.follow then return end
    if now < nui.wt.next_poll then return end
    nui.wt.next_poll = now + 0.25
    local t = nui.N.wtread()
    if t and t ~= nui.wt.type and nui.set_type(t) and on_change then on_change(t) end
end

return nui

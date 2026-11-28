--[[
    Chronicle: the controller, decoded. The raw state the DLL reports each frame (nui's pad(): buttons in
    XInput's bits, triggers, sticks) becomes actions for the window: a direction (D-pad or left stick, with
    auto-repeat), Confirm and Cancel (the player's own, from the game's pad config), and the rest of the
    layout. Pure: no Windower, no DLL, so the tests drive it with numbers.

        local pad = require('ui/pad')
        local d = pad.new()
        d:feed(now, buttons, lt, rt, lx, ly, rx, ry, out) -> out (a reused list of action names), scroll px
        d:latch(buttons)          -- buttons held now act only after they are released (taking the pad)
        d.confirm, d.cancel       -- 'a' / 'b' by default (pad.from_config swaps them for a B-confirm layout)

    Actions: up down left right confirm cancel tab_prev tab_next page_up page_down sort filter settings
    collapse top toggle (L3 + R3: take or give back the pad).
]]

local pad = {}

local B = {
    up = 0x0001, down = 0x0002, left = 0x0004, right = 0x0008, start = 0x0010, back = 0x0020,
    l3 = 0x0040, r3 = 0x0080, lb = 0x0100, rb = 0x0200, a = 0x1000, b = 0x2000, x = 0x4000, y = 0x8000,
    lt = 0x10000, rt = 0x20000,
}
pad.B = B
pad.CHORD = B.l3 + B.r3

pad.REPEAT_DELAY = 0.35      -- a held direction repeats after this
pad.REPEAT_EVERY = 0.07      -- and then this often
pad.STICK_ON = 16384         -- the left stick is a direction past half way ...
pad.STICK_OFF = 11469        -- ... until it comes back inside 35%
pad.SCROLL_DEAD = 0.2        -- the right stick scrolls past 20%
pad.SCROLL_MAX = 1600        -- px a second at full deflection (the speed grows with the square)

-- the face buttons by name: what XInput calls them, and the game's button ids in padsin000
pad.NAMES = {a = 'A', b = 'B', x = 'X', y = 'Y'}
local XID = {[0] = 'b', [1] = 'x', [2] = 'y', [3] = 'a'}

local band = function(a, b)          -- Lua 5.1 has no bit operators; Windower's bit library when present
    if bit and bit.band then return bit.band(a, b) end
    local r, p = 0, 1
    while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then r = r + p end
        a, b, p = math.floor(a / 2), math.floor(b / 2), p * 2
    end
    return r
end
pad.band = band

local function has(buttons, mask) return band(buttons, mask) ~= 0 end

-- The game's own Confirm and Cancel, from its pad settings (nui's pad_config(): padmode000, padsin000). In
-- XInput mode slot 7 is Confirm and slot 5 Cancel, as button ids (0 B, 1 X, 2 Y, 3 A). -> confirm, cancel
-- ('a', 'b' unless the game says otherwise), and whether the game's XInput mode is on (nil: unknown)
function pad.from_config(cfg)
    if type(cfg) ~= 'table' then return 'a', 'b', nil end
    local mode, sin = {}, {}
    for n in tostring(cfg.padmode or ''):gmatch('-?%d+') do mode[#mode + 1] = tonumber(n) end
    for n in tostring(cfg.padsin or ''):gmatch('-?%d+') do sin[#sin + 1] = tonumber(n) end
    local xinput = mode[6] and mode[6] ~= 0 or nil
    if mode[6] == 0 then xinput = false end
    local confirm, cancel = XID[sin[8]], XID[sin[6]]
    if xinput and confirm and cancel and confirm ~= cancel then return confirm, cancel, xinput end
    return 'a', 'b', xinput
end

-- The game's use of L3 and R3 (padsin000 ids 10 and 13 in XInput mode): the slots that would also act
-- on the chord, by index (0-based, as the game's config documents them). -> list, empty when free
function pad.chord_conflicts(cfg)
    local out = {}
    if type(cfg) ~= 'table' then return out end
    local i = 0
    for n in tostring(cfg.padsin or ''):gmatch('-?%d+') do
        local v = tonumber(n)
        if v == 10 or v == 13 then out[#out + 1] = i end
        i = i + 1
    end
    return out
end

local D = {}
D.__index = D

function pad.new()
    return setmetatable({
        prev = 0,                     -- the buttons (with the left stick folded in as a direction) last frame
        latched = 0,                  -- held when the pad was taken: ignored until released
        dir = nil, next_at = 0,       -- the direction held, and when it repeats
        stick = nil,                  -- the direction the left stick holds (with hysteresis)
        last = nil,                   -- the time of the last feed
        r3_alone = false,             -- R3 went down without L3: Top on its release
        confirm = 'a', cancel = 'b',
    }, D)
end

-- the left stick as a direction, with hysteresis (on past STICK_ON, off inside STICK_OFF)
local function stick_dir(self, lx, ly)
    local ax, ay = math.abs(lx), math.abs(ly)
    local held = self.stick
    if held then
        local v = (held == 'left' or held == 'right') and ax or ay
        if v >= pad.STICK_OFF then
            -- still held, unless the other axis is now clearly the stronger
            if math.max(ax, ay) < pad.STICK_ON or v == math.max(ax, ay) then return held end
        end
    end
    if math.max(ax, ay) < pad.STICK_ON then return nil end
    if ax > ay then return lx > 0 and 'right' or 'left' end
    return ly > 0 and 'up' or 'down'      -- XInput: up is positive
end

function D:latch(buttons)
    self.latched = buttons or self.prev
    self.dir, self.r3_alone = nil, false
end

local FACE = {'a', 'b', 'x', 'y'}
local OTHER = {x = 'sort', y = 'filter', a = 'sort', b = 'filter'}   -- a or b only when Confirm / Cancel are elsewhere
local DIRS = {'up', 'down', 'left', 'right'}

-- One frame. -> out (cleared and refilled), scroll (px to scroll this frame, + is down)
function D:feed(now, buttons, lt, rt, lx, ly, rx, ry, out)
    out = out or {}
    for i = #out, 1, -1 do out[i] = nil end
    buttons = buttons or 0
    local dt = self.last and math.max(0, math.min(0.1, now - self.last)) or 0
    self.last = now
    -- nothing held, nothing changed: the frame costs nothing (no closures, no tables)
    if buttons == 0 and self.prev == 0 and not self.dir and self.latched == 0 and not self.r3_alone
        and math.abs(lx or 0) < pad.STICK_OFF and math.abs(ly or 0) < pad.STICK_OFF
        and math.abs(ry or 0) <= pad.SCROLL_DEAD * 32767 then
        self.stick = nil
        return out, 0
    end
    -- a latched button is ignored until it is released
    if self.latched ~= 0 then
        local still = 0
        for _, m in pairs(B) do if has(self.latched, m) and has(buttons, m) then still = still + m end end
        self.latched = still
    end
    local live = buttons - band(buttons, self.latched)
    local prev = self.prev
    local function down(m) return has(live, m) and not has(prev, m) end
    local function up(m) return not has(buttons, m) and has(prev, m) end

    -- the chord first: both stick buttons; their own actions wait for it
    if has(live, pad.CHORD) and pad.CHORD == band(live, pad.CHORD) and (down(B.l3) or down(B.r3)) then
        out[#out + 1] = 'toggle'
        self.r3_alone = false
    elseif down(B.r3) and not has(live, B.l3) then
        self.r3_alone = true
    elseif self.r3_alone and up(B.r3) then
        self.r3_alone = false
        out[#out + 1] = 'top'
    end
    if has(live, B.l3) then self.r3_alone = false end

    -- buttons: on press
    for _, f in ipairs(FACE) do
        if down(B[f]) then
            out[#out + 1] = (f == self.confirm and 'confirm') or (f == self.cancel and 'cancel') or OTHER[f]
        end
    end
    if down(B.lb) then out[#out + 1] = 'tab_prev' end
    if down(B.rb) then out[#out + 1] = 'tab_next' end
    if down(B.lt) then out[#out + 1] = 'page_up' end
    if down(B.rt) then out[#out + 1] = 'page_down' end
    if down(B.start) then out[#out + 1] = 'settings' end
    if down(B.back) then out[#out + 1] = 'collapse' end

    -- a direction: the D-pad, else the left stick; one at a time, repeating while held
    self.stick = stick_dir(self, lx or 0, ly or 0)
    local dir
    for _, d in ipairs(DIRS) do
        if has(live, B[d]) then dir = d break end
    end
    if not dir and self.stick and not has(self.latched, B.up + B.down + B.left + B.right) then dir = self.stick end
    if dir ~= self.dir then
        self.dir = dir
        if dir then
            out[#out + 1] = dir
            self.next_at = now + pad.REPEAT_DELAY
        end
    elseif dir and now >= self.next_at then
        out[#out + 1] = dir
        self.next_at = now + pad.REPEAT_EVERY
    end

    self.prev = buttons
    -- the right stick scrolls: speed by the square of the deflection past the dead zone
    local v = (ry or 0) / 32767
    local scroll = 0
    local a = math.abs(v)
    if a > pad.SCROLL_DEAD then
        local k = (math.min(1, a) - pad.SCROLL_DEAD) / (1 - pad.SCROLL_DEAD)
        scroll = (v > 0 and -1 or 1) * k * k * pad.SCROLL_MAX * dt       -- stick up scrolls up
    end
    return out, scroll
end

-- What the hint line calls Confirm and Cancel
function D:labels() return pad.NAMES[self.confirm] or 'A', pad.NAMES[self.cancel] or 'B' end

return pad

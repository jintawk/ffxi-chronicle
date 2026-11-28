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
        d:set_chord(mask)         -- the two buttons that take and give back the pad (pad.CHORD, L3 + R3, by default)
        pad.parse_chord(name)     -- 'l3+r3', 'lb+rb', 'back+start' -> {mask, name, label, a, b}, or nil and why

    Actions: up down left right confirm cancel tab_prev tab_next page_up page_down sort filter settings
    collapse top toggle (the chord: take or give back the pad).
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

-- The chord's buttons by name, in the order a chord's name and label give them. The D-pad moves the cursor, so it is never
-- a chord button. Nor are the triggers: nui's hook holds a chord button back from the game by hiding it in the button word
-- (PadHook.h, apply_mask: hide and force touch only the low 16 bits), and a trigger is not in that word, so the game would
-- see a trigger go down before its partner came. The Guide button is not in what XInputGetState reports.
local CHORD_ORDER = {'l3', 'r3', 'lb', 'rb', 'back', 'start', 'a', 'b', 'x', 'y'}
local CHORD_LABEL = {l3 = 'L3', r3 = 'R3', lb = 'LB', rb = 'RB', back = 'Back', start = 'Start',
                     a = 'A', b = 'B', x = 'X', y = 'Y', lt = 'LT', rt = 'RT',
                     up = 'Up', down = 'Down', left = 'Left', right = 'Right'}
local CHORD_ALIAS = {ls = 'l3', rs = 'r3', select = 'back', view = 'back', menu = 'start',
                     l1 = 'lb', r1 = 'rb', l2 = 'lt', r2 = 'rt'}
local CHORD_RANK = {}
for i, n in ipairs(CHORD_ORDER) do CHORD_RANK[n] = i end
pad.CHORD_LABEL = CHORD_LABEL

-- A chord by name: two buttons joined by '+' ('l3+r3', 'LB + RB', 'start+back'). -> {mask, name ('l3+r3', in a fixed order),
-- label ('L3+R3'), a, b (the two bits)}, or nil and why
function pad.parse_chord(name)
    local s = tostring(name or ''):lower():gsub('%s+', '')
    local parts = {}
    for p in (s .. '+'):gmatch('([^+]*)%+') do parts[#parts + 1] = CHORD_ALIAS[p] or p end
    if #parts ~= 2 or parts[1] == '' or parts[2] == '' then
        return nil, 'a chord is two buttons joined by +, for example l3+r3'
    end
    for _, p in ipairs(parts) do
        if not B[p] then return nil, 'not a button name: ' .. p end
        if p == 'up' or p == 'down' or p == 'left' or p == 'right' then
            return nil, 'the D-pad (' .. CHORD_LABEL[p] .. ') moves the cursor, so it cannot be in the chord'
        end
        if p == 'lt' or p == 'rt' then
            return nil, 'a trigger (' .. CHORD_LABEL[p] .. ') cannot be in the chord: the game would see it before its partner'
        end
    end
    if parts[1] == parts[2] then return nil, 'a chord is two different buttons' end
    table.sort(parts, function(x, y) return CHORD_RANK[x] < CHORD_RANK[y] end)
    return {mask = B[parts[1]] + B[parts[2]], a = B[parts[1]], b = B[parts[2]], name = parts[1] .. '+' .. parts[2],
            label = CHORD_LABEL[parts[1]] .. '+' .. CHORD_LABEL[parts[2]]}
end

-- the buttons held, as a chord name for pad.parse_chord (any number of buttons: the parser says what is wrong)
function pad.chord_name(buttons)
    local names = {}
    for _, n in ipairs({'l3', 'r3', 'lb', 'rb', 'lt', 'rt', 'back', 'start', 'a', 'b', 'x', 'y', 'up', 'down', 'left', 'right'}) do
        if has(buttons, B[n]) then names[#names + 1] = n end
    end
    return table.concat(names, '+')
end

-- how many buttons are held (the triggers count)
function pad.count(buttons)
    local n = 0
    for _, m in pairs(B) do if has(buttons, m) then n = n + 1 end end
    return n
end

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

-- The game's button ids in padsin000 (XInput mode), where they are known (docs/controller-support.md §3): 0 B, 1 X, 2 Y,
-- 3 A, 10 L3, 13 R3. LB, RB, Start and Back have ids too, but nobody has confirmed them, so a chord with them is not checked.
local SIN_ID = {[B.b] = 0, [B.x] = 1, [B.y] = 2, [B.a] = 3, [B.l3] = 10, [B.r3] = 13}

-- The game's use of the chord's buttons (L3 and R3 by default): the padsin000 slots that would also act on the chord, by
-- index (0-based, as the game's config documents them). -> list, empty when free (or when no button's id is known)
function pad.chord_conflicts(cfg, mask)
    local out = {}
    if type(cfg) ~= 'table' then return out end
    mask = mask or pad.CHORD
    local ids = {}
    for bit_, id in pairs(SIN_ID) do if has(mask, bit_) then ids[id] = true end end
    local i = 0
    for n in tostring(cfg.padsin or ''):gmatch('-?%d+') do
        if ids[tonumber(n)] then out[#out + 1] = i end
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
        alone = 0,                    -- a chord button that went down without its partner: its action on release
        chord = pad.CHORD, ca = B.l3, cb = B.r3,     -- the chord, and its two buttons
        confirm = 'a', cancel = 'b',
    }, D)
end

-- the chord's two buttons (mask: two bits of pad.B)
function D:set_chord(mask)
    mask = mask or pad.CHORD
    local a, b
    for _, n in ipairs(CHORD_ORDER) do
        if has(mask, B[n]) then if a then b = B[n] else a = B[n] end end
    end
    if not (a and b) then a, b, mask = B.l3, B.r3, pad.CHORD end
    self.chord, self.ca, self.cb, self.alone = mask, a, b, 0
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
    self.dir, self.alone = nil, 0
end

local FACE = {'a', 'b', 'x', 'y'}
local OTHER = {x = 'sort', y = 'filter', a = 'sort', b = 'filter'}   -- a or b only when Confirm / Cancel are elsewhere
local DIRS = {'up', 'down', 'left', 'right'}
local PRESS = {lb = 'tab_prev', rb = 'tab_next', lt = 'page_up', rt = 'page_down', start = 'settings', back = 'collapse'}

-- what a button does on its own (nil: nothing, as L3)
local function action_of(self, bit_)
    for _, f in ipairs(FACE) do
        if bit_ == B[f] then return (f == self.confirm and 'confirm') or (f == self.cancel and 'cancel') or OTHER[f] end
    end
    if bit_ == B.r3 then return 'top' end
    for n, a in pairs(PRESS) do if bit_ == B[n] then return a end end
    return nil
end

-- One frame. -> out (cleared and refilled), scroll (px to scroll this frame, + is down)
function D:feed(now, buttons, lt, rt, lx, ly, rx, ry, out)
    out = out or {}
    for i = #out, 1, -1 do out[i] = nil end
    buttons = buttons or 0
    local dt = self.last and math.max(0, math.min(0.1, now - self.last)) or 0
    self.last = now
    -- nothing held, nothing changed: the frame costs nothing (no closures, no tables)
    if buttons == 0 and self.prev == 0 and not self.dir and self.latched == 0 and self.alone == 0
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

    -- the chord first (L3 + R3 by default). Its buttons' own actions wait for it: a chord button alone acts on its release
    -- (R3 alone is Top), and not at all once its partner is held
    local C, ca, cb = self.chord, self.ca, self.cb
    if band(live, C) == C and (down(ca) or down(cb)) then
        out[#out + 1] = 'toggle'
        self.alone = 0
    elseif self.alone == 0 and down(cb) and not has(live, ca) then
        self.alone = cb
    elseif self.alone == 0 and down(ca) and not has(live, cb) then
        self.alone = ca
    elseif self.alone ~= 0 and up(self.alone) then
        local a = action_of(self, self.alone)
        self.alone = 0
        if a then out[#out + 1] = a end
    end
    if self.alone ~= 0 and has(live, C - self.alone) then self.alone = 0 end

    -- buttons: on press (a chord button: above); R3 out of the chord is Top on press
    for _, f in ipairs(FACE) do
        if down(B[f]) and not has(C, B[f]) then out[#out + 1] = action_of(self, B[f]) end
    end
    if down(B.lb) and not has(C, B.lb) then out[#out + 1] = 'tab_prev' end
    if down(B.rb) and not has(C, B.rb) then out[#out + 1] = 'tab_next' end
    if down(B.lt) then out[#out + 1] = 'page_up' end
    if down(B.rt) then out[#out + 1] = 'page_down' end
    if down(B.start) and not has(C, B.start) then out[#out + 1] = 'settings' end
    if down(B.back) and not has(C, B.back) then out[#out + 1] = 'collapse' end
    if down(B.r3) and not has(C, B.r3) then out[#out + 1] = 'top' end

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

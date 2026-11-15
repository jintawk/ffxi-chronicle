--[[
    Chronicle: the three incoming packets that carry Records of Eminence state.

    Every zone-in the client asks for the lot and the server answers with all three; after that
    0x111 arrives in real time (every kill, every accept, every drop) and 0x110 whenever Sparks
    change, while 0x112 is sent on zone-in only.

        IN 0x110   20 bytes    Sparks, Deeds, and the eight gate bytes the client's own
                               visibility rules read
        IN 0x111  260 bytes    the active objective slots: 64 records of a 12-bit id and a
                               20-bit progress count
        IN 0x112  136 bytes    the ever-completed bitfield, a quarter at a time: 128 bytes of
                               bits plus the quarter's index, covering ids 0-4095
        IN 0x061               not an RoE packet, but it carries the player's Unity, which the
                               client's Unity visibility gate reads

    Everything is parsed here rather than through the packet library, because that library's
    0x111 declares 30 of the packet's 64 slots and calls the other 34 junk, and its 0x110 stops
    four bytes short of the end and has the gate bytes in the wrong place.

    No bit library: Lua numbers hold these exactly, and the arithmetic runs in the test harness
    unchanged.

        local P = require('core/roe_packets')
        P.parse_0x110(data) -> {sparks =, deeds =, bytes = {[0]=..,[7]}}
        P.parse_0x111(data) -> {slots = {{id =, count =, kind =}, ...}}
        P.parse_0x112(data) -> {quarter = 0..3, bits = '<128 bytes>'}
        P.parse_0x061(data) -> {unity =}
        P.bitfield()        -> a 512-byte accumulator for the four quarters of 0x112
]]

local P = {}

-- Windower hands the whole chunk over, header included: the body starts at byte 5 (1-based).
local function u8(s, off) return s:byte(off + 1) or 0 end
local function u16(s, off) return u8(s, off) + u8(s, off + 1) * 256 end
local function u32(s, off)
    return u8(s, off) + u8(s, off + 1) * 256 + u8(s, off + 2) * 65536 + u8(s, off + 3) * 16777216
end
P.u8, P.u16, P.u32 = u8, u16, u32

---------------------------------------------------------------------------
-- 0x110: Sparks, Deeds, and the gate byte table
---------------------------------------------------------------------------

-- The eight bytes at +0x0C are what the client's `pkt110_byte_equals` visibility requirement
-- reads, by index: 0 is which of the six Unity (Shared) sets is being offered this month, 1
-- which of the four the player's own Unity leader is offering. The other six have never been
-- seen used by a requirement; they are kept so a game update that starts using one needs no
-- change here.
P.GATE_BYTES = 8
P.GATE_UNITY_SHARED, P.GATE_UNITY_LEADER = 0, 1

function P.parse_0x110(data)
    if not data or #data < 0x14 then return nil end
    local bytes = {}
    for i = 0, P.GATE_BYTES - 1 do bytes[i] = u8(data, 0x0C + i) end
    return {
        -- Sparks is 24 bit; the top byte of the word is unused
        sparks = u32(data, 0x04) % 0x1000000,
        deeds = u16(data, 0x08),
        bytes = bytes,
    }
end

---------------------------------------------------------------------------
-- 0x111: the active objectives
---------------------------------------------------------------------------

-- All 64 slots, by what the client does with each (the window draws the first 30). The last is
-- the limited-time challenge; 'other' is the block whose purpose is not confirmed, carried so a
-- capture can settle it without a change here.
P.SLOTS = 64
local function slot_kind(i)
    if i < 30 then return 'active' end
    if i < 42 then return 'extra' end
    if i == 42 then return 'special' end
    if i < 63 then return 'other' end
    return 'limited'
end
P.slot_kind = slot_kind

function P.parse_0x111(data)
    if not data or #data < 0x104 then return nil end
    local slots = {}
    for i = 0, P.SLOTS - 1 do
        local v = u32(data, 0x04 + i * 4)
        local id = v % 4096
        if id ~= 0 then
            slots[#slots + 1] = {id = id, count = math.floor(v / 4096), slot = i, kind = slot_kind(i)}
        end
    end
    return {slots = slots}
end

---------------------------------------------------------------------------
-- 0x112: the ever-completed bitfield
---------------------------------------------------------------------------

P.BITS_BYTES = 128                      -- a quarter
P.QUARTERS = 4
P.MAX_ID = P.BITS_BYTES * P.QUARTERS * 8 - 1    -- 4095

function P.parse_0x112(data)
    if not data or #data < 0x88 then return nil end
    local quarter = u16(data, 0x84)
    if quarter >= P.QUARTERS then return nil end
    return {quarter = quarter, bits = data:sub(0x04 + 1, 0x04 + P.BITS_BYTES)}
end

-- An accumulator for the four quarters. The server sends them in no guaranteed order and sends
-- them again on every zone, so each quarter is simply stored where its index says; `complete`
-- reports whether all four have arrived at least once.
local Bits = {}
Bits.__index = Bits

function P.bitfield()
    local b = setmetatable({parts = {}, seen = 0}, Bits)
    return b
end

function Bits:put(p)
    if not p then return false end
    if self.parts[p.quarter] == nil then self.seen = self.seen + 1 end
    local changed = self.parts[p.quarter] ~= p.bits
    self.parts[p.quarter] = p.bits
    return changed
end

function Bits:complete() return self.seen >= P.QUARTERS end

-- Is the record ever-completed? Bit `id` of the concatenated 512 bytes, least significant bit
-- of each byte first.
function Bits:has(id)
    if type(id) ~= 'number' or id < 0 or id > P.MAX_ID then return false end
    local part = self.parts[math.floor(id / (P.BITS_BYTES * 8))]
    if not part then return false end
    local within = id % (P.BITS_BYTES * 8)
    local byte = part:byte(math.floor(within / 8) + 1)
    if not byte then return false end
    return math.floor(byte / 2 ^ (within % 8)) % 2 == 1
end

-- How many records are marked completed (the in-game "Number Completed" counter counts a
-- subset of these; this counts every bit, hidden trackers included).
function Bits:count()
    local n = 0
    for _, part in pairs(self.parts) do
        for i = 1, #part do
            local b = part:byte(i)
            while b > 0 do
                n = n + b % 2
                b = math.floor(b / 2)
            end
        end
    end
    return n
end

function Bits:reset() self.parts, self.seen = {}, 0 end

---------------------------------------------------------------------------
-- 0x061: the player's Unity
---------------------------------------------------------------------------

-- The client's Unity visibility requirement compares against the low five bits of the word at
-- +0x58 of the character-stats packet, not against anything in 0x110. 0 is no Unity.
function P.parse_0x061(data)
    if not data or #data < 0x5C then return nil end
    return {unity = u32(data, 0x58) % 32}
end

return P

-- test_mission_words.lua: the mission words of packet 0x056 that are more than one id.
--
--   cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_mission_words.lua
--
-- Rule 104: while CoP is at 530 (Three Paths) the paths come from the progress word at 0xFFFF +0x14
-- (Windower _unknown1, XiPackets Expansion_CoP2), nibbles 2-4. TVR: the client reads 0xFFFE's word as
-- value & 0xEFFF, bit 31 = no active mission, 999 = the original line finished. Recorded words from
-- a packet capture of 2026-04-02: CoP2 0x3FBEEEEE at CoP 850, TVR 0x800001CC.

local pass, fail = 0, 0
local function check(cond, what)
    if cond then pass = pass + 1 else fail = fail + 1; print('FAIL ' .. what) end
end

bit = bit or {band = function(a, b)
    local r, p = 0, 1
    while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then r = r + p end
        a, b, p = math.floor(a / 2), math.floor(b / 2), p * 2
    end
    return r
end, lshift = function(a, n) return a * 2 ^ n end}

windower = {
    add_to_chat = function() end,
    ffxi = {get_items = function() return {} end, get_key_items = function() return {} end},
}

package.path = './?.lua;' .. package.path

local function fresh()
    for k in pairs(package.loaded) do
        if k:find('^maps/') or k:find('^core/') then package.loaded[k] = nil end
    end
    return require('core/data')
end

-- signed 32-bit, as Windower's 'int' fields arrive
local function s32(v) return v >= 2147483648 and v - 4294967296 or v end

local function statuses(d, area)
    local out = {}
    for _, it in ipairs(d.get_area_status('mission', area).items) do out[it.id] = it.status end
    return out
end

local function cop(word, cop_val)
    local d = fresh()
    d.parse_packet({Type = 0xFFFF, Nation = 0, ['Current Nation Mission'] = 0, ['Current ROZ Mission'] = 0,
        ['Current COP Mission'] = cop_val, _unknown1 = word and s32(word), ['Current ACP Mission'] = 0,
        ['Current MKD Mission'] = 0, ['Current ASA Mission'] = 0, ['Current SOA Mission'] = 0, ['Current ROV Mission'] = 0})
    local s = statuses(d, 'cop')
    return {s[540], s[550], s[560]}, s
end

local function same(got, want, what)
    check(got[1] == want[1] and got[2] == want[2] and got[3] == want[3],
        what .. ': got ' .. table.concat(got, ',') .. ' want ' .. table.concat(want, ','))
end

-- Three Paths: each path's last sub-mission is 549, 559, 568 (offsets 9, 9, 8)
same(cop(0x00000000, 530), {'active', 'active', 'active'}, 'all paths at their first step')
same(cop(0x00012300, 530), {'active', 'active', 'active'}, 'mid paths 3, 2, 1')
same(cop(0x00099900, 530), {'completed', 'completed', 'completed'}, 'every path at 9')
same(cop(0x0008E900, 530), {'completed', 'completed', 'completed'}, 'Tenzen 14 clamps to 9, Ulmia 8 is its last')
same(cop(0x00079E00, 530), {'completed', 'completed', 'active'}, 'Louverance 14, Tenzen 9, Ulmia 7')
same(cop(0x000BC300, 530), {'active', 'completed', 'completed'}, 'nibbles 11 and 12 clamp to 9')
same(cop(nil, 530), {'active', 'active', 'active'}, 'no word yet: paths active')
same(cop(0x3FBEEEEE, 850), {'completed', 'completed', 'completed'}, 'recorded word, storyline finished')
same(cop(0x00099900, 520), {'not_started', 'not_started', 'not_started'}, 'before Three Paths the word means nothing')
local _, s = cop(0x00099900, 530)
check(s[530] == 'active', 'Three Paths itself stays active at 530 (got ' .. tostring(s[530]) .. ')')
check(s[568] == nil, 'Flames for the Dead stays hidden under rule 104')

-- the rule-104 switch off: the v1 list (paths hidden) whatever the word says
local d = fresh()
d.COP_PATHS = false
d.parse_packet({Type = 0xFFFF, Nation = 0, ['Current COP Mission'] = 530, _unknown1 = 0x00099900})
local off = statuses(d, 'cop')
check(off[540] == nil and off[550] == nil and off[560] == nil, 'rule 104 off: the paths are hidden')

-- TVR
local function tvr(word)
    local d = fresh()
    d.parse_packet({Type = 0xFFFE, ['Current TVR Mission'] = s32(word)})
    return statuses(d, 'tvr')
end
local t = tvr(0x800001CC)
check(t[452] == 'completed' and t[460] == 'not_started', 'recorded 0x800001CC: 452 done, 460 next, none active')
t = tvr(454)
check(t[452] == 'active' and t[460] == 'not_started', '454: 452 active')
t = tvr(0x000011CC)
check(t[460] == 'active' and t[452] == 'completed', 'bit 12 masked: 0x11CC reads as 460')
t = tvr(0x00FF01CC)
check(t[460] == 'active', 'bits 16-23 masked: reads as 460')
t = tvr(999)
local all = true
for id, st in pairs(t) do if st ~= 'completed' then all = false print('  999: ' .. id .. ' ' .. st) end end
check(all, '999: every TVR mission completed')

print(('test_mission_words: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)

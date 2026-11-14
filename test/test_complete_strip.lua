-- test_complete_strip.lua: an entry the card shows COMPLETED shows every step of its strip done.
--
--   cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_complete_strip.lua
--
-- Real core/data and core/progress with the real mappings. A character who has finished everything: every quest completed bit
-- set, no quest current, every mission line far past its end. For every mapped entry the card shows completed (and that is not a
-- repeatable quest), P.summary must say done == total, and the page must show no step to do.
--
-- The two cases that shipped broken (2026-11-09): CoP 638 One to be Feared read 0/4 (CoP's line has no completed set, and 31 of
-- the 34 CoP mappings waited for one), ACP 6 Those Who Lurk in Shadows (III) read 2/3 (its post step, the Ivory Key use, stayed
-- open in the count).

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

local tmp = (os.getenv('TEMP') or '.') .. '/cr_complete_strip_test/'
os.execute('mkdir "' .. tmp:gsub('/', '\\') .. 'data\\progress" 2>nul')
windower = {
    addon_path = './',
    chronicle_data_dir = tmp,         -- the player's files go to the temp folder, never data/
    create_dir = function() end,
    add_to_chat = function() end,
    ffxi = {get_items = function() return {} end, get_key_items = function() return {} end},
}
package.path = './?.lua;' .. package.path

local data = require('core/data')
local ones, zeros = string.rep('\255', 128), string.rep('\0', 128)
for _, t in ipairs({0x50, 0x58, 0x60, 0x68, 0x70, 0x78, 0x88, 0xE0, 0xF0, 0x100, 0x110, 0x120, 0x130}) do
    data.parse_packet({Type = t, ['Quest Flags'] = zeros})
end
for _, t in ipairs({0x90, 0x98, 0xA0, 0xA8, 0xB0, 0xB8, 0xC8, 0xE8, 0xF8, 0x108, 0x118, 0x128, 0x138, 0x30, 0x38}) do
    data.parse_packet({Type = t, ['Quest Flags'] = ones})
end
data.parse_packet({Type = 0x80, ['Current TOAU Quests'] = string.rep('\0', 16), ['Current Assault Mission'] = 0,
    ['Current TOAU Mission'] = 9999, ['Current WOTG Mission'] = 9999, ['Current Campaign Mission'] = 0})
data.parse_packet({Type = 0xC0, ['Completed TOAU Quests'] = string.rep('\255', 16), ['Completed Assaults'] = string.rep('\255', 16)})
data.parse_packet({Type = 0xD0, ["Completed San d'Oria Missions"] = string.rep('\255', 8), ['Completed Bastok Missions'] = string.rep('\255', 8),
    ['Completed Windurst Missions'] = string.rep('\255', 8), ['Completed Zilart Missions'] = string.rep('\255', 8)})
data.parse_packet({Type = 0xD8, ['Completed TOAU Missions'] = string.rep('\255', 16), ['Completed WOTG Missions'] = string.rep('\255', 16)})
data.parse_packet({Type = 0xFFFE, ['Current TVR Mission'] = 999})
data.parse_packet({Type = 0xFFFF, Nation = 0, ['Current Nation Mission'] = 9999, ['Current ROZ Mission'] = 9999,
    ['Current COP Mission'] = 850, ['Current ACP Mission'] = 9999, ['Current MKD Mission'] = 9999,
    ['Current ASA Mission'] = 9999, ['Current SOA Mission'] = 9999, ['Current ROV Mission'] = 9999})

local P = require('core/progress')
P.debug = false
P.init(data, function() end, 'Tester')
P.on_log()

local function card(cat, area, id)
    for _, it in ipairs(data.get_area_status(cat, area).items or {}) do if it.id == id then return it.status end end
end

local function shown(key)
    local st = P.for_page(key)
    local out = {}
    for i, s in ipairs(st.steps) do out[i] = s.shown end
    return table.concat(out, ',')
end

-- the two reported pages
check(card('mission', 'cop', 638) == 'completed', 'cop 638: the card is completed')
local s = P.summary('mission|cop|638')
check(s and s.done == 4 and s.total == 4, 'cop 638 One to be Feared: 4/4, got ' .. tostring(s and s.done) .. '/' .. tostring(s and s.total))
check(card('mission', 'acp', 6) == 'completed', 'acp 6: the card is completed')
s = P.summary('mission|acp|6')
check(s and s.done == 2 and s.total == 2, 'acp 6 Those Who Lurk in Shadows (III): 2/2 (the unseen Ivory Key use leaves the count), got '
    .. tostring(s and s.done) .. '/' .. tostring(s and s.total))
check(shown('mission|acp|6') == 'done,done', 'acp 6: the page shows the two steps done and no checkbox on the post step, got ' .. shown('mission|acp|6'))

-- every mapped entry the card shows completed
local swept, bad = 0, {}
for _, key in ipairs(P.keys()) do
    local cat, area, id = key:match('^(%a+)|([%w_]+)|(%d+)$')
    id = tonumber(id)
    if card(cat, area, id) == 'completed' then
        local f = loadfile('progress/' .. cat .. 's/' .. area .. '/' .. id .. '.lua')
        local m = f and f()
        if m and not m.repeatable then
            swept = swept + 1
            local sm = P.summary(key)
            if sm and sm.done ~= sm.total then bad[#bad + 1] = ('%s %d/%d'):format(key, sm.done, sm.total) end
        end
    end
end
check(swept > 800, 'the sweep covers the mapped entries, got ' .. swept)
check(#bad == 0, #bad .. ' completed entries show a part-filled strip: ' .. table.concat(bad, ', ', 1, math.min(#bad, 20)))

-- a line still in progress is untouched: CoP at 638, the card says active, the strip is not filled
package.loaded['core/progress'] = nil
data.parse_packet({Type = 0xFFFF, Nation = 0, ['Current Nation Mission'] = 9999, ['Current ROZ Mission'] = 9999,
    ['Current COP Mission'] = 638, ['Current ACP Mission'] = 9999, ['Current MKD Mission'] = 9999,
    ['Current ASA Mission'] = 9999, ['Current SOA Mission'] = 9999, ['Current ROV Mission'] = 9999})
local P2 = require('core/progress')
P2.debug = false
P2.init(data, function() end, 'Tester2')
P2.on_log()
check(card('mission', 'cop', 638) == 'active', 'cop at 638: the card is active')
s = P2.summary('mission|cop|638')
check(s and s.done < s.total, 'cop at 638: the strip is not filled, got ' .. tostring(s and s.done) .. '/' .. tostring(s and s.total))
s = P2.summary('mission|cop|628')
check(s and s.done == s.total, 'cop at 638: 628 behind it is filled, got ' .. tostring(s and s.done) .. '/' .. tostring(s and s.total))

os.remove(tmp .. 'data/progress/Tester.tsv')
os.remove(tmp .. 'data/progress/Tester2.tsv')
print(('test_complete_strip: %d passed, %d failed'):format(pass, fail))
if fail > 0 then os.exit(1) end

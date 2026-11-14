-- test_progress.lua: core/progress.lua with the A Purchase of Arms mapping (progress/quests/sandoria/27.lua), offline.
--
--   cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_progress.lua
--
-- Feeds the packets and chat lines the quest produces (built from XiPackets' layouts and the client's event scripts)
-- and checks the three shown states after each step, the login backfill from held key items and the quest log, the log
-- file round trip, the page's own bullets against the mapping's fingerprints, and that nothing unrelated is kept.
-- Also the mission lines and the CoP word (mission and word matchers, fixtures in the temp dir).
--
--   ... test/test_progress.lua --selftest   also breaks core/progress.lua's mission/word code in memory, one fault at
--                                           a time, and requires the mission cases to fail each time

local SELFTEST = arg and arg[1] == '--selftest'
local pass, fail = 0, 0
local quiet = false
local function check(cond, what)
    if cond then pass = pass + 1 else fail = fail + 1; if not quiet then print('FAIL ' .. what) end end
end

local tmp = (os.getenv('TEMP') or '.') .. '/cr_progress_test/'
os.execute('mkdir "' .. tmp:gsub('/', '\\') .. 'data\\progress" 2>nul')
os.execute('mkdir "' .. tmp:gsub('/', '\\') .. 'progress\\quests\\sandoria" 2>nul')
local function copy(rel)
    local src = assert(io.open(rel, 'rb')) local s = src:read('*a') src:close()
    local dst = assert(io.open(tmp .. rel, 'wb')) dst:write(s) dst:close()
end
copy('progress/index.lua')
copy('progress/quests/sandoria/27.lua')
copy('progress/quests/sandoria/101.lua')
-- mission fixtures: a nation line (mission ids 1 to 3) and the CoP word's third nibble (Louverance's path), under made-up ids,
-- and an index that adds them to the real one
os.execute('mkdir "' .. tmp:gsub('/', '\\') .. 'progress\\missions\\sandoria" 2>nul')
os.execute('mkdir "' .. tmp:gsub('/', '\\') .. 'progress\\missions\\cop" 2>nul')
local function write(rel, text) local f = assert(io.open(tmp .. rel, 'wb')) f:write(text) f:close() end
do
    local f = assert(io.open('progress/index.lua', 'rb')) local base = f:read('*a') f:close()
    write('progress/index_base.lua', base)
end
write('progress/index.lua', ('local t = dofile(%q) t["mission|sandoria|9001"] = true t["mission|cop|9002"] = true t["mission|sandoria|9003"] = true t["mission|sandoria|9004"] = true t["mission|sandoria|9005"] = true t["mission|sandoria|9006"] = true return t'):format(tmp .. 'progress/index_base.lua'))
write('progress/missions/sandoria/9001.lua', [[return {
    steps = {
        {id = 's1', at = {n = 1, fp = 'a'}, done = {{t = 'mission', line = 'sandoria', eq = 1}}},
        {id = 's2', at = {n = 2, fp = 'b'}, done = {{t = 'mission', line = 'sandoria', min = 2}}},
        {id = 's3', at = {n = 3, fp = 'c'}, done = {{t = 'mission', line = 'sandoria', eq = 3}}},
    },
}]])
-- a repeatable mission: accept = the line moving to 5, complete = id 5 entering the completed set
write('progress/missions/sandoria/9003.lua', [[return {
    completes = 's2',
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'a'}, done = {{t = 'mission', line = 'sandoria', eq = 5, completed = false}}},
        {id = 's2', at = {n = 2, fp = 'b'}, done = {{t = 'mission', line = 'sandoria', eq = 5, completed = true}}},
    },
}]])
-- a mission with two routes (as Journey Abroad): each route's last leg completes its own ids (6 then 9, or 7 then 8) and the
-- whole mission is id 5, which ends a route only `after` that route's last leg. The login reads the completed ids ascending,
-- so the 5 comes before the legs
write('progress/missions/sandoria/9005.lua', [[return {
    steps = {
        {id = 'a1', group = 'a', at = {n = 1, fp = 'a'}, done = {{t = 'mission', line = 'sandoria', eq = 6, completed = true}}},
        {id = 'a2', group = 'a', at = {n = 2, fp = 'b'}, done = {{t = 'mission', line = 'sandoria', eq = 9, completed = true}}},
        {id = 'a3', group = 'a', at = {n = 3, fp = 'c'}, done = {{t = 'mission', line = 'sandoria', eq = 5, completed = true, after = 'a2'}}},
        {id = 'b1', group = 'b', at = {n = 4, fp = 'd'}, done = {{t = 'mission', line = 'sandoria', eq = 7, completed = true}}},
        {id = 'b2', group = 'b', at = {n = 5, fp = 'e'}, done = {{t = 'mission', line = 'sandoria', eq = 8, completed = true}}},
        {id = 'b3', group = 'b', at = {n = 6, fp = 'f'}, done = {{t = 'mission', line = 'sandoria', eq = 5, completed = true, after = 'b2'}}},
    },
}]])
-- items (review CORE-5): a step done by losing item 2728, the next by gaining item 2487
write('progress/missions/sandoria/9006.lua', [[return {
    steps = {
        {id = 'i1', at = {n = 1, fp = 'a'}, done = {{t = 'item', id = 2728, lost = true}}},
        {id = 'i2', at = {n = 2, fp = 'b'}, done = {{t = 'item', id = 2487, gained = true}}},
    },
}]])
-- zone-in cutscenes (0x00A): three steps, each done by a zone-in event in the Chateau d'Oraguille (zone 233)
write('progress/missions/sandoria/9004.lua', [[return {
    steps = {
        {id = 's1', at = {n = 1, fp = 'a'}, done = {{t = 'zonein', zone = 233, event = 555}}},
        {id = 's2', at = {n = 2, fp = 'b'}, done = {{t = 'zonein', zone = 233, event = 509}}},
        {id = 's3', at = {n = 3, fp = 'c'}, done = {{t = 'zonein', zone = 233, event = 0}}},    -- event 0 is a real id
    },
}]])
write('progress/missions/cop/9002.lua', [[return {
    steps = {
        {id = 'p1', at = {n = 1, fp = 'a'}, done = {{t = 'word', nib = 2, min = 1}}},
        {id = 'p2', at = {n = 2, fp = 'b'}, done = {{t = 'word', nib = 2, min = 3}}},
        {id = 'p3', at = {n = 3, fp = 'c'}, done = {{t = 'word', nib = 2, min = 5}}},
    },
}]])
os.remove(tmp .. 'data/progress/Tester.tsv')

local said = {}
windower = {addon_path = tmp, create_dir = function() end}
package.path = './?.lua;' .. package.path

-- core/data stand-in: the quest log status of San d'Oria 27 and 101
local status, status101 = 'not_started', 'not_started'
-- and its mission lines {[line] = {current =, completed = {[id] = true}}} and CoP word, as core/data.get_mission_read gives them
local mlines, mword = {}, nil
local data = {
    is_loaded = function() return true end,
    get_area_status = function(cat, area) return {items = {{id = 27, status = status}, {id = 101, status = status101}}} end,
    get_mission_read = function() return mlines, mword end,
}

local mutant                    -- --selftest: core/progress.lua's source with one fault
local emutant                   -- --selftest: core/progress_engine.lua's source with one fault
local function fresh(name)
    package.loaded['core/progress'] = nil
    if emutant then package.loaded['core/progress_engine'] = assert(loadstring(emutant, '@emutant'))()
    else package.loaded['core/progress_engine'] = nil end
    local P
    if mutant then P = assert(loadstring(mutant, '@mutant'))() package.loaded['core/progress'] = P
    else P = require('core/progress') end
    P.debug = false
    P.init(data, function(s) said[#said + 1] = s end, name)
    return P
end

-- packets
local function u16(v) return string.char(v % 256, math.floor(v / 256) % 256) end
local function u32(v) return u16(v % 65536) .. u16(math.floor(v / 65536)) end
local function p055(table_i, kis)
    local flags = {}
    for i = 1, 64 do flags[i] = 0 end
    for _, id in ipairs(kis) do
        local i = id % 512
        local b = math.floor(i / 8) + 1
        flags[b] = flags[b] + 2 ^ (i % 8)
    end
    local s = {}
    for i = 1, 64 do s[i] = string.char(flags[i]) end
    return '\85\68\0\0' .. table.concat(s) .. string.rep('\0', 64) .. u16(table_i) .. '\0\0'
end
-- 0x034 as XiPackets lays it out: UniqueNo, num[8], ActIndex 0x28, EventNum (the zone) 0x2A, EventPara (the event) 0x2C,
-- Mode 0x2E, EventNum2 0x30, EventPara2 0x32
local function p034(event, params, zone)
    zone = zone or 230
    local s = '\52\26\0\0' .. u32(0x010E6039)
    for k = 0, 7 do s = s .. u32((params or {})[k] or 0) end
    return s .. u16(5) .. u16(zone) .. u16(event) .. u16(0) .. u16(zone) .. u16(event)
end
-- 0x032: UniqueNo, ActIndex 0x08, EventNum 0x0A, EventPara 0x0C, Mode 0x0E, EventNum2 0x10, EventPara2 0x12
local function p032(event, zone)
    return '\50\10\0\0' .. u32(0x010E6039) .. u16(5) .. u16(zone) .. u16(event) .. u16(0) .. u16(zone) .. u16(event)
end

-- 0x00A as XiPackets lays it out (GP_SERV_LOGIN, 0x104 bytes): UniqueNo 0x04, ZoneNo u32 0x30, EventNo 0x40, MapNumber 0x42,
-- EventNum (the zone the event file belongs to; 0 with no event) 0x62, EventPara (the event id) 0x64, EventMode 0x66, name 0x84
local function p00A(zone, event)
    local s = '\10\130\0\0' .. u32(0x010E6039) .. u16(5) .. string.rep('\0', 0x30 - 0x0A)
    s = s .. u32(zone) .. string.rep('\0', 0x40 - 0x34)
    s = s .. u16(event and zone or 0) .. u16(zone) .. string.rep('\0', 0x62 - 0x44)
    s = s .. u16(event and zone or 0) .. u16(event or 0) .. u16(event and 4 or 0)
    return s .. string.rep('\0', 0x84 - 0x68) .. 'Tester' .. string.rep('\0', 0x104 - 0x84 - 6)
end

local function shown(P, key)
    local st = P.for_page(key or 'quest|sandoria|27')
    local out = {}
    for i, s in ipairs(st.steps) do out[i] = s.shown end
    return table.concat(out, ',')
end
local function expect(P, want, what, key)
    local got = shown(P, key)
    check(got == want, what .. ': got ' .. got .. ' want ' .. want)
end

-- the page's bullets agree with the mapping's addresses
do
    local D = require('ui/doc')
    for _, id in ipairs({27, 101}) do
    local pg = dofile('pages/quests/sandoria/' .. id .. '.lua')
    local doc = D.decode(pg)
    local E = require('core/progress_engine')
    local tops = {}
    local function walk(blocks)
        for _, b in ipairs(blocks or {}) do
            if b.k == 'list' or b.items then
                for _, it in ipairs(b.items or {}) do tops[#tops + 1] = E.fold(it.spans or {}) end
            end
        end
    end
    walk(doc.blocks or doc)
    local m = dofile('progress/quests/sandoria/' .. id .. '.lua')
    for _, s in ipairs(m.steps) do
        local t = tops[s.at.n]
        check(t and t:sub(1, #s.at.fp) == s.at.fp, ('%d: page bullet %d starts "%s" (got "%s")'):format(id, s.at.n, s.at.fp, tostring(t)))
    end
    end
end

-- 1. a fresh character: nothing known, every step to do
local P = fresh('Tester')
P.on_0x055(p055(0, {}))
P.on_log()
expect(P, 'todo,todo,todo', 'not started')

-- 2. accept at Helbort: event 594, the accept line, key item 97, the quest log flags it
P.on_event(0x034, p034(594, {[0] = 97, [1] = 98}), 230)
P.on_text("Helbort : Then you'll do it? Much obliged! Listen well, and I'll explain what you're to do.")
P.on_0x055(p055(0, {97}))
status = 'active'
P.on_log()
expect(P, 'done,next,todo', 'accepted')

-- 3. Alexius in Jugner: the receipt for the order
P.on_event(0x034, p034(5, {[0] = 98}, 104), 104)
P.on_0x055(p055(0, {98}))
expect(P, 'done,done,next', 'receipt')

-- 4. back to Helbort: completed
P.on_event(0x034, p034(607), 230)
P.on_0x055(p055(0, {}))
status = 'completed'
P.on_log()
expect(P, 'done,done,done', 'completed')

-- what was kept, and nothing else
local kept = P._obs()
local kinds = {}
for _, o in ipairs(kept) do kinds[#kinds + 1] = o.t .. (o.id and (':' .. o.id) or '') .. (o.event and (':' .. o.event) or '') end
check(#kept == 10, 'kept 10 observations, got ' .. #kept .. ' (' .. table.concat(kinds, ' ') .. ')')
local seen = ' ' .. table.concat(kinds, ' ') .. ' '
check(seen:find(' event:594 ', 1, true) and seen:find(' event:5 ', 1, true) and seen:find(' event:607 ', 1, true),
    'the three events are read from EventPara (+0x2C), got' .. seen)
P.on_event(0x034, p034(123), 230)
P.on_text('Somebody : An unrelated line.')
P.on_0x055(p055(0, {500}))
check(#P._obs() == 10, 'unrelated events, lines and key items are not kept')

-- 5. the log file: a new session reads it back and shows the same
local P2 = fresh('Tester')
check(#P2._obs() == 10, 'the log file reads back 10 observations, got ' .. #P2._obs())
status = 'completed'
P2.on_0x055(p055(0, {}))
P2.on_log()
expect(P2, 'done,done,done', 'after a reload')
local o1 = P2._obs()[1]
check(o1.t == 'event' and o1.event == 594 and o1.zone == 230 and o1.p and o1.p[0] == 97, 'an event reads back with its params')

-- 6. backfill: installed mid-quest, holding the receipt, the log says accepted
os.remove(tmp .. 'data/progress/Late.tsv')
status = 'active'
local P3 = fresh('Late')
P3.on_0x055(p055(0, {98}))
P3.on_log()
expect(P3, 'done,done,next', 'mid-quest backfill from the receipt held')

-- 7. backfill: holding the order only
os.remove(tmp .. 'data/progress/Late2.tsv')
local P4 = fresh('Late2')
P4.on_0x055(p055(0, {97}))
P4.on_log()
expect(P4, 'done,next,todo', 'mid-quest backfill from the order held')

-- 8. completed long ago: the log alone
os.remove(tmp .. 'data/progress/Old.tsv')
status = 'completed'
local P5 = fresh('Old')
P5.on_0x055(p055(0, {}))
P5.on_log()
expect(P5, 'done,done,done', 'completed before install')

-- 9. a login snapshot is never written; only changes are
check(#P5._obs() == 0, 'a login snapshot is not kept')

-- 10. no mapping, no progress
check(P5.for_page('quest|sandoria|0') == nil, 'an entry without a mapping has no progress')

-- 11. review CORE-5: Windower fires 'remove item' then 'add item' when an item only moves between bags; that is no change
os.remove(tmp .. 'data/progress/Bags.tsv')
local P8 = fresh('Bags')
P8.on_item(2728, -1) P8.on_item(2728, 1)        -- the bulb moved to a wardrobe
P8.on_item(2487, -1) P8.on_item(2487, 1)        -- the slip taken out of storage
P8.flush()
check(#P8._obs() == 0, 'a bag move keeps nothing, got ' .. #P8._obs())
expect(P8, 'todo,todo', 'a bag move marks no item step done', 'mission|sandoria|9006')
P8.on_item(2728, -1)
P8.flush()
check(#P8._obs() == 1 and P8._obs()[1].id == 2728 and P8._obs()[1].delta == -1, 'a real loss is kept once')
expect(P8, 'done,next', 'a real loss marks the step done', 'mission|sandoria|9006')
P8.on_item(2487, 2) P8.on_item(2487, -1)        -- two gained, one moved away: net +1
P8.on_event(0x034, p034(594), 230)              -- any other observation keeps the pending items first, in order
local o8 = P8._obs()
check(#o8 == 3 and o8[2].t == 'item' and o8[2].delta == 1 and o8[3].t == 'event', 'items pending are kept before the next observation')
P8.on_item(4096, 1) P8.flush()
check(#P8._obs() == 3, 'an item no mapping wants is not kept')

-- 12. review CORE-1: an area whose quest pages have not both arrived is no baseline; its real bits arriving are no change
os.remove(tmp .. 'data/progress/Partial.tsv')
local ready = false
data.quest_area_ready = function() return ready end
status = 'not_started'                          -- what an area that has not arrived reads as
local P9 = fresh('Partial')
P9.on_0x055(p055(0, {}))
P9.on_log()                                     -- another area's page arrived first
ready, status = true, 'completed'
P9.on_log()                                     -- San d'Oria's pages arrive: the first real read, a baseline
check(#P9._obs() == 0, 'a late area is a baseline, not a live change; got ' .. #P9._obs())
expect(P9, 'done,done,done', 'completed long ago, read late')
status = 'not_started'
data.quest_area_ready = nil

-- 13. an area whose raw quest bits are unchanged is not read again (most of a refresh); changed bits are read and kept
os.remove(tmp .. 'data/progress/Skip.tsv')
local raw, reads = 'bits0', 0
local plain_status = data.get_area_status
data.quest_area_inputs = function() return raw, raw end
data.get_area_status = function(...) reads = reads + 1 return plain_status(...) end
local P10 = fresh('Skip')
P10.on_0x055(p055(0, {}))
P10.on_log()                                    -- the baseline
local r0 = reads                                -- one read per mapped area
P10.on_log() P10.on_log()
check(reads == r0, 'unchanged bits are not read again; read ' .. (reads - r0) .. ' times')
raw, status = 'bits1', 'active'
P10.on_log()
local o10 = P10._obs()
check(r0 > 0 and reads == 2 * r0 and #o10 > 0 and o10[1].t == 'quest' and o10[1].current == true, 'changed bits are read and the change kept')
P10.on_login('Skip')                            -- a new session forgets what it read: the next read is a baseline again
P10.on_log()
check(reads == 3 * r0, 'a login reads every area again')
status = 'not_started'
data.quest_area_inputs, data.get_area_status = nil, plain_status

-- 14. review CORE-13: a reload mid-session seeds the key item tables from what Windower holds, so a key item gained right after
-- the reload is kept (the first 0x055 of a table was taken as the login snapshot). A table with nothing in the list is not seeded.
windower.ffxi = {get_key_items = function() return {97, 2000} end}
os.remove(tmp .. 'data/progress/Seed.tsv')
local P11 = fresh('Seed')
P11.on_0x055(p055(0, {97, 98}))
local o11 = P11._obs()
check(#o11 == 1 and o11[1].t == 'ki' and o11[1].id == 98 and o11[1].gained == true, 'a key item gained after a reload is kept; got ' .. #o11)
windower.ffxi = {get_key_items = function() return {} end}
os.remove(tmp .. 'data/progress/Seed2.tsv')
local P12 = fresh('Seed2')
P12.on_0x055(p055(0, {97, 98}))
check(#P12._obs() == 0, 'with no key item listed, the first 0x055 is still the snapshot')
windower.ffxi = nil

-- 15. review CORE-11: a torn write (two records run together, the file not ending in a newline) loses only the torn record; the
-- next record starts a line of its own and every entry still evaluates
do
    local f = assert(io.open(tmp .. 'data/progress/Torn.tsv', 'wb'))
    f:write('100\tevent\tevent=594;zone=230\n')
    f:write('101\titem\tdelta=-1101\titem;id=2728\n')         -- two item records run together: delta is not a number
    f:write('102\tki\tgained=true;id=')                      -- cut short, no newline
    f:close()
    local P13 = fresh('Torn')
    check(#P13._obs() == 1 and P13._obs()[1].t == 'event', 'only whole, well-typed records are read back; got ' .. #P13._obs())
    local ok = pcall(P13.for_page, 'mission|sandoria|9006')
    check(ok, 'a torn record does not break the evaluation')
    P13.on_event(0x034, p034(594), 230)
    local r = assert(io.open(tmp .. 'data/progress/Torn.tsv', 'rb')) local all = r:read('*a') r:close()
    local last = all:gsub('\r', ''):match('([^\n]+)\n$')
    check(last and last:find('^%d+\tevent\t') ~= nil, 'the next record starts its own line: ' .. tostring(last))
    check(#fresh('Torn')._obs() == 2, 'and reads back')
    check(P._valid(P._decode('1\titem\tdelta=x;id=5')) == false and P._valid(P._decode('1\titem\tdelta=1;id=5')) == true,
        'record types are checked')
end

-- 16. review CORE-7: chat modes no mapped line arrives in are not looked at; nil looks at every line
do
    os.remove(tmp .. 'data/progress/Modes.tsv')
    local P14 = fresh('Modes')
    local line = "Helbort : Then you'll do it? Much obliged! Listen well, and I'll explain what you're to do."
    P14.on_text(line, 13)                       -- a party member typed it
    P14.on_text(line, 20)                       -- the combat log
    check(#P14._obs() == 0, 'player chat and combat modes are skipped; got ' .. #P14._obs())
    P14.on_text(line, 150)
    check(#P14._obs() == 1, 'an NPC line is kept')
    os.remove(tmp .. 'data/progress/Modes2.tsv')
    local P15 = fresh('Modes2')
    P15.on_text(line)
    check(#P15._obs() == 1, 'no mode: every line is looked at')
    check(P._skips(13) and P._skips(20) and not P._skips(150) and not P._skips(121) and not P._skips(190), 'the skipped modes')
    check(P._literal('ah%. thank you%!') == 'ah. thank you!' and P._literal('ain.t you') == nil and P._literal('^you') == nil
        and P._literal('100%%') == '100%' and P._literal('a %a') == nil, 'plain patterns are found as plain text')
    -- every real pattern read as plain text finds what the pattern finds, and no real pattern matches a combat line
    local idx = dofile('progress/index.lua')
    local bad, n, battle = {}, 0, 0
    local combat = {'aldreth uses shield bash. the gloom phantom takes 261 points of damage.', 'aldreth defeats the gloom phantom.',
        'berrant casts dia. the gloom phantom takes 2 points of damage.', "aldreth's invisible effect wears off."}
    for key in pairs(idx) do
        local cat, area, id = key:match('^(%a+)|([%w_]+)|(%d+)$')
        local m = dofile(('progress/%ss/%s/%s.lua'):format(cat, area, id))
        for re in pairs(P._wants_of(m).chat) do
            n = n + 1
            local lit = P._literal(re)
            if lit and not (('x ' .. lit .. ' y'):find(re)) then bad[#bad + 1] = re end
            for _, c in ipairs(combat) do if c:find(re) then battle = battle + 1 end end
        end
    end
    check(n > 1000 and #bad == 0, ('plain reading of %d patterns: %d differ (%s)'):format(n, #bad, tostring(bad[1])))
    check(battle == 0, 'no mapped pattern matches a combat line: ' .. battle)
end

-- 17. review CORE-9: no mapping is loaded at init (progress/next/wants.lua says what each can use); a page loads its own
do
    local saved_root = windower.addon_path
    windower.addon_path = './'
    package.loaded['core/progress'] = nil
    local PL = require('core/progress')
    PL.init(data, function() end, nil)
    check(PL._maps_held() == 0, 'no mapping loaded at init; held ' .. PL._maps_held())
    local st = PL.for_page('quest|bastok|31')
    check(st and #st.steps > 0 and PL._maps_held() == 1, 'a page loads its own mapping')
    windower.addon_path = saved_root
    package.loaded['core/progress'] = nil
end

-- encode/decode round trip with awkward text
local o = P._decode(P._encode({t = 'chat', time = 1, text = "a;b=c\td%e"}))
check(o and o.text == "a;b=c\td%e", 'chat text with separators survives the file')

-- 0x032 carries no params: its event is at +0x0C
os.remove(tmp .. 'data/progress/Ev.tsv')
local P7 = fresh('Ev')
P7.on_event(0x032, p032(594, 230), 230)
check(#P7._obs() == 1 and P7._obs()[1].event == 594, '0x032 reads its event from +0x0C')

-- Exit the Gambler (101): the log is silent until completion, so events and dialogue carry every step
do
    local G = 'quest|sandoria|101'
    os.remove(tmp .. 'data/progress/Gam.tsv')
    status101 = 'not_started'
    local Q = fresh('Gam')
    Q.on_0x055(p055(0, {}))
    Q.on_log()
    expect(Q, 'todo,todo,todo,todo,todo', 'gambler: nothing yet', G)
    Q.on_event(0x034, p034(521, {}, 231), 231)
    expect(Q, 'done,todo,next,todo,todo', 'gambler: Aurege 521 (the optional Nonterene bullet is never next)', G)
    Q.on_event(0x034, p034(638, {}, 230), 230)
    expect(Q, 'done,done,done,next,todo', 'gambler: Varchet 638', G)
    Q.on_event(0x034, p034(519, {[0] = 2, [1] = 3, [2] = 5, [3] = 1, [4] = 1, [5] = 2, [6] = 2}, 230), 230)
    expect(Q, 'done,done,done,next,todo', 'gambler: a lost game leaves the gamble next', G)
    Q.on_event(0x034, p034(519, {[0] = 1, [1] = 1, [2] = 2, [3] = 6, [4] = 5, [5] = 11, [6] = 0}, 230), 230)
    expect(Q, 'done,done,done,done,next', 'gambler: won (P6 = 0)', G)
    Q.on_event(0x034, p034(516, {}, 231), 231)
    Q.on_0x055(p055(0, {391}))
    status101 = 'completed'
    Q.on_log()
    expect(Q, 'done,done,done,done,done', 'gambler: completed', G)
    -- the win line alone, as chat, also proves the gamble
    os.remove(tmp .. 'data/progress/Gam2.tsv')
    status101 = 'not_started'
    local Q2 = fresh('Gam2')
    Q2.on_log()
    Q2.on_text('Varchet : As promised, I shall go and see about those woodchippers. Maybe we can play another game later.')
    expect(Q2, 'done,done,done,done,next', 'gambler: the win line alone', G)
    -- completed before install
    os.remove(tmp .. 'data/progress/Gam3.tsv')
    status101 = 'completed'
    local Q3 = fresh('Gam3')
    Q3.on_log()
    expect(Q3, 'done,done,done,done,done', 'gambler: completed before install', G)
    status101 = 'not_started'
end

-- chat as it arrived in game (2026-10-25): the line plain, twice more with colour bytes, and this module's own echo
os.remove(tmp .. 'data/progress/Chat.tsv')
local P6 = fresh('Chat')
local line = "Helbort : Then you'll do it? Much obliged! Listen well, and I'll explain what you're to do."
P6.on_text(line)
P6.on_text('\30\1  ' .. line .. '\31')
P6.on_text('\30\1  ' .. line .. '\31')
P6.on_text("Chronicle: progress: chat: helbort : then you'll do it? much obliged! listen well, and")
P6.on_text("Chronicle: progress: chat:   helbort : then you'll do it? much obliged!")
check(#P6._obs() == 1, 'one NPC line seen three times plus our echo is kept once, got ' .. #P6._obs())
-- as on 2026-10-27: the plain copy ends in a control byte and "1"
P6.on_text("Varchet : As promised, I shall go and see about those woodchippers.\1271")
P6.on_text('\30\1  Varchet : As promised, I shall go and see about those woodchippers.\31')
check(#P6._obs() == 2, 'a line ending in a control byte and a digit is the same line, got ' .. #P6._obs())
P6.on_text("Alexius : An order for weapons? Well, that's my business. Take this weapons receipt back.")
check(#P6._obs() == 3, 'a different line is kept')

-- mission lines and the CoP word -------------------------------------------------------------------------------------------------
local function mission_cases()
    local N = 'mission|sandoria|9001'
    local W = 'mission|cop|9002'
    for _, n in ipairs({'MisA', 'MisB', 'MisC', 'MisW', 'MisS', 'MisR', 'MisV'}) do os.remove(tmp .. 'data/progress/' .. n .. '.tsv') end

    -- a nation mission: the first read is the baseline, then the current value moves, then the mission completes
    mlines, mword = {sandoria = {current = 0, completed = {}}}, nil
    local A = fresh('MisA')
    A.on_log()
    expect(A, 'todo,todo,todo', 'mission: nothing yet', N)
    check(#A._obs() == 0, 'mission: the first read is a baseline, nothing kept')
    mlines.sandoria.current = 1
    A.on_log()
    expect(A, 'done,next,todo', 'mission: current 1', N)
    check(#A._obs() == 1 and A._obs()[1].t == 'mission' and A._obs()[1].line == 'sandoria' and A._obs()[1].current == 1,
        'mission: the move to 1 is one kept observation')
    mlines.sandoria.current = 2
    A.on_log()
    expect(A, 'done,done,next', 'mission: current 2 (min = 2; the step before is behind it)', N)
    mlines.sandoria.current = 4
    mlines.sandoria.completed = {[3] = true}
    A.on_log()
    expect(A, 'done,done,done', 'mission: mission 3 completed, current moved on', N)
    local kept = A._obs()
    check(#kept == 4 and kept[4].completed == true and kept[4].current == 3 and kept[3].current == 4 and not kept[3].completed,
        'mission: a newly completed id and the new current value are kept, got ' .. #kept)
    A.on_log()
    check(#A._obs() == 4, 'mission: an unchanged read keeps nothing')
    -- the file reads back and shows the same (the log, not the snapshot, carries it: the reader's lines are empty)
    mlines = {}
    local A2 = fresh('MisA')
    check(#A2._obs() == 4 and A2._obs()[4].completed == true and A2._obs()[4].line == 'sandoria', 'mission: the log file reads back')
    A2.on_log()
    expect(A2, 'done,done,done', 'mission: after a reload', N)

    -- the login snapshot is a backfill: it fills the steps and is never written
    mlines, mword = {sandoria = {current = 2, completed = {[1] = true}}}, nil
    local B = fresh('MisB')
    B.on_log()
    expect(B, 'done,done,next', 'mission: login at 2 with 1 completed (backfill)', N)
    check(#B._obs() == 0, 'mission: a login snapshot is not kept')
    mlines.sandoria.current = 3
    B.on_log()
    expect(B, 'done,done,done', 'mission: current 3 after a backfill', N)
    check(#B._obs() == 1, 'mission: the change after the snapshot is the only observation, got ' .. #B._obs())
    -- a line that arrives after the first read (log pages come one by one) is a baseline too
    mlines = {}
    local C = fresh('MisC')
    C.on_log()
    mlines = {sandoria = {current = 3, completed = {[1] = true, [2] = true}}}
    C.on_log()
    check(#C._obs() == 0, 'mission: a line first read late is a baseline, nothing kept')
    expect(C, 'done,done,done', 'mission: a late-arriving line backfills', N)
    -- another nation's line does not tick this mapping
    mlines = {bastok = {current = 3, completed = {[3] = true}}}
    local C2 = fresh('MisC')
    C2.on_log()
    expect(C2, 'todo,todo,todo', 'mission: another line is not read as this one', N)

    -- completed apart from current: accept, then complete (the line goes back to 65535, the id enters the completed set)
    local R = 'mission|sandoria|9003'
    local NONE = 65535
    mlines, mword = {sandoria = {current = NONE, completed = {}}}, nil
    local Rp = fresh('MisR')
    Rp.on_log()
    expect(Rp, 'todo,todo', 'completed: nothing yet', R)
    mlines.sandoria.current = 5
    Rp.on_log()
    expect(Rp, 'done,next', 'completed: accepted (the line moved to 5)', R)
    mlines.sandoria.current, mlines.sandoria.completed = NONE, {[5] = true}
    Rp.on_log()
    expect(Rp, 'done,done', 'completed: finished (the line back to 65535, id 5 completed)', R)
    check(#Rp._obs() == 3 and Rp._obs()[3].completed == true and Rp._obs()[3].current == 5 and not Rp._obs()[2].completed,
        'completed: the move and the completion are two observations, got ' .. #Rp._obs())
    -- a finished-before-install player: the completed snapshot ticks every step, and is never written
    mlines, mword = {sandoria = {current = NONE, completed = {[5] = true}}}, nil
    local V = fresh('MisV')
    V.on_log()
    expect(V, 'done,done', 'completed: finished before install shows all done', R)
    check(#V._obs() == 0, 'completed: that snapshot is not kept')
    -- the repeat: a re-accept restarts the run; the completed snapshot (and the completion read) does not
    mlines = {sandoria = {current = NONE, completed = {[5] = true}}}
    local Y = fresh('MisR')
    mlines.sandoria.completed = {[5] = true}
    Y.on_log()
    expect(Y, 'done,done', 'completed: the completed snapshot does not restart a finished run', R)
    mlines.sandoria.current = 5
    Y.on_log()
    expect(Y, 'done,next', 'completed: a re-accept restarts the run (the completed id is history for run 2)', R)
    mlines.sandoria.current = NONE
    Y.on_log()
    expect(Y, 'done,next', 'completed: the line back to 65535 does not tick the new run', R)

    -- two routes, the whole mission's id before the legs in the login read: only the route taken shows finished
    local T = 'mission|sandoria|9005'
    for _, n in ipairs({'MisT1', 'MisT2', 'MisT3'}) do os.remove(tmp .. 'data/progress/' .. n .. '.tsv') end
    mlines, mword = {sandoria = {current = 12, completed = {[5] = true, [6] = true, [9] = true}}}, nil
    local T1 = fresh('MisT1')
    T1.on_log()
    expect(T1, 'done,done,done,todo,todo,todo', 'routes: finished by order A before install (5, 6, 9)', T)
    mlines = {sandoria = {current = 12, completed = {[5] = true, [7] = true, [8] = true}}}
    local T2 = fresh('MisT2')
    T2.on_log()
    expect(T2, 'todo,todo,todo,done,done,done', 'routes: finished by order B before install (5, 7, 8)', T)
    mlines = {sandoria = {current = 5, completed = {[6] = true, [9] = true}}}
    local T3 = fresh('MisT3')
    T3.on_log()
    expect(T3, 'done,done,next,todo,todo,todo', 'routes: both legs of A done, the mission not completed yet', T)
    check(#T1._obs() == 0 and #T2._obs() == 0, 'routes: that snapshot is not kept')

    -- the CoP word: a sub-mission from its nibble; other nibbles do not count
    mlines, mword = {}, 0
    local Wp = fresh('MisW')
    Wp.on_log()
    expect(Wp, 'todo,todo,todo', 'word: nothing yet', W)
    check(#Wp._obs() == 0, 'word: the first read is a baseline, nothing kept')
    mword = 0x30000                -- nibble 4 (Ulmia's path), not this one
    Wp.on_log()
    expect(Wp, 'todo,todo,todo', 'word: another nibble does not tick', W)
    mword = 0x30100                -- nibble 2 = 1
    Wp.on_log()
    expect(Wp, 'done,next,todo', 'word: nibble 2 at 1', W)
    mword = 0x30300
    Wp.on_log()
    expect(Wp, 'done,done,next', 'word: nibble 2 at 3', W)
    mword = 0x3FBEEEEE             -- the recorded word of a finished storyline: nibble 2 = 14
    Wp.on_log()
    expect(Wp, 'done,done,done', 'word: the finished word', W)
    local kw = Wp._obs()
    check(#kw == 4 and kw[1].t == 'word' and kw[1].value == 0x30000 and kw[4].value == 0x3FBEEEEE, 'word: each change is kept, got ' .. #kw)
    local Wp2 = fresh('MisW')
    mword = 0x3FBEEEEE
    Wp2.on_log()
    expect(Wp2, 'done,done,done', 'word: the file reads back', W)
    -- login mid-path: the snapshot backfills, nothing written
    mword = 0x00300
    local Sw = fresh('MisS')
    Sw.on_log()
    expect(Sw, 'done,done,next', 'word: login with nibble 2 at 3 (backfill)', W)
    check(#Sw._obs() == 0, 'word: a login snapshot is not kept')
    mlines, mword = {}, nil
end
-- zone-in cutscenes: the event rides in the 0x00A zone-in packet (EventPara, with EventNum = the zone as the "has one" flag)
local function zonein_cases()
    local Z = 'mission|sandoria|9004'
    for _, n in ipairs({'ZiA', 'ZiB'}) do os.remove(tmp .. 'data/progress/' .. n .. '.tsv') end
    local A = fresh('ZiA')
    check(#p00A(233, 555) == 0x104 and p00A(233, 555):byte(0x30 + 1) == 233 and p00A(233, 555):byte(0x64 + 1) == 555 % 256,
        'zonein: the fixture puts ZoneNo at 0x30 and EventPara at 0x64')
    expect(A, 'todo,todo,todo', 'zonein: nothing yet', Z)
    A.on_zonein(p00A(233, nil))
    check(#A._obs() == 0, 'zonein: a zone-in without an event keeps nothing')
    expect(A, 'todo,todo,todo', 'zonein: no event, no tick (not even for event 0)', Z)
    A.on_zonein(p00A(230, 555))
    check(#A._obs() == 0, 'zonein: the same event in another zone keeps nothing')
    A.on_zonein(p00A(233, 556))
    check(#A._obs() == 0, 'zonein: an event no mapping names keeps nothing')
    expect(A, 'todo,todo,todo', 'zonein: a different zone or event does not tick', Z)
    A.on_zonein(p00A(233, 555))
    expect(A, 'done,next,todo', 'zonein: event 555 in zone 233 ticks s1', Z)
    local o = A._obs()[1]
    check(#A._obs() == 1 and o.t == 'zonein' and o.zone == 233 and o.event == 555, 'zonein: one observation {zonein, 233, 555}')
    A.on_zonein(p00A(233, 555))
    check(#A._obs() == 1, 'zonein: the same packet twice within 5 s counts once')
    A.recent(1)
    check(said[#said] and said[#said]:find('zone-in event 555 in zone 233', 1, true), 'zonein: describe')
    -- the log file round trip
    local A2 = fresh('ZiA')
    expect(A2, 'done,next,todo', 'zonein: read back from the log file', Z)
    A.on_zonein(p00A(233, 0))
    expect(A, 'done,done,done', 'zonein: a real event 0 ticks s3 (EventNum is the flag)', Z)
    local B = fresh('ZiB')
    B.on_zonein(p00A(233, 509))
    expect(B, 'done,done,next', 'zonein: event 509 ticks s2 (s1 is behind it)', Z)
end

local function all_cases() mission_cases() zonein_cases() end
all_cases()

if SELFTEST then
    -- one fault at a time in core/progress.lua's source; the mission cases must fail each time
    local f = assert(io.open('core/progress.lua', 'rb')) local src = f:read('*a'):gsub('\r\n', '\n') f:close()
    local FAULTS = {
        {'mission/word observation off', 'if not data.get_mission_read or (not next(want.mission) and not want.word) then return end',
            'if true then return end'},
        {'mission matchers not wanted', "if x.t == 'mission' then w.lines[x.line] = true\n                elseif x.t == 'word' then w.word = true\n                elseif x.t == 'ki'",
            "if x.t == 'mission' then\n                elseif x.t == 'word' then w.word = true\n                elseif x.t == 'ki'"},
        {'word matchers not wanted', "elseif x.t == 'word' then w.word = true\n                elseif x.t == 'ki'",
            "elseif x.t == 'word' then\n                elseif x.t == 'ki'"},
        {'login snapshot of mission lines dropped', 'for line in pairs(lines_of[key] or {}) do', 'for line in pairs({}) do'},
        {'login snapshot of the word dropped', 'if word_of[key] and word_seen then', 'if false then'},
        {'first mission read kept as an observation', '            if before then\n                if now.current and',
            '            if true then\n                before = before or {current = -1, completed = {}}\n                if now.current and'},
        {'first word read kept as an observation', 'if word_seen and word ~= word_seen then', 'if word ~= word_seen then'},
        {'completed snapshot ids lose the completed flag', 'current = id, completed = true, snap = true}', 'current = id, snap = true}'},
        {'completed ids not kept', 'for _, id in ipairs(added) do keep(', 'for _, id in ipairs({}) do keep('},
        {'word change not kept', "keep({t = 'word', value = word})", 'local _ = word'},
        {'zone-in observation removed', "keep({t = 'zonein', zone = zone, event = ev})", 'local _ = ev'},
        {'zone-in event-less packet kept', 'if num == 0 then return end', ''},
        {'zone-in events not wanted', "elseif x.t == 'zonein' and x.event ~= nil then w.zonein[(x.zone or 0) * 65536 + x.event] = true\n",
            "\n"},
        {'zone-in reads the zone from EventPara', 'u16(raw, 0x30), u16(raw, 0x62), u16(raw, 0x64)', 'u16(raw, 0x64), u16(raw, 0x62), u16(raw, 0x64)'},
        {'zone-in dedupe off', 'if last_zonein.key == key and now - last_zonein.time <= 5 then return end', ''},
    }
    local ef = assert(io.open('core/progress_engine.lua', 'rb')) local esrc = ef:read('*a'):gsub('\r\n', '\n') ef:close()
    local EFAULTS = {
        {'mission matcher ignores completed', "if o.t == 'mission' and m.completed ~= nil and m.completed ~= (o.completed == true) then return nil end",
            ''},
        {'mission matcher: completed = false matches a completed read too', "m.completed ~= (o.completed == true)", "m.completed == true and not o.completed"},
        {'a completed snapshot applied to a later run', '(not m.run1 or run == 1) and not history', '(not m.run1 or run == 1)'},
        {'a login snapshot is not tried again for `after` matchers', 'if scan(o, true) then again = true end', 'local _ = o'},
    }
    for _, ft in ipairs(EFAULTS) do
        local a, b = esrc:find(ft[2], 1, true)
        check(a ~= nil, 'selftest: the engine fault site exists: ' .. ft[1])
        if a then
            emutant = esrc:sub(1, a - 1) .. ft[3] .. esrc:sub(b + 1)
            local pass0, fail0 = pass, fail
            quiet = true
            local ok = pcall(all_cases)
            quiet = false
            local caught = fail > fail0 or not ok
            pass, fail = pass0, fail0
            emutant = nil
            check(caught, 'selftest: the mission cases catch: ' .. ft[1])
        end
    end
    for _, ft in ipairs(FAULTS) do
        local a, b = src:find(ft[2], 1, true)
        check(a ~= nil, 'selftest: the fault site exists: ' .. ft[1])
        if a then
            mutant = src:sub(1, a - 1) .. ft[3] .. src:sub(b + 1)
            local pass0, fail0 = pass, fail
            quiet = true
            local ok = pcall(all_cases)
            quiet = false
            local caught = fail > fail0 or not ok
            pass, fail = pass0, fail0
            mutant = nil
            check(caught, 'selftest: the mission cases catch: ' .. ft[1])
        end
    end
end

print(('test_progress: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)

--[[
    test_roe.lua - the Records of Eminence tab.

    The catalogue the generator bakes (every tree id resolves to a record, the derived
    sub-category hints re-derive identically here in Lua, the cross-links point at entries
    Chronicle really has), the three packets parsed byte by byte against synthetic buffers and
    against the numbers a real capture reported, gate evaluation along the whole tree path
    against hand-built completion bitfields, the totals, and the four screens driven through the
    real addon at three window sizes down to the 480 px minimum.

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_roe.lua
]]

local H = dofile('test/harness.lua')

local pass, fail = 0, 0
local function check(name, cond, detail)
    if cond then pass = pass + 1 else
        fail = fail + 1
        print('FAIL ' .. name .. (detail ~= nil and (': ' .. tostring(detail)) or ''))
    end
end

local function read(path)
    local f = assert(loadfile(path), path .. ' is missing')
    return f()
end

---------------------------------------------------------------------------
-- 1. the catalogue
---------------------------------------------------------------------------

local ix = read('roe/index.lua')

check('index version', ix.version == 1, ix.version)
check('twelve categories', #ix.cats == 12, #ix.cats)

local subs, objs, seen = 0, 0, {}
local dupes = 0
for ci, c in ipairs(ix.cats) do
    check('category ' .. ci .. ' has a name', type(c.n) == 'string' and c.n ~= '')
    check('category ' .. ci .. ' names a file', type(c.f) == 'string' and c.f:find('^roe/c%d%d%.lua$') ~= nil, c.f)
    for si, s in ipairs(c.subs) do
        subs = subs + 1
        check('sub-category ' .. ci .. '/' .. si .. ' has a name', type(s.n) == 'string' and s.n ~= '')
        for _, oid in ipairs(s.o) do
            objs = objs + 1
            if seen[oid] then dupes = dupes + 1 end
            seen[oid] = {ci, si}
        end
    end
end
check('112 sub-categories', subs == 112, subs)
check('counts agree with the tree', ix.counts.objectives == objs and ix.counts.subcategories == subs,
      ix.counts.objectives .. ' vs ' .. objs)
check('no objective sits in two places', dupes == 0, dupes)

-- every id in the tree resolves to a record with a name
local nameless = 0
for oid in pairs(seen) do
    if type(ix.name[oid]) ~= 'string' or ix.name[oid] == '' then nameless = nameless + 1 end
end
check('every tree id has a record name', nameless == 0, nameless)

-- goals and repeat flags are only there when they say something
local bad_goal = 0
for oid, g in pairs(ix.goal) do
    if type(g) ~= 'number' or g <= 1 or not seen[oid] then bad_goal = bad_goal + 1 end
end
check('goal counts are above one and in the tree', bad_goal == 0, bad_goal)

-- every gate names a record or a zone that the index can name
local unnamed_gate, zone_gates = 0, 0
local function scan_gates(list)
    for _, packed in ipairs(list or {}) do
        local t, v = math.floor(packed / 0x10000), packed % 0x10000
        check('gate type is one the client has', t >= 1 and t <= 8, t)
        if t == 1 and not ix.gate_names[v] then unnamed_gate = unnamed_gate + 1 end
        if t == 4 then
            zone_gates = zone_gates + 1
            if not ix.zone_names[v] then unnamed_gate = unnamed_gate + 1 end
        end
    end
end
for _, c in ipairs(ix.cats) do
    scan_gates(c.g)
    for _, s in ipairs(c.subs) do scan_gates(s.g) end
end
for oid in pairs(seen) do scan_gates(ix.gates[oid]) end
check('every record and zone a gate names is named', unnamed_gate == 0, unnamed_gate)
check('the zone gates are there', zone_gates > 300, zone_gates)

-- every category file holds exactly its category's objectives
local wraps = {}
for ci, c in ipairs(ix.cats) do
    local d = read(c.f)
    local want, have = 0, 0
    for _, s in ipairs(c.subs) do
        for _, oid in ipairs(s.o) do
            want = want + 1
            if d[oid] then have = have + 1 end
            if d[oid] and d[oid].w then wraps[oid] = d[oid] end
        end
    end
    check('category ' .. ci .. ' file covers its objectives', want == have, want .. ' vs ' .. have)
    local stray = 0
    for oid in pairs(d) do if not seen[oid] or seen[oid][1] ~= ci then stray = stray + 1 end end
    check('category ' .. ci .. ' file holds nothing else', stray == 0, stray)
end

---------------------------------------------------------------------------
-- 2. the derived sub-category hints, re-derived here
---------------------------------------------------------------------------

-- The generator derives each sub-category's content hint in Python; the same rules again in
-- Lua, so a change to one without the other is caught rather than shipped.
local function strip_tag(s)
    local base, tag = s:match('^(.-)%s*%((%u+)%)%s*$')
    if base and (tag == 'D' or tag == 'W' or tag == 'M' or tag == 'VB' or tag == 'VBD' or tag == 'UC') then
        return (base:gsub('^%s+', ''):gsub('%s+$', ''))
    end
    return s
end

local function lead_strip(s)
    local rest = s:match('^[Ll][Ee][Vv][Ee][Ll]%s+%d+%s+(.*)$')
    if rest then return rest end
    return s:match('^[Ll][Vv]%.?%s*%d+%s+(.*)$')
end

local function is_numbering(s)
    if s:match('^[A-Fa-f]$') then return true end
    local body = s:match('^[Ll][Vv]%.?%s*(.*)$') or s
    local a = body:match('^([0-9IVXLCivxlc]+)%s*%-%s*[0-9IVXLCivxlc]+$')
    if a then return true end
    return body:match('^[0-9IVXLCivxlc]+$') ~= nil
end

local function trim(s) return (s:gsub('^%s+', ''):gsub('%s+$', '')) end

local function words_of(s)
    local w = {}
    for x in s:gmatch('%S+') do w[#w + 1] = x end
    return w
end

local function variants(names)
    local n = {}
    for i, x in ipairs(names) do n[i] = strip_tag(x) end
    local floor6 = math.max(2, math.floor(0.6 * #n))
    local colon = {}
    for _, x in ipairs(n) do if x:find(': ', 1, true) then colon[#colon + 1] = x end end
    if #colon >= floor6 then
        local out = {}
        for _, x in ipairs(colon) do
            local i = x:find(': ', 1, true)
            out[#out + 1] = trim(x:sub(i + 2))
        end
        return out
    end
    local led = 0
    for _, x in ipairs(n) do if lead_strip(x) then led = led + 1 end end
    if led >= floor6 then
        local out = {}
        for _, x in ipairs(n) do
            local r = lead_strip(x)
            if r then out[#out + 1] = trim(r) end
        end
        return out
    end
    if #n > 1 then
        local w = {}
        for i, x in ipairs(n) do w[i] = words_of(x) end
        local k = 0
        while true do
            local ok = true
            for _, x in ipairs(w) do if #x <= k + 1 then ok = false break end end
            if not ok then break end
            local first = w[1][k + 1]
            for _, x in ipairs(w) do if x[k + 1] ~= first then ok = false break end end
            if not ok then break end
            k = k + 1
        end
        if k > 0 then
            local out = {}
            for i, x in ipairs(w) do
                local parts = {}
                for j = k + 1, #x do parts[#parts + 1] = x[j] end
                out[i] = table.concat(parts, ' ')
            end
            return out
        end
    end
    return n
end

local function hint_of(names)
    local v = variants(names)
    local seen_v, out = {}, {}
    for _, x in ipairs(v) do
        if x ~= '' and not seen_v[x] then seen_v[x] = true out[#out + 1] = x end
    end
    if #out == 0 then return '' end
    if #out > 2 then
        local all = true
        for _, x in ipairs(out) do if not is_numbering(x) then all = false break end end
        if all then return out[1] .. ' -> ' .. out[#out] end
    end
    local shown = {}
    for i = 1, math.min(4, #out) do shown[i] = out[i] end
    local more = #out - #shown
    return table.concat(shown, ', ') .. (more > 0 and (' +' .. more .. ' more') or '')
end

local hint_bad = 0
for _, c in ipairs(ix.cats) do
    for _, s in ipairs(c.subs) do
        local names = {}
        for i, oid in ipairs(s.o) do names[i] = ix.name[oid] end
        local want = hint_of(names)
        if want ~= s.h then
            hint_bad = hint_bad + 1
            if hint_bad <= 3 then print('  hint ' .. s.n .. ': baked "' .. tostring(s.h) .. '" derived "' .. want .. '"') end
        end
    end
end
check('every baked hint re-derives identically', hint_bad == 0, hint_bad)
check('the opaque names got a hint', (function()
    for _, c in ipairs(ix.cats) do
        for _, s in ipairs(c.subs) do
            if s.n == 'Job Levels 1' then return s.h ~= '' and s.h:find('Warrior', 1, true) ~= nil end
        end
    end
end)())

---------------------------------------------------------------------------
-- 3. the cross-links
---------------------------------------------------------------------------

local pages_index = read('pages/index.lua')
local entry_index = read('meta/index.lua')

-- meta/index.lua is keyed by the entry's name lowered, punctuation and all
local function norm(n) return (n:lower():gsub('^%s+', ''):gsub('%s+$', '')) end

local n_wraps, no_entry, no_page, bad_shape, missing = 0, 0, 0, 0, {}
for oid, e in pairs(wraps) do
    n_wraps = n_wraps + 1
    local cat, area = e.w:match('^([^|]+)|([^|]+)|%-?%d+$')
    if not cat or (cat ~= 'mission' and cat ~= 'quest') or type(e.wn) ~= 'string' then
        bad_shape = bad_shape + 1
    else
        -- the link opens a Chronicle entry: the name has to be one the index lists, in that area
        local areas = entry_index[cat][norm(e.wn)]
        local ok = false
        for _, a in ipairs(areas or {}) do if a == area then ok = true end end
        if not ok then
            no_entry = no_entry + 1
            if no_entry <= 5 then print('  no entry for ' .. e.w .. ' (' .. e.wn .. ', record ' .. oid .. ')') end
        end
        if not pages_index[e.w] then
            no_page = no_page + 1
            missing[#missing + 1] = e.w .. ' (' .. e.wn .. ')'
        end
    end
end
check('every cross-link has a well-formed key and a name', bad_shape == 0, bad_shape)
check('there are the cross-links the research found', n_wraps >= 265, n_wraps)
check('every cross-link opens an entry Chronicle lists', no_entry == 0, no_entry)
-- Chronicle has an entry for every one of them; a couple of entries have no walkthrough page of
-- their own yet, and the link then opens that entry's card, which is still what it is for.
check('nearly all of them have a walkthrough page', no_page <= 2,
      no_page .. ': ' .. table.concat(missing, ', '))
print(('  cross-links: %d, %d with a walkthrough page'):format(n_wraps, n_wraps - no_page))

---------------------------------------------------------------------------
-- 4. the packets
---------------------------------------------------------------------------

local P = dofile('core/roe_packets.lua')

local function le32(v)
    return string.char(v % 256, math.floor(v / 256) % 256, math.floor(v / 65536) % 256,
                       math.floor(v / 16777216) % 256)
end
local function pkt110(sparks, deeds, bytes)
    local s = string.rep('\0', 4) .. le32(sparks)
          .. string.char(deeds % 256, math.floor(deeds / 256) % 256, 0, 0)
    for i = 0, P.GATE_BYTES - 1 do s = s .. string.char((bytes or {})[i] or 0) end
    return s
end
local function pkt111(slots)
    local s = string.rep('\0', 4)
    for i = 0, P.SLOTS - 1 do
        local e = slots[i]
        s = s .. le32(e and (e[1] + e[2] * 4096) or 0)
    end
    return s
end
local function pkt112(quarter, ids)
    local b = {}
    for i = 1, P.BITS_BYTES do b[i] = 0 end
    for _, id in ipairs(ids) do
        if math.floor(id / (P.BITS_BYTES * 8)) == quarter then
            local within = id % (P.BITS_BYTES * 8)
            local byte = math.floor(within / 8) + 1
            b[byte] = b[byte] + 2 ^ (within % 8)
        end
    end
    local s = string.rep('\0', 4)
    for i = 1, P.BITS_BYTES do s = s .. string.char(b[i]) end
    return s .. string.char(quarter, 0, 0, 0)
end

-- 0x110: the capture of 2026-04-13 reported 99,999 Sparks and a Unity (Person) designator of 3
local p110 = P.parse_0x110(pkt110(99999, 12, {[0] = 2, [1] = 3, [7] = 255}))
check('0x110 sparks', p110.sparks == 99999, p110.sparks)
check('0x110 deeds', p110.deeds == 12, p110.deeds)
check('0x110 Unity (Shared) byte', p110.bytes[P.GATE_UNITY_SHARED] == 2, p110.bytes[0])
check('0x110 Unity (Leader) byte', p110.bytes[P.GATE_UNITY_LEADER] == 3, p110.bytes[1])
check('0x110 keeps all eight gate bytes', p110.bytes[7] == 255, p110.bytes[7])
check('0x110 Sparks is 24 bit', P.parse_0x110(pkt110(0xFF123456, 0, {})).sparks == 0x123456)
check('0x110 refuses a short packet', P.parse_0x110(string.rep('\0', 12)) == nil)

-- 0x111: the capture's own slots, including the ones past the 30 the packet library declares
local p111 = P.parse_0x111(pkt111({[0] = {12, 79}, [1] = {16, 121}, [2] = {57, 9}, [3] = {137, 1},
                                   [29] = {3768, 0}, [30] = {3769, 5}, [42] = {999, 7},
                                   [50] = {4001, 2}, [63] = {4018, 0}}))
check('0x111 reads all 64 slots', #p111.slots == 9, #p111.slots)
check('0x111 id and count', p111.slots[1].id == 12 and p111.slots[1].count == 79)
check('0x111 20 bit count', P.parse_0x111(pkt111({[0] = {4095, 1048575}})).slots[1].count == 1048575)
local kinds = {}
for _, s in ipairs(p111.slots) do kinds[s.slot] = s.kind end
check('0x111 slot 29 is drawn', kinds[29] == 'active', kinds[29])
check('0x111 slot 30 is counted but not drawn', kinds[30] == 'extra', kinds[30])
check('0x111 slot 42 is the second special id', kinds[42] == 'special', kinds[42])
check('0x111 slot 50 is the unconfirmed block', kinds[50] == 'other', kinds[50])
check('0x111 slot 63 is the limited-time challenge', kinds[63] == 'limited', kinds[63])
check('0x111 skips empty slots', P.parse_0x111(pkt111({})) and #P.parse_0x111(pkt111({})).slots == 0)
check('0x111 refuses a short packet', P.parse_0x111(string.rep('\0', 0x80)) == nil)

-- 0x112: four quarters, ids 0-4095
local bits = P.bitfield()
check('nothing is completed before a quarter arrives', bits:has(1) == false)
check('and it is not complete', bits:complete() == false)
local ids = {0, 1, 7, 8, 1023, 1024, 2047, 2048, 3071, 3072, 4095}
for qn = 0, 3 do bits:put(P.parse_0x112(pkt112(qn, ids))) end
check('0x112 is complete after four quarters', bits:complete())
local missing = 0
for _, id in ipairs(ids) do if not bits:has(id) then missing = missing + 1 end end
check('0x112 every bit set is read back', missing == 0, missing)
check('0x112 a bit beside a set one is clear', bits:has(2) == false and bits:has(1022) == false)
check('0x112 counts what is set', bits:count() == #ids, bits:count())
check('0x112 is bounded', bits:has(-1) == false and bits:has(4096) == false and bits:has('x') == false)
check('0x112 refuses a fifth quarter', P.parse_0x112(string.rep('\0', 0x84) .. string.char(4, 0, 0, 0)) == nil)
check('0x112 refuses a short packet', P.parse_0x112(string.rep('\0', 0x40)) == nil)
-- the same quarter again with no change is not a change
check('0x112 an unchanged quarter reports no change', bits:put(P.parse_0x112(pkt112(0, ids))) == false)
check('0x112 a changed quarter reports a change', bits:put(P.parse_0x112(pkt112(0, {5}))) == true)

-- 0x061 carries the Unity the client's own Unity requirement compares against
check('0x061 unity', P.parse_0x061(string.rep('\0', 0x58) .. le32(8)).unity == 8)
check('0x061 is the low five bits', P.parse_0x061(string.rep('\0', 0x58) .. le32(0x120 + 9)).unity == 9)
check('0x061 refuses a short packet', P.parse_0x061(string.rep('\0', 0x20)) == nil)

---------------------------------------------------------------------------
-- 5. gates, status and totals
---------------------------------------------------------------------------

local roe = dofile('core/roe.lua')
roe.attach('')

-- a character who has done nothing at all
roe.reset()
for qn = 0, 3 do roe.on_packet(0x112, pkt112(qn, {})) end
local fresh = roe.summary()
check('with nothing done the tree is nearly all locked', fresh.total < 200 and fresh.total > 0,
      fresh.total)
check('and the pool is still the whole catalogue', fresh.pool == 1508, fresh.pool)
check('Tutorial is the category that is open', fresh.cats[1].total > 0 and fresh.cats[1].name == 'Tutorial',
      fresh.cats[1].name .. ' ' .. fresh.cats[1].total)

-- record 1 ("First Step Forward") is what opens ten of the twelve categories
roe.reset()
for qn = 0, 3 do roe.on_packet(0x112, pkt112(qn, {1})) end
local one = roe.summary()
check('record 1 opens most of the tree', one.total > fresh.total * 3, one.total .. ' vs ' .. fresh.total)
check('and it counts as done', roe.status(1) == 'completed', roe.status(1))

-- the Unity gate: 220 objectives are offered to one Unity each
roe.reset()
for qn = 0, 3 do roe.on_packet(0x112, pkt112(qn, {1, 5})) end
roe.on_packet(0x110, pkt110(0, 0, {[0] = 0, [1] = 0}))
local no_unity = roe.summary()
roe.on_packet(0x061, string.rep('\0', 0x58) .. le32(8))
local unity8 = roe.summary()
-- Before the character packet arrives nothing is known about the player's Unity, so nothing is
-- locked on it. Once it is known, the ones offered to the other eleven drop out: 220 objectives
-- carry a Unity requirement, but they also carry the leader's rotation byte, which at 0 leaves
-- 55 of them, five per Unity -- so a known Unity costs 50 of the 55.
check('an unknown Unity locks nothing', no_unity.total > unity8.total,
      no_unity.total .. ' vs ' .. unity8.total)
check("knowing it leaves one Unity's share of the slice", no_unity.total - unity8.total == 50,
      no_unity.total - unity8.total)
roe.on_packet(0x061, string.rep('\0', 0x58) .. le32(9))
local unity9 = roe.summary()
check('a different Unity opens a different set, the same size', unity9.total == unity8.total,
      unity9.total .. ' vs ' .. unity8.total)

-- the gate byte: the Unity (Shared) rotation
roe.on_packet(0x110, pkt110(0, 0, {[0] = 3, [1] = 0}))
local rot3 = roe.summary()
roe.on_packet(0x110, pkt110(0, 0, {[0] = 4, [1] = 0}))
local rot4 = roe.summary()
check('the Unity (Shared) rotation changes which are offered, not how many',
      rot3.total == rot4.total and rot3.total > 0, rot3.total .. ' vs ' .. rot4.total)

-- a zone requirement never locks anything
local zone_gated = nil
for oid, g in pairs(ix.gates) do
    for _, packed in ipairs(g) do
        if math.floor(packed / 0x10000) == 4 then zone_gated = oid break end
    end
    if zone_gated then break end
end
check('there is a zone-gated objective to test', zone_gated ~= nil)
check('a zone requirement never locks', roe.locked(zone_gated) == nil)
local unk = roe.unknown_gates(zone_gated)
check('and the guide can name the zone', unk and unk[1] and unk[1].kind == 'zone' and unk[1].name,
      unk and unk[1] and unk[1].name)

-- the denominator: locked out, zone-gated in, and the parts add up to the whole
local sum = roe.summary()
local add_total, add_pool, add_done = 0, 0, 0
for ci, c in ipairs(sum.cats) do
    local st, sp = 0, 0
    for si = 1, #ix.cats[ci].subs do
        local s = roe.sub_summary(ci, si)
        st, sp = st + s.total, sp + s.pool
    end
    check('category ' .. ci .. ' is the sum of its sub-categories', st == c.total and sp == c.pool)
    add_total, add_pool, add_done = add_total + c.total, add_pool + c.pool, add_done + c.completed
end
check('the overall figure is the sum of the categories', add_total == sum.total and add_pool == sum.pool
      and add_done == sum.completed)
check('locked and counted make up the pool', sum.total + sum.locked == sum.pool,
      sum.total .. ' + ' .. sum.locked .. ' vs ' .. sum.pool)
check('the pool is the whole catalogue whatever the state', sum.pool == 1508, sum.pool)

-- status: the five states, and a repeatable that is done and running again
roe.reset()
for qn = 0, 3 do roe.on_packet(0x112, pkt112(qn, {1, 5, 16})) end
roe.on_packet(0x110, pkt110(0, 0, {[0] = 0, [1] = 0}))
roe.on_packet(0x061, string.rep('\0', 0x58) .. le32(8))
roe.on_packet(0x111, pkt111({[0] = {16, 53}, [1] = {12, 79}}))
check('ever completed', roe.status(1) == 'completed', roe.status(1))
check('completed and running again', roe.status(16) == 'repeat', roe.status(16))
check('slotted, never completed', roe.status(12) == 'active', roe.status(12))
check('the server count is the progress', roe.progress(12) == 79, roe.progress(12))
check('no count for an objective not slotted', roe.progress(11) == nil)
local some_locked = nil
for oid in pairs(seen) do if roe.status(oid) == 'locked' then some_locked = oid break end end
check('a locked objective says what unlocks it', some_locked and roe.locked(some_locked).kind ~= nil)

-- the category files are not all kept
local before = roe.loaded_categories()
for ci = 1, 12 do roe.cat_data(ci) end
check('at most two category files stay loaded', roe.loaded_categories() <= 2,
      roe.loaded_categories() .. ' (was ' .. before .. ')')

-- in progress
local prog = roe.in_progress()
check('in progress lists the slots', #prog == 2, #prog)
check('and names them from the catalogue', prog[1].name ~= nil and prog[1].name:find('%a') ~= nil)
roe.on_packet(0x111, pkt111({[63] = {4018, 3}}))
local lim = roe.in_progress()
check('a record in no menu category is still named', lim[1] and lim[1].name ~= 'Record 4018'
      and lim[1].known == false, lim[1] and lim[1].name)

-- the game's own order (Ui_RoeWnd_BuildActiveList): the limited-time challenge, then the second
-- special record, then slots 0-29 in slot order, which is the order they were accepted in
roe.on_packet(0x111, pkt111({[0] = {16, 1}, [5] = {12, 1}, [2] = {57, 1},
                             [35] = {3769, 1}, [42] = {11, 1}, [63] = {4018, 1}}))
local order = roe.in_progress()
local ids = {}
for i, e in ipairs(order) do ids[i] = e.id end
check('the limited-time challenge leads the list', ids[1] == 4018, ids[1])
check('then the second special record', ids[2] == 11, ids[2])
check('then the slots in slot order, not by progress', ids[3] == 16 and ids[4] == 57
      and ids[5] == 12, table.concat(ids, ','))
check('a slot the game draws nowhere is left out', #order == 5, #order)
check('and the count is the one the game prints', roe.active_count() == 5, roe.active_count())

---------------------------------------------------------------------------
-- 6. the screens
---------------------------------------------------------------------------

local KEEP = {'data/places_berrant.lua', 'data/pages_berrant.lua', 'data/places.lua', 'data/pages.lua'}
local restore = H.protect(KEEP)

local env = H.load({settings = {visible_on_load = false, active_tab = 'records'}})
local app, N = env.app, env.N
env.cmd('show')
local win = env.win()

check('the tab row has all three tabs', N.layers[1].text:find('Records', 1, true) ~= nil
      and N.layers[1].text:find('Missions', 1, true) ~= nil)
check('Records waits for data', N.layers[2].text:find('Waiting for data') ~= nil)

local function feed()
    for qn = 0, 3 do env.fire('incoming chunk', 0x112, pkt112(qn, {1, 5, 16, 2, 3, 4, 11})) end
    env.fire('incoming chunk', 0x110, pkt110(99999, 7, {[0] = 0, [1] = 0}))
    env.fire('incoming chunk', 0x111, pkt111({[0] = {16, 53}, [1] = {12, 79}, [63] = {4018, 1}}))
    env.fire('incoming chunk', 0x061, string.rep('\0', 0x58) .. le32(8))
end
feed()
win:invalidate('all')
win:flush()

check('Home draws the categories', N.layers[2].text:find('Tutorial', 1, true) ~= nil
      and N.layers[2].text:find('Harvesting', 1, true) ~= nil)
check('Home draws the overall figure', N.layers[1].text:find('Overall Completion', 1, true) ~= nil)
check('Home draws what is in progress', N.layers[2].text:find('In progress', 1, true) ~= nil
      and N.layers[2].text:find('79', 1, true) ~= nil)

local function hits(id)
    local out = {}
    for _, h in ipairs(win.content_b.hits) do if h.id == id then out[#out + 1] = h end end
    return out
end
check('one hit per category card', #hits('rcard') == 12, #hits('rcard'))
check('the limited-time slot has no hit of its own', #hits('robj') == 2, #hits('robj'))

-- the lit tab follows the screen, not the setting: a cross-link can open a record while the
-- setting still says quests, and a tab that lied about the section would be worse than no tab
do
    local cm = package.loaded['ui/screens/common']
    app.settings.active_tab = 'quest'
    app:roe_cat(1)
    check('a record screen lights Records', cm.tab_index(app) == 3, cm.tab_index(app))
    app:go('area', {cat = 'mission', area = 'cop'})
    check('an area screen lights its own tab', cm.tab_index(app) == 1, cm.tab_index(app))
    app:home()
    check('home follows the setting', cm.tab_index(app) == 2, cm.tab_index(app))
    app.settings.active_tab = 'records'
    app:home()
end

-- a packet while another tab is open must not redraw it
app.settings.active_tab = 'mission'
app:home()
win:flush()
local sent = N.sent[2]
env.fire('incoming chunk', 0x111, pkt111({[0] = {16, 54}}))
check('a Records packet does not redraw the Missions tab', N.sent[2] == sent, N.sent[2] - sent)
app.settings.active_tab = 'records'
app:home()
win:flush()

-- down the four levels and back up
local card = hits('rcard')[1]
local S = require('ui/screens/home')
S.click(card, {app = app, win = win, scroll = 0}, app)
win:flush()
check('a card opens its category', app.view.name == 'rcat' and app.view.params.ci == card.ci,
      app.view.name)
check('the category screen draws its sub-categories as rows', #hits('sub') > 0, #hits('sub'))
check('and the rows carry the derived hint', N.layers[2].text:find('First Step Forward', 1, true) ~= nil)

local Scat = require('ui/screens/rcat')
Scat.click(hits('sub')[1], {app = app, win = win, scroll = 0}, app)
win:flush()
check('a row opens its sub-category', app.view.name == 'rsub', app.view.name)
check('the list draws objectives', #hits('obj') > 0, #hits('obj'))

local Ssub = require('ui/screens/rsub')
Ssub.click(hits('obj')[1], {app = app, win = win, scroll = 0}, app)
win:flush()
check('a row opens its objective', app.view.name == 'robj', app.view.name)
check('the objective screen draws the client description',
      N.layers[2].text:find('Rolandienne', 1, true) ~= nil or N.layers[2].text:find('Details', 1, true) ~= nil)
check('four crumbs', #app:crumbs() == 4, #app:crumbs())

-- right click walks back up, one level at a time
local Sobj = require('ui/screens/robj')
Sobj.right(nil, {app = app, win = win}, app)
check('back to the sub-category', app.view.name == 'rsub', app.view.name)
Scat.right(nil, {app = app, win = win}, app)
check('back to the category', app.view.name == 'rcat', app.view.name)
Scat.right(nil, {app = app, win = win}, app)
check('back to Home', app.view.name == 'home', app.view.name)

-- the breadcrumbs go back too
app:roe_objective(1)
win:flush()
local crumbs = app:crumbs()
check('the breadcrumb names the path', crumbs[2].label == 'Tutorial' and crumbs[3].label == 'Basics'
      and crumbs[4].label == 'First Step Forward',
      crumbs[2].label .. ' / ' .. crumbs[3].label .. ' / ' .. crumbs[4].label)
crumbs[3].go()
check('a crumb opens the sub-category', app.view.name == 'rsub', app.view.name)

-- the cross-link opens the entry Chronicle already has
env.packets(H.fixture_packets(530))
local ci, si = app.roe.locate(1313)
app:go('robj', {ci = ci, si = si, id = 1313})
win:flush()
check('a wrapping objective offers the entry', N.layers[2].text:find('Smash the Orcish Scouts', 1, true) ~= nil)
local xl = hits('xlink')[1]
check('and it is clickable', xl ~= nil)
if xl then
    Sobj.click(xl, {app = app, win = win, scroll = 0}, app)
    check('which opens the mission', app.view.name == 'guide' and app.view.params.cat == 'mission'
          and app.view.params.area == 'sandoria', app.view.name .. ' ' .. tostring(app.view.params.area))
end

-- search, filter and sort on the list
app:roe_sub(1, 1)
win:flush()
local all = #hits('obj')
app.search = 'first step'
win:invalidate('all')
win:flush()
check('search narrows the list', #hits('obj') < all and #hits('obj') > 0, #hits('obj'))
app.search = ''
app.settings.roe_filter_mode = 2        -- Completed
win:invalidate('all')
win:flush()
local completed_rows = #hits('obj')
app.settings.roe_filter_mode = 5        -- Locked
win:invalidate('all')
win:flush()
check('the filters pick different rows', #hits('obj') ~= completed_rows or completed_rows == 0,
      completed_rows .. ' vs ' .. #hits('obj'))
app.settings.roe_filter_mode = 1
app.settings.roe_sort_mode = 2          -- Name
win:invalidate('all')
win:flush()
local items = app:roe_items(1, 1)
check('sorting by name is in order', items[1].name:lower() <= items[#items].name:lower())
app.settings.roe_sort_mode = 1

-- three window sizes, down to the minimum, on every new screen
local sizes = {{480, 360}, {620, 760}, {900, 900}}
local views = {{'home', {}}, {'rcat', {ci = 1}}, {'rsub', {ci = 1, si = 1}},
               {'robj', {ci = 1, si = 1, id = 1}}}
for _, sz in ipairs(sizes) do
    win.resize = {mode = 'xy', sx = 0, sy = 0, vw = win.w, vh = win.h, want = {sz[1], sz[2]}}
    env.frame()
    win.resize = nil
    for _, v in ipairs(views) do
        app:go(v[1], v[2])
        env.frame()
        win:flush()
        local ok = N.layers[1] and N.layers[2]
        check(('%s draws at %dx%d'):format(v[1], sz[1], sz[2]), ok)
        -- nothing drawn outside the window
        local over = 0
        for line in N.layers[2].text:gmatch('([^\n]+)') do
            local f = {}
            for t in (line .. '\t'):gmatch('([^\t]*)\t') do f[#f + 1] = t end
            if f[1] == 'T' and tonumber(f[2]) and tonumber(f[2]) > sz[1] then over = over + 1 end
        end
        check(('%s keeps its text inside %d px'):format(v[1], sz[1]), over == 0, over)
        app:home()
    end
end

restore()

---------------------------------------------------------------------------
print(('test_roe: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)

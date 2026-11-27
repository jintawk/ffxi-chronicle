--[[
    Chronicle: the Records of Eminence model.

    The catalogue is the client's own (roe/index.lua and roe/cNN.lua, written by
    tools/gen_roe.py); the live state comes from three packets (core/roe_packets.lua). This
    module joins the two: what an objective is, whether it is done, how far along it is, whether
    the client would currently offer it at all, and the counts every screen draws.

        roe.attach(dir)                 where the addon lives; the catalogue loads on first use
        roe.index()                     the catalogue index, loaded on demand (nil if missing)
        roe.cat_data(ci)                one category's text, rewards and cross-links
        roe.on_packet(id, data)         0x110 / 0x111 / 0x112 / 0x061; -> true when something changed
        roe.status(oid)                 completed | repeat | active | not_started | locked
        roe.progress(oid)               the server's count for a slotted objective, else nil
        roe.locked(oid)                 nil, or why it is not offered
        roe.unlock_text(id)             what the player does to set a hidden gate record (roe/unlocks.lua), else nil
        roe.summary()                   overall, and one entry per category
        roe.sub_summary(ci, si)         one sub-category
        roe.in_progress()               the active slots, each with name, goal and count
        roe.locate(oid)                 ci, si

    Status, and what counts towards a total:

      * `completed` is the ever-completed bit of 0x112. It stays set for a repeatable that is
        running again, which is what we want: a record is a thing you have done.
      * `repeat` is ever-completed and slotted again right now.
      * `active` is slotted and never completed.
      * `locked` is an objective the client would not currently show, because a requirement on
        it, on its sub-category or on its category fails. Chronicle still shows it, dimmed, with
        the record or the Unity that unlocks it, but leaves it out of the totals, so the
        percentage is the one the game itself would show.
      * A requirement Chronicle cannot evaluate never locks anything. That is only
        `zone_visited`, which no packet reports: those objectives are shown and counted, and
        the guide names the zone rather than claiming anything.
]]

local P = require('core/roe_packets')

local roe = {}

local dir = ''
local index = nil
local index_tried = false
roe.SPECIFIC_WHY = true      -- roe.locked names the deepest failing gate (see there)
local unlocks, unlocks_tried = nil, false     -- roe/unlocks.lua, read the first time a hidden gate is asked about
local cats = {}                 -- loaded category files, by index
local CATS_KEPT = 2             -- how many category files stay in the heap
local order = {}                -- most recently used first

local state = {
    sparks = nil, deeds = nil,
    bytes = nil,                -- the 0x110 gate byte table
    unity = nil,                -- the player's Unity, from 0x061
    act = {},                   -- objective id -> count, for every slot of 0x111
    kind = {},                  -- objective id -> which block of 0x111 it sat in
    slots = {},                 -- the 0x111 slots in order
    bits = P.bitfield(),
    zones = {},                 -- zones seen this session: a `zone_visited` maybe become a yes
}
roe.state = state

local where = nil               -- objective id -> {ci, si}, built with the index

-- Home draws twelve category figures, each the sum of its sub-categories, each of those a gate
-- check for every objective in it: 1,508 of them. The answers only change when a packet does,
-- so they are kept until one does.
local gen = 0
local cache = {lock = {}, sub = {}, cat = {}, all = nil}
local function dirty()
    gen = gen + 1
    cache.lock, cache.sub, cache.cat, cache.all = {}, {}, {}, nil
end
roe.dirty = dirty
function roe.generation() return gen end

---------------------------------------------------------------------------
-- the catalogue
---------------------------------------------------------------------------

function roe.attach(d)
    dir = d or ''
    index, index_tried, cats, order, where = nil, false, {}, {}, nil
    unlocks, unlocks_tried = nil, false
    dirty()
end

local function read(rel)
    local f = loadfile(dir .. rel)
    if not f then return nil end
    local ok, t = pcall(f)
    return ok and type(t) == 'table' and t or nil
end

function roe.index()
    if index or index_tried then return index end
    index_tried = true
    index = read('roe/index.lua')
    if index then
        where = {}
        for ci, c in ipairs(index.cats) do
            for si, s in ipairs(c.subs) do
                for _, oid in ipairs(s.o) do where[oid] = {ci, si} end
            end
        end
    end
    return index
end

-- The step that sets a hidden gate record: the client gates some objectives on records no menu shows, named for the developers
-- ("Scenarios 15"), so the record screen names the step instead (roe/unlocks.lua, from BG-wiki). nil for an id the table lacks.
function roe.unlock_text(id)
    if not unlocks_tried then
        unlocks_tried = true
        unlocks = read('roe/unlocks.lua')
    end
    return unlocks and unlocks[id] or nil
end

function roe.ready() return roe.index() ~= nil end

-- One category's heavy text. At most CATS_KEPT are kept: walking back up from an objective to
-- its list and across to the next category must not accumulate.
function roe.cat_data(ci)
    local ix = roe.index()
    local c = ix and ix.cats[ci]
    if not c then return nil end
    if not cats[ci] then
        cats[ci] = read(c.f) or {}
        table.insert(order, 1, ci)
        for i = #order, 1, -1 do
            if order[i] == ci and i > 1 then table.remove(order, i) end
        end
        while #order > CATS_KEPT do
            local drop = table.remove(order)
            cats[drop] = nil
        end
    else
        for i, v in ipairs(order) do
            if v == ci then table.remove(order, i) table.insert(order, 1, ci) break end
        end
    end
    return cats[ci]
end

function roe.loaded_categories() return #order end

function roe.locate(oid)
    roe.index()
    local w = where and where[oid]
    if w then return w[1], w[2] end
end

-- An objective's own record: name, goal count, repeat flag (the index), and, when its category
-- is loaded, its description, rewards and cross-link.
function roe.objective(oid)
    local ix = roe.index()
    if not ix or not ix.name[oid] then return nil end
    local o = {id = oid, name = ix.name[oid], goal = ix.goal[oid] or 1, repeatable = ix.rep[oid] == true}
    local ci = roe.locate(oid)
    local d = ci and roe.cat_data(ci)
    local e = d and d[oid]
    if e then
        o.desc, o.sparks, o.exp, o.cp, o.acc = e.d, e.s, e.x, e.c, e.a
        o.wrap, o.wrap_name = e.w, e.wn
    end
    return o
end

---------------------------------------------------------------------------
-- packets
---------------------------------------------------------------------------

-- -> true when a screen showing Records should be redrawn
function roe.on_packet(id, data)
    if id == 0x110 then
        local p = P.parse_0x110(data)
        if not p then return false end
        local changed = state.sparks ~= p.sparks or state.deeds ~= p.deeds
        if not changed and state.bytes then
            for i = 0, P.GATE_BYTES - 1 do
                if state.bytes[i] ~= p.bytes[i] then changed = true break end
            end
        else
            changed = true
        end
        state.sparks, state.deeds, state.bytes = p.sparks, p.deeds, p.bytes
        if changed then dirty() end
        return changed
    elseif id == 0x111 then
        local p = P.parse_0x111(data)
        if not p then return false end
        local act, kind, changed = {}, {}, false
        for _, s in ipairs(p.slots) do
            act[s.id], kind[s.id] = s.count, s.kind
            if state.act[s.id] ~= s.count then changed = true end
        end
        if not changed then
            for oid in pairs(state.act) do
                if act[oid] == nil then changed = true break end
            end
        end
        state.act, state.kind, state.slots = act, kind, p.slots
        if changed then dirty() end
        return changed
    elseif id == 0x112 then
        local changed = state.bits:put(P.parse_0x112(data))
        if changed then dirty() end
        return changed
    elseif id == 0x061 then
        local p = P.parse_0x061(data)
        if not p then return false end
        local changed = state.unity ~= p.unity
        state.unity = p.unity
        if changed then dirty() end
        return changed
    end
    return false
end

-- Chronicle sees the zones the player is in. That can only ever turn a `zone_visited`
-- requirement from "no way to tell" into "yes": it is never evidence that a zone was not
-- visited, and nothing is locked on it.
function roe.on_zone(zone)
    if type(zone) == 'number' and not state.zones[zone] then
        state.zones[zone] = true
        dirty()
    end
end

function roe.has_live_data() return state.bits:complete() end

-- the caches are rebuilt from the state: a switch such as roe.SPECIFIC_WHY was flipped (tests)
function roe.invalidate() dirty() end

-- A different character has different records: nothing survives a login or a logout.
function roe.reset()
    state.sparks, state.deeds, state.bytes, state.unity = nil, nil, nil, nil
    state.act, state.kind, state.slots, state.zones = {}, {}, {}, {}
    state.bits:reset()
    dirty()
end

---------------------------------------------------------------------------
-- visibility gates
---------------------------------------------------------------------------

roe.GATE = {quest_completed = 1, jobs_unlocked_mask = 2, job_level_at_least = 3, zone_visited = 4,
            skill_at_least = 5, pkt110_byte_equals = 6, unity_is = 7, any_job_level_at_most = 8}

-- One packed gate (type * 0x10000 + value) against the live state.
-- -> 'pass' | 'fail' | 'unknown', and for a failure what it wants.
function roe.check_gate(packed)
    local t = math.floor(packed / 0x10000)
    local v = packed % 0x10000
    if t == 1 then                              -- another record has to be completed
        if not state.bits:complete() then return 'unknown' end
        if state.bits:has(v) then return 'pass' end
        local ix = roe.index()
        return 'fail', {kind = 'record', id = v, name = ix and ix.gate_names[v]}
    elseif t == 4 then                          -- a zone has to have been visited
        local ix = roe.index()
        local name = ix and ix.zone_names[v]
        if state.zones[v] then return 'pass' end
        -- no packet carries the visited-zone table, so this never locks anything
        return 'unknown', {kind = 'zone', id = v, name = name}
    elseif t == 6 then                          -- a byte of 0x110 has to have a given value
        if not state.bytes then return 'unknown' end
        local idx, want = math.floor(v / 256), v % 256
        if state.bytes[idx] == want then return 'pass' end
        return 'fail', {kind = idx == P.GATE_UNITY_SHARED and 'rotation_shared'
                            or (idx == P.GATE_UNITY_LEADER and 'rotation_leader' or 'client_state'),
                        index = idx, want = want, got = state.bytes[idx]}
    elseif t == 7 then                          -- the player has to be in a given Unity
        if not state.unity then return 'unknown' end
        if state.unity == v then return 'pass' end
        return 'fail', {kind = 'unity', id = v}
    end
    -- job masks, job levels and skills: no current objective uses one, and nothing is locked on
    -- a requirement Chronicle does not read
    return 'unknown', {kind = 'unknown', type = t, value = v}
end

local function check_list(list, out)
    if not list then return true end
    for _, g in ipairs(list) do
        local r, why = roe.check_gate(g)
        if r == 'fail' then
            out.why = out.why or why
            return false
        end
    end
    return true
end

-- Why an objective is not currently offered, or nil. The client ANDs the requirements of the
-- category, the sub-category and the objective, so all three are checked.
function roe.locked(oid)
    local hit = cache.lock[oid]
    if hit ~= nil then return hit or nil end
    local ix = roe.index()
    if not ix then return nil end
    local ci, si = roe.locate(oid)
    if not ci then return nil end
    local out = {}
    local c = ix.cats[ci]
    local s = c.subs[si]
    -- The reason given is the most specific gate that fails: the objective's own, then its sub-category's, then its category's.
    -- A deeper gate implies the shallower ones (A Thousand Cuts' "800 unique objectives, the Brown Envelope" comes long after its
    -- list's "50 unique objectives"), and the first failure on the tree path named the list's gate on every record in it.
    -- roe.SPECIFIC_WHY = false is the order before.
    local first, second, third = ix.gates[oid], s.g, c.g
    if not roe.SPECIFIC_WHY then first, third = third, first end
    if check_list(first, out) and check_list(second, out) and check_list(third, out) then
        cache.lock[oid] = false
        return nil
    end
    cache.lock[oid] = out.why or {kind = 'unknown'}
    return cache.lock[oid]
end

-- The requirements Chronicle cannot evaluate for an objective (only ever `zone_visited`), so a
-- guide can say what the client is really waiting for.
function roe.unknown_gates(oid)
    local ix = roe.index()
    if not ix then return nil end
    local ci, si = roe.locate(oid)
    if not ci then return nil end
    local out = nil
    for _, list in ipairs({ix.cats[ci].g, ix.cats[ci].subs[si].g, ix.gates[oid] or {}}) do
        for _, g in ipairs(list) do
            local r, why = roe.check_gate(g)
            if r == 'unknown' and why then
                out = out or {}
                out[#out + 1] = why
            end
        end
    end
    return out
end

---------------------------------------------------------------------------
-- status and progress
---------------------------------------------------------------------------

function roe.progress(oid) return state.act[oid] end
function roe.is_active(oid) return state.act[oid] ~= nil end
function roe.done(oid) return state.bits:has(oid) end

function roe.status(oid)
    local done = state.bits:has(oid)
    local active = state.act[oid] ~= nil
    if done and active then return 'repeat' end
    if done then return 'completed' end
    if active then return 'active' end
    if roe.locked(oid) then return 'locked' end
    return 'not_started'
end

---------------------------------------------------------------------------
-- counts
---------------------------------------------------------------------------

-- A list of objective ids -> completed, total, active, locked.
-- The total is what the client would currently offer this character: a locked objective is
-- left out of it, and a zone-gated one is counted in, because it is one walk away.
function roe.tally(ids)
    local done, total, active, locked = 0, 0, 0, 0
    for _, oid in ipairs(ids) do
        if roe.locked(oid) then
            locked = locked + 1
        else
            total = total + 1
            if state.bits:has(oid) then done = done + 1 end
            if state.act[oid] ~= nil then active = active + 1 end
        end
    end
    return {completed = done, total = total, active = active, locked = locked,
            pool = #ids, has_data = state.bits:complete()}
end

function roe.sub_summary(ci, si)
    local key = ci * 1000 + si
    if cache.sub[key] then return cache.sub[key] end
    local ix = roe.index()
    local c = ix and ix.cats[ci]
    local s = c and c.subs[si]
    if not s then return nil end
    local t = roe.tally(s.o)
    t.name, t.hint, t.ci, t.si = s.n, s.h, ci, si
    cache.sub[key] = t
    return t
end

function roe.cat_summary(ci)
    if cache.cat[ci] then return cache.cat[ci] end
    local ix = roe.index()
    local c = ix and ix.cats[ci]
    if not c then return nil end
    local done, total, active, locked, pool = 0, 0, 0, 0, 0
    for si = 1, #c.subs do
        local t = roe.sub_summary(ci, si)
        done, total = done + t.completed, total + t.total
        active, locked, pool = active + t.active, locked + t.locked, pool + t.pool
    end
    cache.cat[ci] = {name = c.n, completed = done, total = total, active = active, locked = locked,
                     pool = pool, has_data = state.bits:complete(), ci = ci}
    return cache.cat[ci]
end

-- Home: the overall figure and one entry per category.
function roe.summary()
    if cache.all then return cache.all end
    local ix = roe.index()
    if not ix then return {completed = 0, total = 0, active = 0, locked = 0, pool = 0, cats = {}, has_data = false} end
    local out = {completed = 0, total = 0, active = 0, locked = 0, pool = 0,
                 has_data = state.bits:complete(), cats = {}}
    for ci = 1, #ix.cats do
        local c = roe.cat_summary(ci)
        out.cats[ci] = c
        out.completed, out.total = out.completed + c.completed, out.total + c.total
        out.active, out.locked, out.pool = out.active + c.active, out.locked + c.locked, out.pool + c.pool
    end
    cache.all = out
    return out
end

-- The objectives the server is counting right now: the 0x111 slots, each with the catalogue's
-- name and goal, in the order the game's own Current list puts them.
--
-- That order is the client's, read out of Ui_RoeWnd_BuildActiveList: the limited-time challenge
-- first (slot 63), then the second special record (slot 42), then slots 0-29 in slot order,
-- which is the order the records were accepted in. Slots 30-41 are counted when the client sizes
-- the list but never written into it, so they appear in no list the game draws and none here.
local RANK_LIMITED, RANK_SPECIAL = -2, -1
function roe.in_progress()
    local ix = roe.index()
    if not ix then return {} end
    local out = {}
    for _, s in ipairs(state.slots) do
        if s.kind == 'active' or s.kind == 'limited' or s.kind == 'special' then
            -- a slot can hold a record that is in no menu category (a rotation pool member, or
            -- the limited-time challenge): the index names those too, and the row then says
            -- what it is even though there is no list to open it from
            local x = ix.extra and ix.extra[s.id]
            local name = ix.name[s.id] or (x and x[1])
            local goal = ix.goal[s.id] or (x and x[2]) or 1
            local rank = s.slot
            if s.kind == 'limited' then rank = RANK_LIMITED
            elseif s.kind == 'special' then rank = RANK_SPECIAL end
            out[#out + 1] = {id = s.id, name = name or ('Record ' .. s.id), goal = goal,
                             count = s.count, limited = s.kind == 'limited', slot = s.slot,
                             known = ix.name[s.id] ~= nil, rank = rank}
        end
    end
    table.sort(out, function(a, b) return a.rank < b.rank end)
    return out
end

-- The number the game prints beside its Current list, counted the way the client counts it in
-- Ui_RoeWnd_DrawHeaderTitle: the filled slots of 0-29, plus one each for the limited-time
-- challenge and the second special record, against a fixed 30.
function roe.active_count()
    local n = 0
    for _, s in ipairs(state.slots) do
        if s.kind == 'active' or s.kind == 'limited' or s.kind == 'special' then n = n + 1 end
    end
    return n
end
roe.ACTIVE_SLOTS = 30

return roe

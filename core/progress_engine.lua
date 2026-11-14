--[[
    core/progress_engine.lua - quest step progress: one entry's step mapping (progress/<cat>/<area>/<id>.lua) plus the
    observations seen so far -> a state per step. Pure Lua 5.1, no Windower calls. From the research pilot
    (the research pilot); core/progress.lua folds the five
    states into the three the player sees.

        local E = require('core/progress_engine')
        local r = E.evaluate(mapping, observations)
        r.steps[id].state  -- 'done_observed' | 'done_inferred' | 'current' | 'not_yet' | 'unknown'

    An observation, already decoded:
      {t='event', zone, event, p={[0]=..}}  0x032/0x034 at an NPC     {t='zonein', zone, event}  0x00A
      {t='ki', id, gained=bool}  0x055 change     {t='ki_have', id, have=bool}  0x055 at login
      {t='item', id, delta}  inventory change     {t='item_have', id, count}  inventory at login
      {t='chat', text}  incoming text             {t='quest', current, completed}  0x056 bits of this quest
      {t='mission', line, current[, completed=true]}  0x056 value   {t='word', value}  0x056 0xFFFF +0x14 (CoP progress word)
    A matcher has the same shape (fields it names must agree) plus: re (chat pattern), gained/lost (item delta sign),
    min/max/eq (mission value; word nibble `nib`), completed (mission: true = the id entered the completed set,
    false = it became the current mission), p (event params), conf='inferred', after='sN' (counts only once step
    sN is done; a login snapshot is tried again until nothing changes, so its order does not matter), run1=true (first run only). An observation from a login snapshot carries snap=true.
    A step: {id, done={matchers}, reach={matchers}, kind=nil|'optional'|'branch'|'note'|'post', with='sN', group='main',
    implies={'sN'}, count={item, need}}. A mapping: {steps, groups={[g]={start=.., silent_until='sN'}},
    known={matchers}, repeatable={restart={'sN'}, skip={'sN'}}, completes='sN'}.
]]

local E = {}

local function nibble(v, n) return math.floor(v / 16 ^ n) % 16 end

-- the CoP word as the client reads it (Net_In_0x056 0x10098ad0): low five nibbles, each clamped to 9
function E.cop_word(word)
    local raw, client = {}, {}
    for n = 0, 7 do raw[n] = nibble(word, n) end
    for n = 0, 4 do client[n] = math.min(raw[n], 9) end
    return raw, client
end

-- matcher m against observation o -> nil | 'observed' | 'inferred'
function E.match(m, o)
    if m.t ~= o.t then return nil end
    local conf = m.conf or 'observed'
    for _, k in ipairs({'zone', 'event', 'id', 'line'}) do
        if m[k] ~= nil and m[k] ~= o[k] then return nil end
    end
    if o.t == 'event' and m.p then
        for i, v in pairs(m.p) do if not o.p or o.p[i] ~= v then return nil end end
    elseif o.t == 'ki' and m.gained ~= nil then
        if m.gained ~= o.gained then return nil end
    elseif o.t == 'ki_have' and m.have ~= nil then
        if m.have ~= o.have then return nil end
    elseif o.t == 'item' then
        if (m.gained and o.delta <= 0) or (m.lost and o.delta >= 0) then return nil end
    elseif o.t == 'item_have' then
        if (o.count or 0) < (m.min or 1) then return nil end
    elseif o.t == 'chat' then
        if not o.text:find(m.re) then return nil end
    elseif o.t == 'quest' then
        if m.current ~= nil and m.current ~= o.current then return nil end
        if m.completed ~= nil and m.completed ~= o.completed then return nil end
    elseif (o.t == 'mission' or o.t == 'word') and (o.t == 'mission' or m.nib) then
        local v = o.t == 'word' and nibble(o.value, m.nib) or o.current
        -- completed: true is the id entering the completed set, false the line moving to it, nil either
        if o.t == 'mission' and m.completed ~= nil and m.completed ~= (o.completed == true) then return nil end
        if m.eq and v ~= m.eq then return nil end
        if m.min and v < m.min then return nil end
        if m.max and v > m.max then return 'inferred' end    -- a later value: this step is behind it
    end
    return conf
end

local function any(list, o)
    local best
    for _, m in ipairs(list or {}) do
        local c = E.match(m, o)
        if c == 'observed' then return c, m end
        if c and not best then best = {c, m} end
    end
    if best then return best[1], best[2] end
end

function E.evaluate(map, obs)
    local byid, order = {}, {}
    for i, s in ipairs(map.steps) do byid[s.id] = s order[i] = s end
    local st, known, inv, run, by
    local latest                 -- the time of the last live observation that moved a step (nil: only login snapshots)
    local function reset()
        st, by = {}, {}
        for _, s in ipairs(order) do st[s.id] = {} by[s.id] = {} end
    end
    reset() run, known, inv = 1, false, {}
    local gactive = {}
    local function done(id) return st[id].obs or st[id].inf end
    local function mark(id, c, why, live)
        if c == 'observed' then st[id].obs = true else st[id].inf = true end
        st[id].live = st[id].live or live
        table.insert(by[id], why)
        for _, j in ipairs(byid[id].implies or {}) do if not done(j) then mark(j, 'inferred', 'implied by ' .. id, live) end end
    end
    local function run_complete() return map.completes and done(map.completes) end

    -- one observation against every step's matchers. retry = the second look at a login snapshot, which only tries the
    -- matchers that name an `after` step and skips steps that are already proven
    local snaps = {}
    local function moved(o) if o.time and not o.snap and o.time > (latest or 0) then latest = o.time end end
    local function scan(o, retry)
        local changed = false
        for _, s in ipairs(order) do
            -- the completed set read at login says the mission was finished once: history, not this run's progress, so it
            -- is not applied to a later run of a repeatable mission
            local history = o.t == 'mission' and o.snap and o.completed and run > 1
            local ok = function(m)
                if retry and not m.after then return false end
                return (not m.after or done(m.after)) and (not m.run1 or run == 1) and not history
            end
            if not (retry and done(s.id)) then
                for _, m in ipairs(s.done or {}) do
                    local c = ok(m) and E.match(m, o)
                    if c then known = true mark(s.id, c, m.why or o.t, not o.snap) changed = true moved(o) break end
                end
            end
            if not (retry and st[s.id].reached) then
                for _, m in ipairs(s.reach or {}) do
                    if ok(m) and E.match(m, o) then
                        known = true st[s.id].reached = true changed = true moved(o)
                        table.insert(by[s.id], 'reached: ' .. (m.why or o.t)) break
                    end
                end
            end
        end
        return changed
    end

    for _, o in ipairs(obs) do
        if o.t == 'item' then inv[o.id] = (inv[o.id] or 0) + o.delta
        elseif o.t == 'item_have' then inv[o.id] = o.count end
        if any(map.known, o) then known = true end
        -- a repeatable quest: a restart step seen after a finished run opens a new run
        if map.repeatable and run_complete() then
            for _, id in ipairs(map.repeatable.restart) do
                local c, m = any(byid[id].done, o)
                if c and not m.run1 then
                    reset() run = run + 1
                    for _, sk in ipairs(map.repeatable.skip or {}) do mark(sk, 'inferred', 'not needed on a repeat') end
                    break
                end
            end
        end
        scan(o, false)
        if o.snap then snaps[#snaps + 1] = o end
        for g, gd in pairs(map.groups or {}) do
            if any(gd.start, o) then known = true gactive[g] = true end
        end
    end

    -- a login snapshot is read in no particular order (the completed ids ascending, so the whole mission's id comes before the
    -- legs that tell which route was taken): matchers waiting on an `after` step get another look until nothing changes
    local again = #snaps > 0
    while again do
        again = false
        for _, o in ipairs(snaps) do if scan(o, true) then again = true end end
    end

    -- states, group by group in page order
    local res = {steps = {}, run = run, complete = run_complete() and true or false, known = known, last = latest}
    local groups = {}
    for i, s in ipairs(order) do
        local g = s.group or 'main'
        groups[g] = groups[g] or {}
        table.insert(groups[g], i)
    end
    for g, idx in pairs(groups) do
        local gd = (map.groups or {})[g] or {}
        local last = 0
        for k, i in ipairs(idx) do
            local s = order[i]
            if (done(s.id) or st[s.id].reached) and (not s.kind or s.kind == 'post') then last = k end
        end
        local active = last > 0 or gactive[g]
        local lastreq = 0          -- the group's last required step done: a skipped option is unknown, not "to do"
        for k, i in ipairs(idx) do if not order[i].kind or order[i].kind == 'post' then lastreq = k end end
        local finished = lastreq > 0 and last == lastreq and done(order[idx[lastreq]].id)
        local silent = gd.silent_until ~= nil
        local now_set = false
        local passed_silent = false
        for k, i in ipairs(idx) do
            local s = order[i]
            if s.id == gd.silent_until then passed_silent = true end
            local state
            if st[s.id].obs then state = 'done_observed'
            elseif st[s.id].inf then state = 'done_inferred'
            elseif s.kind == 'note' then state = nil
            elseif s.kind == 'post' and k > last then   -- after the log's completion: due if it completed live
                local c = map.completes and st[map.completes]
                if now_set then state = 'not_yet'
                elseif c and c.live then state = 'current' now_set = true
                elseif c and (c.obs or c.inf) then state = 'unknown' else state = 'not_yet' end
            elseif s.kind and s.kind ~= 'post' then state = (k < last or finished or not known) and 'unknown' or 'not_yet'
            elseif k < last then state = 'done_inferred'
            elseif not known then state = 'unknown'
            elseif active and not now_set then state = 'current' now_set = true
            elseif not active and silent and not passed_silent then state = 'unknown'
            else state = 'not_yet' end
            if state == 'done_inferred' and k < last and #by[s.id] == 0 then by[s.id] = {'a later step is done'} end
            res.steps[s.id] = {state = state, by = by[s.id], step = s}
            if state == 'current' and s.count then
                res.steps[s.id].count = math.min(inv[s.count.item] or 0, s.count.need) .. '/' .. s.count.need
            end
        end
    end
    for _, s in ipairs(order) do    -- notes take their step's state (a note is never seen itself)
        if s.kind == 'note' then
            local w = res.steps[s.with].state
            res.steps[s.id].state = (w == 'done_observed') and 'done_inferred' or w
        end
    end
    return res
end

-- the page text of a step bullet, folded, for fingerprints (icon spans are pictures, not words)
function E.fold(spans)
    local t = {}
    for _, sp in ipairs(spans) do if sp.t ~= 'icon' then t[#t + 1] = sp.s or '' end end
    return (table.concat(t):lower():gsub('[^%w]+', ' '):gsub('^ +', ''))
end

return E

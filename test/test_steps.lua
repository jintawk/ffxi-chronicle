--[[
    test_steps.lua - the checks that gate every step mapping (progress/<cat>s/<area>/<id>.lua, listed in progress/index.lua).
    Offline, no game. Exits non-zero on any failure.

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_steps.lua
        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_steps.lua --selftest

    For every entry in progress/index.lua:
      index     the key is cat|area|id, its file exists at progress/<cat>s/<area>/<id>.lua, loads and returns a table,
                the entry has a page in pages/index.lua; every mapping file on disk is listed
      schema    known top-level, step and matcher fields only; step ids unique; kind nil|note|optional|branch|post; a note
                has `with` naming a real step; completes, silent_until, after, implies, repeatable ids name real steps;
                each matcher's `t` is known and carries the fields its type needs, with the right types; a chat `re`
                is a valid Lua pattern, also once lower-cased (core/progress.lua matches in lower case)
      page      each step's at.n is a top-level bullet of its tab (or of the page outside tabs) counted as the checkbox
                drawing counts it, and the bullet's folded text starts with at.fp; then the real ui/doc.lua D.draw
                is run with every step mapped and must draw a checkbox for every step that is not a note
      strength  every step that is not note/optional/branch has a strong done matcher: event, chat, quest, mission,
                word, zonein or ki (an item alone can come from elsewhere, and a reward key item may already be owned)
      sim       the engine plus core/progress.lua's own fold: one observation per required step, built from its first
                strong matcher, fed in step order; after each, every required step so far is done and the next required
                step of its group is next. Then a fresh run with only a completed quest-log snapshot shows every step
                up to the `completes` step done (post bullets after it stay open by design)
      loader    core/progress.lua's own loader (P.init, P.for_page) loads the entry

    --selftest injects one fault per check into an in-memory copy of the first mapping (and of the index) and requires
    each to be caught, while the clean copy raises none of them.

    Counting: D.draw counts steps inline (step_marks in ui/doc.lua, not a function this test can call), so page_items()
    below replicates it: list blocks directly in the page or in a tab (keyed by the tab's label), every item of a list
    block counts, boxes count nothing; a bullet is marked only in a list block with no indent (level 1). The real draw
    is then run as well, so a drift between the two shows as a [draw] failure.
]]

package.path = './?.lua;' .. package.path
local E = require('core/progress_engine')
local P = require('core/progress')
local D = require('ui/doc')
local ops = require('ui/ops')
local kit = require('ui/kit')

local SELFTEST = arg and arg[1] == '--selftest'

local pass, fail = 0, 0
local function check(cond, what)
    if cond then pass = pass + 1 else fail = fail + 1 print('FAIL ' .. what) end
end

local function deepcopy(v)
    if type(v) ~= 'table' then return v end
    local t = {}
    for k, x in pairs(v) do t[k] = deepcopy(x) end
    return t
end

---------------------------------------------------------------------------
-- Lua patterns: validation (lstrlib 5.1's rules) and a sample text that matches
---------------------------------------------------------------------------

-- the end (one past ']') of the set starting at i ('['), or nil, err; as lstrlib's classEnd
local function set_end(p, i)
    local j, n = i + 1, #p
    if p:sub(j, j) == '^' then j = j + 1 end
    repeat
        if j > n then return nil, "malformed pattern (missing ']')" end
        local c = p:sub(j, j)
        j = j + 1
        if c == '%' then
            if j > n then return nil, "malformed pattern (missing ']')" end
            j = j + 1
        end
    until p:sub(j, j) == ']'
    return j + 1
end

-- nil when p is a valid Lua 5.1 pattern, else why not
local function pattern_error(p)
    if type(p) ~= 'string' then return 'not a string' end
    if p == '' then return 'empty pattern' end
    local i, n = 1, #p
    if p:sub(1, 1) == '^' then i = 2 end
    local open, closed = 0, 0
    while i <= n do
        local c = p:sub(i, i)
        local single = true
        if c == '(' then
            open = open + 1 i = i + 1 single = false
        elseif c == ')' then
            if open == 0 then return 'invalid pattern capture' end
            open = open - 1 closed = closed + 1 i = i + 1 single = false
        elseif c == '$' and i == n then
            i = i + 1 single = false
        elseif c == '%' then
            local d = p:sub(i + 1, i + 1)
            if d == '' then return "malformed pattern (ends with '%')" end
            if d == 'b' then
                if i + 3 > n then return 'unbalanced pattern' end
                i = i + 4 single = false
            elseif d == 'f' then
                if p:sub(i + 2, i + 2) ~= '[' then return "missing '[' after '%f' in pattern" end
                local e, err = set_end(p, i + 2)
                if not e then return err end
                i = e single = false
            elseif d:match('%d') then
                local l = tonumber(d)
                if l == 0 or l > closed then return 'invalid capture index %' .. d end
                i = i + 2 single = false
            else
                i = i + 2
            end
        elseif c == '[' then
            local e, err = set_end(p, i)
            if not e then return err end
            i = e
        else
            i = i + 1
        end
        if single and i <= n and p:sub(i, i):match('[%*%+%-%?]') then i = i + 1 end
    end
    if open > 0 then return 'unfinished capture' end
    local ok, err = pcall(string.find, 'sample text 123', p)
    if not ok then return err end
    return nil
end

-- core/progress.lua lower-cases every chat pattern; a class letter in upper case (%A %S %W %D %U ...) changes meaning
local function lower_error(p)
    local i = 1
    while i <= #p do
        if p:sub(i, i) == '%' then
            local d = p:sub(i + 1, i + 1)
            if d:match('%u') then return '%' .. d .. ' changes meaning once the pattern is lower-cased' end
            i = i + 2
        else
            i = i + 1
        end
    end
    return pattern_error(p:lower())
end

local PREFER = {}
for c in ('abcdefghijklmnopqrstuvwxyz0123456789 .,!?\'-:ABCDEFGHIJKLMNOPQRSTUVWXYZ'):gmatch('.') do PREFER[#PREFER + 1] = c end
for b = 1, 126 do PREFER[#PREFER + 1] = string.char(b) end
local function one_char(item)
    for _, c in ipairs(PREFER) do if c:find('^' .. item .. '$') then return c end end
end

-- a text that p (already valid) finds, or nil
local function sample(p)
    local out, i, n = {}, 1, #p
    if p:sub(1, 1) == '^' then i = 2 end
    while i <= n do
        local c = p:sub(i, i)
        if c == '(' or c == ')' then i = i + 1
        elseif c == '$' and i == n then i = i + 1
        elseif c == '%' and p:sub(i + 1, i + 1) == 'b' then out[#out + 1] = p:sub(i + 2, i + 3) i = i + 4
        elseif c == '%' and p:sub(i + 1, i + 1) == 'f' then i = set_end(p, i + 2)
        elseif c == '%' and p:sub(i + 1, i + 1):match('%d') then return nil
        else
            local j
            if c == '%' then j = i + 2
            elseif c == '[' then j = set_end(p, i)
            else j = i + 1 end
            local item, q = p:sub(i, j - 1), p:sub(j, j)
            if q == '*' or q == '-' or q == '?' then
                j = j + 1
            else
                local ch = one_char(item)
                if not ch then return nil end
                out[#out + 1] = ch
                if q == '+' then j = j + 1 end
            end
            i = j
        end
    end
    local s = table.concat(out)
    if s:find(p) then return s end
    return nil
end

---------------------------------------------------------------------------
-- the schema
---------------------------------------------------------------------------

local KINDS = {note = true, optional = true, branch = true, post = true}
local STRONG = {event = true, chat = true, quest = true, mission = true, word = true, zonein = true, ki = true}
local MAP_KEYS = {title = true, completes = true, known = true, steps = true, groups = true, repeatable = true}
local STEP_KEYS = {id = true, at = true, done = true, reach = true, kind = true, with = true, group = true, implies = true, count = true}
local AT_KEYS = {n = true, fp = true, tab = true}
local GROUP_KEYS = {start = true, silent_until = true, label = true}
local COMMON = {t = true, why = true, conf = true, after = true, run1 = true}
-- per type: field -> {check, required}
local function int(v) return type(v) == 'number' and v == math.floor(v) end
local function bool(v) return type(v) == 'boolean' end
local function params(v)
    if type(v) ~= 'table' then return false end
    for k, x in pairs(v) do if not (int(k) and k >= 0 and k <= 7 and int(x)) then return false end end
    return true
end
local function line(v) return type(v) == 'string' or int(v) end
local function nib(v) return int(v) and v >= 0 and v <= 7 end
local function str(v) return type(v) == 'string' end
local TYPES = {
    event = {zone = {int, true}, event = {int, true}, p = {params}},
    zonein = {zone = {int, true}, event = {int}},
    ki = {id = {int, true}, gained = {bool, true}},
    ki_have = {id = {int, true}, have = {bool, true}},
    item = {id = {int, true}, gained = {bool}, lost = {bool}},
    -- no item_have: core/progress.lua never observes the inventory at login, so such a matcher could never prove a step
    -- (review CORE-14)
    chat = {re = {str, true}},
    quest = {current = {bool}, completed = {bool}},
    mission = {line = {line, true}, eq = {int}, min = {int}, max = {int}, completed = {bool}},
    word = {nib = {nib, true}, eq = {int}, min = {int}, max = {int}},
}
local TYPE_NAMES = {}
for k in pairs(TYPES) do TYPE_NAMES[#TYPE_NAMES + 1] = k end
table.sort(TYPE_NAMES)

local function err(errs, tag, msg) errs[#errs + 1] = {tag = tag, msg = '[' .. tag .. '] ' .. msg} end

local function sorted_keys(t)
    local out = {}
    for k in pairs(t) do out[#out + 1] = tostring(k) end
    table.sort(out)
    return out
end

local function is_array(t)
    if type(t) ~= 'table' then return false end
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n == #t
end

-- a matcher list (done, reach, known, start) in context `where`; ids = the step ids
local function check_matchers(list, where, ids, errs, matcher_ctx)
    if list == nil then return end
    if not is_array(list) then err(errs, 'schema', where .. ' is not a list of matchers') return end
    for i, m in ipairs(list) do
        local at = where .. '[' .. i .. ']'
        if type(m) ~= 'table' then err(errs, 'schema', at .. ' is not a table')
        else
            local spec = TYPES[m.t]
            if not spec then
                err(errs, 'matcher', at .. ': unknown t ' .. tostring(m.t) .. ' (known: ' .. table.concat(TYPE_NAMES, ', ') .. ')')
            else
                for _, k in ipairs(sorted_keys(m)) do
                    if not COMMON[k] and not spec[k] then err(errs, 'matcher', at .. ' (' .. m.t .. '): unknown field ' .. k) end
                end
                for k, sp in pairs(spec) do
                    local v = m[k]
                    if v == nil then
                        if sp[2] then err(errs, 'matcher', at .. ' (' .. m.t .. '): needs ' .. k) end
                    elseif not sp[1](v) then
                        err(errs, 'matcher', at .. ' (' .. m.t .. '): ' .. k .. ' has the wrong type (' .. tostring(v) .. ')')
                    end
                end
                if m.t == 'chat' and type(m.re) == 'string' then
                    local e = pattern_error(m.re) or lower_error(m.re)
                    if e then err(errs, 'chat', at .. ': pattern "' .. m.re .. '" does not compile: ' .. e) end
                end
                if m.t == 'zonein' and m.event == nil then
                    err(errs, 'matcher', at .. ' (zonein): names no event id, so the engine can never match it (P.on_zonein keeps only zone/event pairs a mapping names)')
                end
                if m.t == 'item' and m.gained and m.lost then err(errs, 'matcher', at .. ' (item): both gained and lost') end
                if m.t == 'quest' and matcher_ctx ~= 'known' and m.current == nil and m.completed == nil then
                    err(errs, 'matcher', at .. ' (quest): names neither current nor completed, so any quest-log read matches it')
                end
                if (m.t == 'mission' or m.t == 'word') and m.eq == nil and m.min == nil and m.max == nil then
                    err(errs, 'matcher', at .. ' (' .. m.t .. '): needs eq, min or max')
                end
            end
            if m.why ~= nil and type(m.why) ~= 'string' then err(errs, 'matcher', at .. ': why is not a string') end
            if m.conf ~= nil and m.conf ~= 'inferred' then err(errs, 'matcher', at .. ': conf must be nil or inferred') end
            if m.run1 ~= nil and type(m.run1) ~= 'boolean' then err(errs, 'matcher', at .. ': run1 is not a boolean') end
            if m.after ~= nil and not ids[m.after] then err(errs, 'ref', at .. ': after names no step (' .. tostring(m.after) .. ')') end
        end
    end
end

local function check_schema(m, errs)
    if type(m) ~= 'table' then err(errs, 'load', 'the mapping is not a table') return false end
    for _, k in ipairs(sorted_keys(m)) do
        if not MAP_KEYS[k] then err(errs, 'schema', 'unknown top-level field ' .. k) end
    end
    if m.title ~= nil and type(m.title) ~= 'string' then err(errs, 'schema', 'title is not a string') end
    if not is_array(m.steps) or #m.steps == 0 then err(errs, 'schema', 'steps is not a non-empty list') return false end
    local ids, kind_of = {}, {}
    for i, s in ipairs(m.steps) do
        if type(s) ~= 'table' then err(errs, 'schema', 'step ' .. i .. ' is not a table') return false end
        if type(s.id) ~= 'string' or s.id == '' then err(errs, 'schema', 'step ' .. i .. ' has no string id')
        elseif ids[s.id] then err(errs, 'id', 'step id ' .. s.id .. ' is used twice')
        else ids[s.id] = true kind_of[s.id] = s.kind end
    end
    for i, s in ipairs(m.steps) do
        local name = 'step ' .. tostring(s.id or i)
        for _, k in ipairs(sorted_keys(s)) do
            if not STEP_KEYS[k] then err(errs, 'schema', name .. ': unknown field ' .. k) end
        end
        if s.kind ~= nil and not KINDS[s.kind] then
            err(errs, 'kind', name .. ': unknown kind ' .. tostring(s.kind) .. ' (nil, note, optional, branch, post)')
        end
        if s.kind == 'note' then
            if s.with == nil then err(errs, 'with', name .. ': a note needs `with`, the step whose state it takes')
            elseif not ids[s.with] then err(errs, 'with', name .. ': with names no step (' .. tostring(s.with) .. ')')
            elseif kind_of[s.with] == 'note' then err(errs, 'with', name .. ': with names another note (' .. s.with .. ')') end
        elseif s.with ~= nil then
            err(errs, 'with', name .. ': `with` is only for a note')
        end
        if type(s.at) ~= 'table' then err(errs, 'at', name .. ': no `at` address')
        else
            for _, k in ipairs(sorted_keys(s.at)) do
                if not AT_KEYS[k] then err(errs, 'at', name .. ': unknown at field ' .. k) end
            end
            if not int(s.at.n) or s.at.n < 1 then err(errs, 'at', name .. ': at.n is not a positive integer') end
            if type(s.at.fp) ~= 'string' or s.at.fp == '' then err(errs, 'at', name .. ': at.fp is not a non-empty string')
            elseif s.at.fp:find('[^a-z0-9 ]') or s.at.fp:sub(1, 1) == ' ' then
                err(errs, 'at', name .. ': at.fp "' .. s.at.fp .. '" is not folded text (lower case letters, digits, single spaces)')
            end
            if s.at.tab ~= nil and type(s.at.tab) ~= 'string' then err(errs, 'at', name .. ': at.tab is not a string') end
        end
        check_matchers(s.done, name .. '.done', ids, errs)
        check_matchers(s.reach, name .. '.reach', ids, errs)
        if s.group ~= nil and type(s.group) ~= 'string' then err(errs, 'schema', name .. ': group is not a string') end
        if s.implies ~= nil then
            if not is_array(s.implies) then err(errs, 'ref', name .. ': implies is not a list')
            else for _, j in ipairs(s.implies) do if not ids[j] then err(errs, 'ref', name .. ': implies names no step (' .. tostring(j) .. ')') end end end
        end
        if s.count ~= nil then
            if type(s.count) ~= 'table' or not int(s.count.item) or not int(s.count.need) or s.count.need < 1 then
                err(errs, 'schema', name .. ': count needs item and need (integers)')
            end
        end
    end
    if m.completes ~= nil and not ids[m.completes] then err(errs, 'ref', 'completes names no step (' .. tostring(m.completes) .. ')') end
    check_matchers(m.known, 'known', ids, errs, 'known')
    if m.groups ~= nil then
        if type(m.groups) ~= 'table' then err(errs, 'schema', 'groups is not a table')
        else
            for g, gd in pairs(m.groups) do
                if type(gd) ~= 'table' then err(errs, 'schema', 'group ' .. tostring(g) .. ' is not a table')
                else
                    for _, k in ipairs(sorted_keys(gd)) do
                        if not GROUP_KEYS[k] then err(errs, 'schema', 'group ' .. tostring(g) .. ': unknown field ' .. k) end
                    end
                    if gd.silent_until ~= nil then
                        if not ids[gd.silent_until] then
                            err(errs, 'ref', 'group ' .. tostring(g) .. ': silent_until names no step (' .. tostring(gd.silent_until) .. ')')
                        else
                            for _, s in ipairs(m.steps) do
                                if s.id == gd.silent_until and (s.group or 'main') ~= g then
                                    err(errs, 'ref', 'group ' .. tostring(g) .. ': silent_until names a step of group ' .. (s.group or 'main'))
                                end
                            end
                        end
                    end
                    check_matchers(gd.start, 'group ' .. tostring(g) .. '.start', ids, errs)
                end
            end
        end
    end
    if m.repeatable ~= nil then
        local r = m.repeatable
        if type(r) ~= 'table' or not is_array(r.restart) or #r.restart == 0 then
            err(errs, 'schema', 'repeatable needs a restart list')
        else
            for _, j in ipairs(r.restart) do if not ids[j] then err(errs, 'ref', 'repeatable.restart names no step (' .. tostring(j) .. ')') end end
            for _, j in ipairs(r.skip or {}) do if not ids[j] then err(errs, 'ref', 'repeatable.skip names no step (' .. tostring(j) .. ')') end end
        end
    end
    return true
end

---------------------------------------------------------------------------
-- strength
---------------------------------------------------------------------------

local function required(s) return s.kind == nil or s.kind == 'post' end

local function first_strong(s)
    for _, m in ipairs(s.done or {}) do if type(m) == 'table' and STRONG[m.t] then return m end end
end

local function check_strength(m, errs)
    for _, s in ipairs(m.steps) do
        if required(s) and not first_strong(s) then
            local ts = {}
            for _, x in ipairs(s.done or {}) do ts[#ts + 1] = tostring(x.t) end
            err(errs, 'strength', 'step ' .. tostring(s.id) .. ': no strong done matcher (event, chat, quest, mission, word, zonein, ki); has '
                .. (#ts > 0 and table.concat(ts, ', ') or 'none'))
        end
    end
end

---------------------------------------------------------------------------
-- the page: counting as the checkbox drawing counts, then the real draw
---------------------------------------------------------------------------

-- every counted bullet: {[sec] = {{item, indent}, ...}} (sec = '' outside tabs, else the tab's label); replicates the
-- inline counting of D.draw (step_marks in ui/doc.lua)
local function page_items(doc)
    local out = {}
    local function walk(blocks, sec)
        for _, bl in ipairs(blocks or {}) do
            if bl.k == 'list' then
                out[sec] = out[sec] or {}
                for _, it in ipairs(bl.items) do table.insert(out[sec], {item = it, indent = bl.indent or 0}) end
            elseif bl.k == 'tabs' then
                for _, t in ipairs(bl.tabs) do walk(t.blocks, t.label or '') end
            end                                   -- a box's bullets are not counted (in_box), tables hold no lists
        end
    end
    walk(doc.blocks, '')
    return out
end

-- tab label -> {group, i}
local function tab_index(doc)
    local out = {}
    local function walk(blocks)
        for _, bl in ipairs(blocks or {}) do
            if bl.k == 'tabs' then
                for i, t in ipairs(bl.tabs) do
                    if t.label and not out[t.label] then out[t.label] = {group = bl.group, i = i} end
                    walk(t.blocks)
                end
            end
        end
    end
    walk(doc.blocks)
    return out
end

local function check_page(m, doc, errs)
    local items = page_items(doc)
    local tabs = tab_index(doc)
    local seen = {}
    local ok_addr = {}
    for _, s in ipairs(m.steps) do
        local at = s.at
        if type(at) == 'table' and int(at.n) and type(at.fp) == 'string' then
            local name = 'step ' .. tostring(s.id)
            local sec = at.tab or ''
            local addr = sec .. '|' .. at.n
            if seen[addr] then err(errs, 'n', name .. ': bullet ' .. addr .. ' is also step ' .. seen[addr]) end
            seen[addr] = tostring(s.id)
            if at.tab and not tabs[at.tab] then
                err(errs, 'n', name .. ': the page has no tab "' .. at.tab .. '"')
            else
                local list = items[sec] or {}
                local hit = list[at.n]
                if not hit then
                    err(errs, 'n', ('%s: n = %d is out of range (%s has %d top-level bullets)'):format(name, at.n,
                        at.tab and ('tab "' .. at.tab .. '"') or 'the page outside tabs', #list))
                else
                    local folded = E.fold(hit.item.spans or {})
                    if folded:sub(1, #at.fp) ~= at.fp then
                        err(errs, 'fp', ('%s: bullet %d reads "%s", not "%s..."'):format(name, at.n, folded:sub(1, 60), at.fp))
                    elseif hit.indent ~= 0 then
                        err(errs, 'n', name .. ': bullet ' .. at.n .. ' is in an indented list: counted by the drawing but never marked')
                    else
                        ok_addr[s.id] = true
                        if not D.step_text(doc, at.tab, at.n, at.fp) then
                            err(errs, 'draw', name .. ': D.step_text (the strip) does not find the bullet')
                        end
                    end
                end
            end
        end
    end
    -- the real drawing: every mapped step that is not a note (notes are never drawn) must get a checkbox
    local want, by_tab = {}, {}
    for _, s in ipairs(m.steps) do
        if s.kind ~= 'note' and ok_addr[s.id] then
            local tk = s.at.tab or ''
            by_tab[tk] = by_tab[tk] or {}
            table.insert(by_tab[tk], {n = s.at.n, tab = s.at.tab, fp = s.at.fp, shown = 'chk|' .. s.id})
            want[#want + 1] = s.id
        end
    end
    local marked = {}
    local orig = kit.step_box
    kit.step_box = function(_, _, _, state)
        local id = type(state) == 'string' and state:match('^chk|(.*)$')
        if id then marked[id] = (marked[id] or 0) + 1 end
    end
    local ok, e = pcall(function()
        for tk, steps in pairs(by_tab) do
            local tabs_state = {}
            if tk ~= '' then tabs_state[tabs[tk].group] = tabs[tk].i end
            D.draw(ops.new(), doc, 0, 0, 700, {tabs = tabs_state, progress = {steps = steps, rows = {}}})
        end
    end)
    kit.step_box = orig
    D.release()
    if not ok then err(errs, 'draw', 'D.draw failed: ' .. tostring(e)) return end
    for _, id in ipairs(want) do
        if not marked[id] then err(errs, 'draw', 'step ' .. id .. ': the drawing marks no checkbox for it') end
    end
end

---------------------------------------------------------------------------
-- simulation: the engine and core/progress.lua's fold
---------------------------------------------------------------------------

local function observation(mt)
    local t = mt.t
    if t == 'event' then
        local p = nil
        if mt.p then p = {} for k, v in pairs(mt.p) do p[k] = v end end
        return {t = 'event', zone = mt.zone, event = mt.event, p = p}
    elseif t == 'zonein' then return {t = 'zonein', zone = mt.zone, event = mt.event}
    elseif t == 'ki' then return {t = 'ki', id = mt.id, gained = mt.gained}
    elseif t == 'quest' then return {t = 'quest', current = mt.current or false, completed = mt.completed or false}
    elseif t == 'mission' then
        return {t = 'mission', line = mt.line, current = mt.eq or mt.min or mt.max, completed = mt.completed or nil}
    elseif t == 'word' then return {t = 'word', value = (mt.eq or mt.min or mt.max) * 16 ^ mt.nib}
    elseif t == 'chat' then
        local text = sample(mt.re)
        if not text then return nil, 'no sample text for the pattern "' .. mt.re .. '"' end
        return {t = 'chat', text = text}
    end
    return nil, 'cannot build an observation for t = ' .. tostring(t)
end

-- the mapping as core/progress.lua's loader leaves it: chat patterns lower-cased
local function lowered(m)
    local c = deepcopy(m)
    for _, s in ipairs(c.steps) do
        for _, list in ipairs({s.done or {}, s.reach or {}}) do
            for _, x in ipairs(list) do if x.re then x.re = x.re:lower() end end
        end
    end
    return c
end

local function shown_str(m, shown)
    local t = {}
    for i, s in ipairs(m.steps) do t[#t + 1] = s.id .. '=' .. tostring(shown[i]) end
    return table.concat(t, ' ')
end

local function check_sim(key, m, errs)
    local ml = lowered(m)
    local obs = {}
    local fed = {}
    for i, s in ipairs(ml.steps) do
        if required(s) then
            local mt = first_strong(s)
            local o, why = observation(mt)
            if not o then err(errs, 'sim', 'step ' .. s.id .. ': ' .. why) return end
            obs[#obs + 1] = o
            fed[#fed + 1] = i
            local r = E.evaluate(ml, obs)
            local shown = P._fold(ml, r)
            for _, j in ipairs(fed) do
                if shown[j] ~= 'done' then
                    err(errs, 'sim', ('after step %s (%s): step %s shows %s, not done [%s]'):format(s.id, mt.t, ml.steps[j].id,
                        tostring(shown[j]), shown_str(ml, shown)))
                end
            end
            local g = s.group or 'main'
            for k = i + 1, #ml.steps do
                local x = ml.steps[k]
                if (x.group or 'main') == g and required(x) then
                    if shown[k] ~= 'next' then
                        err(errs, 'sim', ('after step %s (%s): step %s shows %s, not next [%s]'):format(s.id, mt.t, x.id,
                            tostring(shown[k]), shown_str(ml, shown)))
                    end
                    break
                end
            end
        end
    end
    -- completed before install: only the log's snapshot
    local cat = key:match('^(%a+)|')
    local snap
    if cat == 'quest' then
        snap = {t = 'quest', current = false, completed = true, snap = true}
    else
        local c
        for _, s in ipairs(ml.steps) do if s.id == ml.completes then c = s end end
        -- a mission matcher with completed = true is the completed set's read, so it is the one the snapshot is built from
        for _, pass in ipairs({'completed', 'any'}) do
            for _, x in ipairs(c and c.done or {}) do
                if (x.t == 'mission' and (pass == 'any' or x.completed == true)) or (pass == 'any' and (x.t == 'word' or x.t == 'quest')) then
                    snap = observation(x) snap.snap = true break
                end
            end
            if snap then break end
        end
    end
    if not snap then
        print('  note: ' .. key .. ': no completed snapshot to test (no quest log; the completes step has no mission/word matcher)')
        return
    end
    local r = E.evaluate(ml, {snap})
    local shown = P._fold(ml, r)
    local upto = #ml.steps
    if ml.completes then for i, s in ipairs(ml.steps) do if s.id == ml.completes then upto = i end end end
    for i, s in ipairs(ml.steps) do
        if s.kind ~= 'note' and i <= upto and shown[i] ~= 'done' then
            err(errs, 'sim', ('completed snapshot: step %s shows %s, not done [%s]'):format(s.id, tostring(shown[i]), shown_str(ml, shown)))
        elseif i > upto and shown[i] == 'next' and s.kind ~= 'post' then
            err(errs, 'sim', ('completed snapshot: step %s after the completion shows next'):format(s.id))
        end
    end
end

---------------------------------------------------------------------------
-- the index and the files
---------------------------------------------------------------------------

local function key_parts(key) return key:match('^(%a+)|([%w_]+)|(%d+)$') end
local function map_path(key)
    local cat, area, id = key_parts(key)
    return cat and ('progress/%ss/%s/%s.lua'):format(cat, area, id)
end

local function file_exists(p)
    local f = io.open(p, 'rb')
    if f then f:close() return true end
    return false
end

-- every .lua under progress/ except progress/index.lua and the generated progress/next/, as 'progress/...' paths
local function disk_files()
    local out = {}
    if package.config:sub(1, 1) == '\\' then
        local cwd = io.popen('cd'):read('*l')
        local h = io.popen('dir /s /b /a-d "progress\\*.lua" 2>nul')
        for l in h:lines() do
            local rel = l:sub(1, #cwd + 1) == cwd .. '\\' and l:sub(#cwd + 2) or l
            out[#out + 1] = rel:gsub('\\', '/')
        end
        h:close()
    else
        local h = io.popen("find progress -name '*.lua' -type f")
        for l in h:lines() do out[#out + 1] = l end
        h:close()
    end
    local keep = {}
    for _, p in ipairs(out) do if p ~= 'progress/index.lua' and not p:find('^progress/next/') then keep[#keep + 1] = p end end
    table.sort(keep)
    return keep
end

-- index (key -> true), files on disk, pages index, exists(path) -> errors
local function check_index(index, files, pages, exists, errs)
    if type(index) ~= 'table' then err(errs, 'index', 'progress/index.lua does not return a table') return end
    local listed = {}
    for _, key in ipairs(sorted_keys(index)) do
        local v = index[key]
        local path = map_path(key)
        if not path then err(errs, 'index', key .. ': not a cat|area|id key')
        else
            listed[path] = true
            if v ~= true then err(errs, 'index', key .. ': value is not true') end
            if not exists(path) then err(errs, 'index', key .. ': no file ' .. path) end
            if not pages[key] then err(errs, 'index', key .. ': no page in pages/index.lua') end
        end
    end
    for _, p in ipairs(files) do
        if not listed[p] then
            local cat, area, id = p:match('^progress/(%a+)s/([%w_]+)/(%d+)%.lua$')
            err(errs, 'index', p .. ': not listed in progress/index.lua' .. (cat and (' (key ' .. cat .. '|' .. area .. '|' .. id .. ')') or ' (and not at progress/<cat>s/<area>/<id>.lua)'))
        end
    end
end

---------------------------------------------------------------------------
-- one entry
---------------------------------------------------------------------------

local function check_entry(key, m, doc)
    local errs = {}
    if not check_schema(m, errs) then return errs end
    if doc then check_page(m, doc, errs) else err(errs, 'page', 'no page to address') end
    check_strength(m, errs)
    local blocking = false
    for _, e in ipairs(errs) do if e.tag ~= 'fp' and e.tag ~= 'n' and e.tag ~= 'draw' and e.tag ~= 'page' then blocking = true end end
    if blocking then
        err(errs, 'sim', 'not simulated (schema or strength errors above)')
    else
        local ok, e = pcall(check_sim, key, m, errs)
        if not ok then err(errs, 'sim', 'simulation failed: ' .. tostring(e)) end
    end
    return errs
end

local function load_page(pages, key)
    local file = pages[key]
    if not file then return nil end
    local f = loadfile(file)
    if not f then return nil end
    local ok, mk = pcall(f)
    if not ok or type(mk) ~= 'table' then return nil end
    return D.decode(mk)
end

local function load_mapping(path)
    local f, e = loadfile(path)
    if not f then return nil, 'does not load: ' .. tostring(e) end
    local ok, m = pcall(f)
    if not ok then return nil, 'errors when run: ' .. tostring(m) end
    if type(m) ~= 'table' then return nil, 'returns ' .. type(m) .. ', not a table' end
    return m
end

local pages = dofile('pages/index.lua')

---------------------------------------------------------------------------
-- the gate
---------------------------------------------------------------------------

-- one pass/fail per check per entry
local TAGS = {'load', 'schema', 'id', 'kind', 'with', 'at', 'matcher', 'chat', 'ref', 'page', 'n', 'fp', 'draw', 'strength', 'sim'}

-- progress/next/ is generated from pages/ and progress/ (test/gen_next.lua): a page or a mapping changed without it means a wrong
-- or missing Next line. `read` gives a file's text. -> the names of the stale files
local function stale_next(read)
    local out = {}
    for name, text in pairs(dofile('test/gen_next.lua').build()) do
        if read(name) ~= text then out[#out + 1] = name end
    end
    table.sort(out)
    return out
end
local function read_next(name)
    local f = io.open('progress/next/' .. name .. '.lua', 'rb')
    if not f then return nil end
    local s = f:read('*a')
    f:close()
    return (s:gsub('\r\n', '\n'))      -- a checkout may have made the line ends CRLF
end

-- progress/next/wants.lua, likewise generated (review CORE-9): a mapping changed without it would keep the wrong observations
local function read_wants()
    local f = io.open('progress/next/wants.lua', 'rb')
    if not f then return nil end
    local s = f:read('*a')
    f:close()
    return (s:gsub('\r\n', '\n'))
end

local function gate()
    local stale = stale_next(read_next)
    check(#stale == 0, 'progress/next/ is up to date (run test/gen_next.lua): ' .. table.concat(stale, ' '))
    check(read_wants() == dofile('test/gen_next.lua').wants(), 'progress/next/wants.lua is up to date (run test/gen_next.lua)')
    local f = loadfile('progress/index.lua')
    local ok, index = false, nil
    if f then ok, index = pcall(f) end
    check(ok and type(index) == 'table', 'progress/index.lua loads and returns a table')
    if not (ok and type(index) == 'table') then return end
    local ierrs = {}
    check_index(index, disk_files(), pages, file_exists, ierrs)
    for _, e in ipairs(ierrs) do check(false, e.msg) end
    if #ierrs == 0 then check(true, 'index') end

    -- the addon's own loader
    package.loaded['core/progress'] = nil
    local PL = require('core/progress')
    PL.init({is_loaded = function() return false end, get_area_status = function() return {items = {}} end}, function() end)

    for _, key in ipairs(sorted_keys(index)) do
        local path = map_path(key)
        if path and file_exists(path) then
            local m, lerr = load_mapping(path)
            check(m ~= nil, key .. ': ' .. path .. ' ' .. tostring(lerr))
            if m then
                local doc = load_page(pages, key)
                local errs = check_entry(key, m, doc)
                for _, e in ipairs(errs) do print('  ' .. key .. ': ' .. e.msg) end
                for _, tag in ipairs(TAGS) do
                    local n = 0
                    for _, e in ipairs(errs) do if e.tag == tag then n = n + 1 end end
                    check(n == 0, ('%s: %s (%d errors)'):format(key, tag, n))
                end
                local unknown = {}
                for _, e in ipairs(errs) do
                    local known = false
                    for _, tag in ipairs(TAGS) do if e.tag == tag then known = true end end
                    if not known then unknown[#unknown + 1] = e.msg end
                end
                check(#unknown == 0, key .. ': ' .. table.concat(unknown, '; '))
                local fp = PL.for_page(key)
                check(fp ~= nil and #fp.steps > 0, key .. ': core/progress.lua loads it (for_page)')
                local nsteps, nreq = #m.steps, 0
                for _, s in ipairs(m.steps) do if required(s) then nreq = nreq + 1 end end
                print(('  %-24s %d steps, %d required: %s'):format(key, nsteps, nreq, #errs == 0 and 'clean' or (#errs .. ' errors')))
            end
        end
    end
end

---------------------------------------------------------------------------
-- --selftest: one fault per check, each must be caught
---------------------------------------------------------------------------

local function has_tag(errs, tag, pat)
    for _, e in ipairs(errs) do
        if e.tag == tag and (not pat or e.msg:find(pat, 1, true)) then return true end
    end
    return false
end

local function selftest()
    local index = dofile('progress/index.lua')
    local key = sorted_keys(index)[1]
    for _, k in ipairs(sorted_keys(index)) do if k == 'quest|sandoria|27' then key = k end end
    local base = assert(load_mapping(map_path(key)))
    local doc = assert(load_page(pages, key))
    local clean = check_entry(key, base, doc)
    check(#clean == 0, 'selftest: the clean copy of ' .. key .. ' raises nothing (' .. (clean[1] and clean[1].msg or '') .. ')')
    check(#stale_next(function(name) return name == 'quest_bastok' and 'stale' or read_next(name) end) == 1, 'selftest: a stale progress/next file is caught')
    check(read_wants():gsub('quest|bastok|31', 'quest|bastok|9031') ~= dofile('test/gen_next.lua').wants(), 'selftest: a stale progress/next/wants.lua is caught')

    -- index the first matcher of a type in a step
    local function find(m, sid, t)
        for _, s in ipairs(m.steps) do
            if s.id == sid then
                for i, x in ipairs(s.done or {}) do if x.t == t then return s, i end end
                return s
            end
        end
    end
    local first = base.steps[1].id
    local last = base.steps[#base.steps].id

    local FAULTS = {
        {'bad fp', 'fp', function(m) m.steps[1].at.fp = 'zz not the bullet' end},
        {'n out of range', 'n', function(m) m.steps[#m.steps].at.n = 99 end},
        {'unknown kind', 'kind', function(m) m.steps[2].kind = 'bogus' end},
        {'a step with only an item matcher', 'strength', function(m)
            m.steps[2].done = {{t = 'item', id = 4096, gained = true}}
        end},
        {'a note with no with', 'with', function(m) m.steps[2].kind = 'note' m.steps[2].with = nil end},
        {'a chat pattern that does not compile (trailing %)', 'chat', function(m)
            local s, i = find(m, first, 'chat')
            s.done[i or 1] = {t = 'chat', re = "Then you'll do it%"}
        end},
        {'a chat pattern that does not compile (open set)', 'chat', function(m)
            local s = find(m, first, 'chat')
            table.insert(s.done, {t = 'chat', re = 'weapons [order'})
        end},
        {'a chat pattern with an upper-case class', 'chat', function(m)
            local s = find(m, first, 'chat')
            table.insert(s.done, {t = 'chat', re = 'weapons%Sorder'})
        end},
        {'an unknown matcher type', 'matcher', function(m) table.insert(m.steps[1].done, {t = 'keyitem', id = 97}) end},
        {'a mission matcher with a non-boolean completed', 'matcher', function(m)
            table.insert(m.steps[1].done, {t = 'mission', line = 'sandoria', eq = 1, completed = 'yes'})
        end},
        {'a zonein matcher without event', 'matcher', function(m) table.insert(m.steps[1].done, {t = 'zonein', zone = 230}) end},
        {'a ki matcher without gained', 'matcher', function(m) table.insert(m.steps[1].done, {t = 'ki', id = 97}) end},
        {'an event matcher with a string zone', 'matcher', function(m) table.insert(m.steps[1].done, {t = 'event', zone = '230', event = 1}) end},
        {'a mistyped matcher field', 'matcher', function(m) table.insert(m.steps[1].done, {t = 'ki', id = 97, gain = true, gained = true}) end},
        {'duplicate step id', 'id', function(m) m.steps[2].id = m.steps[1].id end},
        {'completes names no step', 'ref', function(m) m.completes = 's99' end},
        {'after names no step', 'ref', function(m) m.steps[2].done[1].after = 's99' end},
        {'two steps on one bullet', 'n', function(m) m.steps[2].at = deepcopy(m.steps[1].at) end},
        {'a tab the page does not have', 'n', function(m) m.steps[1].at.tab = 'No Such Tab' end},
        {'fp not folded', 'at', function(m) m.steps[1].at.fp = 'Speak to Helbort' end},
        {'a later step proven by the first step observation (sim)', 'sim', function(m)
            -- the last step's proof now also matches the first step's observation, so it ticks too early
            local s = m.steps[#m.steps]
            table.insert(s.done, 1, deepcopy(first_strong(m.steps[1])))
        end},
        {'a step gated on a later step (after)', 'sim', function(m)
            for _, x in ipairs(m.steps[1].done) do x.after = last end
        end},
        {'no completed quest-log matcher', 'sim', function(m)
            for _, s in ipairs(m.steps) do
                local keep = {}
                for _, x in ipairs(s.done or {}) do if not (x.t == 'quest' and x.completed) then keep[#keep + 1] = x end end
                s.done = keep
            end
        end},
    }
    for _, f in ipairs(FAULTS) do
        local m = deepcopy(base)
        local ok, e = pcall(f[3], m)
        if not ok then
            check(false, 'selftest: could not inject "' .. f[1] .. '": ' .. tostring(e))
        else
            local errs = check_entry(key, m, doc)
            check(has_tag(errs, f[2]) and not has_tag(clean, f[2]), ('selftest: %s -> [%s]'):format(f[1], f[2]))
            if has_tag(errs, f[2]) then
                for _, x in ipairs(errs) do if x.tag == f[2] then print('  caught  ' .. f[1] .. ': ' .. x.msg) break end end
            end
        end
    end

    -- the index: an entry with no file, a file not listed, a key with no page
    local idx = deepcopy(index)
    idx['quest|sandoria|99999'] = true
    local files = disk_files()
    local e1 = {}
    check_index(idx, files, pages, file_exists, e1)
    check(has_tag(e1, 'index', 'no file progress/quests/sandoria/99999.lua'), 'selftest: an index entry with no file -> [index]')
    if e1[1] then print('  caught  an index entry with no file: ' .. e1[1].msg) end
    local e2 = {}
    local f2 = deepcopy(files)
    f2[#f2 + 1] = 'progress/quests/bastok/99999.lua'
    check_index(index, f2, pages, function(p) return p == 'progress/quests/bastok/99999.lua' or file_exists(p) end, e2)
    check(has_tag(e2, 'index', 'not listed'), 'selftest: a mapping file not listed -> [index]')
    local e3 = {}
    local idx3 = deepcopy(index)
    idx3['quest|nowhere|1'] = true
    check_index(idx3, files, pages, function() return true end, e3)
    check(has_tag(e3, 'index', 'no page'), 'selftest: an entry with no page -> [index]')
    local e0 = {}
    check_index(index, files, pages, file_exists, e0)
    check(#e0 == 0, 'selftest: the real index raises nothing')

    -- the pattern tools themselves
    check(pattern_error("Then you'll do it%? Much obliged!") == nil, 'selftest: a valid pattern passes')
    for _, bad in ipairs({'abc%', '[abc', 'a(b', 'a)b', '%f', '%b(', '(a)%2'}) do
        check(pattern_error(bad) ~= nil, 'selftest: pattern_error catches "' .. bad .. '"')
    end
    for _, p in ipairs({"then you'll do it%? much obliged!", 'obtained key item: weapons order', '^a%d+b[xyz]-c$', 'x%s*y.-z'}) do
        local s = sample(p)
        check(s and s:find(p), 'selftest: sample() satisfies "' .. p .. '" (' .. tostring(s) .. ')')
    end
end

if SELFTEST then
    selftest()
    print(('test_steps --selftest: %d passed, %d failed'):format(pass, fail))
else
    gate()
    print(('test_steps: %d passed, %d failed'):format(pass, fail))
end
os.exit(fail == 0 and 0 or 1)

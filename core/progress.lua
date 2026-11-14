--[[
    core/progress.lua - quest and mission step progress (proof of concept).

    Watches, read-only, what proves a step: key items gained or lost (0x055), the quest log (0x056, through core/data),
    event starts at an NPC (0x032/0x034), NPC dialogue in the chat log, items gained or lost. Only what some step
    mapping (progress/<cat>/<area>/<id>.lua, listed in progress/index.lua) can use is kept, appended to
    data/progress/<Name>.tsv: one observation per line, so states are always recomputed from what was seen.
    Login state (key items held, quest log bits) is used as a snapshot and never written.

    The player sees three states per step: done (seen, inferred, or before a step known done), next, to do.
]]

local E = require('core/progress_engine')

local P = {}

P.debug = false                -- //cr progress debug: echo each kept observation and every event start in chat

local root = windower and windower.addon_path or './'
local index = {}               -- key -> true for every entry with a step mapping
local maps = {}                -- key -> mapping (loaded on first use)
local want = {ki = {}, item = {}, event = {}, zonein = {}, chat = {}, quest = {}, quest_areas = {}, mission = {}, word = false}   -- what the mappings can use
local lines_of = {}           -- key -> {[mission line] = true}: the lines the mapping's mission matchers name
local word_of = {}            -- key -> true when the mapping has a word matcher
local obs = {}                 -- this character's kept observations, oldest first
local who                      -- character name the log belongs to
local ki_seen = {}             -- [table index] = {[ki id] = true}: the last 0x055 of each table
local ki_have = {}             -- [ki id] = bool, for the key items the mappings name
local quest_seen = {}          -- key -> {current, completed} last read from the log
local area_read = {}           -- 'cat|area' -> the raw inputs (data.quest_area_inputs) quest_seen was last read from
local mission_seen = {}        -- line -> {current, completed = {[id] = true}} last read from the mission lines
local word_seen                -- the CoP progress word last read
local data                     -- core/data (set by P.init)
local say = function() end
local memo = {}                -- key -> P.summary's result (false: no mapping), dropped whenever anything it reads changes
local area_done = {}           -- 'mission|<area>' -> {[id] = true} for the ids the card shows completed
local texts = {}               -- the last progress/next/<cat>_<area>.lua read: {name, entries}

local function key_parts(key) return key:match('^(%a+)|([%w_]+)|(%d+)$') end

-- Mappings are loaded when a page or a list asks for one, and at most MAPS_MAX are held (review CORE-9: all of them were loaded
-- at init, 89 ms and about 5 MB held for good); what the observers need from every mapping is in progress/next/wants.lua.
local MAPS_MAX = 200
local maps_n = 0

local function load_map(key)
    if maps[key] ~= nil then return maps[key] or nil end
    local cat, area, id = key_parts(key)
    local f = cat and loadfile(root .. ('progress/%ss/%s/%s.lua'):format(cat, area, id))
    local ok, m = false, nil
    if f then ok, m = pcall(f) end
    if maps_n >= MAPS_MAX then maps, maps_n = {}, 0 end
    maps_n = maps_n + 1
    maps[key] = ok and type(m) == 'table' and m or false
    if maps[key] then                  -- chat is matched in lower case
        for _, s in ipairs(m.steps) do
            for _, list in ipairs({s.done or {}, s.reach or {}}) do
                for _, x in ipairs(list) do if x.re then x.re = x.re:lower() end end
            end
        end
    end
    return maps[key] or nil
end

-- What one mapping can use, so nothing else is kept: {ki, item, event, zonein = {[n] = true}, chat = {[pattern] = true} (lower
-- case), lines = {[mission line] = true}, word = bool}. test/gen_next.lua writes it for every mapping to progress/next/wants.lua.
local function wants_of(m)
    local w = {ki = {}, item = {}, event = {}, zonein = {}, chat = {}, lines = {}, word = false}
    local lists = {m.known or {}}      -- mission and word matchers also count in known and in a group's start
    for _, g in pairs(m.groups or {}) do lists[#lists + 1] = g.start or {} end
    for _, list in ipairs(lists) do
        for _, x in ipairs(list) do
            if x.t == 'mission' then w.lines[x.line] = true
            elseif x.t == 'word' then w.word = true end
        end
    end
    for _, s in ipairs(m.steps or {}) do
        for _, list in ipairs({s.done or {}, s.reach or {}}) do
            for _, x in ipairs(list) do
                if x.t == 'mission' then w.lines[x.line] = true
                elseif x.t == 'word' then w.word = true
                elseif x.t == 'ki' or x.t == 'ki_have' then w.ki[x.id] = true
                elseif x.t == 'item' or x.t == 'item_have' then w.item[x.id] = true
                elseif x.t == 'event' then w.event[(x.zone or 0) * 65536 + x.event] = true
                elseif x.t == 'zonein' and x.event ~= nil then w.zonein[(x.zone or 0) * 65536 + x.event] = true
                elseif x.t == 'chat' then w.chat[x.re:lower()] = true end
            end
        end
    end
    return w
end

-- Words only a combat line carries. When no mapped pattern has one, the battle chat modes are skipped (on_text).
local BATTLE_WORDS = {' defeats ', ' uses ', ' casts ', ' points of damage', ' wears off', ' gains the effect', ' readies ',
    ' misses ', ' hits ', ' falls to the ground'}

-- Chat modes no mapped line arrives in (review CORE-7). Every mapped pattern is NPC dialogue or the game's own message for an
-- event (an item or key item obtained, a cutscene's narration): those arrive as NPC and system modes (150, 151, 121, 127, 144,
-- 148, 190 and others). What players type (say, shout, yell, tell, party, linkshell 1 and 2, emote, unity, assist: res/chat.lua)
-- never carries one, and nor does the combat log (20 to 110) unless a mapping matches a combat line (BATTLE_WORDS).
local PLAYER_MODES = {1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 211, 212, 213, 214, 219, 220, 221, 222}
local skip_mode = {}

-- a pattern with no magic character but %-escaped punctuation, as the plain text it matches; nil for a real pattern
local function literal(re)
    if re:gsub('%%%W', ''):find('[%^%$%(%)%.%[%]%*%+%-%?%%]') then return nil end
    return (re:gsub('%%(%W)', '%1'))
end

local chat_plain, chat_re = {}, {}    -- the unique mapped chat patterns: plain text (string.find plain) and real patterns

local function add_wants(key, w)
    local cat, area, id = key_parts(key)
    want.quest[key] = {cat, area, id, cat .. '|' .. area}     -- parsed once: read_log walks these on every log read
    want.quest_areas[cat .. '|' .. area] = true
    lines_of[key], word_of[key] = {}, w.word == true
    for line in pairs(w.lines or {}) do want.mission[line] = true lines_of[key][line] = true end
    if w.word then want.word = true end
    -- wants_of gives sets ({[id] = true}); progress/next/wants.lua lists ({id, ...})
    for _, kind in ipairs({'ki', 'item', 'event', 'zonein', 'chat'}) do
        for k, v in pairs(w[kind] or {}) do want[kind][v == true and k or v] = true end
    end
end

-- progress/next/wants.lua (generated) for every mapping it has; a mapping it lacks is loaded to find out
local function build_wants()
    local f = loadfile(root .. 'progress/next/wants.lua')
    local ok, gen = false, nil
    if f then ok, gen = pcall(f) end
    gen = ok and type(gen) == 'table' and gen or {}
    for key in pairs(index) do
        local w = gen[key]
        if type(w) ~= 'table' then
            local m = load_map(key)
            w = m and wants_of(m)
        end
        if w then add_wants(key, w) end
    end
    local n, battle = 0, false
    chat_plain, chat_re = {}, {}
    for re in pairs(want.chat) do
        n = n + 1
        local lit = literal(re)
        if lit then chat_plain[#chat_plain + 1] = lit else chat_re[#chat_re + 1] = re end
        for _, word in ipairs(BATTLE_WORDS) do if re:find(word, 1, true) then battle = true end end
    end
    table.sort(chat_plain) table.sort(chat_re)
    want.chat_n = n
    skip_mode = {}
    for _, m in ipairs(PLAYER_MODES) do skip_mode[m] = true end
    if not battle then for m = 20, 110 do skip_mode[m] = true end end
end

---------------------------------------------------------------------------
-- the log file: time, kind, fields (k=v;...; values escaped)
---------------------------------------------------------------------------

local function esc(v) return (tostring(v):gsub('[%%;=\t\r\n]', function(c) return ('%%%02X'):format(c:byte()) end)) end
local function unesc(v) return (v:gsub('%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)) end

local function data_root() return windower and windower.chronicle_data_dir or root end   -- see core/fsave.data_dir
local function file_path() return data_root() .. 'data/progress/' .. who .. '.tsv' end

local function encode(o)
    local f = {}
    for k, v in pairs(o) do
        if k ~= 't' and k ~= 'time' and k ~= 'p' then f[#f + 1] = k .. '=' .. esc(v) end
    end
    if o.p then for i = 0, 7 do if o.p[i] then f[#f + 1] = 'p' .. i .. '=' .. o.p[i] end end end
    table.sort(f)
    return ('%d\t%s\t%s\n'):format(o.time or 0, o.t, table.concat(f, ';'))
end

local function decode(line)
    local time, t, rest = line:gsub('[\r\n]+$', ''):match('^(%d+)\t(%w+)\t(.*)$')
    if not t then return nil end
    local o = {t = t, time = tonumber(time)}
    for k, v in rest:gmatch('([%w_]+)=([^;]*)') do
        v = unesc(v)
        local p = k:match('^p(%d)$')
        if p then o.p = o.p or {} o.p[tonumber(p)] = tonumber(v)
        elseif v == 'true' or v == 'false' then o[k] = v == 'true'
        elseif tonumber(v) and k ~= 'text' and k ~= 'key' then o[k] = tonumber(v)
        else o[k] = v end
    end
    return o
end

-- The fields each kind of record must have, and their types (review CORE-11: two lines run together by a torn write decoded as an
-- item with a string delta, and the engine threw for every mapped entry). A record that fails is skipped.
local function num(v) return type(v) == 'number' end
local function bool(v) return type(v) == 'boolean' end
local function opt_bool(v) return v == nil or type(v) == 'boolean' end
local function line_id(v) return type(v) == 'number' or type(v) == 'string' end
local RECORD = {
    ki = {id = num, gained = bool},
    item = {id = num, delta = num},
    event = {zone = num, event = num},
    zonein = {zone = num, event = num},
    quest = {key = function(v) return type(v) == 'string' end, current = opt_bool, completed = opt_bool},
    mission = {line = line_id, current = num, completed = opt_bool},
    word = {value = num},
    chat = {text = function(v) return type(v) == 'string' end},
}
local function valid(o)
    local spec = o and RECORD[o.t]
    if not spec or not num(o.time) then return false end
    for k, ok in pairs(spec) do if not ok(o[k]) then return false end end
    if o.p then for i = 0, 7 do if o.p[i] ~= nil and not num(o.p[i]) then return false end end end
    return true
end

local torn = false             -- the log file does not end in a newline (a write cut short): the next record starts a new line

local function load_log()
    obs = {}
    torn = false
    if not who then return end
    local f = io.open(file_path(), 'rb')
    if not f then return end
    local all = f:read('*a') or ''
    f:close()
    torn = #all > 0 and all:sub(-1) ~= '\n'
    for line in all:gmatch('[^\n]+') do
        local o = decode(line)
        if valid(o) then obs[#obs + 1] = o end
    end
end

local function describe(o)
    if o.t == 'ki' then return ('key item %d %s'):format(o.id, o.gained and 'obtained' or 'lost')
    elseif o.t == 'item' then return ('item %d %+d'):format(o.id, o.delta)
    elseif o.t == 'event' then return ('event %d in zone %d'):format(o.event, o.zone)
    elseif o.t == 'zonein' then return ('zone-in event %d in zone %d'):format(o.event, o.zone)
    elseif o.t == 'quest' then return ('%s: %s'):format(o.key, o.completed and 'completed' or (o.current and 'accepted' or 'not started'))
    elseif o.t == 'mission' then return ('mission line %s: %s %d'):format(tostring(o.line), o.completed and 'completed' or 'now', o.current)
    elseif o.t == 'word' then return ('CoP word 0x%08X'):format(o.value)
    elseif o.t == 'chat' then return 'chat: ' .. o.text:sub(1, 60) end
    return o.t
end

local flush_items              -- defined with the item observer; keep() empties it first so the log stays in order

local function keep(o)
    if not who then return end
    if o.t ~= 'item' then flush_items() end
    o.time = os.time()
    obs[#obs + 1] = o
    if windower and windower.create_dir then windower.create_dir(data_root() .. 'data/progress') end
    local f = io.open(file_path(), 'a')
    if f then
        f:write((torn and '\n' or '') .. encode(o))
        torn = false
        f:close()
    end
    if P.debug then say('progress: ' .. describe(o), 207) end
    memo = {}
    area_done = {}
    if P.on_change then P.on_change() end
end

---------------------------------------------------------------------------
-- observers (called from chronicle.lua's events)
---------------------------------------------------------------------------

local function u16(s, off) return s:byte(off + 1) + s:byte(off + 2) * 256 end
local function i32(s, off)
    local v = s:byte(off + 1) + s:byte(off + 2) * 256 + s:byte(off + 3) * 65536 + s:byte(off + 4) * 16777216
    return v >= 2147483648 and v - 4294967296 or v
end

-- 0x055: GetItemFlag[16] at 0x04 (64 bytes), TableIndex at 0x84 (XiPackets). The first packet of a table after login is
-- a snapshot; a later one that differs is a key item gained or lost.
function P.on_0x055(raw)
    if #raw < 0x86 then return end
    local t = u16(raw, 0x84)
    local now = {}
    for id in pairs(want.ki) do
        if math.floor(id / 512) == t then
            local i = id % 512
            local byte = raw:byte(0x05 + math.floor(i / 8))
            now[id] = math.floor(byte / 2 ^ (i % 8)) % 2 == 1
        end
    end
    local before = ki_seen[t]
    ki_seen[t] = now
    for id, has in pairs(now) do
        ki_have[id] = has
        if before and before[id] ~= nil and before[id] ~= has then keep({t = 'ki', id = id, gained = has}) end
    end
    memo = {}
    area_done = {}
    if not before and P.on_change then P.on_change() end
end

-- A reload mid-session: the first 0x055 of each table was taken as the login snapshot, so a key item gained after the reload was
-- missed (review CORE-13). The key items Windower already holds seed each table that has any of them. A table with none in the
-- list is left to its first 0x055, as before: at a fresh login the list is empty or partial, and a table seeded as "nothing held"
-- would turn every key item of its first packet into a gain.
local function seed_key_items()
    local get = windower and windower.ffxi and windower.ffxi.get_key_items
    if not get then return end
    local ok, list = pcall(get)
    if not ok or type(list) ~= 'table' then return end
    local held, tables = {}, {}
    for _, id in ipairs(list) do
        if type(id) == 'number' then held[id], tables[math.floor(id / 512)] = true, true end
    end
    for t in pairs(tables) do
        if not ki_seen[t] then
            local now = {}
            for id in pairs(want.ki) do
                if math.floor(id / 512) == t then
                    now[id] = held[id] == true
                    ki_have[id] = now[id]
                end
            end
            ki_seen[t] = now
        end
    end
    memo = {}
    area_done = {}
end

-- 0x032 and 0x034: an event started at an NPC. The event id is EventPara (0x032 +0x0C, 0x034 +0x2C; Windower's
-- 'Menu ID'); the word before it, EventNum (+0x0A, +0x2A), is the zone the event file belongs to, not the event.
-- (The 2026-10-25 run read EventNum as the event, so no event matched.) P0-P7 at 0x034 +0x08.
function P.on_event(id, raw, zone)
    local ev, file, p
    if id == 0x034 and #raw >= 0x34 then
        ev, file = u16(raw, 0x2C), u16(raw, 0x2A)
        p = {}
        for k = 0, 7 do p[k] = i32(raw, 0x08 + 4 * k) end
    elseif id == 0x032 and #raw >= 0x14 then
        ev, file = u16(raw, 0x0C), u16(raw, 0x0A)
    end
    -- debug: every event start, kept or not
    if P.debug then
        say(('progress: 0x%03X event %s (file zone %s) in zone %s%s'):format(id, tostring(ev), tostring(file), tostring(zone),
            p and (' P0-P3 ' .. p[0] .. ' ' .. p[1] .. ' ' .. p[2] .. ' ' .. p[3]) or ''), 207)
    end
    if ev and zone and want.event[zone * 65536 + ev] then keep({t = 'event', zone = zone, event = ev, p = p}) end
end

-- 0x00A (zone in, GP_SERV_LOGIN): the server starts a zone-in cutscene inside this packet (LandSandBoat: a csid returned by
-- the zone's onZoneIn, 0x00a_login.cpp). ZoneNo u16 at +0x30; EventNum (+0x62, the zone the event file belongs to) is 0 when
-- the packet carries no event and the zone when it does; EventPara (+0x64) is the event id, the same convention as 0x032/0x034.
-- EventPara is 0 with no event too, and event 0 is a real id, so EventNum is the "has an event" test. The same event for the
-- same zone within 5 s counts once.
local last_zonein = {key = nil, time = 0}
function P.on_zonein(raw)
    if #raw < 0x68 then return end
    local zone, num, ev = u16(raw, 0x30), u16(raw, 0x62), u16(raw, 0x64)
    if P.debug then say(('progress: 0x00A zone %d EventNum %d EventPara %d'):format(zone, num, ev), 207) end
    if num == 0 then return end
    if not want.zonein[zone * 65536 + ev] then return end
    local now, key = os.time(), zone * 65536 + ev
    if last_zonein.key == key and now - last_zonein.time <= 5 then return end
    last_zonein.key, last_zonein.time = key, now
    keep({t = 'zonein', zone = zone, event = ev})
end

-- NPC dialogue: only lines some mapping names. In game (2026-10-25) every NPC line arrived three times (once plain, twice
-- re-sent with colour bytes) and this module's own echo matched again, so: whitespace collapsed, our own lines skipped, and
-- a line equal to one kept in the last 5 s dropped.
-- `mode` is the chat mode of Windower's 'incoming text' event: a line in a mode no mapped line arrives in (skip_mode, above) is
-- not looked at; nil looks at every line. The unique patterns are tried, the plain ones as plain text (review CORE-7).
local last_chat, last_chat_t = nil, 0
local function seen_chat(clean)
    local now = os.time()
    if clean == last_chat and now - last_chat_t <= 5 then return end
    last_chat, last_chat_t = clean, now
    keep({t = 'chat', text = clean:sub(1, 160)})
end
function P.on_text(text, mode)
    if not want.chat_n or want.chat_n == 0 then return end
    if mode and skip_mode[mode] then return end
    -- the plain copy of an NPC line ends in a control byte and a digit ("... later.<ctrl>1", 2026-10-27): drop that tail
    local clean = text:gsub('[%z\1-\31\127]%d*$', ''):gsub('[%z\1-\31\127]', ' '):gsub('%s+', ' '):gsub('^ ', ''):gsub(' $', ''):lower()
    if clean:find('^chronicle: ') then return end
    local find = string.find
    for i = 1, #chat_plain do
        if find(clean, chat_plain[i], 1, true) then return seen_chat(clean) end
    end
    for i = 1, #chat_re do
        if find(clean, chat_re[i]) then return seen_chat(clean) end
    end
end

-- Items: Windower fires 'remove item' then 'add item' when an item only moves between bags (inventory, satchel, wardrobe,
-- storage), which would read as lost and then gained (review CORE-5: a step matched on a lost Cernunnos Bulb was marked
-- done by a move to the wardrobe). Deltas are summed per item for ITEM_WINDOW seconds and only a net change is kept. Any
-- other observation, a login and an unload flush them first, so the log keeps its order.
local ITEM_WINDOW = 1
local item_pending, item_gen = {}, 0

flush_items = function()
    if not next(item_pending) then return end
    local ids = {}
    for id, d in pairs(item_pending) do if d ~= 0 then ids[#ids + 1] = id end end
    table.sort(ids)
    local pending = item_pending
    item_pending = {}
    for _, id in ipairs(ids) do keep({t = 'item', id = id, delta = pending[id]}) end
end

function P.on_item(id, delta)
    if not want.item[id] or not delta or delta == 0 then return end
    local first = not next(item_pending)
    item_pending[id] = (item_pending[id] or 0) + delta
    if not first then return end
    item_gen = item_gen + 1
    local gen = item_gen
    if coroutine.schedule then
        coroutine.schedule(function() if gen == item_gen then flush_items() end end, ITEM_WINDOW)
    end
end

-- keep any item change still being summed (logout, unload); the tests call it in place of the timer
function P.flush() flush_items() end

-- after core/data has read a 0x056 page: the quest bits of every mapped entry; a change after the first read is kept.
-- An area whose current and completed pages have not both arrived is skipped: it would read as every quest not started,
-- and its real bits arriving later would be kept as live changes (review CORE-1: 73 such records in one login).
local function read_log()
    if not data or not data.is_loaded() then return end
    -- an area whose raw bits are what quest_seen was read from cannot have changed: skip it (the read is most of a refresh)
    local skip = {}
    if data.quest_area_inputs then
        for area_key in pairs(want.quest_areas) do
            local cat, area = area_key:match('^(%a+)|(.+)$')
            local a, b, c, d = data.quest_area_inputs(cat, area)
            local r = area_read[area_key]
            if r and r[1] == a and r[2] == b and r[3] == c and r[4] == d then skip[area_key] = true
            else area_read[area_key] = {a, b, c, d} end
        end
    end
    local status_of = {}
    for key, parts in pairs(want.quest) do
        local cat, area, id, area_key = parts[1], parts[2], parts[3], parts[4]
        if not skip[area_key] and (not data.quest_area_ready or data.quest_area_ready(cat, area)) then   -- not read yet: no baseline, nothing kept
            if not status_of[area_key] then
                status_of[area_key] = {}
                for _, it in ipairs(data.get_area_status(cat, area).items or {}) do status_of[area_key][it.id] = it.status end
            end
            local st = status_of[area_key][tonumber(id)]
            local now = {current = st == 'active', completed = st == 'completed'}
            local before = quest_seen[key]
            quest_seen[key] = now
            if before and (before.current ~= now.current or before.completed ~= now.completed) then
                keep({t = 'quest', key = key, current = now.current, completed = now.completed})
            end
        end
    end
    if not data.get_mission_read or (not next(want.mission) and not want.word) then return end
    -- the mission lines named by a mapping, and the CoP word: the first read of a line is the baseline (like the quest bits),
    -- a later change is kept: the current value moving, or a mission id newly in the completed set
    local lines, word = data.get_mission_read()
    for line in pairs(want.mission) do
        local now, before = lines[line], mission_seen[line]
        if now then
            if before then
                if now.current and before.current and now.current ~= before.current then
                    keep({t = 'mission', line = line, current = now.current})
                end
                if now.completed and before.completed then
                    local added = {}
                    for id in pairs(now.completed) do if not before.completed[id] then added[#added + 1] = id end end
                    table.sort(added)
                    for _, id in ipairs(added) do keep({t = 'mission', line = line, current = id, completed = true}) end
                end
            end
            mission_seen[line] = {current = now.current or (before and before.current),
                                  completed = now.completed or (before and before.completed)}
        end
    end
    if want.word and word then
        if word_seen and word ~= word_seen then keep({t = 'word', value = word}) end
        word_seen = word
    end
end

function P.on_log()
    read_log()
    memo = {}
    area_done = {}
end

---------------------------------------------------------------------------
-- states
---------------------------------------------------------------------------

-- the observations one entry is judged on: the kept ones, then the login snapshot
local function observations(key, m)
    local list = {}
    for _, o in ipairs(obs) do
        if (o.t == 'quest' and o.key ~= key) or (o.t == 'mission' and not (lines_of[key] or {})[o.line])
            or (o.t == 'word' and not word_of[key]) then
            -- another entry's quest bits, a line or the word this mapping does not use
        else list[#list + 1] = o end
    end
    for id, has in pairs(ki_have) do list[#list + 1] = {t = 'ki_have', id = id, have = has, snap = true} end
    local q = quest_seen[key]
    if q then list[#list + 1] = {t = 'quest', current = q.current, completed = q.completed, snap = true} end
    -- mission lines: the current value, and each completed id as a value the line has been at
    for line in pairs(lines_of[key] or {}) do
        local s = mission_seen[line]
        if s then
            if s.current then list[#list + 1] = {t = 'mission', line = line, current = s.current, snap = true} end
            local ids = {}
            for id in pairs(s.completed or {}) do ids[#ids + 1] = id end
            table.sort(ids)
            for _, id in ipairs(ids) do list[#list + 1] = {t = 'mission', line = line, current = id, completed = true, snap = true} end
        end
    end
    if word_of[key] and word_seen then list[#list + 1] = {t = 'word', value = word_seen, snap = true} end
    return list
end

-- The game's log says the entry is completed (the card's COMPLETED): the quest's completed bit, or the mission's status as
-- core/data works it out for the card (on the linear lines, CoP among them, that is the line having moved past it). A repeatable
-- quest's bit stays set while it is run again, so the engine's runs decide there. Mission statuses are read once per area until
-- the log next changes.
local function log_done(key, m)
    if m.repeatable then return false end
    local cat, area, id = key_parts(key)
    if cat == 'quest' then return (quest_seen[key] or {}).completed == true end
    if cat ~= 'mission' or not (data and data.get_area_status) then return false end
    local ak = cat .. '|' .. area
    local set = area_done[ak]
    if not set then
        set = {}
        for _, it in ipairs(data.get_area_status(cat, area).items or {}) do
            if it.status == 'completed' then set[it.id] = true end
        end
        area_done[ak] = set
    end
    return set[tonumber(id)] == true
end

-- five engine states -> the three shown: done (seen, inferred, or before a done step), next, to do. Per group.
-- A completed entry (the engine's completing step, or the log, see log_done) shows every required step done; a post, optional
-- or branch step not seen leaves the strip and the count (the bullet stays as text), so COMPLETED never sits over a part-filled strip.
local function fold(m, r, complete)
    local shown, groups = {}, {}
    for i, s in ipairs(m.steps) do
        local g = s.group or 'main'
        groups[g] = groups[g] or {}
        table.insert(groups[g], i)
    end
    for _, idx in pairs(groups) do
        local last = 0
        for k, i in ipairs(idx) do
            local st = r.steps[m.steps[i].id].state
            if st == 'done_observed' or st == 'done_inferred' then last = k end
        end
        local next_set = false
        for k, i in ipairs(idx) do
            local s = m.steps[i]
            local st = r.steps[s.id].state
            if s.kind == 'note' then shown[i] = nil
            elseif k <= last then shown[i] = 'done'
            elseif complete then shown[i] = (not s.kind or st == 'done_observed' or st == 'done_inferred') and 'done' or nil
            elseif not next_set and (st == 'current' or (last > 0 and not s.kind)) then shown[i] = 'next' next_set = true
            else shown[i] = 'todo' end
        end
    end
    return shown
end

-- A run of two or more one-step groups shares a row: any-order steps are a group each (a single group would infer the ones not
-- seen as done), and a 20 px row per step pinned under the title left a page no room (zilart 10, wotg 49). A labelled group keeps
-- its row, and so does a lone one-step group between paths. -> a new list; `joined` marks a shared row.
local function join_rows(rows)
    local out = {}
    for _, r in ipairs(rows) do
        local last = out[#out]
        if #r.steps == 1 and not r.label and last and last.joined then
            last.steps[#last.steps + 1] = r.steps[1]
        elseif #r.steps == 1 and not r.label and last and #last.steps == 1 and not last.label then
            out[#out] = {steps = {last.steps[1], r.steps[1]}, joined = true}
        else out[#out + 1] = r end
    end
    return out
end

-- for the page: {steps = {{n, tab, fp, shown}}, rows = {{label, steps = {i...}, joined}}} or nil when the entry has no mapping;
-- then the engine's result
local function steps_of(key)
    if not index[key] then return nil end
    local m = load_map(key)
    if not m then return nil end
    local r = E.evaluate(m, observations(key, m))
    local shown = fold(m, r, r.complete or log_done(key, m))
    local out = {steps = {}, rows = {}}
    local rows = {}
    for i, s in ipairs(m.steps) do
        if shown[i] then
            out.steps[#out.steps + 1] = {n = s.at.n, tab = s.at.tab, fp = s.at.fp, shown = shown[i], why = r.steps[s.id].by}
            local g = s.group or 'main'
            if not rows[g] then
                rows[g] = {label = m.groups and m.groups[g] and m.groups[g].label, steps = {}}
                out.rows[#out.rows + 1] = rows[g]
            end
            table.insert(rows[g].steps, #out.steps)
        end
    end
    out.rows = join_rows(out.rows)
    return out, r
end

function P.for_page(key) return (steps_of(key)) end

-- What the lists say about entries without opening their pages (a page is too much to decode for a list): generated by
-- test/gen_next.lua, read one area at a time, never kept beyond the last area asked for. -> the entry's {code, s} or nil
local function entry_text(key)
    local cat, area, id = key_parts(key)
    if not cat then return nil end
    local name = cat .. '_' .. area
    if texts[1] ~= name then
        local f = loadfile(root .. 'progress/next/' .. name .. '.lua')
        local ok, t = false, nil
        if f then ok, t = pcall(f) end
        texts = {name, ok and type(t) == 'table' and t or {}}
    end
    return texts[2][tonumber(id)]
end

-- the short name a list gives an entry ("CoP 5-3"), nil when its series has none
function P.code(key)
    local e = entry_text(key)
    return e and e.code
end

-- For a list: {states = {shown...}, done, total, label, text = the next step's text, last = when the entry last advanced}. On a page
-- with paths (steps in tabs) the states are the first open path's and `label` is its name, as the strip's next step; otherwise every
-- step. A step outside the tabs waits for the paths (Three Paths' last visit to Cid), so an open path comes first. nil when the
-- entry has no mapping; `text` is nil when no step is next. Memoised: a list asks on every draw, the answer moves with the log.
function P.summary(key)
    if memo[key] ~= nil then return memo[key] or nil end
    local page, r = steps_of(key)
    if not page or #page.rows == 0 then
        memo[key] = false
        return nil
    end
    local row, label
    for _, rw in ipairs(page.rows) do
        for _, i in ipairs(rw.steps) do
            local st = page.steps[i]
            if st.shown == 'next' and not row and (st.tab or rw.label) then row, label = rw, rw.label or st.tab end
        end
    end
    local ids = {}
    if row then ids = row.steps
    else
        for _, rw in ipairs(page.rows) do
            for _, i in ipairs(rw.steps) do ids[#ids + 1] = i end
        end
    end
    local s = {states = {}, done = 0, total = #ids, label = label, last = r.last}
    for k, i in ipairs(ids) do
        local st = page.steps[i]
        s.states[k] = st.shown
        if st.shown == 'done' then s.done = s.done + 1 end
        if st.shown == 'next' and not s.text then
            local e = entry_text(key)
            s.text = e and e.s and e.s[(st.tab or '') .. '|' .. st.n]
        end
    end
    memo[key] = s
    return s
end

function P.has(key) return index[key] == true end

function P.keys()
    local out = {}
    for k in pairs(index) do out[#out + 1] = k end
    table.sort(out)
    return out
end

-- //cr progress: what is known for one entry, in the chat log
function P.report(key)
    local st = P.for_page(key)
    if not st then say('progress: no step mapping for ' .. tostring(key), 167) return end
    for i, s in ipairs(st.steps) do
        say(('  %d %-5s %s %s'):format(i, s.shown, s.fp, s.why and #s.why > 0 and ('(' .. table.concat(s.why, '; ') .. ')') or ''), 207)
    end
end

function P.recent(n)
    for i = math.max(1, #obs - (n or 10) + 1), #obs do say(os.date('%H:%M:%S ', obs[i].time) .. describe(obs[i]), 207) end
    if #obs == 0 then say('progress: nothing kept yet', 207) end
end

function P.on_login(name)
    flush_items()                  -- what the previous character's last second changed belongs to its log
    who = name
    memo = {}
    area_done = {}
    ki_seen, ki_have, quest_seen, mission_seen, word_seen = {}, {}, {}, {}, nil
    area_read = {}
    load_log()
end

function P.init(d, sayf, name)
    data, say = d, sayf or say
    local f = loadfile(root .. 'progress/index.lua')
    local ok, list = false, nil
    if f then ok, list = pcall(f) end
    index = ok and type(list) == 'table' and list or {}
    want = {ki = {}, item = {}, event = {}, zonein = {}, chat = {}, chat_n = 0, quest = {}, quest_areas = {}, mission = {}, word = false}
    lines_of, word_of = {}, {}
    maps, maps_n = {}, 0
    memo, texts = {}, {}
    build_wants()
    if name then
        P.on_login(name)
        seed_key_items()
    end
end

-- tests only
P._encode, P._decode, P._fold, P._join_rows, P._obs = encode, decode, fold, join_rows, function() return obs end
P._wants_of, P._valid, P._literal = wants_of, valid, literal
P._skips = function(mode) return skip_mode[mode] == true end
P._maps_held = function() return maps_n end

return P

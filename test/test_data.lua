-- test_data.lua: v2's data layer against v1's, and the heap each costs.
--
--   cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_data.lua
--
-- Loads v1 (../chronicle/data.lua with its eager wiki data) and v2
-- (core/data.lua with core/meta.lua) in turn, feeds both the same fixture
-- 0x056 packets and compares every area's status, every entry's metadata,
-- and name -> area lookups. Prints the Lua heap after each load.

local V1 = '../chronicle/'
local V2 = './'

local pass, fail = 0, 0
local function check(cond, what, detail)
    if cond then pass = pass + 1 else fail = fail + 1; print('FAIL ' .. what .. (detail ~= nil and (': ' .. tostring(detail)) or '')) end
end

-- Windower provides the bitop `bit` global; stock Lua does not.
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

local QUEST = {'sandoria', 'bastok', 'windurst', 'jeuno', 'other', 'outlands', 'toau', 'wotg', 'abyssea', 'adoulin', 'coalition'}
local MISSION = {'sandoria', 'bastok', 'windurst', 'zilart', 'cop', 'toau', 'wotg', 'acp', 'mkd', 'asa', 'adoulin', 'rov', 'tvr', 'assault', 'campaign'}

-- Deterministic fixture packets: every story log with pseudo-random flags,
-- every multi-field packet with plausible current values.
local seed = 12345
local function rnd(n)
    -- seed * 1103515245 + 12345 mod 2^31, exact in doubles: the multiplier split at 2^16
    -- (16838 * 65536 + 20077) keeps every product below 2^46, so no FPU precision changes it
    local hi = (seed * 16838) % 32768
    seed = (hi * 65536 + seed * 20077 + 12345) % 2147483648
    return seed % n
end
local function flags(len)
    local b = {}
    for i = 1, len do b[i] = string.char(rnd(256)) end
    return table.concat(b)
end
local packets = {}
for _, t in ipairs({0x50, 0x58, 0x60, 0x68, 0x70, 0x78, 0x88, 0xE0, 0xF0, 0x100, 0x110, 0x120, 0x130,
                    0x90, 0x98, 0xA0, 0xA8, 0xB0, 0xB8, 0xC8, 0xE8, 0xF8, 0x108, 0x118, 0x128, 0x138, 0x30, 0x38}) do
    packets[#packets + 1] = {Type = t, ['Quest Flags'] = flags(128)}
end
packets[#packets + 1] = {Type = 0x80, ['Current TOAU Quests'] = flags(16), ['Current Assault Mission'] = 3,
    ['Current TOAU Mission'] = 20, ['Current WOTG Mission'] = 30, ['Current Campaign Mission'] = 5}
packets[#packets + 1] = {Type = 0xC0, ['Completed TOAU Quests'] = flags(16), ['Completed Assaults'] = flags(16)}
packets[#packets + 1] = {Type = 0xD0, ["Completed San d'Oria Missions"] = flags(8), ['Completed Bastok Missions'] = flags(8),
    ['Completed Windurst Missions'] = flags(8), ['Completed Zilart Missions'] = flags(8)}
packets[#packets + 1] = {Type = 0xD8, ['Completed TOAU Missions'] = flags(16), ['Completed WOTG Missions'] = flags(16)}
packets[#packets + 1] = {Type = 0xFFFE, ['Current TVR Mission'] = 12}
packets[#packets + 1] = {Type = 0xFFFF, Nation = 1, ['Current Nation Mission'] = 7, ['Current ROZ Mission'] = 20,
    ['Current COP Mission'] = 540, ['Current ACP Mission'] = 4, ['Current MKD Mission'] = 6,
    ['Current ASA Mission'] = 3, ['Current SOA Mission'] = 60, ['Current ROV Mission'] = 100}

local function heap()
    collectgarbage(); collectgarbage()
    return collectgarbage('count')
end

local function load_data(root, mod)
    for k in pairs(package.loaded) do
        if k:find('^maps/') or k:find('^wiki/') or k:find('^core/') or k == 'data' then package.loaded[k] = nil end
    end
    package.path = root .. '?.lua;' .. package.path
    local base = heap()
    local d = require(mod)
    local after = heap()
    package.path = package.path:sub(#root + 7)
    return d, after - base
end

local d1, kb1 = load_data(V1, 'data')
for _, p in ipairs(packets) do d1.parse_packet(p) end
local s1 = {quest = {}, mission = {}}
for _, a in ipairs(QUEST) do s1.quest[a] = d1.get_area_status('quest', a) end
for _, a in ipairs(MISSION) do s1.mission[a] = d1.get_area_status('mission', a) end
local FIELDS = {'id', 'start_npc', 'start_zone', 'start_pos', 'description', 'reward', 'fame', 'fame_level', 'title', 'repeatable'}
local e1 = {}
for cat, areas in pairs({quest = QUEST, mission = MISSION}) do
    for _, a in ipairs(areas) do
        for _, item in ipairs(s1[cat][a].items) do
            local key = cat .. '|' .. a .. '|' .. item.id
            local e = cat == 'mission' and d1.get_mission_data(a, item.name, item.id) or d1.get_quest_data(a, item.name)
            local r = {npc = d1.format_npc_info(d1.get_npc_info(a, item.name, cat))}
            if e then
                for _, f in ipairs(FIELDS) do r[f] = e[f] end
                r.prev = e.previous and table.concat(e.previous, ';')
                r.next = e.next and table.concat(e.next, ';')
                r.nreq = e.requirements and #e.requirements or 0
            end
            e1[key] = r
        end
    end
end
d1 = nil
package.loaded.data = nil

local d2, kb2 = load_data(V2, 'core/data')
local meta = require('core/meta')
for _, p in ipairs(packets) do d2.parse_packet(p) end

local function same_status(a, b, what)
    check(a.completed == b.completed and a.current == b.current and a.total == b.total
        and (a.uncompletable or 0) == (b.uncompletable or 0) and a.has_data == b.has_data, what .. ' counts')
    check(#a.items == #b.items, what .. ' item count')
    for i = 1, math.min(#a.items, #b.items) do
        local x, y = a.items[i], b.items[i]
        if x.id ~= y.id or x.name ~= y.name or x.status ~= y.status then
            check(false, what .. ' item ' .. i); return
        end
    end
    pass = pass + 1
end

local entries, missing = 0, 0
local pages_index = dofile(V2 .. 'pages/index.lua')
local filled_from_pages = 0
local cleaned = 0
local repaired = 0
-- allowed difference 3 (core/meta.lua repair_requirements): an entry with a page whose v1 requirement rows are malformed (the bare
-- "[Key Item]" label, two items joined by a line break) takes the rows of its page's Requirements; every other field is v1's
local raw_areas = {}
local function raw_entry(cat, area, name)
    local k = cat .. '|' .. area
    if not raw_areas[k] then
        local f = loadfile(V2 .. 'meta/' .. cat .. 's/' .. area .. '.lua')
        raw_areas[k] = f and f() or {}
    end
    return raw_areas[k][name]
end
-- allowed difference 4 (core/meta.lua refine): the wiki wins where v1 and the page disagree. An entry with a page takes the page's
-- Repeatable (sandoria 5: v1 "No", the wiki "Yes"), and a fame level v1 scraped with the nation in it ("Jeuno Level 3") is its number.
-- The page is read here on its own (its header's text), not through core/meta.lua.
local D_doc = require('ui/doc')
local refined = 0
local reward_added = {}      -- entries whose card reward was missing in v1 and is the page's (allowed difference 11)
-- the page's Starting NPC row as the test reads it: {npc, zone, pos} when it names one NPC and one zone (allowed difference 5)
local function page_start(cat, area, id)
    local file = pages_index[cat .. '|' .. area .. '|' .. tostring(id)]
    local pg = file and dofile(V2 .. file)
    local m = pg and pg.meta
    if not (m and type(m['Starting NPC']) == 'string') then return nil end
    local npcs, zones, coords, people = {}, {}, {}, 0
    for _, sp in ipairs(D_doc.inline(m['Starting NPC'])) do
        if sp.t == 'link' and sp.kind == 'zone' then zones[#zones + 1] = sp.s
        elseif sp.t == 'link' then npcs[#npcs + 1] = sp.s if sp.kind == 'npc' then people = people + 1 end
        elseif sp.t == 'coord' then coords[#coords + 1] = sp.s:match('%((.-)%)') end
    end
    return {npc = #npcs == 1 and npcs[1] or nil, zone = #zones == 1 and zones[1] or nil, pos = #coords == 1 and coords[1] or nil,
            person = #npcs == 1 and people == 1}
end
-- every zone link of the page's Starting NPC row, in order (the row of wotg 0 names three)
local function page_zones(cat, area, id)
    local file = pages_index[cat .. '|' .. area .. '|' .. tostring(id)]
    local pg = file and dofile(V2 .. file)
    local m = pg and pg.meta
    local zs = {}
    if m and type(m['Starting NPC']) == 'string' then
        for _, sp in ipairs(D_doc.inline(m['Starting NPC'])) do
            if sp.t == 'link' and sp.kind == 'zone' then zs[#zs + 1] = sp.s end
        end
    end
    return zs
end
-- the page's Title row as the test reads it: its text, one title a line; nil when it has none (or says None / Unknown / --)
local function page_title(cat, area, id)
    local file = pages_index[cat .. '|' .. area .. '|' .. tostring(id)]
    local pg = file and dofile(V2 .. file)
    local m = pg and pg.meta
    if not (m and type(m.Title) == 'string') then return nil end
    local t = ''
    for _, sp in ipairs(D_doc.inline(m.Title)) do
        if sp.t == 'br' then t = t .. string.char(10)
        elseif sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' then t = t .. (sp.s or '') end
    end
    local low = t:lower():gsub('%s', '')
    if low == '' or low == 'none' or low == 'unknown' or low == '--' then return nil end
    return t
end
local function letters(t) return (t:lower():gsub('[^%w]', '')) end
-- the page's Rewards row as the test reads it: its lines (one per line break), nil when the page has none (allowed difference 13, rule 81)
local function page_reward_lines(cat, area, id)
    local file = pages_index[cat .. '|' .. area .. '|' .. tostring(id)]
    local pg = file and dofile(V2 .. file)
    local m = pg and pg.meta
    if not (m and type(m.Rewards) == 'string') then return nil end
    local t = ''
    for _, sp in ipairs(D_doc.inline(m.Rewards)) do
        if sp.t == 'br' then t = t .. string.char(10) elseif sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' then t = t .. (sp.s or '') end
    end
    local out = {}
    for l in (t .. string.char(10)):gmatch('([^' .. string.char(10) .. ']*)' .. string.char(10)) do
        if letters(l) ~= '' then out[#out + 1] = l end
    end
    return out
end
-- how many of the page's reward lines (a "[...]" tag dropped, none / N/A skipped) have their letters nowhere in the card's reward: lines, missing
local function reward_loss(page_lines, card_reward)
    local have, lines, lost = letters(card_reward or ''), 0, 0
    for _, l in ipairs(page_lines) do
        local w = letters((l:gsub('%b[]', '')))
        if w ~= '' and w ~= 'none' and w ~= 'na' then
            lines = lines + 1
            if not have:find(w, 1, true) then lost = lost + 1 end
        end
    end
    return lines, lost
end
-- allowed difference 6 (core/meta.lua title_from_page): an entry with a page takes the page's Title row for its card (windurst 63: v1 kept
-- the first of two titles, 66 "One of the following:", 104 the first of three)

-- allowed difference 5 (core/meta.lua refine): a starting NPC or zone v1 scraped as something else than the page's row says (windurst 91's
-- zone "Home Point #3)"), the position with a replaced zone, and a title v1 read with a list bullet ("*Discerning Individual")
local folded, gil_spaced, num_spaced = {}, {}, {}
local function refined_want(cat, area, id, e, want, npc)
    local w = {}
    for k, v in pairs(want) do w[k] = v end
    -- allowed difference 18 (core/meta.lua fold_entry, rule 173): v1's text holds characters the game font cannot draw (the section sign of a campaign
    -- ribbon rank, an em dash); the card has them folded to ASCII with the table the pages use
    for _, f in ipairs({'description', 'reward', 'start_npc', 'start_zone', 'start_pos', 'fame', 'fame_level', 'title', 'repeatable'}) do
        if type(want[f]) == 'string' and type(e[f]) == 'string' and e[f] ~= want[f] and meta.fold(want[f]) == e[f] then
            w[f] = e[f]
            refined = refined + 1
            folded[#folded + 1] = cat .. '|' .. area .. '|' .. tostring(id) .. ':' .. f
        end
    end
    if type(want.title) == 'string' and want.title:find('^%*') and e.title == want.title:gsub('^%*%s*', '') then
        w.title = e.title
        refined = refined + 1
    end
    if e.title ~= w.title then
        local pt = page_title(cat, area, id)
        if pt and e.title and letters(pt) == letters(e.title) then w.title = e.title refined = refined + 1 end
    end
    -- allowed difference 15 (core/meta.lua fame_from_page, rule 139): the card's fame is the page's Required Fame row where v1 named another nation
    -- ("Outlands Fame Level: 1" over v1's "Other 1") or held other text ("Accepted at IS 25372" over "Treasures of Aht Urhgan"). Read here from the
    -- page's own row: the nation (or the whole row, when it has no "Fame Level:") is what the card says.
    if e.fame ~= want.fame or e.fame_level ~= want.fame_level then
        local file = pages_index[cat .. '|' .. area .. '|' .. tostring(id)]
        local pg = file and dofile(V2 .. file)
        local row = pg and pg.meta and pg.meta['Required Fame']
        if type(row) == 'string' and type(e.fame) == 'string' then
            local t = ''
            for _, sp in ipairs(D_doc.inline(row)) do if sp.t == 'text' or sp.t == 'link' then t = t .. (sp.s or '') end end
            local nation = t:match('^(.-)%s*Fame Level:')
            if (nation and letters(nation) == letters(e.fame)) or (not nation and t:gsub('^%s+', ''):gsub('%s+$', '') == e.fame) then
                w.fame, w.fame_level = e.fame, e.fame_level
                refined = refined + 1
            end
        end
    end
    -- allowed difference 19 (core/meta.lua fold_entry, rule 175): v1 wrote "3000gil" (quest wotg 10); the card sets the amount off from its number
    if type(want.reward) == 'string' and type(e.reward) == 'string' and e.reward ~= want.reward
        and want.reward:gsub('(%d)([Gg]il)%f[%A]', '%1 %2') == e.reward then
        w.reward = e.reward
        refined = refined + 1
        gil_spaced[#gil_spaced + 1] = cat .. '|' .. area .. '|' .. tostring(id)
    end
    -- allowed difference 21 (core/meta.lua fold_entry, rule 194): v1 wrote "900Allied Notes" / "666Experience Points" (mission campaign 266, 221); the card sets the name off from its number
    if type(want.reward) == 'string' and type(e.reward) == 'string' and e.reward ~= w.reward
        and w.reward:gsub('(%d)(%u)', '%1 %2') == e.reward then
        w.reward = e.reward
        refined = refined + 1
        num_spaced[#num_spaced + 1] = cat .. '|' .. area .. '|' .. tostring(id)
    end
    local ps = (e.start_npc ~= want.start_npc or e.start_zone ~= want.start_zone) and page_start(cat, area, id)
    if ps then
        local hit = false
        if ps.npc and e.start_npc == ps.npc and want.start_npc ~= nil then w.start_npc = e.start_npc hit = true end
        if ps.zone and e.start_zone == ps.zone then
            w.start_zone = e.start_zone
            if ps.pos and e.start_pos == ps.pos then w.start_pos = e.start_pos end
            hit = true
        end
        -- allowed difference 9 (core/meta.lua start_from_page): a row that names a place and no one has no NPC on the card (v1 held the place)
        if ps.zone and not ps.npc and e.start_npc == nil and want.start_npc ~= nil and letters(want.start_npc) == letters(ps.zone) then
            w.start_npc = nil
            hit = true
        end
        -- allowed difference 14 (core/meta.lua start_from_page, rule 129): v1 has no starting NPC (the assault missions) and the page's row names
        -- one person: the card has that person
        if want.start_npc == nil and ps.npc and ps.person and e.start_npc == ps.npc then
            w.start_npc = e.start_npc
            hit = true
        end
        if hit then w.npc = npc refined = refined + 1 end
    end
    -- allowed difference 8 (core/meta.lua description_from_page): the card's description is the page's Description row (toau 19: v1 stopped
    -- after "How will Naja Salaheem"; sandoria 2: a typo; jeuno 164: the end lost)
    if e.description ~= want.description and type(e.description) == 'string' then
        local file = pages_index[cat .. '|' .. area .. '|' .. tostring(id)]
        local pg = file and dofile(V2 .. file)
        local m = pg and pg.meta
        if m and type(m.Description) == 'string' then
            local t = ''
            for _, sp in ipairs(D_doc.inline(m.Description)) do
                if sp.t == 'br' then t = t .. ' ' elseif sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' then t = t .. (sp.s or '') end
            end
            if letters(t) ~= '' and letters(t) == letters(e.description) then w.description = e.description refined = refined + 1 end
        end
    end
    -- allowed difference 20 (core/meta.lua description_from_objective, rule 191): a Campaign Op's card description is the page's Objective row where
    -- v1 began the same way and then differed (cut at a link, "vis" for "via")
    if e.description ~= want.description and type(e.description) == 'string' and type(want.description) == 'string' then
        local file = pages_index[cat .. '|' .. area .. '|' .. tostring(id)]
        local pg = file and dofile(V2 .. file)
        local m = pg and pg.meta
        if m and type(m.Objective) == 'string' and type(m.Description) ~= 'string' then
            local t = ''
            for _, sp in ipairs(D_doc.inline(m.Objective)) do
                if sp.t == 'br' then t = t .. ' ' elseif sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' then t = t .. (sp.s or '') end
            end
            local a, b = letters(t), letters(want.description)
            if #a >= 40 and #b >= 40 and a:sub(1, 40) == b:sub(1, 40) and letters(e.description) == a then w.description = e.description refined = refined + 1 end
        end
    end
    if e.repeatable ~= want.repeatable then
        local file = pages_index[cat .. '|' .. area .. '|' .. tostring(id)]
        local pg = file and dofile(V2 .. file)
        local m = pg and pg.meta
        if m and type(m.Repeatable) == 'string' then
            local t = ''
            for _, sp in ipairs(D_doc.inline(m.Repeatable)) do
                if sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' then t = t .. (sp.s or '') end
            end
            t = t:gsub('^%s+', ''):gsub('%s+$', '')
            if t ~= '' and t:lower() ~= 'none' and e.repeatable == t then w.repeatable = t refined = refined + 1 end
        end
    end
    -- allowed difference 7 (core/meta.lua reward_from_page): a reward v1 cut short is the page's Rewards row (toau 46's rings)
    if type(want.reward) == 'string' and type(e.reward) == 'string' and e.reward ~= want.reward then
        local a, b = letters(want.reward), letters(e.reward)
        if a ~= '' and #b > #a and b:sub(1, #a) == a then w.reward = e.reward refined = refined + 1 end
    end
    -- allowed difference 13 (core/meta.lua reward_from_page, rule 81): v1 rewrote a long Rewards row as a few lines (adoulin 368) and the card
    -- takes the page's lines
    if type(want.reward) == 'string' and type(e.reward) == 'string' and e.reward ~= w.reward then
        local pl = page_reward_lines(cat, area, id)
        if pl then
            local lines, lost = reward_loss(pl, want.reward)
            if lines >= 3 and lost * 2 >= lines and letters(table.concat(pl)) == letters(e.reward) then w.reward = e.reward refined = refined + 1 end
        end
    end
    -- allowed difference 12 (core/meta.lua start_from_page): a row that names several zones and a v1 zone that is none of them (wotg 0: "Rolanberry
    -- Fields, or Sauromugue Champaign.") is the list of the row's zones
    if type(e.start_zone) == 'string' and e.start_zone ~= want.start_zone then
        local zs = page_zones(cat, area, id)
        if #zs >= 2 then
            local have, hit = letters(e.start_zone), true
            for _, z in ipairs(zs) do if not have:find(letters(z), 1, true) then hit = false end end
            local old_one = false
            for _, z in ipairs(zs) do if type(want.start_zone) == 'string' and letters(want.start_zone) == letters(z) then old_one = true end end
            if hit and not old_one then
                w.start_zone = e.start_zone refined = refined + 1
                -- rule 106: the card's one-line start (npc, zone, position) follows the zone of the row, as the three fields do (cop 128
                -- "Any of the Following:" with three Promyvion zones: v1's line had the sentence's first words only)
                w.npc = d2.format_npc_info({start_npc = w.start_npc, start_zone = w.start_zone, start_pos = w.start_pos})
            end
        end
    end
    -- allowed difference 15 (core/meta.lua start_from_page, rule 155): v1 cut "Roskin (Near Cafe des Larmes, Eastern Adoulin)" at the comma and the
    -- zone kept a closing bracket ("Eastern Adoulin)"); the card's zone has none
    if type(want.start_zone) == 'string' and type(e.start_zone) == 'string' and e.start_zone ~= want.start_zone then
        local _, o = want.start_zone:gsub('%(', '')
        local _, c = want.start_zone:gsub('%)', '')
        if c > o and want.start_zone:gsub('%s*%)+$', '') == e.start_zone then
            w.start_zone = e.start_zone refined = refined + 1
            w.npc = d2.format_npc_info({start_npc = w.start_npc, start_zone = w.start_zone, start_pos = w.start_pos})
        end
    end
    -- allowed difference 17 (core/meta.lua start_from_page, rule 158): the same v1 cut left the NPC "Amchuchu (Inventors' Coalition" with its bracket
    -- open; the card's NPC has the bracket closed (adoulin 110, 111, 134)
    if type(want.start_npc) == 'string' and type(e.start_npc) == 'string' and e.start_npc ~= want.start_npc then
        local _, o = want.start_npc:gsub('%(', '')
        local _, c = want.start_npc:gsub('%)', '')
        if o > c and want.start_npc .. string.rep(')', o - c) == e.start_npc then
            w.start_npc = e.start_npc refined = refined + 1
            w.npc = d2.format_npc_info({start_npc = w.start_npc, start_zone = w.start_zone, start_pos = w.start_pos})
        end
    end
    -- allowed difference 16 (core/meta.lua reward_from_page, rule 156): v1 kept "or 30,000 Bayld" and lost the item before it; the card has the page's lines
    if type(want.reward) == 'string' and type(e.reward) == 'string' and e.reward ~= want.reward and want.reward:match('^%s*[Oo][Rr]%s') then
        local a, b = letters(want.reward), letters(e.reward)
        local i = b:find(a, 1, true)
        if a ~= '' and i and i > 1 then w.reward = e.reward refined = refined + 1 end
    end
    -- allowed difference 11 (core/meta.lua reward_from_page): v1 has no reward and the page's Rewards row lists one (wotg 53's Moonshade Earring)
    local v1_stub = want.nreq == 0 and not want.prev and not want.next
    for _, f in ipairs(FIELDS) do if f ~= 'id' and want[f] ~= nil then v1_stub = false end end
    if want.reward == nil and type(e.reward) == 'string' and not v1_stub then
        local file = pages_index[cat .. '|' .. area .. '|' .. tostring(id)]
        local pg = file and dofile(V2 .. file)
        local m = pg and pg.meta
        if m and type(m.Rewards) == 'string' then
            local t = ''
            for _, sp in ipairs(D_doc.inline(m.Rewards)) do
                if sp.t == 'br' then t = t .. string.char(10) elseif sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' then t = t .. (sp.s or '') end
            end
            if letters(t) ~= '' and letters(t) == letters(e.reward) then
                w.reward = e.reward
                refined = refined + 1
                reward_added[#reward_added + 1] = cat .. '|' .. area .. '|' .. tostring(id)
            end
        end
    end
    if type(want.fame_level) == 'string' and want.fame_level:lower():find('level', 1, true) and e.fame_level ~= want.fame_level
        and e.fame_level == want.fame_level:match('(%d+)%s*$') then
        w.fame_level = e.fame_level
        refined = refined + 1
    end
    return w
end
local function repaired_requirements(cat, area, name, id, e, want)
    local raw = raw_entry(cat, area, name)
    if not (raw and type(raw.requirements) == 'table' and pages_index[cat .. '|' .. area .. '|' .. tostring(id)]) then return false end
    local bad = false
    for _, r in ipairs(raw.requirements) do if meta.malformed_requirement(r) or meta.fragment_requirement(r) then bad = true end end   -- fragment rows: rule 152
    if not bad then return false end
    for _, f in ipairs(FIELDS) do if e[f] ~= want[f] then return false end end
    return (e.previous and table.concat(e.previous, ';')) == want.prev and (e.next and table.concat(e.next, ';')) == want.next
end
-- A start the card and the area rows draw must not read as a place where a person belongs: "METALWORKS - METALWORKS",
-- or a wiki anchor ("Varies. Promathia Mission 3-3#Walkthrough").
local function looks_like_place(npc, zone)
    return (zone ~= nil and npc:lower() == zone:lower()) or npc:find('#', 1, true) ~= nil or npc:lower():find('^varies') ~= nil
end

-- Every campaign operation is accepted from its nation's Campaign Ops NPC in the capital, so a row with a nation suffix
-- starts from that officer: NPC, zone and grid square. BG-wiki, Category:Campaign Ops and the "Campaign Ops NPC" page,
-- and the NPCs' own pages (Rasdinice, Hieronymus, Emhi Tchaoryo). Six rows carried a mistyped grid square from their own
-- wiki page (Hazardous Materials (B) H-9, Bridge Too Far I (W) J-9, By Light of Fire I (B) and Pit Spider I, II, III (B) I-9).
local OFFICER = {
    S = {start_npc = 'Rasdinice', start_zone = "Southern San d'Oria (S)", start_pos = 'I-9'},
    B = {start_npc = 'Hieronymus', start_zone = 'Bastok Markets (S)', start_pos = 'E-8'},
    W = {start_npc = 'Emhi Tchaoryo', start_zone = 'Windurst Waters (S)', start_pos = 'H-9'},
}
-- an entry holding nothing but an id and a start (a campaign row split_meta made from a nation's officer)
local function only_start(e)
    for k in pairs(e) do
        if k ~= 'id' and k ~= 'start_npc' and k ~= 'start_zone' and k ~= 'start_pos' then return false end
    end
    return e.start_npc ~= nil and e.start_zone ~= nil
end

-- Rule 188 (campaign, 26 operations of the three nations): v1 has no row for the operation, split_meta.lua made one from the nation's
-- officer (id and start), and the entry then takes the page's Rewards for its card (core/meta.lua reward_from_page: "v1 has no reward at
-- all and the page lists one"). That entry is an id, the officer's start and the page's own reward lines, nothing else; it is still the
-- stub only_start() describes, plus the one field the wiki fills. A reward that is not the page's, or any other field, is not allowed.
-- PAGE_REWARD = false is the check before rule 188.
local PAGE_REWARD = true
local function start_and_page_reward(e, cat, area, id)
    if not PAGE_REWARD or type(e.reward) ~= 'string' then return false end
    local rest = {}
    for k, v in pairs(e) do if k ~= 'reward' then rest[k] = v end end
    if not only_start(rest) then return false end
    local pl = page_reward_lines(cat, area, id)
    return pl ~= nil and #pl > 0 and letters(table.concat(pl)) == letters(e.reward)
end
local function cleaned_start(cat, area, name, e, want)
    for _, f in ipairs(FIELDS) do
        if f ~= 'start_npc' and f ~= 'start_zone' and f ~= 'start_pos' and e[f] ~= want[f]
            and not (f == 'id' and want.id == nil) then return false end
    end
    -- campaign rows only: the start is the nation's officer, whatever v1 scraped (none, or a mistyped grid square)
    local officer = cat == 'mission' and area == 'campaign' and OFFICER[name:match('%((%a)%)$') or '']
    if officer and e.start_npc == officer.start_npc and e.start_zone == officer.start_zone and e.start_pos == officer.start_pos then
        return true
    end
    if want.start_npc == nil and want.start_zone == nil and want.start_pos == nil then
        return cat == 'mission' and area == 'campaign' and e.start_npc ~= nil and e.start_zone ~= nil
    end
    return e.start_zone == want.start_zone and e.start_pos == want.start_pos
        and (e.start_npc == nil or (cat == 'mission' and area == 'cop' and name == 'Three Paths' and e.start_npc == 'Cid'))
        and want.start_npc ~= nil and looks_like_place(want.start_npc, want.start_zone)
end
for cat, areas in pairs({quest = QUEST, mission = MISSION}) do
    for _, a in ipairs(areas) do
        local st = d2.get_area_status(cat, a)
        -- allowed difference 10 (core/data.lua, rule 75): v1 left WotG mission 53 "Lest We Forget" out of the list as a placeholder; the wiki has
        -- it as a mission, so v2 lists it. Every other row and the counts of the rest are v1's.
        local compared = st
        if cat == 'mission' and a == 'wotg' then
            local kept, found = {}, nil
            compared = {completed = st.completed, current = st.current, total = st.total, uncompletable = st.uncompletable, has_data = st.has_data, items = kept}
            for _, it in ipairs(st.items) do
                if it.id == 53 then
                    found = it
                    compared.total = compared.total - 1
                    if it.status == 'completed' then compared.completed = compared.completed - 1 end
                    if it.status == 'active' then compared.current = compared.current - 1 end
                else
                    kept[#kept + 1] = it
                end
            end
            check(found ~= nil and found.name == 'Lest We Forget', 'mission wotg 53 "Lest We Forget" is listed (v1 left it out as a placeholder)', found and found.name)
        end
        -- allowed difference 14 (core/data.lua, rule 104): the Chains of Promathia 5-3 paths. v1 hides Past Sins (540), The Pursuit of Paradise (550)
        -- and Where Messengers Gather (560) and lists the last section of the third, Flames for the Dead (568); the wiki has the three paths as
        -- missions and 568 as a section of the third. v2 lists the three and hides 568; every other row and the counts of the rest are v1's.
        local v1_cmp = s1[cat][a]
        if cat == 'mission' and a == 'cop' then
            local function without(t, ids)
                local out = {completed = t.completed, current = t.current, total = t.total, uncompletable = t.uncompletable, has_data = t.has_data, items = {}}
                local found = {}
                for _, it in ipairs(t.items) do
                    if ids[it.id] then
                        found[it.id] = it
                        out.total = out.total - 1
                        if it.status == 'completed' then out.completed = out.completed - 1 end
                        if it.status == 'active' then out.current = out.current - 1 end
                        if it.status == 'uncompletable' then out.uncompletable = (out.uncompletable or 0) - 1 end
                    else
                        out.items[#out.items + 1] = it
                    end
                end
                return out, found
            end
            local mine, found = without(st, {[540] = true, [550] = true, [560] = true})
            check(found[540] and found[540].name == 'Past Sins' and found[550] and found[550].name == 'The Pursuit of Paradise'
                and found[560] and found[560].name == 'Where Messengers Gather' and not found[568], 'rule 104: cop lists the three paths by the wiki names', found[540] and found[540].name)
            -- the packet of this test says COP 540: that path is active, the others are not started
            check(found[540] and found[540].status == 'active' and found[550] and found[550].status == 'not_started' and found[560] and found[560].status == 'not_started',
                'rule 104: the path the packet is in is active', (found[540] and found[540].status or '?') .. ' ' .. (found[550] and found[550].status or '?'))
            local theirs, v1_568 = without(s1[cat][a], {[568] = true})
            check(v1_568[568] ~= nil, 'rule 104: v1 lists 568 (the fault the rule exists for)')
            compared, v1_cmp = mine, theirs
            -- self-test: with the rule off the list is v1's exactly
            d2.COP_PATHS = false
            same_status(s1[cat][a], d2.get_area_status(cat, a), 'self-test: rule 104 off, cop is the v1 list')
            d2.COP_PATHS = true
        end
        same_status(v1_cmp, compared, cat .. ' ' .. a)
        for _, item in ipairs(st.items) do
            local want = e1[cat .. '|' .. a .. '|' .. item.id]
            local e = cat == 'mission' and d2.get_mission_data(a, item.name, item.id) or d2.get_quest_data(a, item.name)
            local npc = d2.format_npc_info(d2.get_npc_info(a, item.name, cat))
            entries = entries + 1
            if want == nil then
                -- v1 has no row for it (the one allowed: wotg 53, above): the entry still has its id and name
                local path_ids = {[540] = true, [550] = true, [560] = true}
                check(cat == 'mission' and ((a == 'wotg' and item.id == 53) or (a == 'cop' and path_ids[item.id])) and e ~= nil and e.id == item.id,
                    'entry v1 does not list: ' .. cat .. ' ' .. a .. ' ' .. item.name)
            elseif (e == nil) ~= (want.id == nil) and not (e and a == 'campaign' and want.id == nil and (only_start(e) or start_and_page_reward(e, cat, a, item.id))) then
                check(false, 'entry presence ' .. cat .. ' ' .. a .. ' ' .. item.name)
            elseif e then
                local want0 = want            -- v1's own record: the stub test below reads it, not the refined one
                want = refined_want(cat, a, item.id, e, want, npc)
                local ok = npc == want.npc
                for _, f in ipairs(FIELDS) do ok = ok and e[f] == want[f] end
                ok = ok and (e.previous and table.concat(e.previous, ';')) == want.prev
                ok = ok and (e.next and table.concat(e.next, ';')) == want.next
                ok = ok and (e.requirements and #e.requirements or 0) == want.nreq
                -- the one allowed difference: v1 holds only an id for the entry (a name three nations share) and its
                -- walkthrough page, converted from BG-wiki, fills the card (core/meta.lua fill_from_page); v2 must keep the id
                -- and every field v1 has, and the entry must have a page
                if not ok and want.id and pages_index[cat .. '|' .. a .. '|' .. item.id] then
                    local v1_stub = want0.nreq == 0 and not want0.prev and not want0.next
                    for _, f in ipairs(FIELDS) do if f ~= 'id' and want0[f] ~= nil then v1_stub = false end end
                    if v1_stub and e.id == want0.id then ok = true filled_from_pages = filled_from_pages + 1 end
                end
                -- allowed difference 2 (the metadata splitter): a Starting NPC that v1 scraped as a place is
                -- dropped (or the person the walkthrough names), and a campaign row takes its nation's officer (none in v1, or a mistyped grid square)
                if not ok and cleaned_start(cat, a, item.name, e, want) then
                    ok = true; cleaned = cleaned + 1
                end
                if not ok and repaired_requirements(cat, a, item.name, item.id, e, want) then
                    ok = true; repaired = repaired + 1
                end
                check(ok, 'entry fields ' .. cat .. ' ' .. a .. ' ' .. item.name)
            else
                missing = missing + 1
            end
        end
    end
end

-- The entries whose Starting NPC looks like a place.
local function place_npcs(areas_by_cat)
    local bad = {}
    for cat, areas in pairs(areas_by_cat) do
        for area, entries in pairs(areas) do
            for name, e in pairs(entries) do
                if e.start_npc and looks_like_place(e.start_npc, e.start_zone) then bad[#bad + 1] = cat .. '|' .. area .. '|' .. name end
            end
        end
    end
    table.sort(bad)
    return bad
end
local all_meta = {quest = {}, mission = {}}
for cat, areas in pairs({quest = QUEST, mission = MISSION}) do
    for _, a in ipairs(areas) do
        local f = loadfile(V2 .. 'meta/' .. cat .. 's/' .. a .. '.lua')
        all_meta[cat][a] = f and f() or {}
    end
end
local bad = place_npcs(all_meta)
for _, b in ipairs(bad) do check(false, 'Starting NPC is a place: ' .. b) end
check(#bad == 0, 'no entry has a place as its Starting NPC')
-- self-test: the check must catch a place, a wiki anchor and a "Varies" in a copy of the data
do
    local fake = {mission = {cop = {
        A = {start_npc = 'Metalworks', start_zone = 'Metalworks'},
        B = {start_npc = 'Varies. Promathia Mission 3-3#Walkthrough'},
        C = {start_npc = 'Cid', start_zone = 'Metalworks'},
        D = {start_npc = 'Home Point #3', start_zone = 'Lower Jeuno'},
    }}}
    local caught = place_npcs(fake)
    check(#caught == 3 and caught[1] == 'mission|cop|A' and caught[2] == 'mission|cop|B' and caught[3] == 'mission|cop|D',
        'self-test: a place, an anchor and a # are caught, a person is not')
end

-- Every campaign row has the officer who starts it (rows 2-5 of an operation were blank in v1's scrape).
do
    local names = dofile(V2 .. 'maps/missions/campaign.lua')
    local blank = {}
    for id, name in pairs(names) do
        local e = all_meta.mission.campaign[name]
        if not (e and e.start_npc and e.start_zone) then blank[#blank + 1] = id .. ' ' .. name end
    end
    table.sort(blank)
    for _, b in ipairs(blank) do check(false, 'campaign row without a start: ' .. b) end
    check(#blank == 0, 'every campaign row has a start NPC and zone')
    -- self-test: with a row's start removed from a copy, the same scan reports it
    local copy = {}
    for k, v in pairs(all_meta.mission.campaign) do copy[k] = v end
    copy['Smokescreen II (S)'] = {id = 2}
    local n = 0
    for id, name in pairs(names) do
        local e = copy[name]
        if not (e and e.start_npc and e.start_zone) then n = n + 1 end
    end
    check(n == 1, 'self-test: a campaign row without a start is caught')
end

local function off_officer(names, rows)
    local bad = {}
    local function scan(name, id)
        local want = OFFICER[name:match('%((%a)%)$') or '']
        if not want then return end
        local e = rows[name]
        if not (e and e.start_npc == want.start_npc and e.start_zone == want.start_zone and e.start_pos == want.start_pos) then
            bad[#bad + 1] = (id or '-') .. ' ' .. name .. ' ' .. tostring(e and e.start_npc) .. ' / ' .. tostring(e and e.start_zone)
                .. ' / ' .. tostring(e and e.start_pos)
        end
    end
    local listed = {}
    for id, name in pairs(names) do scan(name, id); listed[name] = true end
    for name in pairs(rows) do if not listed[name] then scan(name) end end
    table.sort(bad)
    return bad
end
do
    local names = dofile(V2 .. 'maps/missions/campaign.lua')
    local bad = off_officer(names, all_meta.mission.campaign)
    for _, b in ipairs(bad) do check(false, 'campaign row not from its nation officer: ' .. b) end
    check(#bad == 0, 'every campaign row with a nation suffix starts from its nation officer (NPC, zone, position)')
    -- self-test: from rows that are all right, a wrong grid square, a wrong zone and a wrong NPC are each caught
    local copy = {}
    for _, name in pairs(names) do
        local want = OFFICER[name:match('%((%a)%)$') or '']
        if want then copy[name] = {start_npc = want.start_npc, start_zone = want.start_zone, start_pos = want.start_pos} end
    end
    check(#off_officer(names, copy) == 0, 'self-test: rows that all start from their officer are accepted')
    copy['Smokescreen II (S)'].start_pos = 'I-8'
    copy['Smokescreen IV (B)'].start_zone = 'Bastok Mines'
    copy['Smokescreen IV (W)'].start_npc = 'Rasdinice'
    local caught = off_officer(names, copy)
    local seen = {}
    for _, c in ipairs(caught) do seen[c:match('^%d+ (.-%)) ') or c] = true end
    check(#caught == 3 and seen['Smokescreen II (S)'] and seen['Smokescreen IV (B)'] and seen['Smokescreen IV (W)'],
        'self-test: a wrong grid square, zone and NPC are caught (' .. #caught .. ')')
end

-- Name -> area lookups, where v1's answer was unambiguous.
check(d2.find_mission_area('Three Paths') == 'cop', 'find Three Paths')
check(d2.find_mission_area('Magicite', 'windurst') == 'windurst', 'prefer area on a duplicate name')
check(d2.find_quest_area('This name does not exist') == nil, 'unknown quest name')
local tp = d2.get_mission_data('cop', 'Three Paths', 530)
check(tp and tp.id == 530 and tp.title == 'Treader of an Icy Past' and tp.walkthrough == nil, 'Three Paths meta, no walkthrough')

-- Heap: at most two areas per category resident, and release returns the heap.
local n = meta.resident()
check(n <= 4, 'resident areas capped (' .. n .. ')')
local before = heap()
meta.release()
local after = heap()
check(after < before, 'release frees the heap')
local rest = heap()

-- Requirements: a row the wiki writes with a quantity or in the plural ("4 Flint Stones", "2 Bat Wings") must find its
-- item (the game's res/items.lua, as split_meta does) and carry the quantity as its count; before 2026-10-19 the exact
-- name missed, so the row had a dash for an icon and the card's counter read "0 / 0".
do
    local items = dofile(V2 .. '../../res/items.lua')
    local known = {}
    for _, it in pairs(items) do
        if it.en and it.id ~= 65535 then known[it.en:lower()] = it.id end        -- gil is not kept in a bag
        if it.enl and it.id ~= 65535 then known[it.enl:lower()] = known[it.enl:lower()] or it.id end
    end
    items = nil
    local function missed(reqs_by_entry)
        local bad = {}
        for key, reqs in pairs(reqs_by_entry) do
            for _, r in ipairs(reqs) do
                local name = r.name:gsub('%s+', ' ')
                local qty, rest = name:match('^(%d[%d,]*)x?%s+(.+)$')
                local base = (rest or name):lower()
                local found = known[base] or known[base:gsub('s$', '')] or known[base:gsub('es$', '')]
                if not r.id and found then bad[#bad + 1] = key .. ': ' .. r.name end
            end
        end
        table.sort(bad)
        return bad
    end
    local reqs = {}
    for cat, areas in pairs(all_meta) do
        for area, entries in pairs(areas) do
            for name, e in pairs(entries) do
                if e.requirements then reqs[cat .. '|' .. area .. '|' .. name] = e.requirements end
            end
        end
    end
    local bad = missed(reqs)
    for _, b in ipairs(bad) do check(false, 'requirement not resolved to its item: ' .. b) end
    check(#bad == 0, 'every requirement naming an item (plural, with a quantity) resolves')
    -- the counts the rows carry
    local function req(cat, area, entry, i) return all_meta[cat][area][entry].requirements[i] end
    local flint = req('quest', 'sandoria', 'Starting a Flame', 1)
    check(flint.id ~= nil and flint.count == 4 and flint.name == 'Flint Stone', 'Starting a Flame: 4 Flint Stone')
    local wings = req('quest', 'sandoria', 'Fear of the Dark', 1)
    check(wings.id ~= nil and wings.count == 2, 'Fear of the Dark: 2 Bat Wing')
    -- self-test: an unresolved "4 Flint Stones" is caught
    local caught = missed({fake = {{name = '4 Flint Stones', count = 1}, {name = '10,000 Moat Carp and/or Forest Carp', count = 1}}})
    check(#caught == 1, 'self-test: a quantity row left without its item is caught')
end

-- Requirement rows the v1 scrape could not resolve (2026-10-20: sandoria 84's "[Key Item]" alone on a dash line, 70's "Cupboard" and
-- "Mistletoe" in one row with no icon): rebuilt from the entry's page, where it has one
do
    local NLC = string.char(10)
    check(meta.malformed_requirement({name = 'Cupboard' .. NLC .. 'Mistletoe'}) and meta.malformed_requirement({name = '[Key Item]'})
        and meta.malformed_requirement({name = '[Key Item]  '}), 'malformed requirement: a line break in a name, a bare key item label')
    check(not meta.malformed_requirement({name = '[Key Item] Altepa polishing stone'}) and not meta.malformed_requirement({name = 'Flint Stone'})
        and not meta.malformed_requirement({}), 'malformed requirement: a named key item, an item, nothing')
    local D = require('ui/doc')
    local rows, choice = meta.requirement_rows(D.inline('{@i:Cupboard|57} {i:Cupboard|Cupboard|57} {br}{@i:Lambent Scale|2} {i:Lambent Scale|Lambent Scale|2} x2{br} {@k} {k:Orcish dried food}'))
    check(#rows == 3 and rows[1].id == 57 and rows[1].name == 'Cupboard' and rows[1].count == 1 and rows[2].id == 2 and rows[2].count == 2
        and rows[3].ki and rows[3].name == '[Key Item] Orcish dried food' and rows[3].id == nil and not choice,
        'requirement rows: an icon and its link are one row, "x2" is the count, a key item has its name')
    local _, ch = meta.requirement_rows(D.inline('{i:Silk Thread|Silk Thread|1}{br} or {br}{i:Crawler Calculus|Crawler Calculus|2}'))
    check(ch, 'requirement rows: a page that offers a choice says so')
    local seven = meta.get('quest', 'sandoria', nil, 70)
    local r1, r2 = seven.requirements[1], seven.requirements[2]
    check(#seven.requirements == 2 and r1.name == 'Cupboard' and r1.id == 57 and r2.name == 'Mistletoe' and r2.id == 918,
        'sandoria 70: the card has Cupboard and Mistletoe, each with its item id (was one row, "Cupboard<NL>Mistletoe")')
    local crim = meta.get('quest', 'sandoria', nil, 84)
    check(#crim.requirements == 2 and crim.requirements[1].id == 1103 and crim.requirements[2].ki and crim.requirements[2].name == '[Key Item] Orcish dried food',
        'sandoria 84: the card names the key item (was a bare "[Key Item]")')
    -- the defect is in the data the repair starts from, and every entry with a page is free of it after
    local raw70, raw84 = raw_entry('quest', 'sandoria', 'Unexpected Treasure'), raw_entry('quest', 'sandoria', 'The Crimson Trial')
    check(meta.malformed_requirement(raw70.requirements[1]) and meta.malformed_requirement(raw84.requirements[2]),
        'the v1 rows of sandoria 70 and 84 are malformed (the fault the repair exists for)')
    local left = {}
    for k in pairs(pages_index) do
        local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
        local ent = meta.get(cat, area, nil, tonumber(id))
        for _, r in ipairs(ent and ent.requirements or {}) do
            if meta.malformed_requirement(r) then left[#left + 1] = k .. ': ' .. r.name:gsub(NLC, '/') end
        end
    end
    table.sort(left)
    for _, l in ipairs(left) do check(false, 'a malformed requirement row on a page-backed entry: ' .. l) end
    check(#left == 0, 'no entry with a page has a malformed requirement row')
    -- rule 138: outlands 165 (Open Sesame): Tremorstone, and an "or" inside a line the rows cannot show; the v1 row keeps its words on one line
    local raw165 = raw_entry('quest', 'outlands', 'Open Sesame')
    check(raw165 and meta.malformed_requirement(raw165.requirements[1]), 'the v1 row of outlands 165 has a line break in its name (the fault rule 138 exists for)')
    local e165 = meta.get('quest', 'outlands', nil, 165)
    check(e165 and #e165.requirements == 1 and e165.requirements[1].name == 'Tremorstone and one of the following: 1x Meteorite or 1x Soil Gem or 12x Soil Geode',
        'outlands 165: the card row is one line of the v1 words', e165 and e165.requirements[1] and e165.requirements[1].name)
    meta.CHOICE_ONE_ROW = false
    meta.release()
    local off165 = meta.get('quest', 'outlands', nil, 165)
    local still = off165 and off165.requirements[1] and meta.malformed_requirement(off165.requirements[1])
    meta.CHOICE_ONE_ROW = nil
    meta.release()
    check(still, 'self-test: with rule 138 off the row of outlands 165 is malformed again (caught)')
end

-- Rule 144 (quest other 7, 34, toau 2): a Requirements row that says "One of the following ..." / "Any one of the following:" over a list: the
-- rows under it are a choice, left out of the card's total (the guide's counter), and a row named before it (the Pickaxe) stays needed
do
    local function total(e)       -- the guide's counter: units needed over the found rows that are not a choice
        local need = 0
        for _, r in ipairs(e.requirements or {}) do if r.id and not r.choice and not r.sep then need = need + (r.count or 1) end end
        return need
    end
    local function state()
        local o7, o34, t2 = meta.get('quest', 'other', nil, 7), meta.get('quest', 'other', nil, 34), meta.get('quest', 'toau', nil, 2)
        local pick, kis = t2 and t2.requirements[1], 0
        for i = 2, t2 and #t2.requirements or 0 do if t2.requirements[i].choice and t2.requirements[i].ki then kis = kis + 1 end end
        return o7, o34, t2, pick, kis
    end
    local o7, o34, t2, pick, kis = state()
    check(o7 and #o7.requirements == 11 and total(o7) == 0, 'other 7 (Orlando Antiques): eleven alternatives of eight are a choice, no total of 88', o7 and total(o7))
    check(o34 and #o34.requirements == 3 and total(o34) == 0, 'other 34 (Monstrosity): "any one of the following" three items are a choice', o34 and total(o34))
    check(t2 and pick and pick.name == 'Pickaxe' and not pick.choice and kis == 3 and total(t2) == 1, 'toau 2 (Olduum): the Pickaxe is needed, the three key items are a choice', t2 and total(t2))
    -- no entry of another shape moves: the entries with a cue line are these three (and toau 23, whose rows are all text rows)
    local cued = {}
    for k in pairs(pages_index) do
        local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
        local ent = cat == 'quest' and meta.get(cat, area, nil, tonumber(id))
        for _, r in ipairs(ent and ent.requirements or {}) do
            if r.choice and not r.sep then cued[#cued + 1] = k break end
        end
    end
    table.sort(cued)
    local seen = {}
    for _, k in ipairs(cued) do seen[k] = true end
    check(seen['quest|other|7'] and seen['quest|other|34'] and seen['quest|toau|2'], 'the rows of a "one of the following" list are marked as a choice')
    meta.CHOICE_FROM_PAGE = false
    meta.release()
    local f7, f34, f2 = meta.get('quest', 'other', nil, 7), meta.get('quest', 'other', nil, 34), meta.get('quest', 'toau', nil, 2)
    local caught = total(f7) == 88 and total(f34) == 3 and total(f2) == 4
    meta.CHOICE_FROM_PAGE = nil
    meta.release()
    check(caught, 'self-test: with rule 144 off the counters read 88, 3 and 4 again (caught)')
end

-- Rule 152 (vision wave, F5): v1's requirement rows are fragments of the wiki's one sentence ("Onion Dagger x5 or", "Istakoz,",
-- "Istiridye, and", "[Key Item] A, B, and C", "1 Scream Fungus, 1 Land Crab Meat"). No drawn text-only row of a page-backed entry is
-- only a connector, ends with one, or lists several names; the rows are the page's own (items with their ids), an "or" at the end of a
-- line a separator row between choices
do
    local function fragments()
        local found = {}
        for k in pairs(pages_index) do
            local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
            local ent = meta.get(cat, area, nil, tonumber(id))
            for _, r in ipairs(ent and ent.requirements or {}) do
                if meta.fragment_requirement(r) then found[#found + 1] = k .. ': ' .. r.name break end
            end
        end
        table.sort(found)
        return found
    end
    local left = fragments()
    for _, l in ipairs(left) do check(false, 'a requirement row that is a fragment of the wiki sentence: ' .. l) end
    check(#left == 0, 'no text-only requirement row of a page-backed entry is a connector, ends with one or lists several names')
    local function rows(area, id)
        local ent = meta.get('quest', area, nil, id)
        local t = {}
        for _, r in ipairs(ent and ent.requirements or {}) do t[#t + 1] = (r.sep and '|or|' or (r.name .. (r.id and ('#' .. r.id) or '') .. (r.count > 1 and ('x' .. r.count) or '') .. (r.choice and '?' or ''))) end
        return table.concat(t, ' ')
    end
    check(rows('other', 4) == 'Scream Fungus#4447 Land Crab Meat#4400', 'other 4: two item rows with their ids', rows('other', 4))
    check(rows('other', 16) == 'Onion Daggerx5? |or| Onion Knifex5? |or| Onion Rodx5? |or| Onion Staffx5? |or| Onion Sword#16534x5?', 'other 16: no "or" in a name, an "or" row between', rows('other', 16))
    check(rows('other', 18) == 'La Theine Cabbage#4366x5? |or| Millioncorn#629x3? |or| Boyahda Moss#919?', 'other 18: items with ids, "or" rows', rows('other', 18))
    check(rows('outlands', 130) == 'Eastern Pottery#1200x4? |or| Northern Fur#1199x4? |or| Southern Mummy#1201x4?', 'outlands 130', rows('outlands', 130))
    check(rows('outlands', 201) == '[Key Item] Serpent Rumors Opal Silk#1826 Saber Shoot#1837', 'outlands 201: a key item row and two item rows', rows('outlands', 201))
    check(rows('toau', 15) == 'Istakoz#5453 Mercanbaligi#5454 Ahtapot#5455 Istiridye#5456 Istavrit#5136', 'toau 15: five item rows, no comma or "and"', rows('toau', 15))
    -- a row that is not a fragment is as it was: the "or" lists inside a sentence (rule 138), a counter row, a sandoria key item row
    check(rows('outlands', 165) == 'Tremorstone and one of the following: 1x Meteorite or 1x Soil Gem or 12x Soil Geode', 'outlands 165 is left as rule 138 has it', rows('outlands', 165))
    check(rows('sandoria', 68) == 'Dahlia#959' and rows('sandoria', 104) == '[Key Item] Dropped item#348', 'sandoria 68 and 104 have no fragment rows')
    meta.TIDY_FRAGMENTS = false
    meta.release()
    local off = fragments()
    local offrows = rows('other', 16)
    meta.TIDY_FRAGMENTS = nil
    meta.release()
    local want = {'quest|other|16', 'quest|other|18', 'quest|other|4', 'quest|outlands|130', 'quest|outlands|201', 'quest|toau|15'}
    local seen = {}
    for _, l in ipairs(off) do seen[l:match('^[^:]+')] = true end
    local all = true
    for _, k in ipairs(want) do if not seen[k] then all = false end end
    check(all and offrows:find('x5 or', 1, true), 'self-test: with rule 152 off the scan finds the fragment rows of other 4, 16, 18, outlands 130, 201 and toau 15 again (caught)', #off)
    -- rule 162: a list of two needs in one row, one of them no item (abyssea 183: "Traverser stone, 10,000 Cruor"): a row each, the key item the page's
    check(rows('abyssea', 183) == '[Key Item] Traverser stone 10,000 Cruor', 'rule 162, abyssea 183: the key item row and a text row for the Cruor', rows('abyssea', 183))
    meta.SPLIT_LISTS = false
    meta.release()
    local off162 = fragments()
    local off162rows = rows('abyssea', 183)
    meta.SPLIT_LISTS = nil
    meta.release()
    local s162 = false
    for _, l in ipairs(off162) do if l:match('^quest|abyssea|183:') then s162 = true end end
    check(s162 and off162rows == 'Traverser stone, 10,000 Cruor', 'self-test: with rule 162 off the scan finds the one row of abyssea 183 again (caught)', off162rows)
    -- rule 165: a v1 row that is two lines of the page's Requirements joined ("Pea Soup or Emerald Soup Flint Stone", abyssea 74): a row a line
    local function run_ons()
        local found = {}
        for k in pairs(pages_index) do
            local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
            local ent = meta.get(cat, area, nil, tonumber(id))
            local lines = ent and ent.requirements and meta.page_requirement_lines(cat, area, tonumber(id))
            for _, r in ipairs(ent and ent.requirements or {}) do
                if meta.run_on_lines(r, lines) then found[#found + 1] = k .. ': ' .. r.name break end
            end
        end
        table.sort(found)
        return found
    end
    local left165 = run_ons()
    for _, l in ipairs(left165) do check(false, 'a requirement row that is two lines of the page joined: ' .. l) end
    check(#left165 == 0, 'no requirement row of a page-backed entry is several lines of the page joined into one (rule 165)')
    check(rows('abyssea', 74) == 'Pea Soup or Emerald Soup Flint Stone#768', 'rule 165, abyssea 74: a row for the soups and the Flint Stone row with its id', rows('abyssea', 74))
    check(rows('outlands', 165) == 'Tremorstone and one of the following: 1x Meteorite or 1x Soil Gem or 12x Soil Geode',
        'rule 165: outlands 165, a line that ends in a colon, stays the one row of rule 138', rows('outlands', 165))
    meta.SPLIT_RUNONS = false
    meta.release()
    local off165 = run_ons()
    meta.SPLIT_RUNONS = nil
    meta.release()
    check(#off165 == 1 and off165[1]:match('^quest|abyssea|74:'), 'self-test: with rule 165 off the scan finds the run-on row of abyssea 74 again (caught)', #off165 .. ' ' .. tostring(off165[1]))
end

-- Rules 155 and 156 (vision wave qad1, quest adoulin): the card's ZONE of a page-backed entry has no closing bracket left over from v1 cutting
-- "Roskin (Near Cafe des Larmes, Eastern Adoulin)" at its comma ("Eastern Adoulin)": adoulin 110, 111, 115, 116, 134), and its REWARD
-- does not begin with a connector ("or 30,000 Bayld", adoulin 117: v1 lost the Erudition Necklace before it)
do
    local function scan()
        local zone, reward, npc = {}, {}, {}
        for k in pairs(pages_index) do
            local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
            local ent = meta.get(cat, area, nil, tonumber(id))
            if ent then
                local z = ent.start_zone
                if type(z) == 'string' then
                    local _, o = z:gsub('%(', '')
                    local _, c = z:gsub('%)', '')
                    local _, ob = z:gsub('%[', '')
                    local _, cb = z:gsub('%]', '')
                    if o ~= c or ob ~= cb then zone[#zone + 1] = k end
                end
                local n = ent.start_npc
                if type(n) == 'string' then
                    local _, o = n:gsub('%(', '')
                    local _, c = n:gsub('%)', '')
                    if o ~= c then npc[#npc + 1] = k end
                end
                if type(ent.reward) == 'string' and (ent.reward:match('^%s*[Oo][Rr]%s') or ent.reward:match('^%s*[Aa][Nn][Dd]%s')) then reward[#reward + 1] = k end
            end
        end
        table.sort(zone) table.sort(reward) table.sort(npc)
        return zone, reward, npc
    end
    local zone, reward, npc = scan()
    for _, l in ipairs(zone) do check(false, 'a card zone with a bracket left over: ' .. l) end
    for _, l in ipairs(reward) do check(false, 'a card reward that begins with a connector: ' .. l) end
    for _, l in ipairs(npc) do check(false, 'a card NPC with a bracket left open: ' .. l) end
    check(#npc == 0, 'no page-backed card has an NPC with an unclosed bracket (rule 158)')
    check(#zone == 0 and #reward == 0, 'no page-backed card has a zone with an unmatched bracket or a reward that begins with "or" / "and"')
    local function zoned(id) local e = meta.get('quest', 'adoulin', nil, id) return e and e.start_zone end
    check(zoned(115) == 'Eastern Adoulin' and zoned(116) == 'Eastern Adoulin' and zoned(134) == 'Eastern Adoulin', 'adoulin 115, 116 and 134: the zone is Eastern Adoulin', tostring(zoned(115)) .. '/' .. tostring(zoned(116)) .. '/' .. tostring(zoned(134)))
    check(zoned(110) == 'Western Adoulin' and zoned(111) == 'Western Adoulin', 'adoulin 110 and 111: the zone is Western Adoulin')
    local r117 = meta.get('quest', 'adoulin', nil, 117)
    check(r117 and r117.reward:match('^Erudition Necklace or 30,000 Bayld\n10,000 Experience Points') ~= nil, 'adoulin 117: the reward starts with the necklace the page lists', r117 and r117.reward)
    local function npcd(id) local e = meta.get('quest', 'adoulin', nil, id) return e and e.start_npc end
    check(npcd(110) == "Amchuchu (Inventors' Coalition)" and npcd(111) == "Amchuchu (Inventors' Coalition)" and npcd(134) == 'Nhili Uvolep (Order of Renaye)',
        'adoulin 110, 111 and 134: the NPC has its bracket closed (rule 158)', tostring(npcd(110)) .. ' / ' .. tostring(npcd(134)))
    meta.ZONE_BRACKET = false
    meta.REWARD_LEAD = false
    meta.NPC_BRACKET = false
    meta.release()
    local zoff, roff, noff = scan()
    meta.ZONE_BRACKET = nil
    meta.REWARD_LEAD = nil
    meta.NPC_BRACKET = nil
    meta.release()
    local seen = {}
    for _, l in ipairs(noff) do seen[l] = true end
    check(seen['quest|adoulin|110'] and seen['quest|adoulin|111'] and seen['quest|adoulin|134'], 'self-test: with rule 158 off the scan finds the open NPC brackets of adoulin 110, 111 and 134 again (caught)', #noff)
    for _, l in ipairs(zoff) do seen[l] = true end
    for _, l in ipairs(roff) do seen[l] = true end
    local want = {'quest|adoulin|110', 'quest|adoulin|111', 'quest|adoulin|115', 'quest|adoulin|116', 'quest|adoulin|134', 'quest|adoulin|117'}
    local all = true
    for _, k in ipairs(want) do if not seen[k] then all = false end end
    check(all, 'self-test: with rules 155 and 156 off the scan finds the zones of adoulin 110, 111, 115, 116, 134 and the reward of 117 again (caught)', #zoff + #roff)
end

-- 2026-10-20 (Phase 1d): a choice ("or") in a Requirements row is rows with an "or" between them, not a name with line breaks in it;
-- the wiki's Repeatable is the card's; a fame level scraped with its nation in it is its number
do
    local D = require('ui/doc')
    local rows, ch, seps = meta.requirement_rows(D.inline('{i:Deathball|Deathball|4566}{br}-or-{br} {i:Sobbing Fungus|Sobbing Fungus|4565}'))
    check(#rows == 3 and rows[1].id == 4566 and rows[2].sep and rows[2].name == 'or' and rows[3].id == 4565 and ch and seps == 1
        and rows[1].choice and rows[3].choice and not rows[2].choice, 'requirement rows: "-or-" on a line of its own is a separator, the rows around it a choice')
    rows = meta.requirement_rows(D.inline('3x {i:Silk Thread|Silk Thread|816} {br}**OR** {br}3x {i:Crawler Calculus|Crawler Calculus|1156}'))
    check(#rows == 3 and rows[1].count == 3 and rows[3].count == 3 and rows[2].sep, 'requirement rows: "3x Silk Thread" is a count of 3')
    rows = meta.requirement_rows(D.inline('{i:Dhalmel Leather|Dhalmel Leather|848}, {i:Steel Ingot|Steel Ingot|652}{br}or{br}{q:Goblin Stew 880|Goblin Stew 880|Goblin Stew 880}'))
    check(#rows == 4 and rows[3].sep and rows[4].name == 'Goblin Stew 880' and rows[4].id == nil and rows[4].choice,
        'requirement rows: a quest alone on a line is a row of the choice')
    rows = meta.requirement_rows(D.inline('Must have started {q:The Talekeeper\'s Truth|X|X}.{br} {@i:Eld. Coffer Key|1046} {i:Eldieme Coffer Key|Eld. Coffer Key|1046}{br}-OR-{br} {@i:Thief\'s Tools|1022} {i:Thief\'s Tools|Thief\'s Tools|1022}'))
    check(#rows == 3 and rows[1].id == 1046 and rows[2].sep and rows[3].id == 1022, 'requirement rows: a sentence with a quest in it is not a row', #rows)
    local _, ch2, seps2 = meta.requirement_rows(D.inline('{i:Silk Thread|Silk Thread|1} or {i:Crawler Calculus|Crawler Calculus|2}'))
    check(ch2 and seps2 == 0, 'requirement rows: an "or" inside a line is a choice the rows cannot show (v1 stays)')
    local rows0 = meta.requirement_rows(D.inline('{i:Lambent Scale|Lambent Scale|2} x2{br}{@k} {k:Orcish dried food}'))
    check(#rows0 == 2 and not rows0[1].choice and not rows0[2].choice, 'requirement rows: without an "or" no row is a choice')
    local function names(e)
        local t = {}
        for _, r in ipairs(e.requirements) do t[#t + 1] = r.name end
        return table.concat(t, '|')
    end
    local w29 = meta.get('quest', 'windurst', nil, 29)
    check(names(w29) == 'Deathball|or|Sobbing Fungus' and w29.requirements[1].id == 4566, 'windurst 29: Deathball, or, Sobbing Fungus, with their ids', names(w29))
    local j44 = meta.get('quest', 'jeuno', nil, 44)
    check(names(j44):find('^Eld') and names(j44):find('|or|', 1, true) and j44.requirements[1].id == 1046, 'jeuno 44: the coffer key, or, Thief\'s Tools', names(j44))
    local j27 = meta.get('quest', 'jeuno', nil, 27)
    check(names(j27):find('Peridot|or|Goblin Stew 880', 1, true), 'jeuno 27: the four items, or, Goblin Stew 880', names(j27))
    local raw29 = raw_entry('quest', 'windurst', 'Reap What You Sow')
    check(raw29 and meta.malformed_requirement(raw29.requirements[1]), 'the v1 row of windurst 29 is malformed (the fault the choice rows exist for)')

    -- the wiki's Repeatable is the card's
    local s5 = meta.get('quest', 'sandoria', nil, 5)
    check(s5 and s5.repeatable == 'Yes', 'sandoria 5: the card says Repeatable Yes, as the wiki does', s5 and s5.repeatable)
    local diff = 0
    for k in pairs(pages_index) do
        local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
        local e = meta.get(cat, area, nil, tonumber(id))
        local pg = dofile(V2 .. pages_index[k])
        local m = pg.meta
        if e and m and type(m.Repeatable) == 'string' then
            local t = ''
            for _, sp in ipairs(D.inline(m.Repeatable)) do if sp.t == 'text' or sp.t == 'link' then t = t .. (sp.s or '') end end
            t = t:gsub('^%s+', ''):gsub('%s+$', '')
            if t ~= '' and t:lower() ~= 'none' and e.repeatable ~= t then
                diff = diff + 1
                check(false, 'the card says Repeatable "' .. tostring(e.repeatable) .. '" where the wiki says "' .. t .. '": ' .. k)
            end
        end
    end
    check(diff == 0, 'no entry with a page has a Repeatable that differs from its page')
    -- the fame level scraped as "Jeuno Level 3" is 3
    local j17 = meta.get('quest', 'jeuno', nil, 17)
    check(j17 and j17.fame_level == '3', 'jeuno 17: fame level 3, not "Jeuno Level 3"', j17 and j17.fame_level)
    for _, a in ipairs({'sandoria', 'bastok', 'windurst', 'jeuno'}) do
        for name, e in pairs(loadfile(V2 .. 'meta/quests/' .. a .. '.lua')()) do
            local fl = e.fame_level
            if type(fl) == 'string' and fl:lower():find('level', 1, true) then
                local r = meta.get('quest', a, name)
                check(r.fame_level:match('^%d+$') ~= nil, 'a fame level with the nation in it is its number: ' .. a .. ' ' .. name, r.fame_level)
            end
        end
    end
end

-- 2026-10-20 (quest vision sweep): the card's starting NPC and zone are the page's row (windurst 91's zone "Home Point #3)", windurst 40's NPC
-- "Kohlo-Lakolo Port Windurst"), a title has no list bullet ("*Discerning Individual"), a key item's tag has a space after it
do
    local bad_start, bad_title, bad_ki, n = {}, {}, {}, 0
    for k in pairs(pages_index) do
        local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
        local e = meta.get(cat, area, nil, tonumber(id))
        local ps = page_start(cat, area, id)
        if e and ps then
            n = n + 1
            if ps.npc and e.start_npc ~= nil and e.start_npc ~= ps.npc then bad_start[#bad_start + 1] = k .. ': NPC "' .. e.start_npc .. '" but the page says "' .. ps.npc .. '"' end
            if ps.zone and e.start_zone ~= ps.zone then bad_start[#bad_start + 1] = k .. ': zone "' .. tostring(e.start_zone) .. '" but the page says "' .. ps.zone .. '"' end
        end
    end
    table.sort(bad_start)
    for _, b in ipairs(bad_start) do check(false, 'the card starts somewhere the page does not: ' .. b) end
    check(#bad_start == 0 and n > 300, 'every page-backed entry starts where its page says (' .. n .. ' entries)')
    for cat, areas in pairs({quest = QUEST, mission = MISSION}) do
        for _, a in ipairs(areas) do
            for name in pairs(all_meta[cat][a]) do
                local e = meta.get(cat, a, name)
                if e and type(e.title) == 'string' and e.title:find('^%*') then bad_title[#bad_title + 1] = cat .. '|' .. a .. '|' .. name end
                for _, r in ipairs(e and e.requirements or {}) do
                    if type(r.name) == 'string' and r.name:find('%]%S') then bad_ki[#bad_ki + 1] = cat .. '|' .. a .. '|' .. name .. ': ' .. r.name end
                end
            end
        end
    end
    table.sort(bad_title) table.sort(bad_ki)
    for _, b in ipairs(bad_title) do check(false, 'a title with a list bullet: ' .. b) end
    for _, b in ipairs(bad_ki) do check(false, 'a requirement with no space after its tag: ' .. b) end
    check(#bad_title == 0, 'no title starts with a list bullet')
    check(#bad_ki == 0, 'no requirement name has a tag with no space after it')
    -- the fault each rule exists for, in the raw v1 rows
    local raw91 = raw_entry('quest', 'windurst', 'Tuning Out')
    check(raw91 and raw91.start_zone == 'Home Point #3)', 'the v1 zone of windurst 91 is "Home Point #3)" (the fault the start rule exists for)')
    local e91 = meta.get('quest', 'windurst', nil, 91)
    check(e91.start_zone == 'Windurst Waters South' and e91.start_npc == 'Leepe-Hoppe' and e91.start_pos == 'J-9', 'windurst 91: Leepe-Hoppe, Windurst Waters South (J-9)', tostring(e91.start_zone))
    local e75 = meta.get('quest', 'sandoria', nil, 75)
    check(e75.start_npc == 'Joulet or Gallijaux', 'sandoria 75: a row with two NPCs is left as v1 has it', e75.start_npc)
    local raw104 = raw_entry('quest', 'sandoria', "A Discerning Eye (San d'Oria)")
    check(raw104 and raw104.title:find('^%*') ~= nil, 'the v1 title of sandoria 104 has a bullet (the fault the title rule exists for)')
    check(meta.get('quest', 'sandoria', nil, 104).title:find('^Discerning Individual') ~= nil, 'sandoria 104: title Discerning Individual (then the other two)')
end

-- 2026-10-20 (second quest vision sweep): a zone line never prints "--" with a grid square (windurst 40: v1 glued the zone to the NPC's name and
-- kept the square: "-- (G-5)"), and the card's TITLE is the page's Title row (windurst 63 and 66: the header drew a list beside a cut title)
do
    local card = require('core/card')
    -- the fault, in the raw v1 row, and what the card makes of it now
    local raw40 = raw_entry('quest', 'windurst', "Know One's Onions")
    check(raw40 and raw40.start_zone == nil and raw40.start_pos == 'G-5', 'the v1 row of windurst 40 has a grid square and no zone (the fault the zone rule exists for)')
    local z, tail = card.zone_parts({start_pos = 'G-5'})
    check(z == '--' and tail == nil, 'card.zone_parts: a grid square with no zone is the dash alone', tostring(z) .. ' ' .. tostring(tail))
    local e40 = meta.get('quest', 'windurst', nil, 40)
    check(e40.start_zone == 'Port Windurst' and e40.start_pos == 'G-5' and e40.start_npc == 'Kohlo-Lakolo', 'windurst 40: Kohlo-Lakolo, Port Windurst (G-5)', tostring(e40.start_zone))
    -- every entry of every area: no card zone line is a dash and a square
    local n, bad = 0, {}
    for cat, areas in pairs({quest = QUEST, mission = MISSION}) do
        for _, a in ipairs(areas) do
            for name in pairs(all_meta[cat][a]) do
                local e = meta.get(cat, a, name)
                local zone, pos = card.zone_parts(e)
                n = n + 1
                if zone == '--' and pos then bad[#bad + 1] = cat .. '|' .. a .. '|' .. name end
            end
        end
    end
    table.sort(bad)
    for _, b in ipairs(bad) do check(false, 'a card zone line "-- (square)": ' .. b) end
    check(#bad == 0 and n > 1800, 'no card zone line is a dash with a grid square (' .. n .. ' entries)')
    -- the card's title is the page's Title row
    local bad_t, nt = {}, 0
    for k in pairs(pages_index) do
        local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
        local e = meta.get(cat, area, nil, tonumber(id))
        local pt = e and page_title(cat, area, id)
        if pt then
            nt = nt + 1
            if not (e.title and letters(e.title) == letters(pt)) then bad_t[#bad_t + 1] = k .. ': card "' .. tostring(e.title) .. '", page "' .. pt .. '"' end
        end
    end
    table.sort(bad_t)
    for _, b in ipairs(bad_t) do check(false, 'the card title is not the page title: ' .. b) end
    check(#bad_t == 0 and nt > 100, "every page-backed entry's card title is its page's Title row (" .. nt .. ' entries)')
    local raw63 = raw_entry('quest', 'windurst', 'Curses, Foiled A-Golem!?')
    local raw66 = raw_entry('quest', 'windurst', 'The Three Magi')
    check(raw63 and raw63.title == "*Doctor Shantotto's Flavor of the Month" and raw66 and raw66.title == 'One of the following:',
        'the v1 titles of windurst 63 and 66 are cut (the fault the title rule exists for)')
    local lines = card.title_lines(meta.get('quest', 'windurst', nil, 66).title)
    check(lines and #lines == 4 and lines[1] == 'One of the following:' and lines[4] == 'Professor Koru-Moru Supporter', 'windurst 66: the card title is the four lines of the page')
    check(card.title_lines(nil) == nil and card.title_lines('  ') == nil and #card.title_lines('A' .. string.char(10) .. ' B ') == 2, 'card.title_lines: nothing, or a title a line')
end

-- 2026-10-21 (toau vision wave, rule 68): a card reward v1 cut short is the page's Rewards row (mission toau 46: v1 kept "Imperial Standard" and
-- the words "One of the following:", the three rings under them were lost, and the header's Rewards, hidden for the card, never drew them)
do
    local card = require('core/card')
    local bad, n = {}, 0
    for k in pairs(pages_index) do
        local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
        local e = meta.get(cat, area, nil, tonumber(id))
        local pg = dofile(V2 .. pages_index[k])
        local m = pg.meta
        if e and m and type(m.Rewards) == 'string' and type(e.reward) == 'string' and letters(e.reward) ~= '' then
            local t = ''
            for _, sp in ipairs(D_doc.inline(m.Rewards)) do
                if sp.t == 'br' then t = t .. ' ' elseif sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' then t = t .. (sp.s or '') end
            end
            n = n + 1
            local c, p = letters(e.reward), letters(t)
            if #p > #c and p:sub(1, #c) == c then bad[#bad + 1] = k .. ': card "' .. e.reward:gsub(string.char(10), ' | ') .. '", page "' .. t:gsub('%s+', ' ') .. '"' end
        end
    end
    table.sort(bad)
    for _, b in ipairs(bad) do check(false, 'the card reward is only the start of the page Rewards row: ' .. b) end
    check(#bad == 0 and n > 300, "no page-backed entry's card reward is cut short of its page's Rewards row (" .. n .. ' entries)')
    local raw46 = raw_entry('mission', 'toau', 'The Empress Crowned')
    local e46 = meta.get('mission', 'toau', nil, 46)
    check(raw46 and raw46.reward == 'Imperial Standard' .. string.char(10) .. 'One of the following:',
        'the v1 reward of toau 46 is cut after "One of the following:" (the fault the reward rule exists for)', raw46 and raw46.reward)
    local lines = card.reward_lines(e46 and e46.reward)
    check(lines and #lines == 5 and lines[2] == 'One of the following:' and lines[5] == "Ulthalam's Ring", 'toau 46: the card reward is the five lines of the page', lines and table.concat(lines, '|'))
end

-- 2026-10-21 (toau vision wave, rule 69): a card description that is not the page's Description row. v1 cut "How will Naja" + the
-- link at its text ("How will Naja Salaheem", mission toau 19: the sentence stopped mid-thought) and kept a typo of its own
-- ("Rreceipt", sandoria 2), jeuno 164 lost the end; the wiki wins, as for Title and Repeatable
do
    local bad, n = {}, 0
    for k in pairs(pages_index) do
        local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
        local e = meta.get(cat, area, nil, tonumber(id))
        local pg = dofile(V2 .. pages_index[k])
        local m = pg.meta
        if e and m and type(m.Description) == 'string' and type(e.description) == 'string' then
            local t = ''
            for _, sp in ipairs(D_doc.inline(m.Description)) do
                if sp.t == 'br' then t = t .. ' ' elseif sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' then t = t .. (sp.s or '') end
            end
            if letters(t) ~= '' then
                n = n + 1
                if letters(e.description) ~= letters(t) then bad[#bad + 1] = k .. ': card "' .. e.description .. '", page "' .. t:gsub('%s+', ' ') .. '"' end
            end
        end
    end
    table.sort(bad)
    for _, b in ipairs(bad) do check(false, "the card description is not the page's Description row: " .. b) end
    check(#bad == 0 and n > 400, "every page-backed entry's card description is its page's Description row (" .. n .. ' entries)')
    local raw19 = raw_entry('mission', 'toau', 'Teahouse Tumult')
    local e19 = meta.get('mission', 'toau', nil, 19)
    check(raw19 and raw19.description:sub(-13) == 'Naja Salaheem', 'the v1 description of toau 19 stops after "Naja Salaheem" (the fault the description rule exists for)', raw19 and raw19.description)
    check(e19 and e19.description:find('react to your freelancing', 1, true) and e19.description:find('Aphmau and friends planning%.%.%.%?$'), 'toau 19: the card description is the whole sentence of the page', e19 and e19.description)
    check(meta.get('quest', 'sandoria', nil, 2) and not meta.get('quest', 'sandoria', nil, 2).description:find('Rreceipt', 1, true), 'sandoria 2: the typo of v1 is not on the card')
end

-- Rule 191 (vision wave camp1, mission campaign 21, 361, 362, 363): a Campaign Op card description that is not the page's Objective where the two begin
-- alike. v1 cut the sentence at a link and drew its target (":Category:Campaign Battle"), cut another at a link's text (11) and kept a typo (351). No
-- card text of any entry shows a namespace.
do
    local function objective_text(m)
        local t = ''
        for _, sp in ipairs(D_doc.inline(m.Objective)) do
            if sp.t == 'br' then t = t .. ' ' elseif sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' then t = t .. (sp.s or '') end
        end
        return t
    end
    local function scan()
        local bad, n = {}, 0
        for k, file in pairs(pages_index) do
            local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
            if cat == 'mission' and area == 'campaign' then
                local e = meta.get(cat, area, nil, tonumber(id))
                local m = dofile(V2 .. file).meta
                if e and m and type(m.Objective) == 'string' and type(m.Description) ~= 'string' and type(e.description) == 'string' then
                    local a, b = letters(objective_text(m)), letters(e.description)
                    if #a >= 40 and #b >= 40 and a:sub(1, 40) == b:sub(1, 40) then
                        n = n + 1
                        if a ~= b then bad[#bad + 1] = k .. ': card "' .. e.description .. '"' end
                    end
                end
            end
        end
        table.sort(bad)
        return bad, n
    end
    local function namespaced()
        local out = {}
        for cat, areas in pairs(all_meta) do
            for a, names in pairs(areas) do
                for name in pairs(names) do
                    local e = meta.get(cat, a, name)
                    if type(e) == 'table' then
                        for _, f in ipairs({'description', 'reward', 'start_npc', 'start_zone', 'fame', 'title', 'repeatable'}) do
                            if type(e[f]) == 'string' and e[f]:find('%f[%a]Category:') then out[#out + 1] = cat .. '|' .. a .. '|' .. tostring(e.id) .. ' ' .. f end
                        end
                    end
                end
            end
        end
        table.sort(out)
        return out
    end
    meta.release()
    local bad, n = scan()
    for _, b in ipairs(bad) do check(false, "a Campaign Op card description is not its page's Objective: " .. b) end
    check(#bad == 0 and n >= 20, "every Campaign Op card description that begins like its page's Objective is the Objective (" .. n .. ' entries)')
    local ns = namespaced()
    for _, b in ipairs(ns) do check(false, 'a card text shows a namespace: ' .. b) end
    check(#ns == 0, 'no card text of any entry shows a namespace (Category:)')
    local function d(id) local e = meta.get('mission', 'campaign', nil, id) return e and e.description end
    check(d(21) and d(21):find('Join the campaign battle and assist our knights in defending the location%.$'), 'campaign 21: the card description is the whole sentence of the page', d(21))
    check(d(361) and d(362) and d(363) and not d(361):find('Category', 1, true), 'campaign 361 to 363: no namespace on the card', d(361))
    check(d(351) and d(351):find(' via Fort Karugo-Narugo', 1, true) and not d(351):find(' vis ', 1, true), 'campaign 351: the typo of v1 is not on the card', d(351))
    check(d(11) and d(11):find('Inlet, intercept the caravan, and destroy it%.$'), 'campaign 11: the sentence v1 cut at a link is whole', d(11))
    check(d(5) and d(5):find('^Assist the Knights of the Iron Ram'), 'campaign 5: a v1 description that is not the Objective (another opening) is left as it was', d(5))
    check(d(81) and d(81):find('^Obtain shopping list from Quartermaster'), 'campaign 81: the Mission Orders sentence of v1 is left as it was', d(81))
    meta.OBJECTIVE_DESC = false
    meta.release()
    local old_bad = scan()
    local old_ns = namespaced()
    meta.OBJECTIVE_DESC = nil
    meta.release()
    check(#old_bad >= 8 and #old_ns == 4, 'self-test: with rule 191 off the scans find the cut and mistyped descriptions (campaign 11, 21, 351 to 353, 361 to 363) and the four namespaces (caught)', #old_bad .. ' ' .. #old_ns)
end

-- 2026-10-28 (vision wave qot1 minors, rule 142): a requirement row of a page-backed entry does not start with the wiki's list mark ("*[Key Item]
-- Remnants Permit", quest toau 23; toau 4's "*Only if you take the wrong picture"). meta.KEEP_REQ_MARKS = true is the old reading.
do
    local function scan()
        local bad, n = {}, 0
        for k in pairs(pages_index) do
            local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
            local e = meta.get(cat, area, nil, tonumber(id))
            for _, r in ipairs(e and e.requirements or {}) do
                n = n + 1
                if type(r.name) == 'string' and r.name:find('^%s*[:*#;]') then bad[#bad + 1] = k .. ': ' .. r.name end
            end
        end
        table.sort(bad)
        return bad, n
    end
    local bad, n = scan()
    for _, b in ipairs(bad) do check(false, 'a requirement row starts with a list mark: ' .. b) end
    check(#bad == 0 and n > 500, 'no requirement row of a page-backed entry starts with a list mark (' .. n .. ' rows)')
    check(meta.get('quest', 'toau', nil, 23).requirements[3].name == '[Key Item] Remnants Permit', 'toau 23: the key item row has its name, no mark')
    meta.KEEP_REQ_MARKS = true
    meta.release()
    local old = scan()
    meta.KEEP_REQ_MARKS = nil
    meta.release()
    check(#old == 5, 'self-test: with the old reading the scan finds the five marked rows of toau 4 and 23 (caught)', #old)
end

-- 2026-10-28 (other/outlands/toau fix 1, rule 139): the card's FAME is the page's Required Fame row where the two name another nation (the wiki
-- wins, as for the title): v1 had "Other" for outlands 143 to 147 (the wiki: Outlands) and "Treasures of Aht Urhgan" for toau 48 (the wiki: Accepted
-- at IS 25372). A card with no level keeps none, and a bare number or N/A names no nation, so the other entries are as v1 had them.
do
    local function fame(cat, area, id) local e = meta.get(cat, area, nil, id) return e and e.fame, e and e.fame_level end
    local f143, l143 = fame('quest', 'outlands', 143)
    local f145, l145 = fame('quest', 'outlands', 145)
    local f48 = fame('quest', 'toau', 48)
    check(f143 == 'Outlands' and l143 == '1' and f145 == 'Outlands' and l145 == nil, 'outlands 143 and 145: the card nation is the wiki Outlands, the level as it was', tostring(f143) .. ' ' .. tostring(l143) .. ' ' .. tostring(f145))
    check(f48 == 'Accepted at IS 25372', 'toau 48: the card fame is the page row', tostring(f48))
    check(fame('quest', 'other', 19) == 'Selbina' and select(2, fame('quest', 'other', 19)) == '4', 'other 19: a bare level on the page leaves the card Selbina 4')
    meta.FAME_FROM_PAGE = false
    meta.release()
    local off143, off48 = fame('quest', 'outlands', 143), fame('quest', 'toau', 48)
    meta.FAME_FROM_PAGE = nil
    meta.release()
    check(off143 == 'Other' and off48 == 'Treasures of Aht Urhgan', 'self-test: with rule 139 off the cards of outlands 143 and toau 48 name the v1 fame again (caught)', tostring(off143) .. ' ' .. tostring(off48))
end

-- 2026-10-21 (toau vision wave, rule 70): the card's NPC is a place. v1 put the wiki's Starting NPC cell in start_npc, and a mission that
-- starts in a place (Aht Urhgan Whitegate (K-11), the Aydeewa Subterrane) has the place there: the card read "NPC Aht Urhgan Whitegate,
-- ZONE --". A page whose Starting NPC row names a zone and no NPC has no NPC on its card; the zone and square are the place's
do
    local zones = dofile('../../res/zones.lua')
    local zname = {}
    for _, z in pairs(zones) do if z.en then zname[letters(z.en)] = z.en end end
    local function scan_places()
        local bad, n, hits = {}, 0, 0
        for k in pairs(pages_index) do
            local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
            local e = meta.get(cat, area, nil, tonumber(id))
            local ps = page_start(cat, area, id)
            if e then
                n = n + 1
                if e.start_npc and zname[letters(e.start_npc)] then bad[#bad + 1] = k .. ': card NPC "' .. e.start_npc .. '" is a zone (zone "' .. tostring(e.start_zone) .. '")' end
                if ps and ps.zone and not ps.npc and e.start_npc ~= nil and letters(e.start_npc) == letters(ps.zone) then
                    bad[#bad + 1] = k .. ': the page names the zone "' .. ps.zone .. '" and no NPC, the card has the NPC "' .. e.start_npc .. '"'
                end
                if ps and ps.zone and not ps.npc then
                    hits = hits + 1
                    if e.start_zone ~= ps.zone then bad[#bad + 1] = k .. ': the card zone is "' .. tostring(e.start_zone) .. '", the page has "' .. ps.zone .. '"' end
                end
            end
        end
        table.sort(bad)
        return bad, n, hits
    end
    local bad, n, hits = scan_places()
    -- rule 109: the check is live. Its note (rule 70) expected it to trip on the v1 rows that hold a place as NPC once their pages exist (cop 228 448 718
    -- 738 748 800 818, acp 1 2, asa 0 9); it did not, because core/meta.lua start_from_page (the same rule's fix) takes the page's row for any
    -- page-backed entry. With that fix off, the same scan reports every one of them.
    meta.START_FROM_PAGE = false
    meta.release()
    local off = scan_places()
    meta.START_FROM_PAGE = nil
    meta.release()
    local tripped = {}
    for _, b in ipairs(off) do tripped[b:match('^([^:]+):')] = true end
    local missing_trip = {}
    for _, k in ipairs({'mission|cop|228', 'mission|cop|448', 'mission|cop|718', 'mission|cop|738', 'mission|cop|748', 'mission|cop|800', 'mission|cop|818',
                        'mission|acp|1', 'mission|acp|2', 'mission|asa|0', 'mission|asa|9'}) do
        if pages_index[k] and not tripped[k] then missing_trip[#missing_trip + 1] = k end
    end
    check(#missing_trip == 0 and tripped['mission|cop|748'] and #off >= 11, 'self-test: with the page-start repair off, the place check trips on the v1 place-as-NPC rows (' .. #off .. ' reports)', table.concat(missing_trip, ' '))
    for _, b in ipairs(bad) do check(false, 'the card names a place as its NPC: ' .. b) end
    check(#bad == 0 and n > 400 and hits > 10, "no page-backed entry's card NPC is a place, and a page that names only a zone has the zone (" .. n .. ' entries, ' .. hits .. ' starting in a place)')
    local raw = raw_entry('mission', 'toau', 'Teahouse Tumult')
    check(raw and raw.start_npc == 'Aht Urhgan Whitegate' and raw.start_zone == nil, 'the v1 NPC of toau 19 is the zone Aht Urhgan Whitegate (the fault the place rule exists for)', raw and raw.start_npc)
    local e = meta.get('mission', 'toau', nil, 19)
    check(e and e.start_npc == nil and e.start_zone == 'Aht Urhgan Whitegate' and e.start_pos == 'K-11', 'toau 19: no NPC, the zone Aht Urhgan Whitegate (K-11)', e and (tostring(e.start_npc) .. '|' .. tostring(e.start_zone) .. '|' .. tostring(e.start_pos)))
    local e16 = meta.get('mission', 'toau', nil, 16)
    check(e16 and e16.start_npc == 'Naja Salaheem' and e16.start_zone == 'Aht Urhgan Whitegate', 'toau 16: a person at a place keeps both', e16 and (tostring(e16.start_npc) .. '|' .. tostring(e16.start_zone)))
end

-- 2026-10-22 (vision wave m2, rule 129): v1 has no starting NPC for the Assault missions, so their cards read "NPC --" under a header that
-- names the person (assault 51: Sorrowful Sage). A page-backed entry whose Starting NPC row names exactly one NPC link has that person on the
-- card; the zone is settled as before (rule 70, 76).
do
    local function scan_people()
        local bad, n = {}, 0
        for k in pairs(pages_index) do
            local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
            local ps = page_start(cat, area, tonumber(id))
            if ps and ps.person then
                n = n + 1
                local e = meta.get(cat, area, nil, tonumber(id))
                if not e or e.start_npc ~= ps.npc then bad[#bad + 1] = k .. ': the page names the NPC "' .. ps.npc .. '", the card has "' .. tostring(e and e.start_npc) .. '"' end
            end
        end
        table.sort(bad)
        return bad, n
    end
    local bad, n = scan_people()
    meta.NPC_FROM_PAGE = false
    meta.release()
    local off, off_n = scan_people()
    meta.NPC_FROM_PAGE = nil
    meta.release()
    for _, b in ipairs(bad) do check(false, 'the card lacks the NPC its page names: ' .. b) end
    -- rule 136 (quest other 200, "Green Thumb Moogle, Mog Garden"): the place was a link the wiki has as a disambiguation page, read as the one NPC
    -- link of the row, so start_from_page put "Mog Garden" on the card as the NPC. The converter makes the link a zone (the game's zone data).
    local e200 = meta.get('quest', 'other', nil, 200)
    check(e200 and e200.start_npc == 'Green Thumb Moogle' and e200.start_zone == 'Mog Garden', 'other 200: the card has the NPC Green Thumb Moogle and the zone Mog Garden',
        e200 and (tostring(e200.start_npc) .. ' / ' .. tostring(e200.start_zone)))
    check(#bad == 0 and n > 300, 'every page-backed entry whose Starting NPC row names one NPC has that NPC on the card (' .. n .. ' entries)')
    check(#off >= 45 and off[1]:find('mission|assault|', 1, true) == 1, 'self-test: with the page-NPC repair off, the check trips on the assault cards (' .. #off .. ' reports)', off[1])
    local e51 = meta.get('mission', 'assault', nil, 51)
    check(e51 and e51.start_npc == 'Sorrowful Sage' and e51.start_zone == 'Aht Urhgan Whitegate', 'assault 51: the card has Sorrowful Sage at Aht Urhgan Whitegate', e51 and (tostring(e51.start_npc) .. '|' .. tostring(e51.start_zone)))
    local e42 = meta.get('mission', 'assault', nil, 42)
    check(e42 and e42.start_zone == 'Aht Urhgan Whitegate', 'assault 42: the zone is as before', e42 and tostring(e42.start_zone))
end

-- 2026-10-21 (wotg mission pass, rule 76): a Starting NPC row that names several zones. v1 scraped wotg 0's ("Cavernous Maw in Batallia Downs,
-- Rolanberry Fields, or Sauromugue Champaign.") as the zone "Rolanberry Fields, or Sauromugue Champaign." (the first lost, the full stop kept).
-- The card's zone is then one of the row's zones (toau 13's second is a place beside the first) or names them all.
do
    local bad, n = {}, 0
    for k in pairs(pages_index) do
        local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
        local zs = page_zones(cat, area, tonumber(id))
        local e = #zs >= 2 and meta.get(cat, area, nil, tonumber(id))
        if e then
            n = n + 1
            local have, one, all = letters(e.start_zone or ''), false, true
            for _, z in ipairs(zs) do
                if have == letters(z) then one = true end
                if not have:find(letters(z), 1, true) then all = false end
            end
            if not (one or all) then bad[#bad + 1] = k .. ': the card zone is "' .. tostring(e.start_zone) .. '", the page names ' .. table.concat(zs, ', ') end
        end
    end
    table.sort(bad)
    for _, b in ipairs(bad) do check(false, 'the card zone is none of the zones its page names: ' .. b) end
    check(#bad == 0 and n >= 2, "every page-backed entry whose Starting NPC row names several zones has one of them, or all, as its card zone (" .. n .. ' entries)')
    local raw0 = raw_entry('mission', 'wotg', 'Cavernous Maws')
    check(raw0 and raw0.start_zone == 'Rolanberry Fields, or Sauromugue Champaign.', 'the v1 zone of wotg 0 is "Rolanberry Fields, or Sauromugue Champaign." (the fault the rule exists for)', raw0 and raw0.start_zone)
    local e0 = meta.get('mission', 'wotg', nil, 0)
    check(e0 and e0.start_zone == 'Batallia Downs, Rolanberry Fields, or Sauromugue Champaign' and e0.start_npc == 'Cavernous Maw', 'wotg 0: the card names the three zones', e0 and (tostring(e0.start_npc) .. '|' .. tostring(e0.start_zone)))
    local e13 = meta.get('mission', 'toau', nil, 13)
    check(e13 and e13.start_zone == 'Caedarva Mire', 'toau 13: a place beside the zone does not change the card zone', e13 and e13.start_zone)
end

-- 2026-10-21 (wotg mission pass, rule 75): a card with no reward under a page whose Rewards row lists one. v1 had no reward for wotg 53 (Lest We
-- Forget: an augmented Moonshade Earring) or toau 47 (Eternal Mercenary: Glory Crown); the card read REWARD -- and, for 53, was empty.
do
    local bad, n = {}, 0
    for k in pairs(pages_index) do
        local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
        local pg = dofile(V2 .. pages_index[k])
        local m = pg.meta
        local e = meta.get(cat, area, nil, tonumber(id))
        if e and m and type(m.Rewards) == 'string' then
            local t = ''
            for _, sp in ipairs(D_doc.inline(m.Rewards)) do
                if sp.t == 'br' then t = t .. ' ' elseif sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' then t = t .. (sp.s or '') end
            end
            local w = letters(t)
            if w ~= '' and w ~= 'none' and w ~= 'na' and w ~= 'unknown' then
                n = n + 1
                if type(e.reward) ~= 'string' or not e.reward:find('%S') then bad[#bad + 1] = k .. ': the page lists "' .. t:gsub('%s+', ' ') .. '", the card has no reward' end
            end
        end
    end
    table.sort(bad)
    for _, b in ipairs(bad) do check(false, "the card has no reward the page's Rewards row lists: " .. b) end
    check(#bad == 0 and n > 100, "every page-backed entry whose page lists a reward has one on its card (" .. n .. ' entries)')
    local raw53 = raw_entry('mission', 'wotg', 'Lest We Forget')
    check(raw53 and raw53.reward == nil, 'the v1 entry of wotg 53 has no reward (the fault the rule exists for)', raw53 and raw53.reward)
    local e53 = meta.get('mission', 'wotg', nil, 53)
    check(e53 and e53.reward == 'Moonshade Earring', 'wotg 53: the card reward is the Moonshade Earring', e53 and e53.reward)
    local e47 = meta.get('mission', 'toau', nil, 47)
    check(e47 and e47.reward == 'Glory Crown', 'toau 47: the card reward is the Glory Crown', e47 and e47.reward)
    -- 2026-11-02: the game never sets wotg 53's completed bit, it stays the current mission forever; current means completed
    local p80, pd8
    for _, p in ipairs(packets) do
        if p.Type == 0x80 then p80 = p elseif p.Type == 0xD8 then pd8 = p end
    end
    local done_wotg = pd8['Completed WOTG Missions']
    local function wotg53(cur)
        p80['Current WOTG Mission'] = cur
        d2.parse_packet(p80)
        -- the fixture's random completed flags may hold bit 53; the game never sets it
        pd8['Completed WOTG Missions'] = cur == 53 and string.rep('\0', #done_wotg) or done_wotg
        d2.parse_packet(pd8)
        for _, it in ipairs(d2.get_area_status('mission', 'wotg').items) do
            if it.id == 53 then return it.status end
        end
    end
    local s53 = wotg53(53)
    check(s53 == 'completed', 'wotg 53: the current mission "Lest We Forget" counts as completed (its bit is never set)', s53)
    wotg53(30)
end

-- 2026-10-21 (adoulin wave, rule 80): the card's REWARD keeps the wiki's list marks. v1 scraped the wikitext's ":" indent, ":*" bullet and "*"
-- note marks into the reward text and the card drew them as characters (adoulin 112 ":*Access to Adoulin", 320 ":One of the following:",
-- 368 two leading colons). The check runs over EVERY entry of every area (not only the page-backed ones): no line a card draws starts with a mark.
do
    local card = require('core/card')
    local function marked()
        local bad, n = {}, 0
        for cat, areas in pairs({quest = QUEST, mission = MISSION}) do
            for _, a in ipairs(areas) do
                for name in pairs(all_meta[cat][a] or {}) do
                    local e = meta.get(cat, a, name)
                    local lines = e and card.reward_lines(e.reward)
                    if lines then
                        n = n + 1
                        for _, l in ipairs(lines) do
                            if l:find('^[:*#;]') then bad[#bad + 1] = cat .. '|' .. a .. '|' .. tostring(e.id) .. '|' .. name .. ': "' .. l .. '"' end
                        end
                    end
                end
            end
        end
        table.sort(bad)
        return bad, n
    end
    local bad, n = marked()
    for _, b in ipairs(bad) do check(false, "a card reward line starts with the wiki's list mark: " .. b) end
    check(#bad == 0 and n > 800, "no card reward line, of any entry of any area, starts with a list mark (" .. n .. ' entries with a reward)')
    -- self-test: with the old reading (card.KEEP_LIST_MARKS) the same scan finds them (22 entries of v1 data), and the fixtures read as the rule says
    card.KEEP_LIST_MARKS = true
    local old = marked()
    card.KEEP_LIST_MARKS = nil
    check(#old >= 22, 'self-test: with the list marks kept the check fails on the v1 data (' .. #old .. ' lines)')
    local NL = string.char(10)
    local l1 = card.reward_lines('[Key Item] Geomagnetron' .. NL .. ':*Access to Adoulin')
    check(l1 and #l1 == 2 and l1[1] == '[Key Item] Geomagnetron' and l1[2] == 'Access to Adoulin', 'self-test: ":*Access to Adoulin" reads "Access to Adoulin"', l1 and table.concat(l1, '|'))
    local l2 = card.reward_lines(':One of the following:' .. NL .. '*If already in possession' .. NL .. ' ;# Choose one ' .. NL .. ':*')
    check(l2 and #l2 == 3 and l2[1] == 'One of the following:' and l2[2] == 'If already in possession' and l2[3] == 'Choose one', 'self-test: a lead-in keeps its trailing colon, a line of only marks is dropped', l2 and table.concat(l2, '|'))
    local l3 = card.reward_lines('1,000 Experience Points' .. NL .. 'Rare: Bayld #5')
    check(l3 and #l3 == 2 and l3[1] == '1,000 Experience Points' and l3[2] == 'Rare: Bayld #5', 'self-test: a mark inside a line stays')
    local l4 = card.reward_lines(':*Access to Adoulin')
    card.KEEP_LIST_MARKS = true
    local l5 = card.reward_lines(':*Access to Adoulin')
    card.KEEP_LIST_MARKS = nil
    check(l4[1] == 'Access to Adoulin' and l5[1] == ':*Access to Adoulin', 'card.KEEP_LIST_MARKS restores the old reading')
end

-- 2026-10-21 (adoulin wave, rule 81): the card's REWARD lost lines of the page's Rewards row. v1 rewrote adoulin 368's seventeen (the cuffs, the
-- garb, twelve rings) as three lines, and the header's Rewards is hidden for a card that has a reward, so they were drawn nowhere; rule 68's prefix
-- test (v1's text the very start of the page's) did not see it. A page-backed entry whose card misses most of its page's lines fails. Eleven
-- pages word a few lines otherwise (abbreviations, "Warp (Scroll)": at most a third of the lines) and pass.
do
    local card = require('core/card')
    local function scan()
        local out, count, top = {}, 0, 0
        for k in pairs(pages_index) do
            local cat, area, id = k:match('^(%a+)|([%w_]+)|(%d+)$')
            local e = meta.get(cat, area, nil, tonumber(id))
            local pl = e and page_reward_lines(cat, area, id)
            if pl and type(e.reward) == 'string' then
                local lines, lost = reward_loss(pl, e.reward)
                if lines > 0 then count = count + 1 end
                if lines >= 3 and lost / lines > top then top = lost / lines end
                if lines >= 3 and lost * 2 >= lines then out[#out + 1] = k .. ": the card misses " .. lost .. " of the page's " .. lines .. ' reward lines' end
            end
        end
        table.sort(out)
        return out, count, top
    end
    local bad, n, worst = scan()
    for _, b in ipairs(bad) do check(false, "the card reward drops most of its page's Rewards row: " .. b) end
    check(#bad == 0 and n > 300, "no page-backed entry's card reward drops half or more of its page's reward lines (" .. n .. ' entries, worst ' .. string.format('%.0f%%', worst * 100) .. ')')
    -- self-test: with the old reading (meta.REWARD_LOSSY = false, the prefix rule only) adoulin 368 fails the same scan
    meta.REWARD_LOSSY = false
    meta.release()
    local old = scan()
    meta.REWARD_LOSSY = nil
    meta.release()
    -- the entries v1 cut short: adoulin 368 (17 lines to 3) and, since the Chains of Promathia pages (rule 107), cop 840 "Dawn" (6 to 2); an
    -- entry added to this list must be one the old reading really drops
    -- 2026-10-28 (other, outlands, toau pass): three quests of the pages added since join them, v1 cut each short and rule 81 restores the page's
    -- lines (quest other 29 "9 lines to 1", toau 76 and 103: the old reading drops 8 of 9, 4 of 8 and 3 of 5); the list stays the exact set
    -- 2026-10-30 (quest adoulin pass, rule 154): the two Siren quests join them (quest adoulin 144 and 145: v1 wrote "Choice of one:" and
    -- two lines, the page lists the pact, the ring, the sash, the scythe and the Bayld; the old reading drops 3 of 6 on each)
    -- 2026-10-31 (quest wotg pass): the two Dawn quests join them (Champion of the Dawn, The Dawn Also Rises) (quest wotg 73 and 74: v1 wrote a short list, the page lists the
    -- reward lines; the old reading drops 3 of 6 on each)
    -- 2026-11-03 (mission campaign pass, rule 189): the three Fiat Lux operations (campaign 9, 179, 349: v1 wrote "Random synthesis materials.", the page
    -- lists the seven reward lines, the old reading drops 6 of 7 on each)
    local want_old = {'mission|adoulin|368', 'mission|campaign|179', 'mission|campaign|349', 'mission|campaign|9', 'mission|cop|840', 'quest|adoulin|144', 'quest|adoulin|145', 'quest|other|29', 'quest|toau|103', 'quest|toau|76', 'quest|wotg|73', 'quest|wotg|74'}
    local got_old = {}
    for _, o in ipairs(old) do got_old[#got_old + 1] = o:match('^([^:]+):') end
    check(table.concat(got_old, ' ') == table.concat(want_old, ' '), 'self-test: with the prefix rule only the check fails on adoulin 144, 145 and 368, campaign 9, 179 and 349, cop 840, other 29, toau 76 and 103 and wotg 73 and 74', table.concat(old, ' ; '))
    local NL = string.char(10)
    local fixture = {'1,000 Experience Points', "Councilor's Cuffs", "Councilor's Garb", 'One of the following:', 'Adoulin Ring', 'Gorney Ring'}
    local lines, lost = reward_loss(fixture, '1,000 Experience Points' .. NL .. 'One of the following:')
    check(lines == 6 and lost == 4, 'self-test: the fixture of 368 loses 4 of 6 lines', lines .. '/' .. lost)
    lines, lost = reward_loss({'Drachen Fng. Gnt.', '10,000 Gil', '[Key Item] Airship Pass'}, '10,000 Gil' .. NL .. '[Key Item] Airship Pass')
    check(lines == 3 and lost == 1, 'self-test: a reworded line is under half and passes', lines .. '/' .. lost)
    lines, lost = reward_loss({'Gil', 'Ring'}, 'Nothing')
    check(lines == 2 and lost == 2, 'self-test: a page of two lines is under the three lines the rule needs')
    -- 368: v1 has three lines, the card has the page's seventeen; the wording cases are v1's
    local raw368 = raw_entry('mission', 'adoulin', 'The Light Within')
    check(raw368 and select(2, raw368.reward:gsub(NL, '')) == 2, 'the v1 reward of adoulin 368 is three lines (the fault the rule exists for)', raw368 and raw368.reward)
    local e368 = meta.get('mission', 'adoulin', nil, 368)
    local l368 = card.reward_lines(e368 and e368.reward)
    check(l368 and #l368 == 17 and l368[2] == "Councilor's Cuffs" and l368[4] == 'One of the following:' and l368[16] == 'Woltaris Ring' and l368[17] == 'Permanent Key Item(s), see Walkthrough below:', 'adoulin 368: the card reward is the 17 lines of the page', l368 and (#l368 .. ' ' .. table.concat(l368, '|')))
    local kept = 0
    for _, a in ipairs({'sandoria', 'bastok', 'windurst', 'jeuno'}) do
        for _, cat in ipairs({'quest', 'mission'}) do
            for name, raw in pairs(all_meta[cat][a] or {}) do
                local e = meta.get(cat, a, name)
                if e and e.id and pages_index[cat .. '|' .. a .. '|' .. e.id] and type(raw.reward) == 'string' and e.reward == raw.reward then kept = kept + 1 end
            end
        end
    end
    check(kept > 100, 'the lossy rule leaves the cards that only word a few lines as v1 wrote them (' .. kept .. ' entries)')
end

-- Rule 173 (vision wave qcw1, quest wotg 7, 8, 9): the card's reward drew "Bronze Ribbon of Service" and, on its own line, a "?": v1's text holds the
-- section sign of the campaign ribbon rank, which the game font (ASCII only) cannot draw. No text of any card (entry fields, requirement rows) holds a
-- character outside ASCII; the metadata is folded as it is read, with the table of the page converter.
do
    local FIELDS173 = {'description', 'reward', 'start_npc', 'start_zone', 'start_pos', 'fame', 'fame_level', 'title', 'repeatable'}
    local function scan()
        local out, n = {}, 0
        for cat, areas in pairs(all_meta) do
            for a, names in pairs(areas) do
                for name in pairs(names) do
                    local e = meta.get(cat, a, name)
                    if type(e) == 'table' then
                        n = n + 1
                        for _, f in ipairs(FIELDS173) do
                            if type(e[f]) == 'string' and e[f]:find('[\128-\255]') then out[#out + 1] = cat .. '|' .. a .. '|' .. tostring(e.id) .. ' ' .. f end
                        end
                        for _, r in ipairs(type(e.requirements) == 'table' and e.requirements or {}) do
                            if type(r) == 'table' and type(r.name) == 'string' and r.name:find('[\128-\255]') then out[#out + 1] = cat .. '|' .. a .. '|' .. tostring(e.id) .. ' requirement' end
                        end
                    end
                end
            end
        end
        table.sort(out)
        return out, n
    end
    meta.release()
    local bad, n = scan()
    for _, b in ipairs(bad) do check(false, 'a card text holds a character the game font cannot draw: ' .. b) end
    check(#bad == 0 and n > 1500, 'no card text holds a character outside ASCII (' .. n .. ' entries)')
    local NL = string.char(10)
    local e7 = meta.get('quest', 'wotg', nil, 7)
    check(e7 and e7.reward == 'Bronze Ribbon of Service S' .. NL .. "Sprinter's Shoes", 'wotg 7: the card reward is the ribbon with its rank folded to S', e7 and e7.reward)
    local e69 = meta.get('quest', 'wotg', nil, 69)
    check(e69 and e69.description:find('quests - only one', 1, true), 'wotg 69: the em dash of the description is a hyphen', e69 and e69.description)
    check(#folded == 5, 'the entries with a character folded are the three ribbon rewards and the two descriptions', #folded .. ' ' .. table.concat(folded, ' '))
    check(meta.fold('Service ' .. string.char(194, 167) .. string.char(194, 167)) == 'Service SS' and meta.fold('plain') == 'plain', 'meta.fold: the section sign is S, plain text is left')
    -- self-test: with the fold off the scan finds the five again (caught)
    meta.FOLD_ASCII = false
    meta.release()
    local old = scan()
    meta.FOLD_ASCII = nil
    meta.release()
    check(#old == 5 and old[1] == 'quest|other|24 description' and old[2] == 'quest|wotg|69 description' and old[3] == 'quest|wotg|7 reward', 'self-test: with rule 173 off the scan finds other 24, wotg 69, 7, 8 and 9 (caught)', #old .. ' ' .. table.concat(old, ' ; '))
end

-- Rule 175 (vision wave qcw1, quest wotg 10): the card's REWARD read "3000gil" (v1 lost the space; the page's Rewards row says "3000 gil"). No card
-- reward has a number straight against "gil".
do
    local function scan()
        local out = {}
        for cat, areas in pairs(all_meta) do
            for a, names in pairs(areas) do
                for name in pairs(names) do
                    local e = meta.get(cat, a, name)
                    if type(e) == 'table' and type(e.reward) == 'string' and e.reward:find('%d[Gg]il%f[%A]') then out[#out + 1] = cat .. '|' .. a .. '|' .. tostring(e.id) end
                end
            end
        end
        table.sort(out)
        return out
    end
    meta.release()
    local bad = scan()
    for _, b in ipairs(bad) do check(false, 'a card reward has a number straight against "gil": ' .. b) end
    check(#bad == 0, 'no card reward has a number straight against "gil"')
    local e10 = meta.get('quest', 'wotg', nil, 10)
    check(e10 and e10.reward == '3000 gil', 'wotg 10: the card reward is "3000 gil"', e10 and e10.reward)
    check(#gil_spaced == 1 and gil_spaced[1] == 'quest|wotg|10', 'the entries with a space put in "3000gil" are quest wotg 10 only', #gil_spaced .. ' ' .. table.concat(gil_spaced, ' '))
    meta.GIL_SPACE = false
    meta.release()
    local old = scan()
    meta.GIL_SPACE = nil
    meta.release()
    check(#old == 1 and old[1] == 'quest|wotg|10', 'self-test: with rule 175 off the scan finds wotg 10 again (caught)', #old .. ' ' .. table.concat(old, ' '))
end

-- Rule 194 (vision wave camp2, mission campaign 266 and 221): the card's REWARD read "900Allied Notes" and "666Experience Points" (v1 copied the wiki's HTML,
-- which has no space; the page's header got its space in rule 193). No card reward has a digit straight against a capital letter.
do
    local function scan()
        local out = {}
        for cat, areas in pairs(all_meta) do
            for a, names in pairs(areas) do
                for name in pairs(names) do
                    local e = meta.get(cat, a, name)
                    if type(e) == 'table' and type(e.reward) == 'string' and e.reward:find('%d%u') then out[#out + 1] = cat .. '|' .. a .. '|' .. tostring(e.id) end
                end
            end
        end
        table.sort(out)
        return out
    end
    meta.release()
    local bad = scan()
    for _, b in ipairs(bad) do check(false, 'a card reward has a digit straight against a capital: ' .. b) end
    check(#bad == 0, 'no card reward has a digit straight against a capital letter')
    local e266 = meta.get('mission', 'campaign', nil, 266)
    check(e266 and e266.reward:find('900 Allied Notes', 1, true) ~= nil, 'campaign 266: the card reward says "900 Allied Notes"', e266 and e266.reward)
    local e221 = meta.get('mission', 'campaign', nil, 221)
    check(e221 and e221.reward:find('666 Experience Points', 1, true) ~= nil, 'campaign 221: the card reward says "666 Experience Points"', e221 and e221.reward)
    table.sort(num_spaced)
    check(#num_spaced == 2 and num_spaced[1] == 'mission|campaign|221' and num_spaced[2] == 'mission|campaign|266', 'the entries with a space put in a number are campaign 221 and 266 only', #num_spaced .. ' ' .. table.concat(num_spaced, ' '))
    meta.NUM_SPACE = false
    meta.release()
    local old = scan()
    meta.NUM_SPACE = nil
    meta.release()
    check(#old == 2, 'self-test: with rule 194 off the scan finds campaign 221 and 266 again (caught)', #old .. ' ' .. table.concat(old, ' '))
end

-- rule 188: the officer-only entry that takes the page's reward is allowed, and nothing near it is
do
    local e7 = meta.get('mission', 'campaign', nil, 7)
    local function copy(t, k, v) local c = {} for kk, vv in pairs(t) do c[kk] = vv end c[k] = v return c end
    check(e7 ~= nil and e7.reward ~= nil and e7.description == nil, 'rule 188: campaign 7 is the officer start plus the page reward', e7 and e7.reward)
    check(e7 and start_and_page_reward(e7, 'mission', 'campaign', 7), 'rule 188: id, officer start and the page reward is allowed')
    check(e7 and not start_and_page_reward(copy(e7, 'reward', 'Experience Points'), 'mission', 'campaign', 7), 'self-test: rule 188 refuses a reward that is not the page one')
    check(e7 and not start_and_page_reward(copy(e7, 'description', 'x'), 'mission', 'campaign', 7), 'self-test: rule 188 refuses a second field beside the reward')
    check(e7 and not start_and_page_reward(copy(e7, 'start_npc', nil), 'mission', 'campaign', 7), 'self-test: rule 188 refuses an entry without its start')
    PAGE_REWARD = false
    check(e7 and not start_and_page_reward(e7, 'mission', 'campaign', 7), 'self-test: with rule 188 off the entry is refused (the 26 failures)')
    PAGE_REWARD = true
end

print('card reward added from the page (v1 had none): ' .. #reward_added .. ' ' .. table.concat(reward_added, ' '))
print(string.format('entries compared %d (no wiki entry in either: %d; stubs filled from their page: %d; starts cleaned: %d; requirements rebuilt from their page: %d; Repeatable / fame level taken from the wiki: %d)', entries, missing, filled_from_pages, cleaned, repaired, refined))
print(string.format('heap: v1 data load %.0f KB, v2 data load %.0f KB, v2 at rest %.0f KB total',
    kb1, kb2, rest))
print(string.format('%d passed, %d failed', pass, fail))
os.exit(fail == 0 and 0 or 1)

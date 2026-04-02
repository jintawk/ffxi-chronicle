--[[
    Chronicle data layer
    Handles packet parsing, completion state tracking, and map loading
    Supports both quests and missions via packet 0x056
]]

local data = {}
local debug_enabled = false

-- Completion state: populated from packet 0x056
local state = {
    quest = {completed = {}, current = {}},
    mission = {completed = {}, current = {}, fields = {}},
    loaded = false,
    character = nil,
}

-- Unknown IDs encountered at runtime (dedup table)
local unknown_ids = {}

-- Map packet sub-type to category, status type, and area
-- Derived from Mastery addon's story_logs table
local story_logs = {
    -- Current quest flags
    [0x0050] = {cat = 'quest', type = 'current',   area = 'sandoria'},
    [0x0058] = {cat = 'quest', type = 'current',   area = 'bastok'},
    [0x0060] = {cat = 'quest', type = 'current',   area = 'windurst'},
    [0x0068] = {cat = 'quest', type = 'current',   area = 'jeuno'},
    [0x0070] = {cat = 'quest', type = 'current',   area = 'other'},
    [0x0078] = {cat = 'quest', type = 'current',   area = 'outlands'},
    -- 0x0080 handled below in packet_fields (multi-field packet)
    [0x0088] = {cat = 'quest', type = 'current',   area = 'wotg'},
    [0x00E0] = {cat = 'quest', type = 'current',   area = 'abyssea'},
    [0x00F0] = {cat = 'quest', type = 'current',   area = 'adoulin'},
    [0x0100] = {cat = 'quest', type = 'current',   area = 'coalition'},
    [0x0110] = {cat = 'quest', type = 'current',   area = 'acp'},
    [0x0120] = {cat = 'quest', type = 'current',   area = 'mkd'},
    [0x0130] = {cat = 'quest', type = 'current',   area = 'asa'},
    -- Completed quest flags
    [0x0090] = {cat = 'quest', type = 'completed', area = 'sandoria'},
    [0x0098] = {cat = 'quest', type = 'completed', area = 'bastok'},
    [0x00A0] = {cat = 'quest', type = 'completed', area = 'windurst'},
    [0x00A8] = {cat = 'quest', type = 'completed', area = 'jeuno'},
    [0x00B0] = {cat = 'quest', type = 'completed', area = 'other'},
    [0x00B8] = {cat = 'quest', type = 'completed', area = 'outlands'},
    -- 0x00C0 handled below in packet_fields (multi-field packet)
    [0x00C8] = {cat = 'quest', type = 'completed', area = 'wotg'},
    [0x00E8] = {cat = 'quest', type = 'completed', area = 'abyssea'},
    [0x00F8] = {cat = 'quest', type = 'completed', area = 'adoulin'},
    [0x0108] = {cat = 'quest', type = 'completed', area = 'coalition'},
    [0x0118] = {cat = 'quest', type = 'completed', area = 'acp'},
    [0x0128] = {cat = 'quest', type = 'completed', area = 'mkd'},
    [0x0138] = {cat = 'quest', type = 'completed', area = 'asa'},
    -- Completed mission bitflags (campaign)
    [0x0030] = {cat = 'mission', type = 'completed', area = 'campaign'},
    [0x0038] = {cat = 'mission', type = 'completed', area = 'campaign_2'},
}

-- Multi-field packets that contain quest/mission data alongside other fields
-- (these sub-types don't have a standard 'Quest Flags' field)
local packet_fields = {
    [0x0080] = {
        {label = 'Current TOAU Quests',      cat = 'quest',   area = 'toau'},
        {label = 'Current Assault Mission',  cat = 'mission', area = 'assault'},
        {label = 'Current TOAU Mission',     cat = 'mission', area = 'toau'},
        {label = 'Current WOTG Mission',     cat = 'mission', area = 'wotg'},
        {label = 'Current Campaign Mission', cat = 'mission', area = 'campaign'},
    },
    [0x00C0] = {
        {label = 'Completed TOAU Quests', cat = 'quest',   area = 'toau'},
        {label = 'Completed Assaults',    cat = 'mission', area = 'assault'},
    },
    [0x00D0] = {
        {label = 'Completed San d\'Oria Missions', cat = 'mission', area = 'sandoria'},
        {label = 'Completed Bastok Missions',      cat = 'mission', area = 'bastok'},
        {label = 'Completed Windurst Missions',    cat = 'mission', area = 'windurst'},
        {label = 'Completed Zilart Missions',      cat = 'mission', area = 'zilart'},
    },
    [0x00D8] = {
        {label = 'Completed TOAU Missions', cat = 'mission', area = 'toau'},
        {label = 'Completed WOTG Missions', cat = 'mission', area = 'wotg'},
    },
    [0xFFFE] = {
        {label = 'Current TVR Mission', cat = 'mission', area = 'tvr'},
    },
    [0xFFFF] = {
        {label = 'Nation'},  -- no cat; stored in state.mission.fields for nation routing
        {label = 'Current Nation Mission',  cat = 'mission', area = 'nation'},
        {label = 'Current ROZ Mission',     cat = 'mission', area = 'zilart'},
        {label = 'Current COP Mission',     cat = 'mission', area = 'cop'},
        {label = 'Current ACP Mission',     cat = 'mission', area = 'acp'},
        {label = 'Current MKD Mission',     cat = 'mission', area = 'mkd'},
        {label = 'Current ASA Mission',     cat = 'mission', area = 'asa'},
        {label = 'Current SOA Mission',     cat = 'mission', area = 'adoulin'},
        {label = 'Current ROV Mission',     cat = 'mission', area = 'rov'},
    },
}

-- Load quest and mission name maps
local maps = {
    quest = {
        sandoria    = require('maps/quests/sandoria'),
        bastok      = require('maps/quests/bastok'),
        windurst    = require('maps/quests/windurst'),
        jeuno       = require('maps/quests/jeuno'),
        other       = require('maps/quests/other'),
        outlands    = require('maps/quests/outlands'),
        toau        = require('maps/quests/toau'),
        wotg        = require('maps/quests/crystal_war'),
        abyssea     = require('maps/quests/abyssea'),
        adoulin     = require('maps/quests/adoulin'),
        coalition   = require('maps/quests/coalition'),
    },
    mission = {
        sandoria    = require('maps/missions/sandoria'),
        bastok      = require('maps/missions/bastok'),
        windurst    = require('maps/missions/windurst'),
        zilart      = require('maps/missions/zilart'),
        cop         = require('maps/missions/cop'),
        toau        = require('maps/missions/toau'),
        wotg        = require('maps/missions/wotg'),
        adoulin     = require('maps/missions/adoulin'),
        rov         = require('maps/missions/rov'),
        acp         = require('maps/missions/acp'),
        mkd         = require('maps/missions/mkd'),
        asa         = require('maps/missions/asa'),
        tvr         = require('maps/missions/tvr'),
        assault     = require('maps/missions/assault'),
        campaign    = require('maps/missions/campaign'),
    },
}

-- Precompute sorted ID lists for each map area (maps are static)
local sorted_ids = {quest = {}, mission = {}}
for cat, cat_maps in pairs(maps) do
    for area, area_map in pairs(cat_maps) do
        local ids = {}
        for id in pairs(area_map) do ids[#ids + 1] = id end
        table.sort(ids)
        sorted_ids[cat][area] = ids
    end
end

-- Special-case quest overrides
-- handler(id, name, is_completed, is_current, ctx) -> status_override, skip
local quest_overrides = {
    -- The Rivalry (75) / The Competition (76): mutually exclusive.
    -- Only one can be completed per character. Merged into a single entry;
    -- ID 76 is skipped from the list entirely.
    sandoria = {
        [75] = function(id, name, is_completed, is_current, ctx)
            local other_completed = ctx.completed_set[76 + 1] or false
            local other_current = ctx.current_set[76 + 1] or false
            if is_completed or other_completed then return 'completed', false
            elseif is_current or other_current then return 'active', false
            else return 'not_started', false
            end
        end,
        [76] = function() return nil, true end, -- skip (merged into 75)
    },
    -- "Mystery of *" (33-40) and "JNQuest" (122,125-127): DAT placeholders, not real quests.
    jeuno = {
        [33] = function() return nil, true end,
        [34] = function() return nil, true end,
        [35] = function() return nil, true end,
        [36] = function() return nil, true end,
        [37] = function() return nil, true end,
        [38] = function() return nil, true end,
        [39] = function() return nil, true end,
        [40] = function() return nil, true end,
        [122] = function() return nil, true end,
        [125] = function() return nil, true end,
        [126] = function() return nil, true end,
        [127] = function() return nil, true end,
    },
    -- "Windurst Quest #X": DAT placeholders, not real quests.
    windurst = {
        [22] = function() return nil, true end,
        [54] = function() return nil, true end,
        [55] = function() return nil, true end,
        [56] = function() return nil, true end,
        [57] = function() return nil, true end,
        [58] = function() return nil, true end,
        [59] = function() return nil, true end,
        [99] = function() return nil, true end,
    },
    -- The Sahagin's Key (128): not a real quest; it's an item obtainment sequence
    -- that exists in the DAT but is not trackable in-game.
    outlands = {
        [128] = function() return nil, true end, -- skip
    },
    -- Gather: (47): placeholder quest in the rogue coalition, not completable in-game.
    coalition = {
        [47] = function() return nil, true end, -- skip
    },
    -- Ad Infinitum: never gets completed flag; treat "active" as "completed"
    wotg = {
        [98] = function(id, name, is_completed, is_current)
            if is_completed or is_current then return 'completed', false
            else return 'not_started', false
            end
        end,
    },
}

-- Helper for nation "choose a destination" missions:
-- Main mission (ID 5) is completed if any sub-mission (6-9) is completed.
-- Sub-missions are hidden from the list.
local function nation_main_override(id, name, is_completed, is_current, ctx)
    for _, sub_id in ipairs({6, 7, 8, 9}) do
        if ctx.completed_set[sub_id + 1] then return 'completed', false end
    end
    if is_completed then return 'completed', false
    elseif is_current then return 'active', false
    else return 'not_started', false
    end
end
local function skip_override() return nil, true end

-- Helper: "permanently active" final missions that signify storyline completion
local function active_means_completed(id, name, is_completed, is_current)
    if is_completed or is_current then return 'completed', false end
    return 'not_started', false
end

-- Special-case mission overrides
-- handler(id, name, is_completed, is_current, ctx) -> status_override, skip
local mission_overrides = {
    -- Nation missions: sub-missions (6-9) are alternate destinations for the main
    -- mission (5). Only one can be done; if any is completed the main one counts.
    sandoria = {
        [5] = nation_main_override,
        [6] = skip_override, [7] = skip_override,
        [8] = skip_override, [9] = skip_override,
    },
    bastok = {
        [5] = nation_main_override,
        [6] = skip_override, [7] = skip_override,
        [8] = skip_override, [9] = skip_override,
    },
    windurst = {
        [5] = nation_main_override,
        [6] = skip_override, [7] = skip_override,
        [8] = skip_override, [9] = skip_override,
    },
    -- Zilart: "The Outlands" (2) is an internal transitional state, not a real mission.
    -- "The Last Verse" (31) belongs to COP's packet.
    -- If COP's current mission >= 850, Zilart is complete.
    zilart = {
        [2] = skip_override,
        [31] = function(id, name, is_completed, is_current, ctx)
            if is_completed then return 'completed', false end
            if ctx.cop_current and ctx.cop_current >= 850 then return 'completed', false end
            if is_current then return 'active', false end
            return 'not_started', false
        end,
    },
    -- COP: "The Road Forks" (325) has sub-missions that are completed implicitly.
    -- They don't have wiki pages and should be hidden from the list.
    -- "The Last Verse" (850) stays active forever once storyline is done.
    cop = {
        [101] = skip_override, -- Ancient Flames Beckon
        [137] = skip_override, -- The Isle of Forgotten Saints
        [257] = skip_override, -- A Transient Dream
        [330] = skip_override, -- Emerald Waters
        [331] = skip_override, -- Vicissitudes
        [335] = skip_override, -- Descendants of a Line Lost
        [339] = skip_override, -- Louverance
        [340] = skip_override, -- Memories of a Maiden
        [341] = skip_override, -- Comedy of Errors, Act I
        [345] = skip_override, -- Comedy of Errors, Act II
        [349] = skip_override, -- Exit Stage Left
        [367] = skip_override, -- The Cradles of Children Lost
        [447] = skip_override, -- The Return Home
        [540] = skip_override, -- Past Sins
        [542] = skip_override, -- Southern Legend
        [543] = skip_override, -- Partners Without Fame
        [546] = skip_override, -- A Century of Hardship
        [549] = skip_override, -- Departures
        [550] = skip_override, -- The Pursuit of Paradise
        [552] = skip_override, -- Spiral
        [553] = skip_override, -- Branded
        [556] = skip_override, -- Pride and Honor
        [559] = skip_override, -- And the Compass Guides
        [560] = skip_override, -- Where Messengers Gather
        [562] = skip_override, -- Entanglement
        [564] = skip_override, -- Head Wind
        [577] = skip_override, -- Echoes of Time
        [647] = skip_override, -- In the Light of the Crystal
        [758] = skip_override, -- Emptiness Bleeds
        [850] = active_means_completed,
    },
    -- WotG: "Lest We Forget" (53) is a hidden placeholder, exclude entirely.
    wotg = {
        [53] = skip_override,
    },
    -- ACP/MKD/ASA: final "(Fin)" missions stay active forever = completed.
    acp = {
        [11] = active_means_completed,
    },
    mkd = {
        [14] = active_means_completed,
    },
    asa = {
        [14] = active_means_completed,
    },
    -- Adoulin: "The Light Within" (368) stays active forever = completed.
    -- "fin" (999) is a hidden placeholder, exclude entirely.
    adoulin = {
        [368] = active_means_completed,
        [999] = skip_override,
    },
    -- ROV: "A Rhapsody for the Ages" (334) stays active forever = completed.
    rov = {
        [334] = active_means_completed,
    },
    -- TVR: "Your Decision" (642) stays active forever = completed.
    tvr = {
        [642] = active_means_completed,
    },
    -- TOAU: "Eternal Mercenary" (47) stays active forever = completed.
    toau = {
        [47] = active_means_completed,
    },
}

---------------------------------------------------------------------------
-- Name normalization (defined early so it's available for index building)
---------------------------------------------------------------------------

-- Normalize a quest/mission name for fuzzy matching:
-- lowercase, strip trailing " (Quest)"/" (mission)" suffixes
local function normalize_name(name)
    if not name then return '' end
    return name:lower():gsub('%s*%([Qq]uest%)%s*$', ''):gsub('%s*%([Mm]ission%)%s*$', '')
end

-- Static quest data (walkthrough, NPC, requirements, etc.) from BG Wiki extracts
-- Keys match story_logs area names; wotg maps to crystal_war file
local quest_data_file = {
    sandoria    = 'wiki/quests/sandoria',
    bastok      = 'wiki/quests/bastok',
    windurst    = 'wiki/quests/windurst',
    jeuno       = 'wiki/quests/jeuno',
    other       = 'wiki/quests/other',
    outlands    = 'wiki/quests/outlands',
    toau        = 'wiki/quests/toau',
    wotg        = 'wiki/quests/crystal_war',
    abyssea     = 'wiki/quests/abyssea',
    adoulin     = 'wiki/quests/adoulin',
    coalition   = 'wiki/quests/coalition',
}

local quest_data = {}
for area, path in pairs(quest_data_file) do
    local ok, tbl = pcall(require, path)
    if ok and type(tbl) == 'table' then
        quest_data[area] = tbl
    else
        quest_data[area] = {}
    end
end

-- Static mission data (walkthrough, NPC, requirements, etc.) from BG Wiki extracts
local mission_data_file = {
    sandoria    = 'wiki/missions/sandoria',
    bastok      = 'wiki/missions/bastok',
    windurst    = 'wiki/missions/windurst',
    zilart      = 'wiki/missions/zilart',
    cop         = 'wiki/missions/cop',
    toau        = 'wiki/missions/toau',
    wotg        = 'wiki/missions/wotg',
    acp         = 'wiki/missions/acp',
    mkd         = 'wiki/missions/mkd',
    asa         = 'wiki/missions/asa',
    adoulin     = 'wiki/missions/adoulin',
    rov         = 'wiki/missions/rov',
    tvr         = 'wiki/missions/tvr',
    assault     = 'wiki/missions/assault',
    campaign    = 'wiki/missions/campaign',
}

local mission_data = {}
for area, path in pairs(mission_data_file) do
    local ok, tbl = pcall(require, path)
    if ok and type(tbl) == 'table' then
        mission_data[area] = tbl
    else
        mission_data[area] = {}
    end
end

-- Build normalized name indexes for O(1) lookup
local function build_norm_index(data_table)
    local index = {}
    for area, area_data in pairs(data_table) do
        index[area] = {}
        for k, v in pairs(area_data) do
            index[area][normalize_name(k)] = v
        end
    end
    return index
end

local quest_data_norm = build_norm_index(quest_data)
local mission_data_norm = build_norm_index(mission_data)

-- Build normalized index for mission name maps (used in find_mission_area)
local mission_map_norm = {}
for area, area_map in pairs(maps.mission) do
    mission_map_norm[area] = {}
    for _, name in pairs(area_map) do
        mission_map_norm[area][normalize_name(name)] = true
    end
end

-- Display name for each area
local area_names = {
    sandoria    = 'San d\'Oria',
    bastok      = 'Bastok',
    windurst    = 'Windurst',
    jeuno       = 'Jeuno',
    other       = 'Other Areas',
    outlands    = 'Outlands',
    toau        = 'Aht Urhgan',
    wotg        = 'Crystal War',
    abyssea     = 'Abyssea',
    adoulin     = 'Adoulin',
    coalition   = 'Coalition',
    zilart      = 'Zilart',
    cop         = 'Promathia',
    assault     = 'Assault',
    campaign    = 'Campaign',
    acp         = 'A Crystalline Prophecy',
    mkd         = 'A Moogle Kupo d\'Etat',
    asa         = 'A Shantotto Ascension',
    rov         = 'Rhapsodies',
    tvr         = 'Voracious Resurgence',
}

-- Mission-specific display name overrides (where mission pack name differs from quest category)
local mission_area_names = {
    sandoria    = 'San d\'Oria',
    bastok      = 'Bastok',
    windurst    = 'Windurst',
    zilart      = 'Rise of the Zilart',
    cop         = 'Chains of Promathia',
    toau        = 'Treasures of Aht Urhgan',
    wotg        = 'Wings of the Goddess',
    adoulin     = 'Seekers of Adoulin',
    rov         = 'Rhapsodies of Vana\'diel',
    tvr         = 'The Voracious Resurgence',
    assault     = 'Assaults',
    campaign    = 'Campaign Operations',
}

-- Ordered lists for display
local quest_areas = {'sandoria', 'bastok', 'windurst', 'jeuno', 'other', 'outlands', 'toau', 'wotg', 'abyssea', 'adoulin', 'coalition'}
local mission_areas = {'sandoria', 'bastok', 'windurst', 'zilart', 'cop', 'toau', 'wotg', 'acp', 'mkd', 'asa', 'adoulin', 'rov', 'tvr', 'assault', 'campaign'}

-- Mission areas that use linear progression (current ID = single value, not bitflags)
-- For these areas, missions before the current ID are completed, the current one is active
-- Note: COP, SOA (adoulin), ROV packet values "don't correspond directly to DAT" per fields.lua
local linear_mission_areas = {
    cop = true, adoulin = true, rov = true,
    acp = true, mkd = true, asa = true, tvr = true,
}

-- Nation ID mapping for packet 0xFFFF
local nation_map = {[0] = 'sandoria', [1] = 'bastok', [2] = 'windurst'}

---------------------------------------------------------------------------
-- Bitflag parsing
---------------------------------------------------------------------------

-- Convert raw bitflag data to a boolean set (1-indexed)
-- Handles both string data (quest flag packets) and numeric bitfields
-- Memoized: same raw_data string/number returns cached result
local to_set_cache = {}

local function to_set(raw_data)
    if not raw_data then return {} end
    local cached = to_set_cache[raw_data]
    if cached then return cached end
    local set = {}
    if type(raw_data) == 'number' then
        for i = 0, 31 do
            if bit.band(raw_data, bit.lshift(1, i)) ~= 0 then
                set[i + 1] = true
            end
        end
    else
        for i = 0, #raw_data * 8 - 1 do
            local byte_pos = math.floor(i / 8) + 1
            local bit_pos = i % 8
            local byte = raw_data:byte(byte_pos)
            if byte and bit.band(byte, bit.lshift(1, bit_pos)) ~= 0 then
                set[i + 1] = true
            end
        end
    end
    to_set_cache[raw_data] = set
    return set
end

---------------------------------------------------------------------------
-- Packet parsing
---------------------------------------------------------------------------

function data.parse_packet(p)
    if not p or not p.Type then return end

    if debug_enabled then
        windower.add_to_chat(207, string.format('[Chronicle Debug] Packet sub-type: 0x%04X', p.Type))
    end

    -- Handle story log bitflag packets (quests current/completed)
    local log = story_logs[p.Type]
    if log then
        state[log.cat][log.type][log.area] = p['Quest Flags']
        state.loaded = true

        -- Check for unknown IDs
        local set = to_set(p['Quest Flags'])
        local area_map = maps[log.cat] and maps[log.cat][log.area]
        if area_map then
            for idx in pairs(set) do
                local quest_id = idx - 1
                if area_map[quest_id] == nil then
                    local key = string.format('%s:%s:%d', log.cat, log.area, quest_id)
                    if not unknown_ids[key] then
                        unknown_ids[key] = true
                        if debug_enabled then
                            windower.add_to_chat(167, string.format('[Chronicle] Unknown %s ID: %s #%d', log.cat, log.area, quest_id))
                        end
                    end
                end
            end
        end
    end

    -- Handle multi-field packets (TOAU quests, missions, etc.)
    local fields = packet_fields[p.Type]
    if fields then
        state.loaded = true
        for _, field in ipairs(fields) do
            if not field.cat then
                -- Non-categorized field (e.g., Nation) — store in mission.fields
                state.mission.fields[field.label] = p[field.label]
            elseif field.label:find('Current') then
                state[field.cat].current[field.area] = p[field.label]
            elseif field.label:find('Completed') then
                state[field.cat].completed[field.area] = p[field.label]
            end
        end

        -- Route nation mission current value to the correct nation area
        if p.Type == 0xFFFF then
            local nation_id = state.mission.fields['Nation']
            local nation_area = nation_map[nation_id]
            if nation_area and state.mission.current['nation'] then
                state.mission.current[nation_area .. '_current_mission'] = state.mission.current['nation']
            end
        end
    end

    -- Log unknown packet types
    if not log and not fields then
        local key = string.format('unknown_packet:0x%04X', p.Type)
        if not unknown_ids[key] then
            unknown_ids[key] = true
            if debug_enabled then
                windower.add_to_chat(207, string.format('[Chronicle Debug] Unknown 0x056 sub-type: 0x%04X', p.Type))
            end
        end
    end
end

---------------------------------------------------------------------------
-- Status queries
---------------------------------------------------------------------------

-- Get mission completion status for an area
-- Handles both bitflag-based (nations, zilart, assault, campaign) and
-- linear/current-ID-based (cop, adoulin, rov, acp, mkd, asa, tvr) areas
local function get_mission_area_status(area, area_map)
    local completed_count = 0
    local current_count = 0
    local total = 0
    local items = {}
    local has_data = false

    -- Use precomputed sorted IDs
    local ids = sorted_ids.mission[area]

    if linear_mission_areas[area] then
        -- Linear progression: current value is a single mission ID.
        --
        -- Packet values do not correspond directly to DAT mission IDs. The
        -- server sends a value that falls between consecutive DAT IDs (e.g.,
        -- TVR sends 454 when the active mission's DAT ID is 452, the next
        -- mission is 460). We resolve this with a fuzzy lookup: find the
        -- largest map ID that is <= the packet value.
        --
        -- TVR "no active mission" high-bit flag (0x80000000):
        --
        --   Packet 0x056 sub-type 0xFFFE carries TVR mission state as a
        --   signed 32-bit integer at offset 0x04. The high bit encodes
        --   whether the player currently has an active TVR mission:
        --
        --     Bit 31 clear (positive value):
        --       Player has a mission in progress. The lower 31 bits hold a
        --       value near the active mission's DAT ID (use <= fuzzy lookup).
        --       Example: value 454 → active mission is DAT ID 452.
        --
        --     Bit 31 set (negative when parsed as signed int):
        --       Player has NO active mission. The lower 31 bits point to
        --       the next uncompleted mission's DAT ID (or near it). All
        --       missions with IDs strictly less than this value are completed.
        --       Example: value 0x800001CC (lower bits = 460) → missions
        --       through DAT ID 452 are completed, 460 onward not started.
        --
        --   This flag is unique to TVR among current mission lines. Other
        --   linear areas (COP, SOA, ROV, ACP, MKD, ASA) always have an
        --   active mission once started (their final mission stays
        --   permanently active via active_means_completed overrides), so
        --   the high bit is never set for them. The stripping logic below
        --   is safe for all areas — it only triggers on negative values.
        --
        --   Discovery: 2026-04-02 via raw packet hex inspection with the
        --   MissionSniffer addon. The 28 bytes after the int in 0xFFFE
        --   (labeled _junk in fields.lua) are confirmed all-zero and do
        --   not carry completion bitflags.
        --
        local raw_val = state.mission.current[area]
        has_data = raw_val ~= nil

        local no_active_flag = false
        local current_val = raw_val
        if current_val then
            -- Detect and strip the high-bit flag (signed int: negative means bit set)
            if current_val < 0 then
                no_active_flag = true
                -- Strip high bit: signed int with 0x80000000 set -> lower 31 bits
                -- In Lua 5.1 signed arithmetic: add 2^31 to convert from negative
                current_val = current_val + 2147483648
            end
        end

        -- Find the active mission ID: largest map ID <= current_val
        local active_id = nil
        if current_val and current_val > 0 then
            for i = #ids, 1, -1 do
                if ids[i] <= current_val then
                    active_id = ids[i]
                    break
                end
            end
        end

        for _, id in ipairs(ids) do
            local name = area_map[id]
            if name then
                local handled = false

                -- Check for mission-specific override
                local area_overrides = mission_overrides[area]
                if area_overrides and area_overrides[id] then
                    local is_completed = active_id and id < active_id or false
                    local is_current = active_id and id == active_id and not no_active_flag or false
                    local status_override, skip = area_overrides[id](id, name, is_completed, is_current, {
                        current_val = current_val,
                        cop_current = state.mission.current['cop'],
                    })
                    if skip then
                        handled = true
                    elseif status_override then
                        total = total + 1
                        if status_override == 'completed' then completed_count = completed_count + 1 end
                        if status_override == 'active' then current_count = current_count + 1 end
                        table.insert(items, {id = id, name = name, status = status_override})
                        handled = true
                    end
                end

                if not handled then
                    total = total + 1
                    local status
                    if active_id then
                        if no_active_flag then
                            -- High-bit flag: active_id is the next uncompleted mission,
                            -- not an in-progress one. Everything before it is completed.
                            if id < active_id then
                                status = 'completed'
                                completed_count = completed_count + 1
                            else
                                status = 'not_started'
                            end
                        elseif id < active_id then
                            status = 'completed'
                            completed_count = completed_count + 1
                        elseif id == active_id then
                            status = 'active'
                            current_count = current_count + 1
                        else
                            status = 'not_started'
                        end
                    else
                        -- No current value or 0 — check if there are completed bitflags too
                        -- (some linear areas also have completed data, e.g., if finished)
                        local completed_set = to_set(state.mission.completed[area])
                        if completed_set[id + 1] then
                            status = 'completed'
                            completed_count = completed_count + 1
                            has_data = true
                        else
                            status = 'not_started'
                        end
                    end
                    table.insert(items, {id = id, name = name, status = status})
                end
            end
        end
    elseif area == 'campaign' then
        -- Campaign: merge two bitflag packets (campaign + campaign_2)
        local completed_set_1 = to_set(state.mission.completed['campaign'])
        local completed_set_2 = to_set(state.mission.completed['campaign_2'])
        has_data = state.mission.completed['campaign'] ~= nil

        for _, id in ipairs(ids) do
            local name = area_map[id]
            if name then
                total = total + 1
                -- campaign_2 starts at index 256
                local is_completed
                if id >= 256 then
                    is_completed = completed_set_2[(id - 256) + 1] or false
                else
                    is_completed = completed_set_1[id + 1] or false
                end
                local status = is_completed and 'completed' or 'not_started'
                if is_completed then completed_count = completed_count + 1 end
                table.insert(items, {id = id, name = name, status = status})
            end
        end
    else
        -- Bitflag-based areas (nations, zilart, toau, wotg, assault)
        local completed_set = to_set(state.mission.completed[area])
        has_data = state.mission.completed[area] ~= nil

        -- Areas where "current" is a single integer ID (not bitflags)
        -- TOAU and WOTG use ctype='int' for their current mission field
        local current_int_areas = {toau = true, wotg = true}
        local current_set, current_int_val
        if current_int_areas[area] then
            current_int_val = state.mission.current[area]
        else
            current_set = to_set(state.mission.current[area])
        end

        -- For nation areas, also check the routed current mission value
        local nation_current_val = state.mission.current[area .. '_current_mission']

        for _, id in ipairs(ids) do
            local name = area_map[id]
            if name then
                local is_completed = completed_set[id + 1] or false
                local is_current
                if current_int_val then
                    is_current = current_int_val == id
                elseif current_set then
                    is_current = current_set[id + 1] or false
                else
                    is_current = false
                end

                -- Check if this is the current mission via nation routing
                if not is_current and nation_current_val and nation_current_val == id then
                    is_current = true
                end

                local handled = false

                -- Check for mission-specific override
                local area_overrides = mission_overrides[area]
                if area_overrides and area_overrides[id] then
                    local status_override, skip = area_overrides[id](id, name, is_completed, is_current, {
                        completed_set = completed_set,
                        current_set = current_set,
                        cop_current = state.mission.current['cop'],
                    })
                    if skip then
                        handled = true
                    elseif status_override then
                        total = total + 1
                        if status_override == 'completed' then completed_count = completed_count + 1 end
                        if status_override == 'active' then current_count = current_count + 1 end
                        table.insert(items, {id = id, name = name, status = status_override})
                        handled = true
                    end
                end

                if not handled then
                    total = total + 1
                    local status
                    if is_completed then
                        status = 'completed'
                        completed_count = completed_count + 1
                    elseif is_current then
                        status = 'active'
                        current_count = current_count + 1
                    else
                        status = 'not_started'
                    end
                    table.insert(items, {id = id, name = name, status = status})
                end
            end
        end
    end

    return {
        completed = completed_count,
        current = current_count,
        total = total,
        items = items,
        has_data = has_data,
    }
end

-- Get completion counts for a specific area
-- Returns: {completed=N, current=N, total=N, items={[id]={name, status}}}
function data.get_area_status(cat, area)
    local area_map = maps[cat] and maps[cat][area]
    if not area_map then
        return {completed = 0, current = 0, total = 0, items = {}, has_data = false}
    end

    -- Mission areas may use linear progression or bitflags
    if cat == 'mission' then
        return get_mission_area_status(area, area_map)
    end

    local completed_set = to_set(state[cat].completed[area])
    local current_set = to_set(state[cat].current[area])
    local has_data = state[cat].completed[area] ~= nil

    local completed_count = 0
    local current_count = 0
    local total = 0
    local items = {}

    local ids = sorted_ids[cat][area]

    for _, id in ipairs(ids) do
        local name = area_map[id]
        if name then
            local is_completed = completed_set[id + 1] or false
            local is_current = current_set[id + 1] or false
            local handled = false

            -- Check for quest-specific override
            local area_overrides = quest_overrides[area]
            if area_overrides and area_overrides[id] then
                local status_override, skip = area_overrides[id](id, name, is_completed, is_current, {
                    completed_set = completed_set,
                    current_set = current_set,
                })
                if skip then
                    handled = true
                elseif status_override then
                    total = total + 1
                    if status_override == 'completed' then completed_count = completed_count + 1 end
                    if status_override == 'active' then current_count = current_count + 1 end
                    table.insert(items, {id = id, name = name, status = status_override})
                    handled = true
                end
            end

            if not handled then
                -- Standard logic
                total = total + 1
                if is_completed then completed_count = completed_count + 1 end
                if is_current then current_count = current_count + 1 end

                -- Note: "current" flags are unreliable for completed quests (bits persist
                -- after completion). Only use current flag for incomplete quests.
                local status
                if is_completed then
                    status = 'completed'
                elseif is_current then
                    status = 'active'
                else
                    status = 'not_started'
                end

                table.insert(items, {id = id, name = name, status = status})
            end
        end
    end

    return {
        completed = completed_count,
        current = current_count,
        total = total,
        items = items,
        has_data = has_data,
    }
end

-- Get summary for quests or missions
function data.get_type_summary(cat)
    local areas = cat == 'mission' and mission_areas or quest_areas
    local total_completed = 0
    local total_count = 0
    local area_summaries = {}

    for _, area in ipairs(areas) do
        local status = data.get_area_status(cat, area)
        total_completed = total_completed + status.completed
        total_count = total_count + status.total
        table.insert(area_summaries, {
            area = area,
            name = (cat == 'mission' and mission_area_names[area]) or area_names[area] or area,
            completed = status.completed,
            total = status.total,
            has_data = status.has_data,
        })
    end

    return {
        completed = total_completed,
        total = total_count,
        areas = area_summaries,
    }
end

-- Get overall summary (quests and missions)
function data.get_summary()
    local quests = data.get_type_summary('quest')
    local missions = data.get_type_summary('mission')
    return {
        quest = quests,
        mission = missions,
        total_completed = quests.completed + missions.completed,
        total = quests.total + missions.total,
        loaded = state.loaded,
    }
end

---------------------------------------------------------------------------
-- Chat output
---------------------------------------------------------------------------

local function pct(n, d)
    if d == 0 then return 0 end
    return math.floor((n / d) * 100)
end

function data.print_type_summary(cat)
    if not state.loaded then
        windower.add_to_chat(167, 'Chronicle: No data loaded yet. Please zone to receive data.')
        return
    end

    local s = data.get_type_summary(cat)
    local label = cat == 'mission' and 'Missions' or 'Quests'
    windower.add_to_chat(207, string.format('---------- %s Summary ----------', label))
    windower.add_to_chat(207, string.format('  Total: %d / %d  (%d%%)', s.completed, s.total, pct(s.completed, s.total)))
    windower.add_to_chat(207, ' ')

    for _, a in ipairs(s.areas) do
        local data_marker = a.has_data and '' or ' [no data]'
        windower.add_to_chat(207, string.format('  %-25s %3d / %3d  (%2d%%)%s',
            a.name, a.completed, a.total, pct(a.completed, a.total), data_marker))
    end
    windower.add_to_chat(207, string.rep('-', 42))
end

function data.print_area(cat, area)
    if not state.loaded then
        windower.add_to_chat(167, 'Chronicle: No data loaded yet. Please zone to receive data.')
        return
    end

    local s = data.get_area_status(cat, area)
    if s.total == 0 then
        windower.add_to_chat(167, string.format('Chronicle: Unknown area "%s" for %s.', area, cat))
        return
    end

    local display_name = (cat == 'mission' and mission_area_names[area]) or area_names[area] or area
    local label = cat == 'mission' and 'Missions' or 'Quests'
    windower.add_to_chat(207, string.format('---------- %s %s ----------', display_name, label))
    windower.add_to_chat(207, string.format('  %d / %d  (%d%%)', s.completed, s.total, pct(s.completed, s.total)))
    windower.add_to_chat(207, ' ')

    -- Status colors: completed=green(158), active=blue(207), repeat=yellow(159), not_started=grey(207)
    local status_colors = {
        completed   = 158,
        active      = 207,
        ['repeat']  = 159,
        not_started = 207,
    }
    local status_symbols = {
        completed   = '\xe2\x97\x8f',  -- filled circle
        active      = '\xe2\x97\x8e',  -- circle with dot
        ['repeat']  = '\xe2\x97\x90',  -- half circle
        not_started = '\xe2\x97\x8b',  -- empty circle
    }

    if not s.has_data then
        windower.add_to_chat(167, '  [No packet data — zone to load]')
    end

    for _, item in ipairs(s.items) do
        local color = status_colors[item.status] or 207
        local sym = status_symbols[item.status] or '?'
        local tag = item.status == 'repeat' and '  [RPT]' or ''
        windower.add_to_chat(color, string.format('  %s %s%s', sym, item.name, tag))
    end

    windower.add_to_chat(207, string.rep('-', 42))
end

---------------------------------------------------------------------------
-- Event handlers
---------------------------------------------------------------------------

function data.on_zone_change()
    -- Data will arrive via packets shortly after zone change
    if debug_enabled then
        windower.add_to_chat(207, '[Chronicle Debug] Zone change detected, awaiting packet data...')
    end
end

function data.on_login(name)
    state.character = name
    if debug_enabled then
        windower.add_to_chat(207, '[Chronicle Debug] Login: ' .. tostring(name))
    end
end

function data.on_logout()
    -- Clear all state on logout
    state.quest = {completed = {}, current = {}}
    state.mission = {completed = {}, current = {}, fields = {}}
    state.loaded = false
    state.character = nil
    unknown_ids = {}
    to_set_cache = {}
end

function data.toggle_debug()
    debug_enabled = not debug_enabled
    windower.add_to_chat(207, 'Chronicle debug: ' .. (debug_enabled and 'ON' or 'OFF'))
end

---------------------------------------------------------------------------
-- Public accessors for UI
---------------------------------------------------------------------------

function data.is_loaded()
    return state.loaded
end

function data.get_area_name(area, cat)
    return (cat == 'mission' and mission_area_names[area]) or area_names[area] or area
end

local function ci_lookup(tbl, norm_tbl, key)
    if not tbl or not key then return nil end
    -- Try exact match first (fast path)
    if tbl[key] then return tbl[key] end
    -- Use precomputed normalized index for O(1) lookup
    if norm_tbl then
        return norm_tbl[normalize_name(key)]
    end
    return nil
end

-- Get full quest entry from static data for a given area and quest name
function data.get_quest_data(area, quest_name)
    local area_data = quest_data[area]
    if not area_data then return nil end
    return ci_lookup(area_data, quest_data_norm[area], quest_name)
end

-- Find which area a quest belongs to by searching all quest data
-- Returns area key (e.g. 'windurst') or nil if not found
-- If prefer_area is given, check that area first (handles duplicate names)
function data.find_quest_area(quest_name, prefer_area)
    if prefer_area and quest_data[prefer_area] and ci_lookup(quest_data[prefer_area], quest_data_norm[prefer_area], quest_name) then
        return prefer_area
    end
    for area, area_data in pairs(quest_data) do
        if ci_lookup(area_data, quest_data_norm[area], quest_name) then
            return area
        end
    end
    return nil
end

-- Get full mission entry from static data for a given area and mission name
-- If mission_id is provided, prefer an entry whose .id field matches (handles duplicate names)
function data.get_mission_data(area, mission_name, mission_id)
    local area_data = mission_data[area]
    if not area_data then return nil end
    -- If we have an ID, try to find an entry with a matching .id first
    if mission_id then
        for _, entry in pairs(area_data) do
            if type(entry) == 'table' and entry.id == mission_id then
                return entry
            end
        end
    end
    return ci_lookup(area_data, mission_data_norm[area], mission_name)
end

-- Find which area a mission belongs to by searching all mission data
-- If prefer_area is given, check that area first (handles duplicate names like "Magicite")
function data.find_mission_area(mission_name, prefer_area)
    if prefer_area and mission_data[prefer_area] and ci_lookup(mission_data[prefer_area], mission_data_norm[prefer_area], mission_name) then
        return prefer_area
    end
    for area, area_data in pairs(mission_data) do
        if ci_lookup(area_data, mission_data_norm[area], mission_name) then
            return area
        end
    end
    -- Fall back to searching mission name maps using precomputed normalized index
    local norm = normalize_name(mission_name)
    if prefer_area and mission_map_norm[prefer_area] and mission_map_norm[prefer_area][norm] then
        return prefer_area
    end
    for area, norm_map in pairs(mission_map_norm) do
        if norm_map[norm] then
            return area
        end
    end
    return nil
end

-- Get prev/next mission from the sorted map order
function data.get_mission_chain(area, mission_name)
    local area_map = maps.mission and maps.mission[area]
    if not area_map then return nil end

    -- Use precomputed sorted ID list; find target mission
    local ids = sorted_ids.mission[area]
    local target_id = nil
    for _, id in ipairs(ids) do
        if area_map[id] and area_map[id]:lower() == mission_name:lower() then
            target_id = id
            break
        end
    end
    if not target_id then return nil end

    local prev_name, next_name
    for i, id in ipairs(ids) do
        if id == target_id then
            if i > 1 then prev_name = area_map[ids[i - 1]] end
            if i < #ids then next_name = area_map[ids[i + 1]] end
            break
        end
    end

    return {
        previous = prev_name and {prev_name} or nil,
        next = next_name and {next_name} or nil,
    }
end

-- Get NPC info for a quest or mission from static data
-- Returns structured table {start_npc, start_zone, start_pos} or nil
function data.get_npc_info(area, quest_name, cat)
    local entry
    if cat == 'mission' then
        entry = data.get_mission_data(area, quest_name)
    else
        entry = data.get_quest_data(area, quest_name)
    end
    if not entry then return nil end
    -- Return info if there's any useful data: NPC, zone, or position
    if not entry.start_npc and not entry.start_zone and not entry.start_pos then return nil end
    return {
        start_npc = entry.start_npc,
        start_zone = entry.start_zone,
        start_pos = entry.start_pos,
    }
end

-- Format NPC info for display: "NPC_NAME - ZONE (POS)"
function data.format_npc_info(info)
    if not info then return nil end
    local parts = {}
    if info.start_npc then
        table.insert(parts, info.start_npc:upper())
    end
    if info.start_zone then
        local zone = info.start_zone:upper()
        if info.start_pos then
            zone = zone .. ' (' .. info.start_pos .. ')'
        end
        table.insert(parts, zone)
    end
    if #parts == 0 then return nil end
    return table.concat(parts, ' - ')
end

function data.get_unknown_ids()
    return unknown_ids
end

function data.get_unknown_count()
    local count = 0
    for k in pairs(unknown_ids) do
        -- Only count quest/mission IDs, not unknown packet types
        if not k:find('^unknown_packet:') then
            count = count + 1
        end
    end
    return count
end

function data.print_unknown_ids()
    local count = 0
    local entries = {}
    for k in pairs(unknown_ids) do
        if not k:find('^unknown_packet:') then
            count = count + 1
            table.insert(entries, k)
        end
    end

    if count == 0 then
        windower.add_to_chat(207, 'Chronicle: No unknown IDs detected.')
        return
    end

    table.sort(entries)
    windower.add_to_chat(207, string.format('---------- Unknown IDs (%d) ----------', count))
    for _, entry in ipairs(entries) do
        windower.add_to_chat(167, '  ' .. entry)
    end
    windower.add_to_chat(207, string.rep('-', 42))
end

return data

-- Step progress for Fate's Call (Rhapsodies of Vana'diel mission 1-12, page id 136). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/1_12_Fates_Call.lua. The rov line holds the page id (enum + 108) and has no completed set;
-- the next value is 138 (What Lies Beyond). The mission is one scene: once the character is rank 6 or past the Shadow Lord, zoning into
-- any of the ten starting-nation zones plays event 30036 from onZoneIn and its finish completes the mission. No other mission plays that
-- id there (the first RoV mission plays 30035). The client has no script for it, LandSandBoat only, and whether the 0x00A packet carries
-- it with an EventNum the way a zone's own events do is not known, so the line moving on (min = 138) also ticks the bullet.
return {
    title = "Fate's Call",
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 136}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into any of the three starting'},
         done = {
            {t = 'zonein', zone = 230, event = 30036, why = "Southern San d'Oria zone-in cutscene 30036 (Iroha)"},
            {t = 'zonein', zone = 231, event = 30036, why = "Northern San d'Oria zone-in cutscene 30036 (Iroha)"},
            {t = 'zonein', zone = 232, event = 30036, why = "Port San d'Oria zone-in cutscene 30036 (Iroha)"},
            {t = 'zonein', zone = 234, event = 30036, why = 'Bastok Mines zone-in cutscene 30036 (Iroha)'},
            {t = 'zonein', zone = 235, event = 30036, why = 'Bastok Markets zone-in cutscene 30036 (Iroha)'},
            {t = 'zonein', zone = 236, event = 30036, why = 'Port Bastok zone-in cutscene 30036 (Iroha)'},
            {t = 'zonein', zone = 238, event = 30036, why = 'Windurst Waters zone-in cutscene 30036 (Iroha)'},
            {t = 'zonein', zone = 239, event = 30036, why = 'Windurst Walls zone-in cutscene 30036 (Iroha)'},
            {t = 'zonein', zone = 240, event = 30036, why = 'Port Windurst zone-in cutscene 30036 (Iroha)'},
            {t = 'zonein', zone = 241, event = 30036, why = 'Windurst Woods zone-in cutscene 30036 (Iroha)'},
            {t = 'mission', line = 'rov', min = 138, why = 'mission log: the line moved past Fate\'s Call'},
         }},
    },
}

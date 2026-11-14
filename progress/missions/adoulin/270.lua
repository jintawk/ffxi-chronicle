-- Step progress for A Vow of Truth (Seekers of Adoulin mission 4-2-3, mission id 270). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/soa/4_2_3_A_Vow_of_Truth.lua. While the mission is current, entering Woh Gates (zone 273)
-- plays zone-in cutscene 7 (no client script decodes it) and its finish completes the mission, so the zone-in is the one step.
-- The adoulin line has no completed set; its value is the page id and moves past 270 on completion (`min = 271`). Levil's 165 in
-- Western Adoulin is a reminder while the mission is current and proves nothing, so it is not used.
return {
    title = 'A Vow of Truth',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 270}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter woh gates from any entrance'},
         done = {
            {t = 'zonein', zone = 273, event = 7, why = 'Woh Gates zone-in 7, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 271, why = 'mission log: the line moved past A Vow of Truth'},
         }},
    },
}

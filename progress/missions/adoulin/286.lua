-- Step progress for A Shrouded Canopy (Seekers of Adoulin mission 4-3-5, mission id 286). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/soa/4_3_5_A_Shrouded_Canopy.lua. While the mission is current, entering Leafallia (zone
-- 281) plays zone-in cutscene 2 (no client script decodes it) and its finish completes the mission. Levil's 166 is a reminder
-- while the mission is current and proves nothing. The adoulin line has no completed set (`min = 287`).
return {
    title = 'A Shrouded Canopy',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 286}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'travel to g 11 almost f'},
         done = {
            {t = 'zonein', zone = 281, event = 2, why = 'Leafallia zone-in 2, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 287, why = 'mission log: the line moved past A Shrouded Canopy'},
         }},
    },
}

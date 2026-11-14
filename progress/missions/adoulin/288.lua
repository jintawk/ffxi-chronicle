-- Step progress for Leafallia (Seekers of Adoulin mission 4-3-6, mission id 288). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/soa/4_3_6_Leafallia.lua and the client script S4 281_Aged_Stump_01119036 (event 4 has no
-- dialogue). The Aged Stump in Leafallia (zone 281) plays event 4 while the mission is current and its finish completes it. Levil's
-- 166 is a reminder while the mission is current and proves nothing. The adoulin line has no completed set (`min = 289`).
return {
    title = 'Leafallia',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 288}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the aged stump at h'},
         done = {
            {t = 'event', zone = 281, event = 4, why = 'Aged Stump 4, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 289, why = 'mission log: the line moved past Leafallia'},
         }},
    },
}

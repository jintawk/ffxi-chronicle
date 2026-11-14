-- Step progress for Summoned by Spirits (Seekers of Adoulin mission, page id 200). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_3_0_Summoned_by_Spirits.lua. Every zone-in to the Celennia Memorial Library
-- (zone 284) plays cutscene 3 while the mission is current, and its finish always completes the mission. The adoulin line
-- (packet value = page id, no completed set) moves past 200: `min = 201`.
return {
    title = 'Summoned by Spirits',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 200}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into the celennia memorial library'},
         done = {
            {t = 'zonein', zone = 284, event = 3, why = 'Celennia Memorial Library zone-in 3: its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 201, why = 'mission log: the line moved past Summoned by Spirits'},
         }},
    },
}

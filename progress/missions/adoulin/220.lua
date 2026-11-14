-- Step progress for The Order's Treasures (Seekers of Adoulin, mission page id 220). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_4_3_The_Orders_Treasures.lua. Zoning into the Celennia Memorial Library (zone
-- 284) plays event 4 only while this mission is current (the other missions that zone in there use other event ids), and its
-- finish completes the mission. Levil's 143 is a reminder. The adoulin line has no completed set: `min = 221`.
return {
    title = "The Order's Treasures",
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 220}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into the celennia memorial library'},
         done = {
            {t = 'zonein', zone = 284, event = 4, why = 'Celennia Memorial Library zone-in 4, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 221, why = "mission log: the line moved past The Order's Treasures"},
         }},
    },
}

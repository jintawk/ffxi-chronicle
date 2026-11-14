-- Step progress for Adoulin Calling (Seekers of Adoulin mission, page id 204). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_3_2_Adoulin_Calling.lua. The Door: Boarding House (Eastern Adoulin 257) plays 1511
-- on every check while the mission is current and its finish always completes the mission. Elmric 24 (Ceizak) and Levil 141 are
-- reminders and prove nothing. The adoulin line (packet value = page id, no completed set) moves past 204: `min = 205`.
return {
    title = 'Adoulin Calling',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 204}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'check the door boarding house at'},
         done = {
            {t = 'event', zone = 257, event = 1511, why = 'Door: Boarding House 1511: the long cutscene, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 205, why = 'mission log: the line moved past Adoulin Calling'},
         }},
    },
}

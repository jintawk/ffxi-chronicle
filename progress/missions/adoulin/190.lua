-- Step progress for The Purgation (Seekers of Adoulin mission, page id 190). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_1_3_The_Purgation.lua. The Castle Adoulin gates trigger area (Eastern Adoulin 257)
-- plays event 1510 while the mission is current and its finish always completes the mission (and deletes the four key items).
-- Erminold 1526 and Levil 138 are reminders and prove nothing. The adoulin line (packet value = page id, no completed set)
-- moves past 190: `min = 191`.
return {
    title = 'The Purgation',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 190}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'with the 4 key items in'},
         done = {
            {t = 'event', zone = 257, event = 1510, why = 'Eastern Adoulin castle gates area 1510: the cutscene, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 191, why = 'mission log: the line moved past The Purgation'},
         }},
    },
}

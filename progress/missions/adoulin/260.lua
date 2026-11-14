-- Step progress for Ministerial Whispers (Seekers of Adoulin mission 4-1-4, page id 260). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_1_4_Ministerial_Whispers.lua. Levil (Western Adoulin 256) plays event 158 as the
-- mission's own progress event; its finish completes the mission and pays 500 bayld (the client body is empty). Rejected: Kipligg 163
-- (a reminder dialogue). The line has no completed set, so the end is `min = 261`.
return {
    title = 'Ministerial Whispers',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 260}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with levil for a small'},
         done = {
            {t = 'event', zone = 256, event = 158, why = 'Levil 158: finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 261, why = 'mission log: the line moved past Ministerial Whispers'},
         }},
    },
}

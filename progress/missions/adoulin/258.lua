-- Step progress for Done and Delivered (Seekers of Adoulin mission 4-1-3, page id 258). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_1_3_Done_and_Delivered.lua. Kipligg (Western Adoulin 256) plays event 157 as the mission's
-- own progress event and its finish always completes the mission (the client body is empty). Rejected: Levil 161 (a reminder).
-- The line has no completed set, so the end is `min = 259`.
return {
    title = 'Done and Delivered',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 258}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to and speak with kipligg'},
         done = {
            {t = 'event', zone = 256, event = 157, why = 'Kipligg 157: finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 259, why = 'mission log: the line moved past Done and Delivered'},
         }},
    },
}

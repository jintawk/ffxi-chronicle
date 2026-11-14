-- Step progress for Courier Catastrophe (Seekers of Adoulin mission 4-1-2, page id 256). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_1_2_Courier_Catastrophe.lua. The Port Storage door (Western Adoulin 256) plays event 167
-- only when the traded item matches the one asked for (a wrong trade plays nothing), and its finish completes the mission and takes the
-- trade. Examining the door just prints the request, Kipligg 162 and Levil 161 are reminders: none prove anything. Bullets 1 and 2
-- are notes on the trade; the interview link is not a step. The line has no completed set, so the end is `min = 257`.
return {
    title = 'Courier Catastrophe',
    completes = 's3',
    known = {{t = 'mission', line = 'adoulin', eq = 256}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'as seen in the previous cutscene'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'the specific item asked for depends'}},
        {id = 's3', at = {n = 3, fp = 'trade the requested item s to'},
         done = {
            {t = 'event', zone = 256, event = 167, why = 'Port Storage 167: only on the right trade (finish completes)'},
            {t = 'mission', line = 'adoulin', min = 257, why = 'mission log: the line moved past Courier Catastrophe'},
         }},
    },
}

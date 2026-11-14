-- Step progress for Melvien de Malecroix (Seekers of Adoulin mission 4-1-1, page id 254). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_1_1_Melvien_de_Malecroix.lua. The Port Storage door (Western Adoulin 256) plays event 156
-- as this mission's own progress event (it picks the item Guilberien asks for) and its finish always completes the mission. Kipligg 162
-- and Levil 161 are reminders and prove nothing. Page bullets 3 and 4 describe the trade of the next mission (Courier Catastrophe,
-- event 167), which this mission's script does not handle, so they are left unmapped, as are the item list and the interview link.
-- The line has no completed set, so the end is `min = 255`.
return {
    title = 'Melvien de Malecroix',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 254}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'warp to the western adoulin waterfront'},
         done = {
            {t = 'event', zone = 256, event = 156, why = 'Port Storage 156: the cutscene (this mission only; finish completes)'},
            {t = 'mission', line = 'adoulin', min = 255, why = 'mission log: the line moved past Melvien de Malecroix'},
         }},
    },
}

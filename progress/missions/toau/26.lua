-- Step progress for Misplaced Nobility (Treasures of Aht Urhgan, mission id 26). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/27_Misplaced_Nobility.lua: the blank target (blank_toau20) in Aydeewa Subterrane (68) plays
-- event 12, which completes the mission. Bullets 1 and 2 (get there, walk west) are direction notes with s3.
return {
    title = 'Misplaced Nobility',
    completes = 's3',
    known = {{t = 'mission', line = 'toau', eq = 26}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'get to aydeewa subterrane by any'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head for the western end of'}},
        {id = 's3', at = {n = 3, fp = 'examine the blank target at f'},
         done = {
            {t = 'event', zone = 68, event = 12, why = "blank target 12: completes the mission"},
            {t = 'mission', line = 'toau', eq = 26, completed = true, why = "mission log: Misplaced Nobility completed"},
         }},
    },
}

-- Step progress for Prevalence of Pirates (Treasures of Aht Urhgan, mission id 29). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/30_Prevalence_of_Pirates.lua: Arrapago Reef (54) zone-in cutscene 13 plays only at status 0
-- and sets status 1; the Cutter trigger area plays event 14 only at status 1 and completes the mission. The Periqia entry permit
-- (a reward key item) is not used. Bullet 1 (get there) is a note with s2, bullet 4 (do not warp) a note with s3.
return {
    title = 'Prevalence of Pirates',
    completes = 's3',
    known = {{t = 'mission', line = 'toau', eq = 29}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'head to the cutter which is'}},
        {id = 's2', at = {n = 2, fp = 'there will be a cutscene when'},
         done = {
            {t = 'zonein', zone = 54, event = 13, why = "Arrapago Reef zone-in cutscene 13 (status 0 only, LandSandBoat)"},
         }},
        {id = 's3', at = {n = 3, fp = 'approach the cutter for another cutscene'},
         done = {
            {t = 'event', zone = 54, event = 14, why = "Cutter trigger area 14: completes the mission (status 1 only)"},
            {t = 'mission', line = 'toau', eq = 29, completed = true, why = "mission log: Prevalence of Pirates completed"},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'do not warp out the next'}},
    },
}

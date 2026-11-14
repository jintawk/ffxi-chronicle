-- Step progress for Social Graces (Treasures of Aht Urhgan, mission id 22). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/23_Social_Graces.lua: the Salaheem's Sentinels trigger area (Whitegate 50) plays event 3095,
-- which completes the mission.
return {
    title = 'Social Graces',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 22}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter salaheem s sentinels for a'},
         done = {
            {t = 'event', zone = 50, event = 3095, why = "Salaheem's Sentinels trigger area 3095: completes the mission"},
            {t = 'mission', line = 'toau', eq = 22, completed = true, why = "mission log: Social Graces completed"},
         }},
    },
}

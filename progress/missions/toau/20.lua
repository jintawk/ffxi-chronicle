-- Step progress for Finders Keepers (Treasures of Aht Urhgan, mission id 20). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/21_Finders_Keepers.lua: the Salaheem's Sentinels trigger area (Whitegate 50) plays event
-- 3093, which completes the mission. The draft made the only bullet a note on itself: it is the step.
return {
    title = 'Finders Keepers',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 20}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter salaheem s sentinels for a'},
         done = {
            {t = 'event', zone = 50, event = 3093, why = "Salaheem's Sentinels trigger area 3093: completes the mission"},
            {t = 'mission', line = 'toau', eq = 20, completed = true, why = "mission log: Finders Keepers completed"},
         }},
    },
}

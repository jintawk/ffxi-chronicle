-- Step progress for Ragnarok (Treasures of Aht Urhgan mission 45, mission id 44). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/toau/45_Ragnarok.lua; S4 pseudo-code 050_Salaheem_s_Sentinels_0103208B.txt lists 3139 (zone 50 =
-- Aht Urhgan Whitegate). The Whitegate trigger area plays event 3139 and its finish runs mission:complete, so the one bullet is proved by it.
-- The draft had a note only and no completion: fixed.
return {
    title = 'Ragnarok',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 44}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach naja salaheem for a cutscene'},
         done = {
            {t = 'event', zone = 50, event = 3139, why = 'Whitegate trigger area 3139: the cutscene, completes the mission'},
            {t = 'mission', line = 'toau', eq = 44, completed = true, why = 'mission log: Ragnarok completed'},
         }},
    },
}

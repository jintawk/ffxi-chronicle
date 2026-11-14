-- Step progress for Fangs of the Lion (Treasures of Aht Urhgan mission 43, mission id 42). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/toau/43_Fangs_of_the_Lion.lua; S4 pseudo-code 050_actor_01032112.txt lists 3138 (zone 50 = Aht
-- Urhgan Whitegate). The Whitegate trigger area plays event 3138 and its finish runs mission:complete, so the one bullet is proved by it.
-- The Mythril mirror reward key item is not used. The draft had a note only and no completion: fixed.
return {
    title = 'Fangs of the Lion',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 42}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach naja salaheem back in aht'},
         done = {
            {t = 'event', zone = 50, event = 3138, why = 'Whitegate trigger area 3138: the cutscene, completes the mission'},
            {t = 'mission', line = 'toau', eq = 42, completed = true, why = 'mission log: Fangs of the Lion completed'},
         }},
    },
}

-- Step progress for Astral Waves (Treasures of Aht Urhgan mission 10, mission id 9). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/10_Astral_Waves.lua. Naja Salaheem (Whitegate, zone 50) plays 3052 as a progress event
-- and its finish always completes the mission; there is no refusal.
return {
    title = 'Astral Waves',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 9}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to naja salaheem i 10'},
         done = {
            {t = 'event', zone = 50, event = 3052, why = 'Naja Salaheem 3052: the mission completes'},
            {t = 'mission', line = 'toau', eq = 9, completed = true, why = 'mission log: Astral Waves completed'},
         }},
    },
}

-- Step progress for The Dolphin Crest (Treasures of Aht Urhgan mission 14, mission id 13). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/14_The_Dolphin_Crest.lua. Naja Salaheem (Whitegate, zone 50) plays 3072 as a progress
-- event and its finish always completes the mission.
return {
    title = 'The Dolphin Crest',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 13}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to naja salaheem for a'},
         done = {
            {t = 'event', zone = 50, event = 3072, why = 'Naja Salaheem 3072: the mission completes'},
            {t = 'mission', line = 'toau', eq = 13, completed = true, why = 'mission log: The Dolphin Crest completed'},
         }},
    },
}

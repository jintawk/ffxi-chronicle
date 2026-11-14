-- Step progress for Easterly Winds (Treasures of Aht Urhgan mission 6, mission id 5). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/06_Easterly_Winds.lua. Ru'Lude Gardens (zone 243) trigger area 1 plays 10094 only for
-- this mission; the questions are inside it. A full inventory on the Imperial Bronze Pieces answer stops the completion, so the event
-- proves the cutscene (bullet 1) and only the mission line proves bullet 2. The bronze pieces (a reward item) are not used.
return {
    title = 'Easterly Winds',
    completes = 's2',
    known = {{t = 'mission', line = 'toau', eq = 5}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach the palace in ru lude'},
         done = {
            {t = 'event', zone = 243, event = 10094, why = "Ru'Lude Gardens trigger area 10094: the cutscene with the questions"},
         }},
        {id = 's2', at = {n = 2, fp = 'choose any of the answers to'},
         done = {
            {t = 'mission', line = 'toau', eq = 5, completed = true, why = 'mission log: Easterly Winds completed'},
         }},
    },
}

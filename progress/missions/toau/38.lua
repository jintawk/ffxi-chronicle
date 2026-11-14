-- Step progress for Allied Rumblings (Treasures of Aht Urhgan mission 39, mission id 38). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/toau/39_Allied_Rumblings.lua; zone 243 = Ru'Lude Gardens. The palace-door trigger area plays event
-- 10097 and its finish runs mission:complete (and sets the one-day wait the next mission asks for), so the one bullet is proved by it.
-- Naja's 3148 is a reminder shared by several missions and is not used. The draft had a note only and no completion: fixed.
return {
    title = 'Allied Rumblings',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 38}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to ru lude gardens and'},
         done = {
            {t = 'event', zone = 243, event = 10097, why = "Ru'Lude Gardens palace doors 10097: the cutscene, completes the mission (LandSandBoat)"},
            {t = 'mission', line = 'toau', eq = 38, completed = true, why = 'mission log: Allied Rumblings completed'},
         }},
    },
}

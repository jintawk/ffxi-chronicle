-- Step progress for Bastion of Knowledge (Treasures of Aht Urhgan, mission id 27). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/28_Bastion_of_Knowledge.lua: the Walahra Temple trigger area (Whitegate 50) plays event 3112,
-- which completes the mission.
return {
    title = 'Bastion of Knowledge',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 27}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter the walahra temple in aht'},
         done = {
            {t = 'event', zone = 50, event = 3112, why = "Walahra Temple trigger area 3112: completes the mission"},
            {t = 'mission', line = 'toau', eq = 27, completed = true, why = "mission log: Bastion of Knowledge completed"},
         }},
    },
}

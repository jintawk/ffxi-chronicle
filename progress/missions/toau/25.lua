-- Step progress for Seal of the Serpent (Treasures of Aht Urhgan, mission id 25). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/26_Seal_of_the_Serpent.lua: the Imperial Whitegate (Whitegate 50) plays 3111 and completes
-- the mission only with both weapon slots empty; with a weapon equipped it plays 3114 (a refusal, not used).
return {
    title = 'Seal of the Serpent',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 25}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'unequip your weapon and examine the'},
         done = {
            {t = 'event', zone = 50, event = 3111, why = "Imperial Whitegate 3111: completes the mission (unarmed only)"},
            {t = 'mission', line = 'toau', eq = 25, completed = true, why = "mission log: Seal of the Serpent completed"},
         }},
    },
}

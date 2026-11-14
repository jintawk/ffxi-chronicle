-- Step progress for Stirrings of War (Treasures of Aht Urhgan mission 38, mission id 37). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/toau/38_Stirrings_of_War.lua; zone 50 = Aht Urhgan Whitegate. The Shararat Teahouse trigger area
-- (area 5) plays event 3136 only once the day has turned and the player has zoned (the mission's Timer / mustZone check), and its finish
-- runs mission:complete, so the one bullet (wait, then the cutscene) is proved by it. Naja's 3134 is a reminder and the Allied Council
-- Summons reward key item is not used. The draft had a note only and no completion: fixed.
return {
    title = 'Stirrings of War',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 37}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'wait until the end of the'},
         done = {
            {t = 'event', zone = 50, event = 3136, why = 'Shararat Teahouse trigger area 3136: the cutscene, completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'toau', eq = 37, completed = true, why = 'mission log: Stirrings of War completed'},
         }},
    },
}

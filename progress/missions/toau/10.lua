-- Step progress for Imperial Schemes (Treasures of Aht Urhgan mission 11, mission id 10). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/11_Imperial_Schemes.lua. The Whitegate trigger area 6 (zone 50) plays 3070 only once a
-- Vana'diel day has passed and the player has zoned, and its finish always completes the mission. Naja's 3053 is a reminder dialogue
-- while the mission is current and proves nothing, so it is not used.
return {
    title = 'Imperial Schemes',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 10}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'wait a game day and zone'},
         done = {
            {t = 'event', zone = 50, event = 3070, why = 'Whitegate trigger area 6: event 3070, finish completes the mission'},
            {t = 'mission', line = 'toau', eq = 10, completed = true, why = 'mission log: Imperial Schemes completed'},
         }},
    },
}

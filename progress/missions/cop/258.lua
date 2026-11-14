-- Step progress for The Call of the Wyrmking (Chains of Promathia 3-1, mission id 258). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/3_1_The_Call_of_the_Wyrmking.lua; client script S4 237_Cid_010ED02B.txt (event 845 listed,
-- body empty). South Gustaberg (107) zone-in cutscene 906 plays at status 0 (the arrival after Ancient Vows); the Port Bastok departures
-- trigger area plays event 305 at status 1 (zone 236; LandSandBoat only); Cid 845 (Metalworks 237, status 2) completes the mission.
-- Bullet 1 only describes the arrival, so it is marked by the zone-in cutscene that plays on it.
return {
    title = 'Call of the Wyrmking',
    completes = 's3',
    known = {{t = 'mission', line = 'cop', eq = 258}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after the mammett fight you will'},
         done = {
            {t = 'zonein', zone = 107, event = 906, why = 'South Gustaberg zone-in cutscene 906 (status 0, LandSandBoat)'},
         }},
        {id = 's2', at = {n = 2, fp = 'make your way to the airship'},
         done = {
            {t = 'event', zone = 236, event = 305, why = 'Port Bastok departures trigger area 305 (status 1, LandSandBoat)'},
         }},
        {id = 's3', at = {n = 3, fp = 'go to the second floor of'},
         done = {
            {t = 'mission', line = 'cop', eq = 258, completed = true, why = 'mission log: The Call of the Wyrmking completed'},
            {t = 'event', zone = 237, event = 845, why = 'Cid 845: completes (status 2)'},
         }},
    },
}

-- Step progress for Flames in the Darkness (Chains of Promathia 7-2, mission id 718). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/7_2_Flames_in_the_Darkness.lua. Each bullet is one status: the Dilapidated Gate in
-- Misareaux Coast (25, event 12, status 0), Sueleen in Sealion's Den (32, event 16, status 1; the client body in
-- 032_Sueleen_010200A9.txt is empty, the id is in the NPC's event list), the Ru'Lude Gardens trigger area under the Palace (243,
-- event 10051, status 2) and the Marble Bridge Tavern door in Upper Jeuno (244, event 10012, status 3), which completes the mission.
-- There is no client text for any of them and the gate, palace and door events have no client script (LandSandBoat only). The draft
-- turned bullets 3 and 4 into notes on bullet 2 and left the completing step without a signal; each is a step of its own here.
return {
    title = 'Flames in the Darkness',
    completes = 's4',
    known = {{t = 'mission', line = 'cop', eq = 718}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'make your way toward the north'},
         done = {
            {t = 'event', zone = 25, event = 12, why = 'Dilapidated Gate 12 (status 0, LandSandBoat)'},
         }},
        {id = 's2', at = {n = 2, fp = 'return to sealion s den and'},
         done = {
            {t = 'event', zone = 32, event = 16, why = 'Sueleen 16 (status 1)'},
         }},
        {id = 's3', at = {n = 3, fp = 'travel to ru lude gardens and'},
         done = {
            {t = 'event', zone = 243, event = 10051, why = "Ru'Lude Gardens Palace trigger area 10051 (status 2, LandSandBoat)"},
         }},
        {id = 's4', at = {n = 4, fp = 'travel to upper jeuno and check'},
         done = {
            {t = 'mission', line = 'cop', eq = 718, completed = true, why = 'mission log: Flames in the Darkness completed'},
            {t = 'event', zone = 244, event = 10012, why = 'Marble Bridge Tavern door 10012 (status 3): completes'},
         }},
    },
}

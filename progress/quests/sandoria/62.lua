-- Step progress for Her Majesty's Garden (San d'Oria quest 62). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Her_Majestys_Garden.lua (Chalvatot 84 begins the quest on option 1; 82 is the
-- accepted-state talk; 83 is the trade of a Chunk of Derfland Humus and its finish completes the quest; the reward is a
-- key item and fame, so 83 cannot be refused by a full bag); client event script S4 233_Chalvatot_010E900E.txt (84 say
-- #7417 is the accept branch; 82 say #7390; 83 say #7419).
return {
    title = "Her Majesty's Garden",
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to chalvatot to begin this'},
         done = {
            {t = 'chat', re = "Ah, now that's the answer I was expectin'%.", why = 'Chalvatot 84 (say #7417, accept branch)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 233, event = 82, conf = 'inferred', why = 'Chalvatot 82: plays only once accepted'},
            {t = 'chat', re = 'Ah, almost forgot%. You can find', conf = 'inferred', why = 'Chalvatot 82 (say #7390)'},
         },
         reach = {{t = 'event', zone = 233, event = 84, why = 'Chalvatot 84 offered (accepting needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade chalvatot a derfland humus to'},
         done = {
            {t = 'event', zone = 233, event = 83, why = 'Chalvatot 83: the trade'},
            {t = 'chat', re = 'Ah, thanks be to you%. This will keep me flowers perky for weeks, it will%.', why = 'Chalvatot 83 (say #7419)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

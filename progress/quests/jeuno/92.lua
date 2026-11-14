-- Step progress for Chocobo on the Loose! (Jeuno quest 92). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Chocobo_on_the_Loose.lua (Brutus 10093 begins the quest with no refusal; the
-- Chocobo Tracks in La Theine Plateau play 209 at Prog 0; Brutus 10095 at Prog 1; Hantileon 821 at Prog 2, 822 is his
-- reminder at Prog 3; Brutus 10100 at Prog 3 sets the one day wait; 10109 completes the quest after the wait but only if the
-- Chocobo Egg could be given, so it is only a reach and the completed bit carries the last bullet; 10094 and 10099 are his
-- reminders at Prog 0 and 2); client event scripts S4 102_Chocobo_Tracks_0106629F.txt (209) and 230_Hantileon_010E6112.txt
-- (822 say #10542). Zone ids from res/zones.lua (102 La Theine Plateau, 230 Southern San d'Oria, 244 Upper Jeuno). Item 2312
-- is the reward Chocobo Egg (LandSandBoat's item enum), which can also be bought, so only supporting and counted only after s5. The quest log is set
-- at s1, so it is not silent. Not repeatable (page meta).
return {
    title = 'Chocobo on the Loose!',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to upper jeuno and speak to'},
         done = {
            {t = 'event', zone = 244, event = 10093, why = 'Brutus 10093: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 244, event = 10094, conf = 'inferred', why = 'Brutus 10094: reminder at Prog 0, only while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to la theine plateau and check'},
         done = {
            {t = 'event', zone = 102, event = 209, why = 'Chocobo Tracks 209 (Prog 0)'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to upper jeuno and speak to'},
         done = {
            {t = 'event', zone = 244, event = 10095, why = 'Brutus 10095 (Prog 1)'},
            {t = 'event', zone = 244, event = 10099, conf = 'inferred', why = 'Brutus 10099: reminder at Prog 2'},
         }},
        {id = 's4', at = {n = 4, fp = 'head to southern san d oria and'},
         done = {
            {t = 'event', zone = 230, event = 821, why = 'Hantileon 821 (Prog 2)'},
            {t = 'event', zone = 230, event = 822, conf = 'inferred', why = 'Hantileon 822: reminder at Prog 3'},
            {t = 'chat', re = 'Please make your way to the chocobo stables in Jeuno%.', conf = 'inferred', why = 'Hantileon 822 (say #10542)'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to brutus g 7 in upper'},
         done = {
            {t = 'event', zone = 244, event = 10100, why = 'Brutus 10100 (Prog 3): the day wait begins'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to brutus g 7 after one'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 2312, gained = true, after = 's5', conf = 'inferred', why = 'Chocobo Egg obtained (reward)'},
         },
         reach = {{t = 'event', zone = 244, event = 10109, why = 'Brutus 10109 (completes only if the egg could be given)'}}},
    },
}

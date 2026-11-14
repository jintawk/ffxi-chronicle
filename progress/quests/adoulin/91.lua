-- Step progress for The Longest Way Round... (Adoulin quest 91). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/The_Longest_Way_Round.lua (Vastran in Eastern Adoulin: 2510 begins the quest
-- and gives the Eastern Adoulin patrol route, no refusal; while accepted a plain talk is 2511; the seven patrol NPCs each play
-- 2513 + offset only when the quest's Prog equals their place in the order: Fostaig 2513, Lamaron 2514, Irate Destrier 2515,
-- Nhili Uvolep 2516, Ploh Trishbahk 2517, Cunegonde 2518, Ndah Tolohjin 2519 (the last, so only reached when the six before
-- were done); Vastran 2512 plays only at Prog 7, runs quest:complete and takes the route; the reward is bayld and
-- experience, so no refusal). Client event script S4 257_Vastran_011010CE.txt (2510 say #7880, 2512 say #7923); the patrol NPCs
-- have no client script, and LandSandBoat computes 2513 to 2519 as 2513 + offset, so check_steps cannot find a literal id. The
-- bullet "speak to the following in order" therefore stays a note on the return step: its eight sub-bullets are not steps,
-- and the patrol talks are the only signals of it. Key item 2276 from res/key_items.lua. Not repeatable.
return {
    title = 'The Longest Way Round...',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to vastran at f 8'},
         done = {
            {t = 'event', zone = 257, event = 2510, why = 'Vastran 2510: the first talk, begins the quest'},
            {t = 'chat', re = "Hey, aren't you one of those pioneers from Jeuno%?", why = 'Vastran 2510 (say #7880)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 2276, gained = true, why = 'Eastern Adoulin patrol route obtained'},
            {t = 'ki_have', id = 2276, have = true, why = 'Eastern Adoulin patrol route held'},
            {t = 'chat', re = 'obtained key item: eastern adoulin patrol route', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak to the following in order'}},
        {id = 's3', at = {n = 3, fp = 'return to vastran for your reward'},
         done = {
            {t = 'event', zone = 257, event = 2512, why = 'Vastran 2512: only at Prog 7, runs quest:complete'},
            {t = 'chat', re = "How was it%? Eastern Adoulin sure has a lot to offer, don't you think%?", why = 'Vastran 2512 (say #7923)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 2276, gained = false, why = 'Eastern Adoulin patrol route handed over'},
         }},
    },
}

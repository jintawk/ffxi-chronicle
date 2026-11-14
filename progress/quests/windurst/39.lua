-- Step progress for Creepy Crawlies (Windurst quest 39). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Illu_Bohjaa.lua (333 is the offer and only option 1 "Yup!" adds
-- the quest; 334 is her talk once the quest is not available, so it proves the offer was taken; a trade of 3 Silk Thread or
-- 3 Crawler Calculus is event 335, which completes the quest, pays 600 gil and gives the title, with no item reward, and plays
-- whenever the quest is not still available, so a repeat needs no new talk); client event script S4 241_Illu_Bohjaa_010F1080.txt
-- (333 menu #8247, 334 say #8250, 335 say #8252). The quest log bits mark the first run only (retail keeps the current bit), so
-- a trade after a finished run opens the next one and the talk is skipped (the Siren's Tear pattern). The two indented
-- sub-bullets (the "Yup!" reminder and where to find the items) are not steps.
return {
    title = 'Creepy Crawlies',
    completes = 's2',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s2'}, skip = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to illu bohjaa to begin'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 241, event = 334, conf = 'inferred', why = 'Illu Bohjaa 334: talk once the quest is not available'},
            {t = 'chat', re = 'Them crawlers are out of control, and', conf = 'inferred', why = 'Illu Bohjaa 334 (say #8250)'},
         },
         reach = {{t = 'event', zone = 241, event = 333, why = 'Illu Bohjaa 333 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade illu bohjaa either 3x silk'},
         done = {
            {t = 'event', zone = 241, event = 335, why = 'Illu Bohjaa 335: the items accepted'},
            {t = 'chat', re = 'Why, thankee you, pardnerrr!', why = 'Illu Bohjaa 335 (say #8252)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
    },
}

-- Step progress for Mean Machine (Bastok quest 25). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Mean_Machine.lua (Unlucky Rat 556 begins it at Bastok fame 2; 559 is his talk
-- while accepted; trading one Vial of Slime Oil is event 557, which runs quest:complete and gives the Scroll of Warp); client
-- event script S4 237_Unlucky_Rat_010ED03B.txt (556 say #7898, 559 say #8139, 557 say #7900 with a placeholder). The draft put
-- 559, the reminder talk, on the trade step; it only follows the accept and supports s1. Full-inventory rule: 557 plays the
-- same with a full bag (the Scroll may not fit), so it is `reach` only and the quest log proves s2. The quest log is set at
-- s1, so it is not silent.
return {
    title = 'Mean Machine',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to unlucky rat located on'},
         done = {
            {t = 'event', zone = 237, event = 556, why = 'Unlucky Rat 556'},
            {t = 'chat', re = "Hmm%.%.%.this machine's been acting up lately%.", why = 'Unlucky Rat 556 (say #7898)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 237, event = 559, conf = 'inferred', why = 'Unlucky Rat 559: his talk while accepted'},
            {t = 'chat', re = "I've heard an adventurer say that there were these oily monsters in Beadeaux sometimes%.", conf = 'inferred', why = 'Unlucky Rat 559 (say #8139)'},
         }},
        {id = 's2', at = {n = 2, fp = 'although he doesn t ask for'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 237, event = 557, why = 'Unlucky Rat 557: the Slime Oil trade (also plays with a full bag)'}}},
    },
}

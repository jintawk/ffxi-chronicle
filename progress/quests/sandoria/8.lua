-- Step progress for The Sweetest Things (San d'Oria quest 8). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Sweetest_Things.lua (Raimbroy 532 is the first talk and only sets a
-- variable; 533 or 534 begin the quest on the accept answer, a refusal plays the same event; 536 is his reminder while
-- accepted; trading exactly 5 Pots of Honey is event 535, which runs quest:complete and pays 400 gil; 537 plays once it is
-- completed); client event script S4 230_Raimbroy_010E6012.txt (accept branch say #7878, 537 say #7880).
-- Event 535 has no decoded client script, so it rests on LandSandBoat and the quest log. The draft made bullet 2 a note and
-- completed the quest at bullet 1; the trade is the completing event, so it is a step. The quest is repeatable, but a repeat
-- needs no new accept (the trade alone, same event 535 as the first run), so there is no `repeatable` entry. The quest log
-- is set at the accept.
return {
    title = 'The Sweetest Things',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with raimbroy twice to begin'},
         done = {
            {t = 'chat', re = "Well, thanks be to you! I'll need five", why = 'Raimbroy 533/534, accepted (say #7878)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 230, event = 536, conf = 'inferred', why = 'Raimbroy 536: reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 230, event = 532, why = 'Raimbroy 532: the first talk'},
                  {t = 'event', zone = 230, event = 533, why = 'Raimbroy 533 offered (its finish needs option 0)'},
                  {t = 'event', zone = 230, event = 534, why = 'Raimbroy 534 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'obtain 5 pots of honey and'},
         done = {
            {t = 'event', zone = 230, event = 535, why = 'Raimbroy 535: 5 Pots of Honey accepted, completes the quest'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 230, event = 537, conf = 'inferred', why = 'Raimbroy 537: plays only once the quest is completed'},
            {t = 'chat', re = 'Hrmm%.%.%. Still not enough, eh%?', conf = 'inferred', why = 'Raimbroy 537 (say #7880)'},
         }},
    },
}

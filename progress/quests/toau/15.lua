-- Step progress for Cook-a-roon? (Aht Urhgan quest 15). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Cook-a-roon.lua (Ququroon 241 is the offer and only option 1 begins the
-- quest, so 241 is a reach; while accepted his talk is 242; trading exactly the five fish plays 243, which runs quest:complete
-- (no reward item, so it never replays on a full bag) and, on a roll of 2, hands over a Bowl of Nashmau Stew; once completed his
-- talk is 244 and the same trade plays 243 again, which is how a repeat shows: it opens the next run).
-- Client event script S4 053_Ququroon_0103504E.txt (242 say #10629, 244 say #10618); 241 and 243 have no text. The log's
-- accepted and completed bits count for the first run only (run1), as the repeat never touches the log. The stew is a reward
-- item and not used; the notes after the trade (stew failure, repeat timer, Rat Race) hang on it. Repeatable once a real-life
-- minute (page meta).
return {
    title = 'Cook-a-roon?',
    completes = 's1',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'trade ququroon all of the fish'},
         done = {
            {t = 'event', zone = 53, event = 243, why = 'Ququroon 243: the five fish accepted, runs quest:complete'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         },
         reach = {
            {t = 'event', zone = 53, event = 241, why = 'Ququroon 241 offered (its finish needs option 1)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 53, event = 242, run1 = true, why = 'Ququroon 242: his talk while accepted'},
            {t = 'chat', re = 'Ququroon need', run1 = true, why = 'Ququroon 242 (say #10629)'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'there is a small chance that'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'this quest is repeatable once every'}},
        {id = 's4', kind = 'note', with = 's1', at = {n = 4, fp = 'this quest must be completed during'}},
        {id = 's5', kind = 'note', with = 's1', at = {n = 5, fp = 'if you complete this quest prior'}},
    },
}

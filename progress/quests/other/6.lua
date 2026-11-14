-- Step progress for The Basics (quest other 6). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/RQ7_The_Basics.lua (Rycharde 94 is the offer and its menu loops until
-- Yes, but it is still an offer, so a reach; accepting gives the Mhauran couscous (key item 92) and runs quest:begin; the
-- "All right! Go to the port" line is shared with His Name Is Valgeir, and Take 66 and Valgeir 144 play for anyone who has
-- not accepted yet, so none is used; accepted, Valgeir 106 (Prog 0) takes the couscous and gives the Baked Popoto, 145 is
-- his talk afterwards; Rycharde 95 is his talk until the popoto is traded, 96 takes exactly one Baked Popoto at Prog 1
-- and runs quest:complete, but the Tea Set reward needs a free slot and the same event plays without one, so 96 is only a
-- reach and the log bit proves the step; after completion Valgeir 107 and Rycharde 97 are one-time commentary, 98 and 146 the defaults).
-- The draft made the Valgeir bullet a note and put his events on the Rycharde bullet; Valgeir 106 is a real step.
-- Client event scripts S4 249_Rycharde_010F9009.txt (94 say #6949, 95 say #6951, 96 say #6952, 97 say #6954),
-- 248_Valgeir_010F800B.txt (106 say #6940, 107 say #6948, 145 say #6954). Not repeatable.
return {
    title = 'The Basics',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you need to wait 8 real'}},
        {id = 's2', at = {n = 2, fp = 'speak to rycharde who asks you'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 92, gained = true, why = 'Mhauran couscous obtained'},
            {t = 'ki_have', id = 92, have = true, why = 'Mhauran couscous held'},
            {t = 'chat', re = 'obtained key item: mhauran couscous', why = 'chat: key item obtained'},
            {t = 'event', zone = 249, event = 95, conf = 'inferred', why = 'Rycharde 95: his talk, only while accepted'},
            {t = 'chat', re = "I'm sure this time he'll be surprised", conf = 'inferred', why = 'Rycharde 95 (say #6951)'},
         },
         reach = {{t = 'event', zone = 249, event = 94, why = 'Rycharde 94 offered (its finish needs option 85)'}}},
        {id = 's3', at = {n = 3, fp = 'speak to valgeir in selbina he'},
         done = {
            {t = 'event', zone = 248, event = 106, why = 'Valgeir 106: takes the couscous, gives the Baked Popoto'},
            {t = 'chat', re = "What, you again%? Well, I'm not about to chastise you%.", why = 'Valgeir 106 (say #6940)'},
            {t = 'ki', id = 92, gained = false, why = 'Mhauran couscous handed over'},
            {t = 'event', zone = 248, event = 145, conf = 'inferred', why = 'Valgeir 145: his talk after 106'},
            {t = 'chat', re = 'Cooking is a complex art, but the basics are as clear as day%.', conf = 'inferred', why = 'Valgeir 145 (say #6954)'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to rycharde and trade him'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 249, event = 96, why = 'Rycharde 96: the Baked Popoto trade (also plays with no room for the Tea Set)'},
            {t = 'chat', re = 'Hmm%? He sent you back to give this to me%?', why = 'Rycharde 96 (say #6952)'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'you will receive a tea set'}},
        {id = 's6', kind = 'optional', at = {n = 6, fp = 'optional speak to valgeir in selbina'},
         done = {
            {t = 'event', zone = 248, event = 107, why = 'Valgeir 107: one-time commentary after completion'},
            {t = 'chat', re = 'Back when I started teaching him how to cook', why = 'Valgeir 107 (say #6948)'},
         }},
        {id = 's7', kind = 'optional', at = {n = 7, fp = 'optional speak to rycharde one last'},
         done = {
            {t = 'event', zone = 249, event = 97, why = 'Rycharde 97: one-time commentary after completion'},
            {t = 'chat', re = 'Hi again%. Thanks for last time!', why = 'Rycharde 97 (say #6954)'},
         }},
    },
}

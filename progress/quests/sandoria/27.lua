-- Step progress for A Purchase of Arms (San d'Oria quest 27). Data only: which observation proves which step bullet of
-- pages/quests/sandoria/27.lua. A step is addressed by its ordinal among the walkthrough's top-level bullets (`n`) and
-- the start of its folded text (`fp`); if the page no longer matches, the step is not marked.
-- Evidence: LandSandBoat scripts/quests/sandoria/A_Purchase_of_Arms.lua (594 gives Weapons order 97 on accept; Alexius 5
-- swaps it for Weapons receipt 98; 607 completes and takes the receipt); client event scripts S4
-- 230_Helbort_010E6039.txt (594: P0 = 97, P1 = 98, say #8013 on accept; 607: say #8019) and 104_Alexius_01068265.txt
-- (5: say #7911); key item ids from res/key_items.lua.
return {
    title = 'A Purchase of Arms',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to helbort in southern'},
         done = {
            {t = 'ki', id = 97, gained = true, why = 'Weapons order obtained'},
            {t = 'ki_have', id = 97, have = true, why = 'Weapons order held'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'chat', re = "Then you'll do it%? Much obliged!", why = 'Helbort 594, accepted (say #8013)'},
            {t = 'chat', re = 'obtained key item: weapons order', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 230, event = 594, why = 'Helbort 594 offered'}}},
        {id = 's2', at = {n = 2, fp = 'bring the weapons order to alexius'},
         done = {
            {t = 'ki', id = 98, gained = true, why = 'Weapons receipt obtained'},
            {t = 'ki_have', id = 98, have = true, why = 'Weapons receipt held'},
            {t = 'event', zone = 104, event = 5, why = 'Alexius 5'},
            {t = 'chat', re = "An order for weapons%? Well, that's my business%.", why = 'Alexius 5 (say #7911)'},
            {t = 'chat', re = 'obtained key item: weapons receipt', why = 'chat: key item obtained'},
            {t = 'ki', id = 97, gained = false, conf = 'inferred', why = 'Weapons order handed over'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to helbort to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 230, event = 607, why = 'Helbort 607'},
            {t = 'chat', re = "You've returned, and with the receipt!", why = 'Helbort 607 (say #8019)'},
         }},
    },
}

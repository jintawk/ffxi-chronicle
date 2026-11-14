-- Step progress for The Trader in the Forest (San d'Oria quest 7). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Trader_in_the_Forest.lua (Abeaule 524/592 begin the quest only on the
-- accept answer, a refusal plays the same event; 593 is his reminder while accepted; Phairet 124 takes the Supplies Order and
-- hands out the batagreens, 125 is the wrong-trade refusal, 127 plays only once the order was traded; Abeaule 525 takes the
-- batagreens and runs quest:complete); client event scripts S4 231_Abeaule_010E7048.txt (524/592 accept branch say #11250,
-- 525 say #11258) and 100_Phairet_010642B0.txt (124 say #7427, 127 say #7430); item ids from res/items.lua. The quest log is
-- set at s1.
-- Full-inventory rule (coordinator, 2026-10-28): an event whose finish can fail on a full bag (giveItem or a reward item)
-- plays the same either way, so it and its lines are `reach` only; the quest log or a success-only signal proves the step.
-- Shared-signal audit (2026-10-28): dropped item 4367 (Batagreens are sold by guild shops and grown in the Mog Garden); s2 keeps Phairet 127 (inferred).
return {
    title = 'The Trader in the Forest',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'start this quest by speaking to'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'item', id = 592, gained = true, conf = 'inferred', why = 'Supplies Order gained (items can come from elsewhere)'},
            {t = 'event', zone = 231, event = 593, conf = 'inferred', why = 'Abeaule 593: reminder, only while accepted'},
         },
         reach = {{t = 'chat', re = "We always pay after delivery, so you needn't give him any money!", why = 'Abeaule 524/592, accept answer (the order may not fit)'},
                  {t = 'event', zone = 231, event = 524, why = 'Abeaule 524 offered (its finish needs option 0)'},
                  {t = 'event', zone = 231, event = 592, why = 'Abeaule 592 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'take the supplies order to the'},
         done = {
            {t = 'event', zone = 100, event = 127, conf = 'inferred', why = 'Phairet 127: plays only once the order was traded'},
         },
         reach = {{t = 'event', zone = 100, event = 124, why = 'Phairet 124: the Supplies Order (the batagreens may not fit)'},
                  {t = 'chat', re = "Oh, a customer sent you%? Well, why didn't you say so!", why = 'Phairet 124 (say #7427)'}}},
        {id = 's3', at = {n = 3, fp = 'take the batagreens back to abeaule'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 231, event = 525, why = 'Abeaule 525: the batagreens (the reward may not fit)'},
                  {t = 'chat', re = 'Here, this is yours for your trouble%.', why = 'Abeaule 525 (say #11258)'}}},
    },
}

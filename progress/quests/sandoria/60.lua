-- Step progress for The General's Secret (San d'Oria quest 60). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Generals_Secret.lua (Curilla 55 begins the quest on option 1 and gives
-- the empty Curilla's bottle 164; the Hot Springs on Horlais Peak swap it for the full one 165; Curilla 54 needs the full
-- bottle, takes it and completes the quest, but the reward is an item (Lynx Baghnakhs): with no free slot 54 plays and the
-- quest is NOT completed, so 54 and its line are only `reach`); client event script S4 233_Curilla_010E900C.txt
-- (55 say #7397 is the accept branch; 53 say #7386 is the accepted-state talk; 54 say #7400). res/key_items.lua names both
-- bottles "Curilla's bottle", so no key item chat pattern is used. The two travel bullets: the first a note on the springs.
return {
    title = "The General's Secret",
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to curilla and agree to'},
         done = {
            {t = 'chat', re = 'Then, good luck! Use this to draw water from the spring atop Horlais Peak%.', why = 'Curilla 55 (say #7397, accept branch)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 164, gained = true, why = "empty Curilla's bottle obtained"},
            {t = 'event', zone = 233, event = 53, conf = 'inferred', why = 'Curilla 53: plays only once accepted'},
            {t = 'chat', re = 'Listen, I want you to bring me water that flows from Horlais Peak%.', conf = 'inferred', why = 'Curilla 53 (say #7386)'},
         },
         reach = {{t = 'event', zone = 233, event = 55, why = 'Curilla 55 offered (accepting needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to horlais peak by going'}},
        {id = 's3', at = {n = 3, fp = 'once in horlais peak head to'},
         done = {
            {t = 'ki', id = 165, gained = true, why = "full Curilla's bottle obtained at the Hot Springs"},
            {t = 'ki_have', id = 165, have = true, why = "full Curilla's bottle held"},
         }},
        {id = 's4', at = {n = 4, fp = 'return to curilla for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 165, gained = false, conf = 'inferred', why = "full Curilla's bottle handed over"},
            {t = 'item', id = 16409, gained = true, conf = 'inferred', why = 'Lynx Baghnakhs gained (reward)'},
         },
         reach = {{t = 'event', zone = 233, event = 54, why = 'Curilla 54: the hand-in (a full bag plays it too, no completion)'}}},
    },
}

-- Step progress for Past Perfect (Bastok quest 23). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Past_Perfect.lua (Evi's first talk is event 21 and only sets a variable; his
-- second talk is 130 and begins the quest; the Konschtat ??? gives key item 109; Evi 131 runs quest:complete, which also gives
-- the Scale Mail, and only then takes the orders; 104 is his talk while accepted) and zones/Port_Bastok/DefaultActions.lua
-- (event 21 is Evi's default line for everyone, Rafaela's is 22); client event script S4 236_Evi_010EC01F.txt (130 say #7563,
-- 104 say #7459, 131 say #7568); key item 109 from res/key_items.lua. The draft put event 104 on the first bullet; it is the
-- accepted-state talk (bullet 3), and 21 plays for anyone, so bullet 1 (the first talk) and bullet 2 (Rafaela, no quest
-- event) have no signal and stay plain bullets. Bullet 4 (travel and find the ???) is a note on the orders, bullet 5.
-- Full-inventory rule: 131 plays the same with a full bag, so it is `reach` only; the quest log and the loss of the orders
-- (taken only after the completion succeeded) prove s6. The quest log is set at s3.
return {
    title = 'Past Perfect',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's3', at = {n = 3, fp = 'speak with evi again'},
         done = {
            {t = 'event', zone = 236, event = 130, why = 'Evi 130'},
            {t = 'chat', re = 'I must ask you to do something for me%.', why = 'Evi 130 (say #7563)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 236, event = 104, conf = 'inferred', why = 'Evi 104: his talk while accepted'},
            {t = 'chat', re = "I am from San d'Oria%. Have you ever gone there%?", conf = 'inferred', why = 'Evi 104 (say #7459)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'travel to konschtat highlands and look'}},
        {id = 's5', at = {n = 5, fp = 'touch the to receive a temporary'},
         done = {
            {t = 'ki', id = 109, gained = true, why = 'tattered mission orders obtained'},
            {t = 'ki_have', id = 109, have = true, why = 'tattered mission orders held'},
            {t = 'chat', re = 'obtained key item: tattered mission orders', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to evi speak with him'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 109, gained = false, why = 'tattered mission orders handed over (taken only after the completion succeeded)'},
         },
         reach = {
            {t = 'event', zone = 236, event = 131, why = 'Evi 131 (also plays with a full bag, the Scale Mail may not fit)'},
            {t = 'chat', re = 'Yes, this is it%. Finally, I may start anew%.', why = 'Evi 131 (say #7568)'},
         }},
    },
}

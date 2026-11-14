-- Step progress for Gates to Paradise (San d'Oria quest 18). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Northern_San_dOria/npcs/Olbergieut.lua (619 on option 0 adds the quest and gives the
-- Scripture of Wind, key item 151; 620 plays whenever the Scripture of Water is held and completes the quest) and
-- zones/La_Theine_Plateau/npcs/Faurbellant.lua (a plain talk, no event, that swaps the Scripture of Wind for the Scripture of
-- Water, key item 150); client event script S4 231_Olbergieut_010E701A.txt (619 accept branch say #11312, 620 say #11314);
-- key item ids from res/key_items.lua. The key items are quest items, handed out and taken within the quest, so they are
-- real markers. Bullet 2 is a travel note on the Faurbellant talk. The quest log is set at the accept.
-- Full-inventory rule (coordinator, 2026-10-28): an event whose finish can fail on a full bag (giveItem or a reward item)
-- plays the same either way, so it and its lines are `reach` only; the quest log or a success-only signal proves the step.
-- Shared-signal audit (2026-10-28): dropped item 13584 (Cotton Cape is sold by guild shops); the completed bit and the 620 reach stay.
return {
    title = 'Gates to Paradise',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with olbergieut to begin quest'},
         done = {
            {t = 'ki', id = 151, gained = true, why = 'Scripture of Wind obtained'},
            {t = 'chat', re = 'Great is the generosity in your heart!', why = 'Olbergieut 619, accepted (say #11312)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki_have', id = 151, have = true, why = 'Scripture of Wind held'},
            {t = 'chat', re = 'obtained key item: scripture of wind', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 231, event = 619, why = 'Olbergieut 619 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to k 8 in la'}},
        {id = 's3', at = {n = 3, fp = 'speak to faubellant and he will'},
         done = {
            {t = 'ki', id = 150, gained = true, why = 'Scripture of Water obtained'},
            {t = 'ki_have', id = 150, have = true, why = 'Scripture of Water held'},
            {t = 'chat', re = 'obtained key item: scripture of water', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to olbergieut and speak with'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 150, gained = false, conf = 'inferred', why = 'Scripture of Water handed over (only after the cape was given)'},
         },
         reach = {{t = 'event', zone = 231, event = 620, why = 'Olbergieut 620 (the Cotton Cape may not fit)'},
                  {t = 'chat', re = 'Gracious are we for your service%.', why = 'Olbergieut 620 (say #11314)'}}},
    },
}

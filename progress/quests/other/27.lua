-- Step progress for Trial by Lightning (other areas quest 27). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Mhaura/npcs/Ripapa.lua (event 10016 is the offer, and on option 1 adds the quest and gives
-- the Tuning Fork of Lightning, key item 333; 10024 re-gives a lost fork and 10017 is her reminder, both only while accepted;
-- 10019 is the reward menu with the Whisper of Storms, key item 325, and its finish runs completeQuest and takes the whisper
-- only when a bag slot is free, so the event itself also plays on a full bag and proves nothing); the Whisper of Storms comes
-- from winning the Ramuh Prime battlefield. The client's Ripapa script holds no text for these events (10016 there is the
-- Trial-Size dialogue shared with Carbuncle Debacle), so chat lines are the key item lines. The travel and fight rules are
-- notes. Repeatable (once per Earth day): the log marks the first run only (run1), as for Bastok quest 0.
return {
    title = 'Trial by Lightning',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with ripapa to obtain the'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (Ripapa 10016, option 1; first run only)'},
            {t = 'ki', id = 333, gained = true, why = 'tuning fork of lightning obtained'},
            {t = 'chat', re = 'obtained key item: tuning fork of lightning', why = 'chat: key item obtained'},
            {t = 'event', zone = 249, event = 10024, conf = 'inferred', why = 'Ripapa 10024: a lost fork replaced, only while accepted'},
            {t = 'event', zone = 249, event = 10017, conf = 'inferred', why = 'Ripapa 10017: reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 249, event = 10016, why = 'Ripapa 10016 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to the sanctuary of zi'}},
        {id = 's3', at = {n = 3, fp = 'defeat ramuh prime and you will'},
         done = {
            {t = 'ki', id = 325, gained = true, why = 'whisper of storms obtained (battle won)'},
            {t = 'chat', re = 'obtained key item: whisper of storms', why = 'chat: key item obtained'},
            {t = 'ki_have', id = 325, have = true, conf = 'inferred', why = 'whisper of storms held'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to ripapa with the whisper'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 325, gained = false, why = 'whisper of storms handed over (reward taken)'},
         }},
    },
}

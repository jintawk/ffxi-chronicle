-- Step progress for Trial by Earth (Bastok quest 61). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Trial_by_Earth.lua (Juroro 249 offers the quest, option 1 gives the Tuning fork
-- of earth 329 and begins it; 284 re-gives a lost fork and 250 is the accepted-state talk; 252 is the reward menu: a full bag
-- plays it and the quest is NOT completed, so 252 is never proof, the quest log is; the Cloister of Tremors win gives the
-- Whisper of tremors 321 and takes the fork); client event script S4 236_Juroro_010EC088.txt (249 accept branch say #8546,
-- 284 say #8638); key items from res/key_items.lua. The draft's reward line (#8554) sits in branches of the reward menu that
-- cannot be told apart, so it is dropped. Same shape as Trial by Ice (San d'Oria quest 59). Repeatable once per Earth day: the
-- fork may stay held after a finish, so its login snapshot is run 1 only (run1) and the restart is the next acceptance.
-- Bullets 5 to 11 are tips.
-- Shared-signal audit: Juroro's two accept lines ("only a person who carries one", "careful-wareful") also play for Trial by Ice, Wind, Fire,
-- Thunder and Water (sandoria/59, windurst/9 and others): dropped (s1 has no earlier step); the log bit, key item 329 and events 249, 250 and 284 stay.
-- Whisper of tremors (321) is also taken by The Moonlit Path (windurst/9): gain and line gated after s1, its loss gated after s3; ki_have 321 dropped.
return {
    title = 'Trial by Earth',
    completes = 's4',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with juroro to obtain the'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
            {t = 'ki', id = 329, gained = true, why = 'tuning fork of earth obtained'},
            {t = 'ki_have', id = 329, have = true, run1 = true, why = 'tuning fork of earth held (may stay held after a finish)'},
            {t = 'chat', re = 'obtained key item: tuning fork of earth', why = 'chat: key item obtained'},
            {t = 'event', zone = 236, event = 284, conf = 'inferred', why = 'Juroro 284: a new fork, only once accepted'},
            {t = 'event', zone = 236, event = 250, conf = 'inferred', why = 'Juroro 250: accepted-state talk'},
         },
         reach = {{t = 'event', zone = 236, event = 249, why = 'Juroro 249 offered (accepting needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to eastern altepa desert and'}},
        {id = 's3', at = {n = 3, fp = 'defeat titan prime and you will'},
         done = {
            {t = 'ki', id = 321, gained = true, after = 's1', why = 'whisper of tremors obtained'},
            {t = 'chat', re = 'obtained key item: whisper of tremors', after = 's1', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to juroro with the whisper'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 321, gained = false, conf = 'inferred', after = 's3', why = 'whisper of tremors handed over'},
         },
         reach = {{t = 'event', zone = 236, event = 252, why = 'Juroro 252: the reward menu (a full bag plays it too, no completion)'}}},
    },
}

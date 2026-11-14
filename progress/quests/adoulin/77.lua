-- Step progress for The Old Man and the Harpoon (Adoulin quest 77). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat zones/Western_Adoulin/npcs/Jorin.lua (2540 begins the quest and gives the Broken harpoon, no refusal;
-- 2541 the talk while accepted; 2542 once the Extravagant harpoon is held runs completeQuest and takes it) and Shipilolo.lua
-- (2543 only while accepted and holding the Broken harpoon: takes it, gives the Extravagant harpoon). Client event scripts S4
-- 256_Jorin_01100126.txt (2540 say #7927, 2541 say #7934, 2542 say #7947) and 256_Shipilolo_0110010C.txt (2543 say #7935).
-- The reward is bayld and experience, so 2542 has no refusal. Not repeatable.
return {
    title = 'The Old Man and the Harpoon',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with jorin in western adoulin'},
         done = {
            {t = 'event', zone = 256, event = 2540, why = 'Jorin 2540: the first talk, begins the quest'},
            {t = 'chat', re = "Damn it! Why's it gotta be now, of all times!%?", why = 'Jorin 2540 (say #7927)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 2192, gained = true, why = 'broken harpoon obtained'},
            {t = 'ki_have', id = 2192, have = true, why = 'broken harpoon held'},
            {t = 'chat', re = 'obtained key item: broken harpoon', why = 'chat: key item obtained'},
            {t = 'event', zone = 256, event = 2541, conf = 'inferred', why = 'Jorin 2541: plays only while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak with shipilolo at j 9'},
         done = {
            {t = 'event', zone = 256, event = 2543, why = 'Shipilolo 2543: only while accepted and holding the Broken harpoon'},
            {t = 'chat', re = "If you're here seeking the brightaruest minds in all of Adoulin, then you're in luck!", why = 'Shipilolo 2543 (say #7935)'},
            {t = 'ki', id = 2193, gained = true, why = 'extravagant harpoon obtained'},
            {t = 'ki_have', id = 2193, have = true, why = 'extravagant harpoon held'},
            {t = 'chat', re = 'obtained key item: extravagant harpoon', why = 'chat: key item obtained'},
            {t = 'ki', id = 2192, gained = false, why = 'broken harpoon handed over'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to jorin to complete the'},
         done = {
            {t = 'event', zone = 256, event = 2542, why = 'Jorin 2542: the Extravagant harpoon held, runs completeQuest'},
            {t = 'chat', re = "I see the Inventors' Coalition done lived up to their reputation once again!", why = 'Jorin 2542 (say #7947)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 2193, gained = false, why = 'extravagant harpoon handed over'},
         }},
    },
}

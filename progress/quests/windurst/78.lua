-- Step progress for The Promise (Windurst quest 78). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/SOB7_The_Promise.lua (Kohlo-Lakolo 513, or 532 when Windurst is already rank 9,
-- begins the quest with no option test; 514, 533 and 543 are his reminders while accepted, 505 and 535 are his default lines
-- before the quest and prove nothing; Chamama 797 sets Chamama = 1 and 798 is her reminder; 799 is the accepted Shoalweed trade
-- that gives the Invisible man sticker key item, 800 her talk once it is held; Kohlo-Lakolo 522, 534 and 542 call quest:complete
-- for the Promise Badge, which fails with a full bag after the cutscene played, so they are reaches and the quest log carries
-- bullet 4; 584 plays only once completed, with the Dark Mana Orb held, and runs the closing cutscene of bullet 6). Client
-- event scripts S4 238_Chamama_010EE057.txt (798 say #9935, 799 say #9938, 800 say #9940); key item 271 from res/key_items.lua.
-- Bullet 5 is the condition of bullet 6. The quest log is set at s1, so it is not silent.
return {
    title = 'The Promise',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kohlo lakolo to begin'},
         done = {
            {t = 'event', zone = 240, event = 513, why = 'Kohlo-Lakolo 513: the quest begins in time'},
            {t = 'event', zone = 240, event = 532, why = 'Kohlo-Lakolo 532: the quest begins late'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 240, event = 514, conf = 'inferred', why = 'Kohlo-Lakolo 514: reminder, only once accepted'},
            {t = 'event', zone = 240, event = 543, conf = 'inferred', why = 'Kohlo-Lakolo 543: reminder, only once accepted'},
            {t = 'event', zone = 240, event = 533, conf = 'inferred', why = 'Kohlo-Lakolo 533: reminder, only once accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to chamama windurst waters f'},
         done = {
            {t = 'event', zone = 238, event = 797, why = 'Chamama 797'},
            {t = 'event', zone = 238, event = 798, conf = 'inferred', why = 'Chamama 798: reminder, only after 797'},
            {t = 'chat', re = 'Out of all the materials needed to make', conf = 'inferred', why = 'Chamama 798 (say #9935)'},
         }},
        {id = 's3', at = {n = 3, fp = 'she will make you the invisible'},
         done = {
            {t = 'event', zone = 238, event = 799, why = 'Chamama 799: the Shoalweed accepted'},
            {t = 'chat', re = 'Now, if I add this to this%.%.%.', why = 'Chamama 799 (say #9938)'},
            {t = 'ki', id = 271, gained = true, why = 'invisible man sticker obtained'},
            {t = 'ki_have', id = 271, have = true, why = 'invisible man sticker held'},
            {t = 'chat', re = 'obtained key item: invisible man sticker', why = 'chat: key item obtained'},
            {t = 'event', zone = 238, event = 800, conf = 'inferred', why = 'Chamama 800: her talk once the sticker is held'},
            {t = 'chat', re = "Phew, I'm glad that worked%.", conf = 'inferred', why = 'Chamama 800 (say #9940)'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to kohlo lakolo for your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 271, gained = false, conf = 'inferred', why = 'invisible man sticker handed over'},
         },
         reach = {
            {t = 'event', zone = 240, event = 522, why = 'Kohlo-Lakolo 522 (completion needs a free slot for the badge)'},
            {t = 'event', zone = 240, event = 534, why = 'Kohlo-Lakolo 534 (completion needs a free slot for the badge)'},
            {t = 'event', zone = 240, event = 542, why = 'Kohlo-Lakolo 542 (completion needs a free slot for the badge)'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'if you have killed fenrir after'}},
        {id = 's6', kind = 'post', at = {n = 6, fp = 'zoning and talking to kohlo lakolo'},
         done = {
            {t = 'event', zone = 240, event = 584, after = 's4', why = 'Kohlo-Lakolo 584: the closing cutscene'},
         }},
    },
}

-- Step progress for The Fanged One (Windurst quest 31). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/The_Fanged_One.lua (Perih Vashai 351 is her available-state talk and its finish
-- begins the quest with no way to decline; 352 is her talk while accepted before the fang; the Tiger Bones in Sauromugue
-- Champaign spawn the Old Sabertooth with the zone's OLD_SABERTOOTH_DIALOG_I line and, after it dies naturally, give key item
-- 117; 357 is the hand-in, which runs quest:complete with the Ranger's Necklace as item reward, so it plays the same with a full
-- bag and is a reach, while the zone's PERIH_VASHAI_DIALOG line, the job gesture key item and the loss of the fang happen only
-- on success; 358 is her talk once completed until the player zones). Client event script S4 241_Perih_Vashai_010F1076.txt
-- (352 say #8288, 358 #8302); text from Windurst_Woods and Sauromugue_Champaign IDs.lua; key items 117 and 1748 from
-- res/key_items.lua. The travel and spawn bullet (n=2) has no done signal of its own (the spawn line only shows the mob popped,
-- not that it died), so it is a note on the fang step and the spawn line is a reach there. The quest log is set at s1.
return {
    title = 'The Fanged One',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to perih vashai in windurst'},
         done = {
            {t = 'event', zone = 241, event = 351, why = 'Perih Vashai 351: her talk, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 241, event = 352, why = 'Perih Vashai 352: only while accepted'},
            {t = 'chat', re = 'My child, if you desire to submit yourself to the laws of naturrre', why = 'Perih Vashai 352 (say #8288)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to sauromugue champaign and find'}},
        {id = 's3', at = {n = 3, fp = 'once the old sabertooth dies naturally'},
         reach = {{t = 'chat', re = 'You hear the distant roar of a tiger', why = 'OLD_SABERTOOTH_DIALOG_I: the Old Sabertooth spawned'}},
         done = {
            {t = 'ki', id = 117, gained = true, why = "old tiger's fang obtained"},
            {t = 'ki_have', id = 117, have = true, why = "old tiger's fang held"},
            {t = 'chat', re = "obtained key item: old tiger's fang", why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to perih vashai to complete'},
         reach = {{t = 'event', zone = 241, event = 357, why = "Perih Vashai 357: the fang (also plays with a full bag, the Ranger's Necklace may not fit)"}},
         done = {
            {t = 'chat', re = 'You can now become a ranger!', why = 'PERIH_VASHAI_DIALOG, only on success'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 1748, gained = true, conf = 'inferred', why = 'job gesture: ranger obtained (reward)'},
            {t = 'ki', id = 117, gained = false, after = 's3', conf = 'inferred', why = "old tiger's fang handed over"},
            {t = 'event', zone = 241, event = 358, why = 'Perih Vashai 358: her talk once completed'},
            {t = 'chat', re = 'The one unto whom Mother Nature has bestowed her fangs', why = 'Perih Vashai 358 (say #8302)'},
         }},
    },
}

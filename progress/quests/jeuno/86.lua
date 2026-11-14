-- Step progress for Storms of Fate (Jeuno quest 86). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Storms_of_Fate.lua (the Ru'Lude Gardens area trigger plays 142 and only option 1
-- begins the quest, so 142 is a reach; the Dilapidated Gate _0p2 in Misareaux Coast plays 559 at Prog 0; the Unstable
-- Displacement in Riverne Site #B01 plays 1 at Prog 1 and only that NPC can (the Spatial Displacements play 2 and up); the
-- Storms of Fate battlefield win gives the Whisper of the Wyrmking; the Ru'Lude area trigger plays 143 at Prog 3 and runs
-- quest:complete with no item reward to refuse) and scripts/battlefields/Riverne_Site_B01/storms_of_fate.lua. Key item 361
-- from res/key_items.lua (the same pattern as The Moonlit Path's whisper: only this fight gives it, so it proves the win;
-- event 32001 is any win in that zone, so only a reach, counted after s3). Entering the battlefield (n=4) has no event of its own (32000 is any
-- battlefield entry) and stays a plain bullet. Zone ids from res/zones.lua (25 Misareaux Coast, 29 Riverne Site #B01, 243
-- Ru'Lude Gardens). Not repeatable (page meta). The quest log is set at s1, so it is not silent.
return {
    title = 'Storms of Fate',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after finishing all of the cutscenes'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Ru\'Lude trigger 142, option 1)'},
         },
         reach = {{t = 'event', zone = 243, event = 142, why = 'Ru\'Lude Gardens 142 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'examine the dilapidated gate in misareaux'},
         done = {
            {t = 'event', zone = 25, event = 559, why = 'Dilapidated Gate 559 (Prog 0)'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to the unstable displacement in'},
         done = {
            {t = 'event', zone = 29, event = 1, why = 'Unstable Displacement 1 (Prog 1)'},
         }},
        {id = 's5', at = {n = 5, fp = 'defeat bahamut for another cutscene'},
         done = {
            {t = 'ki', id = 361, gained = true, why = 'whisper of the Wyrmking obtained (the win)'},
            {t = 'ki_have', id = 361, have = true, why = 'whisper of the Wyrmking held'},
            {t = 'chat', re = 'obtained key item: whisper of the wyrmking', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 29, event = 32001, after = 's3', why = 'battlefield win in Riverne Site #B01 (any battlefield there)'}}},
        {id = 's6', at = {n = 6, fp = 'return to the palace in ru'},
         done = {
            {t = 'event', zone = 243, event = 143, why = 'Ru\'Lude Gardens 143 (Prog 3): runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

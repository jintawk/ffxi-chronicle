-- Step progress for Borghertz's Lurking Hands (Jeuno quest 56). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Borghertzs_Lurking_Hands.lua through the shared helper scripts/quests/jeuno/helpers.lua
-- (BorghertzQuests): Guslam (Upper Jeuno 244) plays 155 when the quest is available and begins it (the same event begins every
-- Borghertz quest for the player's main job, so it is only a reach); with the quest accepted and no Old gauntlets he plays 43,
-- the Treasure Coffer in Ifrit's Cauldron gives key item 210, and with the gauntlets held he plays 26 (client event script S4
-- 244_Guslam_010F4037.txt: 26 say #7705); first AF only: Deadly Minnow 24 (244_Deadly_Minnow_010F4038.txt, say #7707) and Yin
-- Pocanakhu in Lower Jeuno 245 (245_Yin_Pocanakhu_010F500C.txt: 220 is the 1,000 gil menu and also plays on "No, thanks", so it
-- proves nothing; "That's the spirit, my fine customer!" #8020 plays only after the gil is taken; 221 plays at both later
-- Prog values, including the skip on a later AF, so it is only inferred); the ??? in Port Jeuno (246) plays 20, 49 and 48 (helpers.lua only: 20 is a cutscene whose option 1 moves on, 48 runs
-- quest:complete and also plays when the Ninja Tekko cannot be given), so no event of it is proof; the cutscene bullet stays a
-- plain bullet and the log's completed bit carries the last step; the torch in Castle
-- Zvahl Baileys gives key item 211 (the pop message "sense of foreboding" is shared with other quests, so the torch bullet
-- stays a plain bullet). Key items 210 and 211 and Guslam's 26 are the same for all 15 Borghertz quests and Chronicle's
-- observations are not scoped to a quest, so every signal after the first step counts only once the quest's own log bit was
-- seen set (after = 's1'): without it one run would tick the other fourteen pages. The cost: installed mid-quest, the steps
-- wait for the completed bit. Held key items at login (ki_have) are left out for the same reason. Key item ids from
-- res/key_items.lua (210 old gauntlets, 211 shadow flames). Repeat after the Memory reset (Vingijard) is not modelled.
return {
    title = "Borghertz's Lurking Hands",
    completes = 's21',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'travel to durable shields in upper'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Guslam 155)'},
         },
         reach = {{t = 'event', zone = 244, event = 155, why = 'Guslam 155 offered (begins whichever Borghertz quest fits the main job)'}}},
        {id = 's2', kind = 'note', with = 's8', at = {n = 2, fp = 'go to ifrit s cauldron'}},
        {id = 's5', kind = 'note', with = 's8', at = {n = 5, fp = 'either obtain a cauldron coffer key'}},
        {id = 's8', at = {n = 8, fp = 'you will receive a old gauntlets'},
         done = {
            {t = 'ki', id = 210, gained = true, after = 's1', why = 'old gauntlets obtained'},
            {t = 'chat', re = 'obtained key item: old gauntlets', after = 's1', why = 'chat: key item obtained'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to upper jeuno and speak'},
         done = {
            {t = 'event', zone = 244, event = 26, after = 's1', why = 'Guslam 26: the gauntlets cannot be repaired'},
            {t = 'chat', re = "Could it be!%? Why, they're soiled and rusty", after = 's1', why = 'Guslam 26 (say #7705)'},
         }},
        {id = 's10', kind = 'branch', at = {n = 10, fp = 'speak to deadly minnow inside of'},
         done = {
            {t = 'event', zone = 244, event = 24, after = 's1', why = 'Deadly Minnow 24 (first AF only)'},
            {t = 'chat', re = 'Wait%. I heard that a Mithra working for the Tenshodo', after = 's1', why = 'Deadly Minnow 24 (say #7707)'},
         }},
        {id = 's11', kind = 'branch', at = {n = 11, fp = 'head to lower jeuno inside the'},
         done = {
            {t = 'chat', re = "That's the spirit, my fine customer!", after = 's1', why = 'Yin Pocanakhu 220: the 1,000 gil taken (say #8020)'},
            {t = 'event', zone = 245, event = 221, after = 's1', conf = 'inferred', why = 'Yin Pocanakhu 221: plays once paid, or skipped on a later AF'},
         },
         reach = {{t = 'event', zone = 245, event = 220, after = 's1', why = 'Yin Pocanakhu 220: the offer (also plays on "No, thanks")'}}},
        {id = 's13', kind = 'note', with = 's19', at = {n = 13, fp = 'go to port jeuno and head'}},
        {id = 's15', kind = 'note', with = 's19', at = {n = 15, fp = 'travel to castle zvahl baileys and'}},
        {id = 's19', at = {n = 19, fp = 'once dark spark is defeated examine'},
         done = {
            {t = 'ki', id = 211, gained = true, after = 's1', why = 'shadow flames obtained'},
            {t = 'chat', re = 'obtained key item: shadow flames', after = 's1', why = 'chat: key item obtained'},
         }},
        {id = 's21', at = {n = 21, fp = 'return to port jeuno and examine'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 211, gained = false, after = 's19', conf = 'inferred', why = 'shadow flames handed over'},
         }},
    },
}

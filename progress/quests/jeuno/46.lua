-- Step progress for Borghertz's Healing Hands (Jeuno quest 46). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Borghertzs_Healing_Hands.lua through the shared helper scripts/quests/jeuno/helpers.lua
-- (BorghertzQuests): Guslam (Upper Jeuno 244) plays 155 when the quest is available and begins it (the same event begins every
-- Borghertz quest for the player's main job, so it is only a reach); the Treasure Coffer gives key item 210, and with the gauntlets
-- held Guslam plays 26 (client event script S4 244_Guslam_010F4037.txt: 26 say #7705); on a first AF Yin Pocanakhu's accepted
-- 1,000 gil says #8020 (245_Yin_Pocanakhu_010F500C.txt) and Deadly Minnow plays 24; the ??? in Port Jeuno (246) plays 20, 49 and 48
-- (helpers.lua only: 48 runs quest:complete and also plays when the AF hands cannot be given), so no event of it is proof and the log's
-- completed bit carries the last step; the torch in Castle Zvahl Baileys gives key item 211 (the "sense of foreboding" pop message is
-- shared, so that bullet stays plain). Key items 210 and 211, Guslam's 26 and Yin's line are the same for all 15 Borghertz quests and
-- Chronicle's observations are not scoped to a quest, so every signal after the first step counts only once the quest's own accepted
-- bit was seen (after = 's1'): one run cannot tick the other fourteen pages, since only one can be accepted at a time. The cost:
-- installed mid-quest, those steps wait for the completed bit. Held key items at login (ki_have) are left out for the same reason.
-- Repeat after the Memory reset is not modelled.
return {
    title = "Borghertz's Healing Hands",
    completes = 's15',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'travel to the durable shields shop'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Guslam 155, as a WHM)'},
         },
         reach = {{t = 'event', zone = 244, event = 155, why = 'Guslam 155 offered (begins whichever Borghertz quest fits the main job)'}}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'go to beadeaux and find a'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'either obtain a beadeaux coffer key'}},
        {id = 's5', at = {n = 5, fp = 'you will receive a key item'},
         done = {
            {t = 'ki', id = 210, gained = true, after = 's1', why = 'old gauntlets obtained'},
            {t = 'chat', re = 'obtained key item: old gauntlets', after = 's1', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to upper jeuno and speak'},
         done = {
            {t = 'event', zone = 244, event = 26, after = 's1', why = 'Guslam 26: the gauntlets cannot be repaired'},
            {t = 'chat', re = "Could it be!%? Why, they're soiled and rusty", after = 's1', why = 'Guslam 26 (say #7705)'},
         }},
        {id = 's7', kind = 'optional', at = {n = 7, fp = 'if this is your first af'},
         done = {
            {t = 'chat', re = "That's the spirit, my fine customer!", after = 's1', why = 'Yin Pocanakhu 220: the 1,000 gil taken (say #8020), first AF only'},
         },
         reach = {
            {t = 'event', zone = 244, event = 24, after = 's1', why = 'Deadly Minnow 24 (first AF only)'},
            {t = 'event', zone = 245, event = 220, after = 's1', why = 'Yin Pocanakhu 220: the offer (also plays on "No, thanks")'},
         }},
        {id = 's10', kind = 'note', with = 's14', at = {n = 10, fp = 'go to port jeuno and head'}},
        {id = 's11', kind = 'note', with = 's14', at = {n = 11, fp = 'click on the to receive a'}},
        {id = 's12', kind = 'note', with = 's14', at = {n = 12, fp = 'travel to castle zvahl baileys and'}},
        {id = 's13', kind = 'note', with = 's14', at = {n = 13, fp = 'click on one of the torches'}},
        {id = 's14', at = {n = 14, fp = 'once dark spark is defeated examine'},
         done = {
            {t = 'ki', id = 211, gained = true, after = 's1', why = 'shadow flames obtained'},
            {t = 'chat', re = 'obtained key item: shadow flames', after = 's1', why = 'chat: key item obtained'},
         }},
        {id = 's15', at = {n = 15, fp = 'return to port jeuno and examine'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 211, gained = false, after = 's14', conf = 'inferred', why = 'shadow flames handed over'},
         }},
    },
}

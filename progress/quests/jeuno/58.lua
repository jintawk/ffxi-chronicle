-- Step progress for Borghertz's Calling Hands (Jeuno quest 58). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Borghertzs_Calling_Hands.lua through the shared helper scripts/quests/jeuno/helpers.lua
-- (BorghertzQuests): Guslam (Upper Jeuno 244) plays 155 when the quest is available and begins it (the same event begins every
-- Borghertz quest for the player's main job, so it is only a reach); with the quest accepted and no Old gauntlets he plays 43,
-- the Treasure Coffer in Sea Serpent Grotto gives key item 210, and with the gauntlets held he plays 26 (client event script S4
-- 244_Guslam_010F4037.txt: 26 say #7705); the first-AF Deadly Minnow / Yin Pocanakhu steps are sub-bullets on this page, so
-- they are not steps; the ??? in Port Jeuno (246) plays 20, 49 and 48 (helpers.lua only: 20 is a cutscene whose option 1 moves on, 48 runs
-- quest:complete and also plays when the Evoker's Bracers cannot be given), so no event of it is proof; the cutscene bullet stays a
-- plain bullet and the log's completed bit carries the last step; the torch in Castle Zvahl Baileys gives key item 211 (the pop message
-- "sense of foreboding" is shared with other quests, so the torch bullet stays a plain bullet). Key items 210 and 211 and
-- Guslam's 26 are the same for all 15 Borghertz quests and Chronicle's observations are not scoped to a quest, so every signal
-- after the first step counts only once the quest's own log bit was seen set (after = 's1'): without it one run would tick
-- the other fourteen pages. The cost: installed mid-quest, the steps wait for the completed bit. Held key items at login
-- (ki_have) are left out for the same reason. Key item ids from res/key_items.lua (210 old gauntlets, 211 shadow flames).
-- The three bullets before the walkthrough (where to get the coffer key) are plain. Repeat after the Memory reset
-- (Vingijard) is not modelled.
return {
    title = "Borghertz's Calling Hands",
    completes = 's16',
    known = {{t = 'quest'}},
    steps = {
        {id = 's4', at = {n = 4, fp = 'travel to the durable shields shop'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Guslam 155)'},
         },
         reach = {{t = 'event', zone = 244, event = 155, why = 'Guslam 155 offered (begins whichever Borghertz quest fits the main job)'}}},
        {id = 's5', kind = 'note', with = 's8', at = {n = 5, fp = 'head to the sea serpent grotto'}},
        {id = 's8', at = {n = 8, fp = 'find and open a coffer in'},
         done = {
            {t = 'ki', id = 210, gained = true, after = 's4', why = 'old gauntlets obtained'},
            {t = 'chat', re = 'obtained key item: old gauntlets', after = 's4', why = 'chat: key item obtained'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to upper jeuno and speak'},
         done = {
            {t = 'event', zone = 244, event = 26, after = 's4', why = 'Guslam 26: the gauntlets cannot be repaired'},
            {t = 'chat', re = "Could it be!%? Why, they're soiled and rusty", after = 's4', why = 'Guslam 26 (say #7705)'},
         }},
        {id = 's10', kind = 'note', with = 's15', at = {n = 10, fp = 'if this is your first af'}},
        {id = 's11', kind = 'note', with = 's15', at = {n = 11, fp = 'go to port jeuno and head'}},
        {id = 's13', kind = 'note', with = 's15', at = {n = 13, fp = 'travel to castle zvahl baileys and'}},
        {id = 's15', at = {n = 15, fp = 'once dark spark is defeated examine'},
         done = {
            {t = 'ki', id = 211, gained = true, after = 's4', why = 'shadow flames obtained'},
            {t = 'chat', re = 'obtained key item: shadow flames', after = 's4', why = 'chat: key item obtained'},
         }},
        {id = 's16', at = {n = 16, fp = 'return to port jeuno and examine'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 211, gained = false, after = 's15', conf = 'inferred', why = 'shadow flames handed over'},
         }},
    },
}

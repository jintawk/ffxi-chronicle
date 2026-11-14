-- Step progress for Borghertz's Loyal Hands (Jeuno quest 55). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Borghertzs_Loyal_Hands.lua through the shared helper scripts/quests/jeuno/helpers.lua
-- (BorghertzQuests): Guslam (Upper Jeuno 244) plays 155 when the quest is available and begins it (the same event begins every
-- Borghertz quest for the player's main job, so it is only a reach); with the quest accepted and no Old gauntlets he plays 43,
-- the Treasure Coffer in the dungeon gives key item 210, and with the gauntlets held he plays 26 (client event script S4
-- 244_Guslam_010F4037.txt: 26 say #7705); the first-AF Deadly Minnow 24 / Yin Pocanakhu 220, 221 steps are indented on this page,
-- so they are not steps; the ??? in Port Jeuno (246) plays 20, 49 and 48 (helpers.lua only: 20 is a cutscene whose option 1 moves on, 48 runs
-- quest:complete and also plays when the Myochin Kote cannot be given), so no event of it is proof; the cutscene bullet stays a
-- plain bullet and the log's completed bit carries the last step; the torch in Castle Zvahl Baileys gives key item 211 (the pop message
-- "sense of foreboding" is shared with other quests, so the torch bullet stays a plain bullet). Key items 210 and 211 and
-- Guslam's 26 are the same for all 15 Borghertz quests and Chronicle's observations are not scoped to a quest, so every signal
-- after the first step counts only once the quest's own log bit was seen set (after = 's1'): without it one run would tick
-- the other fourteen pages. The cost: installed mid-quest, the steps wait for the completed bit. Held key items at login
-- (ki_have) are left out for the same reason. Key item ids from res/key_items.lua (210 old gauntlets, 211 shadow flames).
-- Repeat after the Memory reset (Vingijard) is not modelled.
return {
    title = "Borghertz's Loyal Hands",
    completes = 's15',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'travel to the durable shields shop'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Guslam 155)'},
         },
         reach = {{t = 'event', zone = 244, event = 155, why = 'Guslam 155 offered (begins whichever Borghertz quest fits the main job)'}}},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'go to kuftal tunnel coffers spawn'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'either obtain a kuftal coffer key'}},
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
        {id = 's7', kind = 'note', with = 's14', at = {n = 7, fp = 'if this is your first af'}},
        {id = 's10', kind = 'note', with = 's14', at = {n = 10, fp = 'go to port jeuno and head'}},
        {id = 's12', kind = 'note', with = 's14', at = {n = 12, fp = 'travel to castle zvahl baileys and'}},
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

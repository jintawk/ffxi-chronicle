-- Step progress for Hat in Hand (Windurst quest 0). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Waters/npcs/Baren-Moren.lua (event 48 offers the quest and its menu can be
-- declined, so it only proves the offer; accepting gives the New model hat and adds the quest; event 52 is the hang-up menu
-- and also plays on "Not yet", and the quest is completed in onEventFinish only if the reward can be given, so it is a reach
-- and the quest log's completed bit carries the last step; the hat is taken only after a successful completion); client
-- event script S4 238_Baren_Moren_010EE044.txt (48 menu #7385, 52 menu #7414); key item id from res/key_items.lua (115 new
-- model hat). Repeatable (page meta): a repeat is a new hat, so the key item gained opens the next run and the quest-log
-- matchers count for the first run only (run1). The NPC list and the reward tiers are notes on the hang-up. The quest log
-- is set at s1, so it is not silent.
return {
    title = 'Hat in Hand',
    completes = 's4',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to baren moren h 7'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'ki', id = 115, gained = true, why = 'new model hat obtained'},
            {t = 'ki_have', id = 115, have = true, why = 'new model hat held'},
            {t = 'chat', re = 'obtained key item: new model hat', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 238, event = 48, why = 'Baren-Moren 48 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'mandatory npcs you need to show'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'the more npcs you talk to'}},
        {id = 's4', at = {n = 4, fp = 'after you have shown the hat'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 115, gained = false, conf = 'inferred', why = 'new model hat handed over (taken only after a completed hang-up)'},
         },
         reach = {{t = 'event', zone = 238, event = 52, why = 'Baren-Moren 52 offered (hang-up menu, also played on "Not yet")'}}},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'zoning will reset any npc spoken'}},
    },
}

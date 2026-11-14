-- Step progress for A Thirst for Eternity (Adoulin quest 116). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script for Roskin, Palomel, Quwi Orihbhe or the record locations, so
-- the page is the only source. Key items from res/key_items.lua: Elder wooden box (2613, handed over at the first talk, n=1),
-- Imprint device S (2614, Palomel's appraisal of the box, n=2), the four records (Record of a thousand lights 2618, of a
-- cavernous foray 2616, of the generals' foray 2615, of the knight in black 2617; n=5, 8, 11, 13) and Heroes and Legends of
-- Adoulin (2620, after the quiz, n=21). The page says in n=23 "At this point the quest is now listed as Completed in your
-- logs", so the log's completed bit belongs to n=23 (n=15 says the section after the records is only optional if you skip the
-- next quest; the quiz bullet stays a branch). The four records can be gathered in any order and the quiz is not needed for
-- every player, so those five are branch bullets: each ticks on its own key item and none is inferred from a later one.
-- Roskin and Palomel talks, Quwi Orihbhe and the quiz set-up (n=3, 4, 16-20, 22) have no signal: left plain. n=24 is after
-- the quest and optional. Not repeatable.
return {
    title = 'A Thirst for Eternity',
    completes = 's23',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to roskin in eastern adoulin'},
         done = {
            {t = 'ki', id = 2613, gained = true, why = 'elder wooden box obtained'},
            {t = 'ki_have', id = 2613, have = true, why = 'elder wooden box held'},
            {t = 'chat', re = 'obtained key item: elder wooden box', why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to palomel in eastern adoulin'},
         done = {
            {t = 'ki', id = 2614, gained = true, why = 'imprint device S obtained'},
            {t = 'ki_have', id = 2614, have = true, why = 'imprint device S held'},
            {t = 'chat', re = 'obtained key item: imprint device s', why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'branch', at = {n = 5, fp = 'ceizak battlegrounds eastern side of f'},
         done = {
            {t = 'ki', id = 2618, gained = true, why = 'record of a thousand lights obtained'},
            {t = 'ki_have', id = 2618, have = true, why = 'record of a thousand lights held'},
            {t = 'chat', re = 'obtained key item: record of a thousand lights', why = 'chat: key item obtained'},
         }},
        {id = 's8', kind = 'branch', at = {n = 8, fp = 'cirdas caverns southern side of h'},
         done = {
            {t = 'ki', id = 2616, gained = true, why = 'record of a cavernous foray obtained'},
            {t = 'ki_have', id = 2616, have = true, why = 'record of a cavernous foray held'},
            {t = 'chat', re = 'obtained key item: record of a cavernous foray', why = 'chat: key item obtained'},
         }},
        {id = 's11', kind = 'branch', at = {n = 11, fp = 'yorcia weald northwest corner of j'},
         done = {
            {t = 'ki', id = 2615, gained = true, why = "record of the generals' foray obtained"},
            {t = 'ki_have', id = 2615, have = true, why = "record of the generals' foray held"},
            {t = 'chat', re = "obtained key item: record of the generals' foray", why = 'chat: key item obtained'},
         }},
        {id = 's13', kind = 'branch', at = {n = 13, fp = 'kamihr drifts eastern side of the'},
         done = {
            {t = 'ki', id = 2617, gained = true, why = 'record of the knight in black obtained'},
            {t = 'ki_have', id = 2617, have = true, why = 'record of the knight in black held'},
            {t = 'chat', re = 'obtained key item: record of the knight in black', why = 'chat: key item obtained'},
         }},
        {id = 's21', kind = 'branch', at = {n = 21, fp = 'after the quiz you will receive'},
         done = {
            {t = 'ki', id = 2620, gained = true, why = 'Heroes and Legends of Adoulin obtained'},
            {t = 'ki_have', id = 2620, have = true, why = 'Heroes and Legends of Adoulin held'},
            {t = 'chat', re = 'obtained key item: heroes and legends of adoulin', why = 'chat: key item obtained'},
         }},
        {id = 's23', at = {n = 23, fp = 'talk to roskin at this point'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed at Roskin (the page says so)'},
         }},
        {id = 's24', kind = 'optional', at = {n = 24, fp = 'after a game day talk to'}, done = {}},
    },
}

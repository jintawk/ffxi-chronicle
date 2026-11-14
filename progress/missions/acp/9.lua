-- Step progress for Banishing the Echo (A Crystalline Prophecy mission 10, mission id 9). Data only; see progress/missions/acp/1.lua.
-- Evidence: res/key_items.lua only. LandSandBoat's script for this mission is an empty stub (scripts/missions/acp/10_Banishing_The_Echo.lua)
-- and no client event for the Seed Fragments or Afterglows is decoded, so no event is used. The twelve Stone key items (1092
-- Amicitia to 1103 Salus, one per Seed Afterglow from the first to the twelfth floor, in the order the page walks them) and the
-- Omnis Stone (1104, "Re-obtain an Omnis Stone from the previous mission" on page 10) are the markers. Only the climb is sequential,
-- so the last stone of each top-level bullet proves it: bullet 5 (floors one to three) ends with the Sapientia Stone 1094, bullet 6
-- (floors four to nine) with the Caritas Stone 1100, bullet 7 (floors ten to twelve) with the Salus Stone 1103. The stones and the
-- fragments are indented bullets or part of the bullet, never steps of their own. Bullet 8 hands over the Omnis Stone, which is
-- the mission's last step and `completes` it (the acp line moving to 10 backs it and covers a character that finished before
-- installing Chronicle). The Omnis Stone comes back on a repeat and only re-ticks. Bullets 1 to 4 (level cap, Destrier Beret,
-- Sprinter's Shoes, powders and oils) are notes. The draft had only bullet 8 mapped.
return {
    title = 'Banishing the Echo',
    completes = 's8',
    known = {{t = 'mission', line = 'acp', eq = 9}},
    groups = {main = {start = {{t = 'mission', line = 'acp', min = 9, why = 'mission line: Banishing the Echo is current'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's5', at = {n = 1, fp = 'you will not be able to'}},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'pro tip use destrier beret to'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'it is recommended to utilize sprinter'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'prism powders and silent oils are'}},
        {id = 's5', at = {n = 5, fp = 'examine the seed fragment on the'},
         done = {
            {t = 'ki', id = 1094, gained = true, why = 'Sapientia Stone obtained (third floor, the last stone of this bullet)'},
            {t = 'ki_have', id = 1094, have = true, why = 'Sapientia Stone held'},
            {t = 'chat', re = 'obtained key item: sapientia stone', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'examine the seed fragment on the'},
         done = {
            {t = 'ki', id = 1100, gained = true, why = 'Caritas Stone obtained (ninth floor, the last stone of this bullet)'},
            {t = 'ki_have', id = 1100, have = true, why = 'Caritas Stone held'},
            {t = 'chat', re = 'obtained key item: caritas stone', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'examine the seed fragment on the'},
         done = {
            {t = 'ki', id = 1103, gained = true, why = 'Salus Stone obtained (twelfth floor, the last stone of this bullet)'},
            {t = 'ki_have', id = 1103, have = true, why = 'Salus Stone held'},
            {t = 'chat', re = 'obtained key item: salus stone', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'examine the seed fragment in stellar'},
         done = {
            {t = 'ki', id = 1104, gained = true, why = 'Omnis Stone obtained (Stellar Fulcrum Seed Fragment, with all twelve stones)'},
            {t = 'ki_have', id = 1104, have = true, why = 'Omnis Stone held'},
            {t = 'chat', re = 'obtained key item: omnis stone', why = 'chat: key item obtained'},
            {t = 'mission', line = 'acp', min = 10, why = 'mission line: Ode of Life Bestowing is current, Banishing the Echo is done'},
         }},
    },
}

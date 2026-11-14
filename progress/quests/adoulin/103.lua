-- Step progress for All the Way to the Bank (Adoulin quest 103). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script (the quest id is named but nothing implements it) and no client event script for the
-- Mummers' Coalition NPC or the Mischief Marker, so the page is the only source. Key items from res/key_items.lua: the
-- Tarutaru Sauce invoice (2396) is handed over at the first talk (the bullet's sub-bullet) and the receipt (2397) when the
-- last vendor is paid (bullet 5). The page says the five-hat game "must be done five times to complete the quest", so the
-- log's completed bit belongs to the Mischief Marker bullet (n=7), not to the receipt. The talk back to Peladi (n=6) and the
-- vendor trips (n=2, n=4) have no signal: notes. The gruel trade (n=8) is optional and after the quest. Not repeatable.
return {
    title = 'All the Way to the Bank',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to peladi shalmohr at the'},
         done = {
            {t = 'ki', id = 2396, gained = true, why = 'Tarutaru Sauce invoice obtained'},
            {t = 'ki_have', id = 2396, have = true, why = 'Tarutaru Sauce invoice held'},
            {t = 'chat', re = 'obtained key item: tarutaru sauce invoice', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'you must travel to each of'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'movement speed quickening from farso dafarso'}},
        {id = 's5', at = {n = 5, fp = 'after visiting all vendors you will'},
         done = {
            {t = 'ki', id = 2397, gained = true, why = 'Tarutaru Sauce receipt obtained'},
            {t = 'ki_have', id = 2397, have = true, why = 'Tarutaru Sauce receipt held'},
            {t = 'chat', re = 'obtained key item: tarutaru sauce receipt', why = 'chat: key item obtained'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'return to peladi shalmohr at the'}},
        {id = 's7', at = {n = 7, fp = 'travel to j 11 and click'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the fifth hat choice succeeds)'},
         }},
        {id = 's8', kind = 'optional', at = {n = 8, fp = 'after completing the quest you can'}, done = {}},
    },
}

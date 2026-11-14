-- Step progress for Vegetable Vegetable Evolution (Adoulin quest 109). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script for Amchuchu's door, the Yorcia Weald ??? or the Tenshodo
-- cutscene, so the page is the only source. The Yorcia Weald ??? (n=3) hands over Midras's explosive sample (2376) and the
-- Report on Midras's explosive (2377) in one click (key items from res/key_items.lua). The page ends the quest at the door
-- ("for CS and your reward", n=5), so the log's completed bit belongs to n=5. The wait, the first door click and the Tenshodo
-- cutscene (n=1, n=2, n=4) have no signal: notes. Not repeatable.
return {
    title = 'Vegetable Vegetable Evolution',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'wait till the next game day'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'click on the door amuchuchu s'}},
        {id = 's3', at = {n = 3, fp = 'check the in yorcia weald at'},
         done = {
            {t = 'ki', id = 2376, gained = true, why = "Midras's explosive sample obtained"},
            {t = 'ki_have', id = 2376, have = true, why = "Midras's explosive sample held"},
            {t = 'chat', re = "obtained key item: midras's explosive sample", why = 'chat: key item obtained'},
            {t = 'ki', id = 2377, gained = true, why = "report on Midras's explosive obtained"},
            {t = 'ki_have', id = 2377, have = true, why = "report on Midras's explosive held"},
            {t = 'chat', re = "obtained key item: report on midras's explosive", why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'after that enter the tenshodo in'}},
        {id = 's5', at = {n = 5, fp = 'then head back to inventors coalition'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed at the door'},
         }},
    },
}

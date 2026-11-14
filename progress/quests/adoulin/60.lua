-- Step progress for Talk About Wrinkly Skin (Adoulin quest 60). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script (quests.lua only names the id) and no client event script for Orsa-Porsa, so this rests on
-- the page and res/key_items.lua. The Hot springs care package (key item 2277, a temporary key item) is obtained by the
-- Apkallu Egg, Felicifruit and Uleguerand Milk trade at bullet 2, which makes its gain the one strong signal before the end;
-- the log's completed bit proves bullet 5. Calor resilience (2209) is the reward, so it only supports the last bullet. Nothing
-- shows when the log first flags the quest (the first talk, or the trade), so there is no silent_until. Bullets 1, 3 and 4 (the
-- talk, the walk and the hot spring cutscene) have no signal and are notes.
return {
    title = 'Talk About Wrinkly Skin',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'talk to orsa porsa at the'}},
        {id = 's2', at = {n = 2, fp = 'trade him an apkallu egg felicifruit'},
         done = {
            {t = 'ki', id = 2277, gained = true, why = 'Hot springs care package obtained by the trade'},
            {t = 'ki_have', id = 2277, have = true, why = 'Hot springs care package held'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'head to the hot springs at'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'remove all equipment barring rings and'}},
        {id = 's5', at = {n = 5, fp = 'return to orsa porsa to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 2209, gained = true, conf = 'inferred', why = 'Calor resilience obtained (reward)'},
         }},
    },
}

-- Step progress for Mistress of Ceremonies (Adoulin quest 129). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest but has no script for it, so the page is the source. Rigobertine hands out the Purple
-- purgation cloth (key item 2810, res/key_items.lua, a temporary key item; the page says she gives a new one after a defeat) in
-- bullet 1, which is also the entry ticket to the battlefield. The roots cutscene, the battlefield entry and the win (bullets
-- 2-3) have no signal of their own and are notes on the last step; the last cutscene (bullet 4) gives the rewards, so the
-- log's completed bit belongs to it (the draft put it on bullet 1). The quest log's current bit is not mapped. Not repeatable.
return {
    title = 'Mistress of Ceremonies',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with rigobertine eastern adoulin j'},
         done = {
            {t = 'ki', id = 2810, gained = true, why = 'purple purgation cloth obtained'},
            {t = 'ki_have', id = 2810, have = true, why = 'purple purgation cloth held'},
            {t = 'chat', re = 'obtained key item: purple purgation cloth', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'click the suspicious roots at g'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'select the suspicious roots again to'}},
        {id = 's4', at = {n = 4, fp = 'upon victory examine the suspicious roots'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

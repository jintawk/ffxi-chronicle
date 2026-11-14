-- Step progress for Keep Your Bloomers On, Erisa (Adoulin quest 71). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script for the Door: Research Chamber (quests.lua only names the id), so
-- this rests on the page and res/key_items.lua. The Tiny seed (key item 2262, temporary) is handed out by the Alluring Plant in
-- Rala Waterways, which makes its gain the one strong signal before the end. The door's last cutscene finishes the quest, so the
-- log's completed bit belongs to bullet 4, not to the plant bullet as the draft had it. Nothing shows when the log first flags
-- the quest (the first door cutscene or the Humus trade), so there is no silent_until. Bullets 1 and 2 (the door cutscene and
-- the Yahse Humus trade) have no signal of their own and are notes on the plant.
return {
    title = 'Keep Your Bloomers On, Erisa',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'click on the door research chamber'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'trade yahse humus to the door'}},
        {id = 's3', at = {n = 3, fp = 'click on the northern alluring plant'},
         done = {
            {t = 'ki', id = 2262, gained = true, why = 'Tiny seed obtained from the Alluring Plant'},
            {t = 'ki_have', id = 2262, have = true, why = 'Tiny seed held'},
         }},
        {id = 's4', at = {n = 4, fp = 'return again to the door research'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

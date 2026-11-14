-- Step progress for The Secret to Success (Adoulin quest 127). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest but has no script for it, so the page is the source. The Unblemished pioneer's badge
-- (key item 2507, res/key_items.lua, a temporary key item) is what bullet 5 hands out at the right Suspicious Place; bullet 4
-- only says what Emjook-Renook lost (the draft put the badge there), so bullet 4 is a note on bullet 5. The cutscene talks
-- (bullets 1-3 and 6) have no signal of their own and are notes on the step they lead into. The last cutscene (bullet 7)
-- gives the reward, so the log's completed bit belongs to it. The quest log's current bit is not mapped (nothing says which
-- bullet flags it). Not repeatable.
return {
    title = 'The Secret to Success',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's5', at = {n = 1, fp = 'talk to behsa alehgo at j'}},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'head to the scouts coalition and'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'head to the frontier station at'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'emjook renook said he lost his'}},
        {id = 's5', at = {n = 5, fp = 'check the suspicious places at j'},
         done = {
            {t = 'ki', id = 2507, gained = true, why = "unblemished pioneer's badge obtained"},
            {t = 'ki_have', id = 2507, have = true, why = "unblemished pioneer's badge held"},
            {t = 'chat', re = "obtained key item: unblemished pioneer's badge", why = 'chat: key item obtained'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'return to emjook renook for a'}},
        {id = 's7', at = {n = 7, fp = 'speak with behsa alehgo for the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

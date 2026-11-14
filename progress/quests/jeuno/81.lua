-- Step progress for Blighted Gloom (Jeuno quest 81). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: neither LandSandBoat (the id 81 is only listed in globals/quests.lua) nor the client's event scripts have anything
-- for this quest, so the mapping rests on the quest log and on key item 732 (Vitrallum, res/key_items.lua), which the page
-- names as the reward of touching the ??? in bullet 2. The page says Luto's cutscene begins the quest (bullet 1), so the log's
-- current bit marks s1; the quest completes at the cutscene in Jugner Forest (bullet 4), so only the log's completed bit proves
-- that step. Bullet 3 (return to Luto) has no signal and stays a plain bullet. Not repeatable. Retail has not been captured,
-- so the log flagging at s1 follows the page. Disagreement with the draft: it made bullet 1 a note and put the completion on
-- the Vitrallum step.
return {
    title = 'Blighted Gloom',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to luto for a cutscene'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'touch the spot for a brief'},
         done = {
            {t = 'ki', id = 732, gained = true, why = 'Vitrallum obtained'},
            {t = 'ki_have', id = 732, have = true, why = 'Vitrallum held'},
         }},
        {id = 's4', at = {n = 4, fp = 'you will then need to go'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

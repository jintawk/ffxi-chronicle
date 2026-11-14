-- Step progress for Stonewalled (Seekers of Adoulin mission 3-6-3, page id 244). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_6_3_Stonewalled.lua. The Marolith instance is entered from the Hollowed Pathway, which
-- LandSandBoat does not script; the win sends the player back to Cirdas Caverns (270), where zone-in cutscene 30 plays only after a win
-- and its finish completes the mission, handing over the Soul siphon (key item 2509). Bullet 1 (enter the battlefield) is the action
-- the win answers; bullets 2 to 4 are notes on it. Rejected: the Aureate ball of fur (taken before the entry, can be held already),
-- Cirdas Caverns [U] (271) event 1000 (LandSandBoat's own script calls it an unverified assumption and the client has no script for
-- it), and Levil 152 (a reminder). The line has no completed set, so the end is `min = 245`.
return {
    title = 'Stonewalled',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 244}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'click on the hollowed pathway again'},
         done = {
            {t = 'zonein', zone = 270, event = 30, why = 'Cirdas Caverns zone-in cutscene 30 (played only after the win; its finish completes)'},
            {t = 'ki', id = 2509, gained = true, why = 'Soul siphon obtained (reward of the win)'},
            {t = 'mission', line = 'adoulin', min = 245, why = 'mission log: the line moved past Stonewalled'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'you may enter solo and summon'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'you only need to kill the'}},
        {id = 's4', kind = 'note', with = 's1', at = {n = 4, fp = 'you will receive the soul siphon'}},
    },
}

-- Step progress for That Which Curdles Blood (ASA mission 3, mission id 2). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/asa/03_That_Which_Curdles_Blood.lua. The Trodden Snow in Qufim Island (126) plays event 44
-- only when the trade matches the kit the previous mission chose (npcUtil.tradeMatches), and its finish completes the mission and
-- takes the kit, so 44 proves bullet 4 (a trade event: a wrong item plays nothing). The reward key items (Domina's seals 1191 to
-- 1196) are never used. The recipe NPCs (Kuroido-Moido 858, Faulpie 944, Abd-al-Raziq 590) are lookups the page says you need not
-- visit, and the synthesis of the kit has no signal of its own (an item gain can come from elsewhere), so bullets 1 to 3 are notes
-- on the trade. The asa line moves to 3 on completion (no completed set: `min = 3`). Bullets 5 to 10 are the daily Moogle key
-- repeat: every signal there is a reward key item, so they stay plain bullets.
return {
    title = 'That Which Curdles Blood',
    completes = 's4',
    known = {{t = 'mission', line = 'asa', eq = 2}},
    groups = {main = {start = {{t = 'mission', line = 'asa', eq = 2, completed = false, why = 'mission line: current mission = That Which Curdles Blood'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'you are tasked with creating an'}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'for the kit you will need'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'once you have obtained all the'}},
        {id = 's4', at = {n = 4, fp = 'trade the kit to the trodden'},
         done = {
            {t = 'event', zone = 126, event = 44, why = 'Trodden Snow 44: the kit accepted (trade only; its finish completes)'},
            {t = 'mission', line = 'asa', min = 3, why = 'mission line: past That Which Curdles Blood (Sugar-coated Directive is 3)'},
         }},
    },
}

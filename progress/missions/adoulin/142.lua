-- Step progress for In the Presence of Royalty (Seekers of Adoulin mission, page id 142). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_2_2_In_the_Presence_of_Royalty.lua. Yorcia's tear (key item 2385) is given by the
-- Ergon Locus ??? in Yorcia Weald (or by harvesting), so its gain proves bullet 1. The Pellucid Afflusion (Yorcia Weald 263) plays
-- event 2 only while the mission is current and the tear is held, and its finish completes the mission, so the event proves bullet 2.
-- The adoulin line (packet value = page id) has no completed set, so the completion is `min = 143`, not `completed = true`. Rosulatia's
-- pome (bullet 3) is the mission's reward key item and can already be owned, so that bullet is a note on the cutscene. The draft's
-- "NEEDS REVIEW: page id" note was dropped (the page id is the line value).
return {
    title = 'In the Presence of Royalty',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 142}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'obtain a yorcia s tear via'},
         done = {
            {t = 'ki', id = 2385, gained = true, why = "Yorcia's tear obtained"},
            {t = 'ki_have', id = 2385, have = true, why = "Yorcia's tear held"},
            {t = 'chat', re = "obtained key item: yorcia's tear", why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'go to g 6 after obtaining'},
         done = {
            {t = 'event', zone = 263, event = 2, why = 'Pellucid Afflusion 2: only with the tear in this mission, its finish completes it'},
            {t = 'mission', line = 'adoulin', min = 143, why = 'mission log: the line moved past In the Presence of Royalty'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'after the cutscene you will obtain'}},
    },
}

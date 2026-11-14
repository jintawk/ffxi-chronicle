-- Step progress for The Seventh Guardian (Seekers of Adoulin mission, page id 344). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_3_1_The_Seventh_Guardian.lua. Yeggha Dolashi (Rala Waterways 258) plays 374 as a plain
-- progress event while the mission is current, the update only chooses a branch of the same scene, and the finish always completes
-- the mission, so there is no refusal path and the event proves the one bullet. The adoulin line has no completed set (packet value
-- = page id), so the completion is `min = 345`, not the draft's `completed = true`. Levil's 40 is a reminder and proves nothing.
return {
    title = 'The Seventh Guardian',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 344}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to rala waterways m 6'},
         done = {
            {t = 'event', zone = 258, event = 374, why = 'Yeggha Dolashi 374, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 345, why = 'mission line: the line moved past The Seventh Guardian'},
         }},
    },
}

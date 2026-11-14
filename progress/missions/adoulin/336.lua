-- Step progress for Returning to the Trees (Seekers of Adoulin mission, page id 336). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_2_1_Returning_to_the_Trees.lua. Leafallia (281) returns cutscene 11 from onZoneIn
-- whenever this mission is current, and the finish of 11 always completes the mission (no refusal path: the two choices in bullet 2
-- are inside this one cutscene and change nothing). So the zone-in proves bullet 1 and the cutscene, and bullet 2 is a note on it.
-- Levil's 40 is a reminder while the mission is current and proves nothing. The adoulin line has no completed set (packet value =
-- page id), so the completion is `min = 337`, not the draft's `completed = true`.
return {
    title = 'Returning to the Trees',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 336}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter leafallia'},
         done = {
            {t = 'zonein', zone = 281, event = 11, why = 'Leafallia zone-in 11, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 337, why = 'mission log: the line moved past Returning to the Trees'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'select ask for forgiveness followed by'}},
    },
}

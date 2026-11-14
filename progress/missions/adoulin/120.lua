-- Step progress for Heartwings and the Kindhearted (Seekers of Adoulin mission 1-4, mission id 120). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/1_4_Heartwings_and_the_Kindhearted.lua. Zone-in scene 2 in Western Adoulin plays
-- whenever this mission is current and its finish completes it. The adoulin line has no completed set, so the completion is
-- `min = 121`. The draft's `completed = true` matcher is dropped.
return {
    title = 'Heartwings and the Kindhearted',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 120}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head north east through ceizak battlegrounds'},
         done = {
            {t = 'zonein', zone = 256, event = 2, why = 'Western Adoulin zone-in scene 2, its finish completes'},
            {t = 'mission', line = 'adoulin', min = 121, why = 'mission log: the line moved past Heartwings and the Kindhearted'},
         }},
    },
}

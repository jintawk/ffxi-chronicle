-- Step progress for The Watergarden Coliseum (Seekers of Adoulin mission, page id 148). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_4_1_The_Watergarden_Coliseum.lua. Yeggha Dolashi (Rala Waterways 258) plays event 0 only
-- while this mission is current at status 0, with no refusal path, and its finish completes the mission. The adoulin line has no
-- completed set (packet value = page id), so the completion is `min = 149`, not `completed = true`. The page's second line (the
-- nearest entrance) is an indented sub-bullet and not a step.
return {
    title = 'The Watergarden Coliseum',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 148}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to the room at the'},
         done = {
            {t = 'event', zone = 258, event = 0, why = 'Yeggha Dolashi 0, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 149, why = 'mission log: the line moved past The Watergarden Coliseum'},
         }},
    },
}

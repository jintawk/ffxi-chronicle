-- Step progress for The Leafkin Monarch (Seekers of Adoulin mission, page id 178). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_7_2_The_Leafkin_Monarch.lua. Eastern Adoulin trigger area 1 plays event 1507 while this
-- mission is current (no refusal path) and its finish completes the mission. The adoulin line has no completed set (packet value
-- = page id), so the completion is `min = 179`, not `completed = true`.
return {
    title = 'The Leafkin Monarch',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 178}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'walk near the adoulin castle gates'},
         done = {
            {t = 'event', zone = 257, event = 1507, why = 'Eastern Adoulin trigger area: event 1507, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 179, why = 'mission log: the line moved past The Leafkin Monarch'},
         }},
    },
}

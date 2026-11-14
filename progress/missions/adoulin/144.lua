-- Step progress for The Twin World Trees (Seekers of Adoulin mission, page id 144). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_3_The_Twin_World_Trees.lua. The Eastern Adoulin trigger area 2 plays event 1503 once
-- the Vana'diel-day timer has passed, only while this mission is current, and its finish completes the mission. Levil's event 127
-- in Western Adoulin is a reminder that persists over several missions and proves nothing, so it is not used. The adoulin line has
-- no completed set (packet value = page id), so the completion is `min = 145`, not `completed = true`.
return {
    title = 'The Twin World Trees',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 144}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach oscairn at g 7 in'},
         done = {
            {t = 'event', zone = 257, event = 1503, why = 'Eastern Adoulin trigger area: event 1503, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 145, why = 'mission log: the line moved past The Twin World Trees'},
         }},
    },
}

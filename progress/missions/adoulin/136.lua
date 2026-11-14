-- Step progress for The Heirloom (Seekers of Adoulin mission 2-1-3, mission id 136). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_1_2_The_Heirloom.lua. Trigger area 1 at the Eastern Adoulin castle gate plays 1502
-- only while this mission is current, and its finish completes it (no NPC, so no client script). Levil's 103 is a reminder and
-- proves nothing. The adoulin line has no completed set, so the completion is `min = 137`. The draft's `completed = true`
-- matcher is dropped.
return {
    title = 'The Heirloom',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 136}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach eastern adoulin s castle gate'},
         done = {
            {t = 'event', zone = 257, event = 1502, why = 'Eastern Adoulin castle gate trigger area: scene 1502, its finish completes'},
            {t = 'mission', line = 'adoulin', min = 137, why = 'mission log: the line moved past The Heirloom'},
         }},
    },
}

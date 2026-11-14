-- Step progress for Arciela Appears Again (Seekers of Adoulin mission 1-8, mission id 128). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/1_8_Arciela_Appears_Again.lua and the client script S4 256_Levil_01100091 (events
-- 6 and 7 are empty cutscenes there). The page never names the NPC: it says the imprimatur requirement "can be fulfilled" and the
-- next mission starts on the next game day, and that is what Levil's scene 6 follows (LandSandBoat plays it only once the
-- imprimatur gate is met, and its finish completes the mission in both branches). So scene 6 proves bullet 1, and bullets 2 to 4
-- (the ways to earn imprimaturs) are notes on it. Levil 7 never plays in LandSandBoat's flow and is dropped. The adoulin line
-- has no completed set, so the completion is `min = 129`. Bullets 5 to 8 are plain bullets.
return {
    title = 'Arciela Appears Again',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 128}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'the imprimatur requirement can be fulfilled'},
         done = {
            {t = 'event', zone = 256, event = 6, why = 'Levil 6: the Arciela scene once the imprimatur gate is met, its finish completes'},
            {t = 'mission', line = 'adoulin', min = 129, why = 'mission log: the line moved past Arciela Appears Again'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'a quick and easy way to'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'another method is to do simple'}},
        {id = 's4', kind = 'note', with = 's1', at = {n = 4, fp = 'trio of repeatable quests using item'}},
    },
}

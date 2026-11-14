-- Step progress for The Light Shining in Your Eyes (Seekers of Adoulin mission 2-1-2, mission id 134). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_1_1_The_Light_Shining_in_Your_Eyes.lua and the client script S4 256_Levil_01100091
-- (event 9, an empty cutscene). Levil's 9 plays on every talk while this mission is current and its finish completes it. The
-- adoulin line has no completed set, so the completion is `min = 135`. The draft's `completed = true` matcher is dropped.
return {
    title = 'The Light Shining in Your Eyes',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 134}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to the pioneers coalition and'},
         done = {
            {t = 'event', zone = 256, event = 9, why = 'Levil 9: the mission scene, its finish completes'},
            {t = 'mission', line = 'adoulin', min = 135, why = 'mission log: the line moved past The Light Shining in Your Eyes'},
         }},
    },
}

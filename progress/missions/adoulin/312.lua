-- Step progress for Just the Thing (Seekers of Adoulin mission 4-5-2, mission page id 312). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_5_2_Just_the_Thing.lua. Andreine (Celennia Memorial Library 284) plays 7 on any talk
-- while this mission is current, no refusal path, and its finish completes the mission. The "Suffering Sacchariferous" key item
-- is the reward (it can already be owned), so it is not used. Levil's 40 is a reminder. The adoulin line has no completed set:
-- `min = 313`. The client script for 7 has no text.
return {
    title = 'Just the Thing',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 312}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter celennia memorial library in eastern'},
         done = {
            {t = 'event', zone = 284, event = 7, why = 'Andreine 7, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 313, why = 'mission log: the line moved past Just the Thing'},
         }},
    },
}

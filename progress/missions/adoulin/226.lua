-- Step progress for Wildcat with a Gold Pelt (Seekers of Adoulin, mission page id 226). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_5_1_Wildcat_with_a_Gold_Pelt.lua. The trigger area at the Castle Adoulin gates
-- (Eastern Adoulin 257) plays 1515 only while this mission is current, and its finish completes the mission. Levil's 143 is a
-- reminder. The adoulin line has no completed set: `min = 227`. No client script is decoded for 1515.
return {
    title = 'Wildcat with a Gold Pelt',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 226}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach the castle adoulin gates in'},
         done = {
            {t = 'event', zone = 257, event = 1515, why = 'Eastern Adoulin castle gate area 1515, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 227, why = 'mission log: the line moved past Wildcat with a Gold Pelt'},
         }},
    },
}

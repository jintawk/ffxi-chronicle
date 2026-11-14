-- Step progress for The Tomatoes of Wrath (Seekers of Adoulin mission 4-4-2, mission page id 300). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_4_2_The_Tomatoes_of_Wrath.lua. Ploh Trishbahk (Eastern Adoulin 257) plays 1533 on
-- any talk while this mission is current, no refusal path, and its finish completes the mission. Levil's 40 is a reminder and
-- Chalvava's 370 (Rala Waterways) only sets a variable nothing tests, so neither is used. The adoulin line has no completed
-- set (packet value = page id): `min = 301`. No client script is decoded for 1533.
return {
    title = 'The Tomatoes of Wrath',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 300}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head back to adoulin castle and'},
         done = {
            {t = 'event', zone = 257, event = 1533, why = 'Ploh Trishbahk 1533, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 301, why = 'mission log: the line moved past The Tomatoes of Wrath'},
         }},
    },
}

-- Step progress for August's Heirloom (Seekers of Adoulin, mission page id 222). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_4_4_Augusts_Heirloom.lua. Ploh Trishbahk at the castle gate (Eastern Adoulin
-- 257) plays 1514 only while this mission is current, and its finish completes the mission. Levil's 143 is a reminder. The
-- adoulin line has no completed set: `min = 223`. No client script is decoded for 1514.
return {
    title = "August's Heirloom",
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 222}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ploh trishbahk at the'},
         done = {
            {t = 'event', zone = 257, event = 1514, why = 'Ploh Trishbahk 1514, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 223, why = "mission log: the line moved past August's Heirloom"},
         }},
    },
}

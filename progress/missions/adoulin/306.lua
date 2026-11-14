-- Step progress for An Emergency Convocation (Seekers of Adoulin mission 4-4-4, mission page id 306). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_4_4_An_Emergency_Convocation.lua. The one bullet is a three-scene chain in Eastern
-- Adoulin (257): Ploh Trishbahk's 1535 (only after the must-zone from the last mission has passed), then the zone-in 1551, then
-- the zone-in 1552, whose finish completes the mission. So 1552 and the line moving on prove the step, while 1535 and 1551 only
-- show the chain has begun and are `reach`. Ploh's 1542 (must-zone still pending) and Levil's 40 are reminders. The adoulin
-- line has no completed set: `min = 307`. No client script is decoded for these events.
return {
    title = 'An Emergency Convocation',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 306}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone out of eastern adoulin and'},
         done = {
            {t = 'zonein', zone = 257, event = 1552, why = 'Eastern Adoulin zone-in 1552, the end of the chain, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 307, why = 'mission log: the line moved past An Emergency Convocation'},
         },
         reach = {
            {t = 'event', zone = 257, event = 1535, why = 'Ploh Trishbahk 1535: the chain starts'},
            {t = 'zonein', zone = 257, event = 1551, why = 'Eastern Adoulin zone-in 1551: the middle of the chain'},
         }},
    },
}

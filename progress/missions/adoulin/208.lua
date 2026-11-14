-- Step progress for Shared Consciousness (Seekers of Adoulin, mission page id 208). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_3_4_Shared_Consciousness.lua. The Boarding House door in Eastern Adoulin (zone 257)
-- plays 1513 only while this mission is current (otherwise it gives its "nothing out of the ordinary" line), and the finish of 1513
-- completes the mission. Levil's 141 is a reminder and proves nothing. The adoulin line carries the page id and has no completed
-- set, so completion is `min = 209`. No client script is decoded for the door.
return {
    title = 'Shared Consciousness',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 208}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to the door boarding house'},
         done = {
            {t = 'event', zone = 257, event = 1513, why = 'Eastern Adoulin Door: Boarding House 1513, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 209, why = 'mission log: the line moved past Shared Consciousness'},
         }},
    },
}

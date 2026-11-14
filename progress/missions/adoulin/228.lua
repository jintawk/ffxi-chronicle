-- Step progress for In Search of Arciela (Seekers of Adoulin, mission page id 228). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_5_2_In_Search_of_Arciela.lua. Levil (Western Adoulin 256) plays 137 only while
-- this mission is current, and its finish completes the mission. Ploh Trishbahk's 1516 is a side scene whose finish does nothing,
-- so it proves nothing. The adoulin line has no completed set: `min = 229`.
return {
    title = 'In Search of Arciela',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 228}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to levil at the pioneers'},
         done = {
            {t = 'event', zone = 256, event = 137, why = 'Levil 137, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 229, why = 'mission log: the line moved past In Search of Arciela'},
         }},
    },
}

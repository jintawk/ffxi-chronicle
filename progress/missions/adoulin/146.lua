-- Step progress for Honor and Audacity (Seekers of Adoulin mission, page id 146). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_4_0_Honor_and_Audacity.lua. Rala Waterways (258) returns cutscene 342 from onZoneIn
-- whenever this mission is current (no refusal path), and the finish of 342 completes the mission. Levil's event 127 in Western
-- Adoulin is a reminder and proves nothing. The adoulin line has no completed set (packet value = page id), so the completion is
-- `min = 147`, not `completed = true`.
return {
    title = 'Honor and Audacity',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 146}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into rala waterways from eastern'},
         done = {
            {t = 'zonein', zone = 258, event = 342, why = 'Rala Waterways zone-in 342, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 147, why = 'mission log: the line moved past Honor and Audacity'},
         }},
    },
}

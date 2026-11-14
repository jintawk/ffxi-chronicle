-- Step progress for Arciela's Promise (Seekers of Adoulin mission, page id 168). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_6_2_Arcielas_Promise.lua. Ploh Trishbahk (Eastern Adoulin 257) plays event 1506 on
-- every talk while this mission is current (no refusal path) and its finish completes the mission. Chalvava's event 360 is a
-- reminder (once per zone) and proves nothing. The adoulin line has no completed set (packet value = page id), so the completion
-- is `min = 169`, not `completed = true`.
return {
    title = "Arciela's Promise",
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 168}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to the castle adoulin gates'},
         done = {
            {t = 'event', zone = 257, event = 1506, why = 'Ploh Trishbahk 1506, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 169, why = "mission log: the line moved past Arciela's Promise"},
         }},
    },
}

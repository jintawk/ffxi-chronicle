-- Step progress for Aiming for Ygnas (Seekers of Adoulin mission, page id 162). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_6_0_Aiming_for_Ygnas.lua. Ploh Trishbahk (Eastern Adoulin 257) plays event 1505 on
-- every talk while this mission is current (no refusal path) and its finish completes the mission. Levil's event 126 is a reminder
-- and proves nothing. The adoulin line has no completed set (packet value = page id), so the completion is `min = 163`, not
-- `completed = true`.
return {
    title = 'Aiming for Ygnas',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 162}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to the castle adoulin gates'},
         done = {
            {t = 'event', zone = 257, event = 1505, why = 'Ploh Trishbahk 1505, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 163, why = 'mission log: the line moved past Aiming for Ygnas'},
         }},
    },
}

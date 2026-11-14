-- Step progress for Predators and Prey (Seekers of Adoulin mission, page id 170). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_7_0_Predators_and_Prey.lua (enum name PREDATOR_AND_PREY, which the draft did not
-- find). The Sluice Gate (Rala Waterways 258) plays event 352 on every talk while this mission is current (no refusal path) and its
-- finish completes the mission. Levil's event 126 is a reminder and proves nothing. The adoulin line has no completed set (packet
-- value = page id), so the completion is `min = 171`, not `completed = true`.
return {
    title = 'Predators and Prey',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 170}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to the sluice gate c'},
         done = {
            {t = 'event', zone = 258, event = 352, why = 'Sluice Gate 352, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 171, why = 'mission log: the line moved past Predators and Prey'},
         }},
    },
}

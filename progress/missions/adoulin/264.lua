-- Step progress for Lighting the Way (Seekers of Adoulin mission 4-2-0, page id 264). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_2_0_Lighting_the_Way.lua. The Alpine Trail (Kamihr Drifts 267) plays event 44, a "Proceed?"
-- menu (client S4 267_Alpine_Trail: Yes / No, shared by several mission events), and only Yes sends the player to Mount Kamihr (282),
-- where zone-in cutscene 1 plays only at that status. Zoning back to Kamihr Drifts then completes the mission. Event 44 plays on a
-- refusal too, so it is only `reach`; the Mount Kamihr zone-in 1 is the proof. Rejected: Levil 165 (a reminder). The line has no
-- completed set, so the end is `min = 265`.
return {
    title = 'Lighting the Way',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 264}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the alpine trail in kamihr'},
         done = {
            {t = 'zonein', zone = 282, event = 1, why = 'Mount Kamihr zone-in cutscene 1 (played only after answering Proceed)'},
            {t = 'mission', line = 'adoulin', min = 265, why = 'mission log: the line moved past Lighting the Way'},
         },
         reach = {
            {t = 'event', zone = 267, event = 44, why = 'Alpine Trail 44 offered (a Yes/No menu; only Yes proceeds)'},
         }},
    },
}

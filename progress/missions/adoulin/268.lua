-- Step progress for Studying Up (Seekers of Adoulin mission 4-2-2, page id 268). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_2_2_Studying_Up.lua. The Alpine Trail (Kamihr Drifts 267) plays event 45, a "Proceed?"
-- menu (client S4 267_Alpine_Trail: Yes / No), and only Yes sends the player to Mount Kamihr (282), where zone-in cutscene 2 plays only
-- at that status (it holds the quiz of bullet 2, whose answers the server does not check). Zoning back to Kamihr Drifts then completes
-- the mission. Event 45 plays on a refusal too, so it is only `reach`; the Mount Kamihr zone-in 2 is the proof. Rejected: Levil 165
-- (a reminder). The line has no completed set, so the end is `min = 269`.
return {
    title = 'Studying Up',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 268}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to the alpine trail in'},
         done = {
            {t = 'zonein', zone = 282, event = 2, why = 'Mount Kamihr zone-in cutscene 2 (played only after answering Proceed)'},
            {t = 'mission', line = 'adoulin', min = 269, why = 'mission log: the line moved past Studying Up'},
         },
         reach = {
            {t = 'event', zone = 267, event = 45, why = 'Alpine Trail 45 offered (a Yes/No menu; only Yes proceeds)'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'you must answer the questions correctly'}},
    },
}

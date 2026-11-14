-- Step progress for Salvation (Seekers of Adoulin mission 3-6-4, page id 248). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_6_4_Salvation.lua. The Crawling Cave (Kamihr Drifts 267) plays event 33, a cutscene
-- with a choice (updates for options 1 to 3); only the third option completes the mission, takes the Soul siphon (key item 2509) and
-- starts the next mission's timer. So event 33 starting proves bullet 1 (the cutscene), and the Soul siphon being lost proves bullet 2
-- (the third option). The client has no script for event 33. The line has no completed set, so the end is `min = 249`.
-- Rejected: Rising Solstice 150 and Volgoi 151 (their finishes do nothing), Levil 152 (a reminder).
return {
    title = 'Salvation',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 248}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go back to the crawling cave'},
         done = {
            {t = 'event', zone = 267, event = 33, why = 'Crawling Cave 33: the cutscene (only while this mission is current)'},
         }},
        {id = 's2', at = {n = 2, fp = 'chose the third option her hilt'},
         done = {
            {t = 'ki', id = 2509, gained = false, why = 'Soul siphon taken: only the third option does this'},
            {t = 'mission', line = 'adoulin', min = 249, why = 'mission log: the line moved past Salvation'},
         }},
    },
}

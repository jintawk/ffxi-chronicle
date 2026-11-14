-- Step progress for Curses! A Horrifically Harrowing Hex (A Moogle Kupo d'Etat mission 5, mission id 4). Data only; see
-- progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/amk/05_Curses_A_Horrifically_Harrowing_Hex.lua. Shantotto in Windurst Walls (239) plays event
-- 506 while this mission is current (progressEvent, no menu); its finish calls mission:complete. The client's event list for Shantotto
-- carries 506 (239_Shantotto_010EF01A.txt header) with an empty body, so there is no client line. The next mission, 5, begins at once,
-- which is why the page says Shantotto "will ask you for a Ripe starfruit". The mkd line has no completed set in Chronicle, so the
-- completion is the line moving to 5.
return {
    title = 'Curses! A Horrifically Harrowing Hex',
    completes = 's1',
    known = {{t = 'mission', line = 'mkd', eq = 4}},
    groups = {main = {start = {{t = 'mission', line = 'mkd', eq = 4, why = 'mission line: current mission = Curses! A Horrifically Harrowing Hex'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to shantotto in windurst walls'},
         done = {
            {t = 'event', zone = 239, event = 506, why = 'Shantotto 506: the cutscene, completes the mission'},
            {t = 'mission', line = 'mkd', eq = 5, why = "mission line: moved on to An Errand! The Professor's Price (this one completed)"},
         }},
    },
}

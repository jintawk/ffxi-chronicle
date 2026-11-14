-- Step progress for Relief! A Triumphant Return (A Moogle Kupo d'Etat mission 11, mission id 10). Data only; see
-- progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/amk/11_Relief_A_Triumphant_Return.lua. The Inconspicuous Door in Upper Jeuno (244) plays event
-- 10185 while this mission is current (progressEvent, no menu) and its finish calls mission:complete. The door's event ids run in
-- mission order (10178 m2, 10179 to 10181 m3, 10182 m5, 10183 m6, 10184 m7, 10185 here). LandSandBoat reuses 10184 and 10185 as
-- placeholders in its mission 9 and mission 13 scripts, which is why those two pages do not use a door event. The mkd line has no
-- completed set in Chronicle, so the completion is the line moving to 11.
return {
    title = 'Relief! A Triumphant Return',
    completes = 's1',
    known = {{t = 'mission', line = 'mkd', eq = 10}},
    groups = {main = {start = {{t = 'mission', line = 'mkd', eq = 10, why = 'mission line: current mission = Relief! A Triumphant Return'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to the inconspicuous door in'},
         done = {
            {t = 'event', zone = 244, event = 10185, why = 'Inconspicuous Door 10185: the cutscene, completes the mission'},
            {t = 'mission', line = 'mkd', min = 11, why = 'mission line: moved on to Joy! Summoned to a Fabulous Fete (this one completed)'},
         }},
    },
}

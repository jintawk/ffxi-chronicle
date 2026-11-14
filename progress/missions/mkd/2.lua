-- Step progress for Hasten! In a Jam in Jeuno? (A Moogle Kupo d'Etat mission 3, mission id 2). Data only; see
-- progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/amk/03_Hasten_In_a_Jam_in_Jeuno.lua. The Inconspicuous Door in Upper Jeuno (244) plays event
-- 10178 while this mission is current; it is a plain cutscene (progressEvent, no menu) and its finish calls mission:complete. The mkd
-- line has no completed set in Chronicle, so the completion is the line moving to the next mission id, 3 (core/data.lua
-- get_mission_read reads mkd as a current value only).
return {
    title = 'Hasten! In a Jam in Jeuno?',
    completes = 's1',
    known = {{t = 'mission', line = 'mkd', eq = 2}},
    groups = {main = {start = {{t = 'mission', line = 'mkd', eq = 2, why = 'mission line: current mission = Hasten! In a Jam in Jeuno?'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the inconspicuous door in upper'},
         done = {
            {t = 'event', zone = 244, event = 10178, why = 'Inconspicuous Door 10178: the cutscene, completes the mission'},
            {t = 'mission', line = 'mkd', min = 3, why = 'mission line: moved on to Welcome! To My Decrepit Domicile (this one completed)'},
         }},
    },
}

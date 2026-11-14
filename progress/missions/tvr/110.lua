-- Step progress for The Gloom Phantom's Approach (The Voracious Resurgence mission 1-2, page id 110). Data only; see progress/missions/rov/110.lua for the format.
-- Evidence: a capture, not a script (LandSandBoat's tvr scripts are all stubs). In-game capture records from two characters (identical values) and
-- a capture log 20261106-110101.log (the capture benchmark, "tvr, read on 2026-11-06"): the line holds 110 from Gumbah's
-- event 661, 112 when the Zeruhn Mines zone-in event 220 ends, 114 when the Disturbed Dirt event 223 ends, 116 when Gloom Phantom is defeated (no event),
-- and 118 (bit 31 set, 20,000 gil) when the Disturbed Dirt event 224 ends. Each value names one bullet; the tvr line has no completed set, so the end is `min = 118`.
-- Bullet 3 says the dirt spawns the NM; the line moves on the kill, so the step ticks when Gloom Phantom is defeated. The two optional sub-bullets are dialogue only.
return {
    title = "The Gloom Phantom's Approach",
    completes = 's4',
    known = {{t = 'mission', line = 'tvr', min = 110, max = 117}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into zeruhn mines from bastok'},
         done = {
            {t = 'mission', line = 'tvr', min = 112, why = 'mission log: zone-in event 220 ended (112)'},
         }},
        {id = 's2', at = {n = 2, fp = 'touch the disturbed dirt at k'},
         done = {
            {t = 'mission', line = 'tvr', min = 114, why = 'mission log: Disturbed Dirt event 223 ended (114)'},
         }},
        {id = 's3', at = {n = 3, fp = 'touch the disturbed dirt again to'},
         done = {
            {t = 'mission', line = 'tvr', min = 116, why = 'mission log: Gloom Phantom defeated (116)'},
         }},
        {id = 's4', at = {n = 4, fp = 'after defeating gloom phantom touch the'},
         done = {
            {t = 'mission', line = 'tvr', min = 118, why = 'mission log: Disturbed Dirt event 224 ended, the line moved to The Brygid Cup (118)'},
         }},
    },
}

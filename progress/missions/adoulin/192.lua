-- Step progress for The Key (Seekers of Adoulin mission, page id 192). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_1_4_The_Key.lua. Levil (Western Adoulin 256) plays 131 only once the one-day timer
-- has passed (before that he plays the reminder 138), and the finish of 131 always completes the mission. The client script has
-- no text for 131. The adoulin line (packet value = page id, no completed set) moves past 192: `min = 193`.
return {
    title = 'The Key',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 192}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head back to the pioneers coalition'},
         done = {
            {t = 'event', zone = 256, event = 131, why = 'Levil 131: only after the timer, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 193, why = 'mission log: the line moved past The Key'},
         }},
    },
}

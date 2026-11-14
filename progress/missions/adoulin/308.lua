-- Step progress for Balamor, the Deathborne Xol (Seekers of Adoulin mission 4-5, mission page id 308). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_5_0_Balamor_the_Deathborne_Xol.lua. Ploh Trishbahk (Eastern Adoulin 257) plays 1536
-- only once the stored game-day timer has passed (before that he plays 1543, a reminder), and its finish completes the mission.
-- Levil's 40 is a reminder. The adoulin line has no completed set: `min = 309`. The client script for 1536 is empty.
return {
    title = 'Balamor, the Deathborne Xol',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 308}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'wait until the next game day'},
         done = {
            {t = 'event', zone = 257, event = 1536, why = 'Ploh Trishbahk 1536: only after the day wait, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 309, why = 'mission log: the line moved past Balamor, the Deathborne Xol'},
         }},
    },
}

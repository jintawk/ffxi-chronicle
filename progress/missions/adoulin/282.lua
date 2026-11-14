-- Step progress for The Sacred Sapling (Seekers of Adoulin mission 4-3-3, mission id 282). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/soa/4_3_3_The_Sacred_Sapling.lua. Ploh Trishbahk (Eastern Adoulin 257) plays event 1528
-- while the mission is current and its finish completes it. The client script for Ploh Trishbahk (S4 257_Ploh_Trishbahk_0110108E)
-- does not list 1528 and four other actors' lists do, with no body decoded, so LandSandBoat is the only source for the NPC and
-- the event id; the adoulin line moving on covers a miss. Bullet 2 ("Select Tree Grafting") is part of the same cutscene and is a
-- note on bullet 1. Levil's 165 is a reminder. The adoulin line has no completed set (`min = 283`).
return {
    title = 'The Sacred Sapling',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 282}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ploh trishbahk at the'},
         done = {
            {t = 'event', zone = 257, event = 1528, why = 'Ploh Trishbahk 1528, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 283, why = 'mission log: the line moved past The Sacred Sapling'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'select tree grafting to continue'}},
    },
}

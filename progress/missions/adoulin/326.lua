-- Step progress for Arboreal Rumors (Seekers of Adoulin mission 5-1, mission page id 326). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_1_0_Arboreal_Rumors.lua. Ploh Trishbahk (Eastern Adoulin 257) plays 1539 on any talk
-- while this mission is current and its finish completes the mission whatever the menu answer; the Hastily scribbled note is
-- the reward (it can already be owned), so it is not used. Levil's 183 and 40 are reminders. The adoulin line has no completed
-- set: `min = 327`. The client script for 1539 is empty. Bullet 2 (the menu answer) is a note on bullet 1.
return {
    title = 'Arboreal Rumors',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 326}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to the castle adoulin gates'},
         done = {
            {t = 'event', zone = 257, event = 1539, why = 'Ploh Trishbahk 1539, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 327, why = 'mission log: the line moved past Arboreal Rumors'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'select i just want to see'}},
    },
}

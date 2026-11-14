-- Step progress for Sajj'aka (Seekers of Adoulin mission 4-2-1, page id 266). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_2_1_Sajjaka.lua. While this mission is current, zoning into Celennia Memorial Library
-- (284) always plays zone-in cutscene 5; its finish completes the mission. Bullet 2 (reading the stories) is inside that cutscene, so it
-- is a note. Rejected: Levil 165 (a reminder). The line has no completed set, so the end is `min = 267`.
return {
    title = "Sajj'aka",
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 266}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into celennia memorial library for'},
         done = {
            {t = 'zonein', zone = 284, event = 5, why = 'Celennia Memorial Library zone-in cutscene 5 (finish completes)'},
            {t = 'mission', line = 'adoulin', min = 267, why = "mission log: the line moved past Sajj'aka"},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'read the different stories in the'}},
    },
}

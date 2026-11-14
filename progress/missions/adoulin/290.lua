-- Step progress for Rosulatia's Promise (Seekers of Adoulin mission 4-3-7, mission id 290). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/soa/4_3_7_Rosulatias_Promise.lua. The Heroic Footprints in Leafallia (zone 281) play event 3
-- while the mission is current; its finish always completes the mission and takes the World Tree sapling (key item 2558, a
-- temporary key item given by the previous mission), so the sapling leaving the key items is proof too. The client script for the
-- Heroic Footprints (S4 281_Heroic_Footprints_01119021) lists only the next mission's event 5, so LandSandBoat is the only source for
-- event 3. Levil's 166 is a reminder. The adoulin line has no completed set (`min = 291`).
return {
    title = "Rosulatia's Promise",
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 290}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'click the heroic footprints h 8'},
         done = {
            {t = 'event', zone = 281, event = 3, why = 'Heroic Footprints 3, its finish completes the mission'},
            {t = 'ki', id = 2558, gained = false, why = 'World Tree sapling taken when the mission completes'},
            {t = 'mission', line = 'adoulin', min = 291, why = "mission log: the line moved past Rosulatia's Promise"},
         }},
    },
}

-- Step progress for Drifting Northwest (Seekers of Adoulin, mission page id 234). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_6_0_Drifting_Northwest.lua. Zoning into Kamihr Drifts (zone 267) plays event 29
-- only while this mission is current, and its finish completes the mission. LandSandBoat also removes the Tintinnabulum there,
-- but that is its own guess about retail, so the key item is not used; Levil's 144 is a reminder. The adoulin line has no completed
-- set: `min = 235`. No client script is decoded for 29.
return {
    title = 'Drifting Northwest',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 234}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zoning in from woh gates using'},
         done = {
            {t = 'zonein', zone = 267, event = 29, why = 'Kamihr Drifts zone-in 29, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 235, why = 'mission log: the line moved past Drifting Northwest'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'bivouac 2 is the closest to'}},
    },
}

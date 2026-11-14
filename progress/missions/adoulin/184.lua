-- Step progress for Return of the Exorcist (Seekers of Adoulin mission, page id 184). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_1_0_Return_of_the_Exorcist.lua. The Western Adoulin airship docks trigger area
-- (zone 256) plays event 130 unconditionally while the mission is current, and its finish completes the mission. Levil 138 is a
-- reminder and proves nothing. The adoulin line (packet value = page id, no completed set) moves past 184 on completion: `min = 185`.
return {
    title = 'Return of the Exorcist',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 184}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to the western adoulin airship'},
         done = {
            {t = 'event', zone = 256, event = 130, why = 'Western Adoulin airship docks area 130: the cutscene, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 185, why = 'mission log: the line moved past Return of the Exorcist'},
         }},
    },
}

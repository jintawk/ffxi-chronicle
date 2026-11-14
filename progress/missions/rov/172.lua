-- Step progress for Reunited (Rhapsodies of Vana'diel mission, page id 172 = LandSandBoat's REUNITED 64 + 108). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_10_Reunited.lua: Nadeey in Aht Urhgan Whitegate plays event 167 (no branch,
-- no refusal) and its finish completes the mission into Take Wing. 167 is not used by any other mission script. The rov line
-- holds the page id and has no completed set, so the completion is `min = 174` (Take Wing, 66 + 108, the next value in the
-- enum). Bullet 2 (the Rider Cometh cutscene) is another mission's scene and is not mapped.
return {
    title = 'Reunited',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 172}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter walahra temple and talk to'},
         done = {
            {t = 'event', zone = 50, event = 167, why = 'Nadeey 167: the cutscene that completes the mission'},
            {t = 'mission', line = 'rov', min = 174, why = 'mission log: the line moved past Reunited'},
         }},
    },
}

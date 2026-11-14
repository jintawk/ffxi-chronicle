-- Step progress for Sacrifice (Rhapsodies of Vana'diel mission, page id 191 = LandSandBoat's SACRIFICE 83 + 108). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_17_Sacrifice.lua. Bullets 1 and 2 are two ways into the Walk of Echoes (zone 182)
-- and bullet 3 is the Ornate Door inside: the door plays event 27 only when the Rhapsody characters are available and neither
-- blocking quest is active (otherwise a message and no event), and its finish sends the player to Grauberg [S] (zone 89), where
-- the zone-in cutscene 47 completes the mission. So 27 proves bullet 3 and 47 (which needs the door's flag) proves it as well and is
-- the completion. The entry zone-in 26 plays on any entrance, including the wrong instance, so it proves neither entrance and is
-- not used. Bullets 1 and 2 are notes (how to get in; bullet 1 also repeats the door check of bullet 3). The rov line holds the
-- page id and has no completed set, so the completion is `min = 194` (Somber Dreams, 86 + 108, the next value in the enum).
return {
    title = 'Sacrifice',
    completes = 's3',
    known = {{t = 'mission', line = 'rov', min = 191, max = 193}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'enter walk of echoes from pashhow'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'enter walk of echoes by touching'}},
        {id = 's3', at = {n = 3, fp = 'after you zone in run straight'},
         done = {
            {t = 'event', zone = 182, event = 27, why = 'Walk of Echoes Ornate Door 27'},
            {t = 'zonein', zone = 89, event = 47, why = 'Grauberg [S] zone-in 47: the cutscene that completes the mission'},
            {t = 'mission', line = 'rov', min = 194, why = 'mission log: the line moved past Sacrifice'},
         }},
    },
}

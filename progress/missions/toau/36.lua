-- Step progress for Path of Blood (Treasures of Aht Urhgan mission 37, mission id 36). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/toau/37_Path_of_Blood.lua; zone 50 = Aht Urhgan Whitegate. Entering Salaheem's Sentinels (trigger
-- area 3) plays event 3131 (S4 pseudo-code: a bare event on the area actors; it sets status 1 and forces a zone), and the Whitegate zone-in
-- cutscene 3220 that follows completes the mission, so the one bullet is the whole mission. The draft had no `completes` and only a note.
return {
    title = 'Path of Blood',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 36}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter salaheem s sentinels for a'},
         done = {
            {t = 'event', zone = 50, event = 3131, why = "Salaheem's Sentinels trigger area 3131: the cutscene (status 1, LandSandBoat)"},
            {t = 'zonein', zone = 50, event = 3220, why = 'Whitegate zone-in cutscene 3220 (status 1): completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'toau', eq = 36, completed = true, why = 'mission log: Path of Blood completed'},
         }},
    },
}

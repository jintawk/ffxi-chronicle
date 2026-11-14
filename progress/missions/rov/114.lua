-- Step progress for The Beginning (Rhapsodies of Vana'diel mission 1-5, page id 114). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/1_05_The_Beginning.lua and the client scripts S4 248_Pacomart (event 179) and
-- 249_Tonasav (event 371), which have no lines. The rov line holds the page id (enum + 108) and has no completed set; the next value is
-- 118 (Flames of Prayer). The two bullets are the two paths (Pacomart in Selbina, Tonasav in Mhaura), a group each opened by the mission
-- being current. Both end at the same Oaken Door in Norg: its event 276 (zone 252) plays only for this mission and its finish completes
-- it, so it proves the path's last act, but it cannot say which path was taken, so both bullets take it (a finished mission shows both).
-- Pacomart 179 / Tonasav 371 are a menu whose option 1 warps and whose other options only close it, so they are `reach` (the path
-- begun), never proof. The Reisenjima Sanctorium orb is a reward and is not used.
return {
    title = 'The Beginning',
    completes = 's2',
    known = {{t = 'mission', line = 'rov', min = 114, max = 117}},
    groups = {
        selbina = {start = {{t = 'mission', line = 'rov', min = 114, max = 117, why = 'mission line: current mission = The Beginning'}}},
        mhaura = {start = {{t = 'mission', line = 'rov', min = 114, max = 117, why = 'mission line: current mission = The Beginning'}}},
    },
    steps = {
        {id = 's1', group = 'selbina', at = {n = 1, fp = 'for selbina path'},
         done = {
            {t = 'event', zone = 252, event = 276, why = 'Norg Oaken Door 276: Gilgamesh\'s room, its finish completes the mission'},
            {t = 'mission', line = 'rov', min = 118, why = 'mission log: the line moved past The Beginning'},
         },
         reach = {{t = 'event', zone = 248, event = 179, why = 'Pacomart 179 offered (option 1 warps to Norg)'}}},
        {id = 's2', group = 'mhaura', at = {n = 2, fp = 'for mhaura path'},
         done = {
            {t = 'event', zone = 252, event = 276, why = 'Norg Oaken Door 276: Gilgamesh\'s room, its finish completes the mission'},
            {t = 'mission', line = 'rov', min = 118, why = 'mission log: the line moved past The Beginning'},
         },
         reach = {{t = 'event', zone = 249, event = 371, why = 'Tonasav 371 offered (option 1 warps to Norg)'}}},
    },
}

-- Step progress for President Salaheem (Treasures of Aht Urhgan mission 3, mission id 2). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/03_President_Salaheem.lua. Naja Salaheem (Whitegate, zone 50) plays 73 first (it sets the
-- status and the must-zone flag; the same id is her Mog Locker scene, so it is only `reach`) and, after a zone, 3020, whose finish
-- completes the mission. One bullet bundles both talks. LandSandBoat says the Rytaal cutscene is unlocked by this mission but not needed
-- (and Rytaal's events 268 and 270 are the Assault menu, which plays at any time), so bullet 2 stays a plain bullet.
-- Fubruhn's event 600 is his Mog Locker menu: talking to him is the optional bullet. The Trust bullet is a note.
return {
    title = 'President Salaheem',
    completes = 's3',
    known = {{t = 'mission', line = 'toau', eq = 2}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'you must zone out and return'}},
        {id = 's3', at = {n = 3, fp = 'speak to naja salaheem twice for'},
         done = {
            {t = 'event', zone = 50, event = 3020, why = 'Naja Salaheem 3020: the second cutscene, the mission completes'},
            {t = 'mission', line = 'toau', eq = 2, completed = true, why = 'mission log: President Salaheem completed'},
         },
         reach = {
            {t = 'event', zone = 50, event = 73, why = 'Naja Salaheem 73: the first cutscene (the Mog Locker scam)'},
         }},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'optional speak to fubruhn f 11'},
         done = {
            {t = 'event', zone = 50, event = 600, why = 'Fubruhn 600: the Mog Locker menu'},
         }},
        {id = 's5', kind = 'note', with = 's3', at = {n = 5, fp = 'if you have completed rov mission'}},
    },
}

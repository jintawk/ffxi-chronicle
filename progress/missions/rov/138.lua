-- Step progress for What Lies Beyond (Rhapsodies of Vana'diel mission 1-13, page id 138). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/1_13_What_Lies_Beyond.lua and the client script S4 252_Comitiolus. The rov line holds the
-- page id (enum + 108) and has no completed set; the next value is 140 (The Ties that Bind). Bullet 2 is the Oaken Door in Norg: its
-- event 278 (zone 252) plays on every touch while this mission is current, has no options, and its finish completes the mission. The
-- client has no script for it, LandSandBoat only. Bullet 1 (zone into Norg, with the Rise of the Zilart opening scene if that is not
-- started) has no scene of this mission, so it is a note on bullet 2. Comitiolus 6 is the default talk and proves nothing.
return {
    title = 'What Lies Beyond',
    completes = 's2',
    known = {{t = 'mission', line = 'rov', eq = 138}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'zone into norg'}},
        {id = 's2', at = {n = 2, fp = 'examine gilgamesh s oaken door in norg'},
         done = {
            {t = 'event', zone = 252, event = 278, why = 'Norg Oaken Door 278: its finish completes the mission'},
            {t = 'mission', line = 'rov', min = 140, why = 'mission log: the line moved past What Lies Beyond'},
         }},
    },
}

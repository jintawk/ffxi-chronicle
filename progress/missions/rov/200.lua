-- Step progress for Of Light and Darkness (Rhapsodies of Vana'diel mission, page id 200). Data only; see progress/missions/adoulin/134.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_19_Of_Light_and_Darkness.lua (the Oaken Door `_700` in Norg plays event 285 only while this
-- mission is current; its finish is `mission:complete`, nothing is asked, so it cannot play on a refusal). No client event script for it.
-- The rov line holds the page id (LandSandBoat's enum + 108) and has no completed set, so the completion is `min = 202` (Temporary
-- Farewells, LSB 94).
return {
    title = 'Of Light and Darkness',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 200}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to norg and examine gilgamesh'},
         done = {
            {t = 'event', zone = 252, event = 285, why = 'Norg Oaken Door 285: the mission scene, its finish completes'},
            {t = 'mission', line = 'rov', min = 202, why = 'mission log: the line moved past Of Light and Darkness'},
         }},
    },
}

-- Step progress for Temporary Farewells (Rhapsodies of Vana'diel mission, page id 202). Data only; see progress/missions/adoulin/134.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_20_Temporary_Farewells.lua (the ??? `qm_rov2_20` in Misareaux Coast plays event 15 only while
-- this mission is current; its finish is `mission:complete`, nothing is asked). No client event script for it.
-- The rov line has no completed set, so the completion is `min = 204` (Brushing Up, LSB 96).
return {
    title = 'Temporary Farewells',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 202}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to misareaux coast g 5'},
         done = {
            {t = 'event', zone = 25, event = 15, why = 'Misareaux Coast ??? 15: the mission scene, its finish completes'},
            {t = 'mission', line = 'rov', min = 204, why = 'mission log: the line moved past Temporary Farewells'},
         }},
    },
}

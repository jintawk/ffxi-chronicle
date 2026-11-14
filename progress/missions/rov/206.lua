-- Step progress for Keep On Giving (Rhapsodies of Vana'diel mission, page id 206). Data only; see progress/missions/adoulin/134.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_22_Keep_On_Giving.lua: the ??? `qm_rov2_20` in Misareaux Coast plays event 17 only on a trade
-- of the food chosen in Brushing Up (a wrong trade plays nothing), and its finish is `mission:complete` plus `tradeComplete`. The default
-- talk (event 19, a reminder of the wanted food) is not used. No client event script for 17.
-- The rov line has no completed set, so the completion is `min = 208` (Past Imperfect, LSB 100).
return {
    title = 'Keep On Giving',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 206}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'obtain the food iroha asks for'},
         done = {
            {t = 'event', zone = 25, event = 17, why = 'Misareaux Coast ??? 17: the right food traded, its finish completes'},
            {t = 'mission', line = 'rov', min = 208, why = 'mission log: the line moved past Keep On Giving'},
         }},
    },
}

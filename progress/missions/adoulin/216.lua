-- Step progress for An Extraordinary Gentleman (Seekers of Adoulin, mission page id 216). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_4_2_An_Extraordinary_Gentleman.lua. Levil (Western Adoulin 256) plays 135 only
-- while this mission is current, and its finish completes the mission, so it proves the talk with Levil (bullet 1). The menu
-- choice (bullet 2) and the troubleshooting tip (bullet 3, about the cutscene not triggering) have no signal of their own and are
-- notes on bullet 1; the draft put the completion on the tip. The adoulin line has no completed set: `min = 217`.
return {
    title = 'An Extraordinary Gentleman',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 216}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to the pioneers coalition and'},
         done = {
            {t = 'event', zone = 256, event = 135, why = 'Levil 135: the cutscene, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 217, why = 'mission log: the line moved past An Extraordinary Gentleman'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'select the first option ortharsyne'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'if speaking to levil is not'}},
    },
}

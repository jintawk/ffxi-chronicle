-- Step progress for Clear Skies (Seekers of Adoulin, mission page id 210). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_3_5_Clear_Skies.lua. Levil (Western Adoulin 256) plays 133 only once the Vana'diel
-- day timer has passed, and its finish completes the mission; before that he plays the reminder 141, which proves nothing. The
-- first bullet (wait a day) has no signal of its own and is a note on the Levil step. The adoulin line has no completed set:
-- `min = 211`. The client script for Levil 133 has no text.
return {
    title = 'Clear Skies',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 210}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'wait a game day from the'}},
        {id = 's2', at = {n = 2, fp = 'speak to levil in the pioneers'},
         done = {
            {t = 'event', zone = 256, event = 133, why = 'Levil 133: only after the day has passed, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 211, why = 'mission log: the line moved past Clear Skies'},
         }},
    },
}

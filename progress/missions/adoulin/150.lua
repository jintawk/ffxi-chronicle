-- Step progress for Friction and Fissures (Seekers of Adoulin mission, page id 150). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_5_0_Friction_and_Fissures.lua. Levil (Western Adoulin 256) plays event 123 once the
-- Vana'diel-day timer has passed, and its finish completes the mission; before that he plays the reminder 127, which proves nothing
-- and is not used. The adoulin line has no completed set (packet value = page id), so the completion is `min = 151`, not
-- `completed = true`.
return {
    title = 'Friction and Fissures',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 150}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to levil at the pioneers'},
         done = {
            {t = 'event', zone = 256, event = 123, why = 'Levil 123 (after the timer), finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 151, why = 'mission log: the line moved past Friction and Fissures'},
         }},
    },
}

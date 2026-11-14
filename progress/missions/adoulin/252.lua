-- Step progress for ...Into the Fire (Seekers of Adoulin mission 4-1-0, page id 252). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_1_0_Into_the_Fire.lua. Kipligg (Western Adoulin 256) plays event 155 as the mission's own
-- progress event and its finish always completes the mission (the client body is empty). Rejected: Levil 161 (a reminder dialogue
-- while current). The line has no completed set, so the end is `min = 253`.
return {
    title = '...Into the Fire',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 252}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kipligg at the entrance'},
         done = {
            {t = 'event', zone = 256, event = 155, why = 'Kipligg 155: finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 253, why = 'mission line moved past ...Into the Fire'},
         }},
    },
}

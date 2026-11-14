-- Step progress for Pioneer Registration (Seekers of Adoulin mission 1-5, mission id 122). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/1_5_Pioneer_Registration.lua. Brenton's event 3 (Western Adoulin) plays on every
-- talk while this mission is current and its finish completes it and gives the Pioneer's Badge. The client script for Brenton
-- has empty bodies for 3 and 4, so no line is available. The other NPC events in the script play after the completion and
-- prove nothing. The adoulin line has no completed set, so the completion is `min = 123`.
return {
    title = 'Pioneer Registration',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 122}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'proceed to the pioneers coalition at'},
         done = {
            {t = 'event', zone = 256, event = 3, why = 'Brenton 3: the cutscene, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 123, why = 'mission log: the line moved past Pioneer Registration'},
         }},
    },
}

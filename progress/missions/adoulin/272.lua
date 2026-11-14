-- Step progress for Darrcuiln (Seekers of Adoulin mission 4-2-4, mission id 272). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/soa/4_2_4_Darrcuiln.lua. The Darkened Crevice in Woh Gates (zone 273) plays event 8
-- only while this mission is current, and its finish completes the mission and gives the Tuft of golden fur. The client script
-- (S4 273_Darkened_Crevice_011111DD) has no dialogue for event 8. The Tuft (key item 2552) is not used: it is the reward and the
-- Large Animal Track gives it again, so it proves nothing alone. Levil's 165 is a reminder and proves nothing. The adoulin line
-- has no completed set, so the completion is `min = 273`.
return {
    title = 'Darrcuiln',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 272}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the spot darkened crevice in'},
         done = {
            {t = 'event', zone = 273, event = 8, why = 'Darkened Crevice 8, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 273, why = 'mission log: the line moved past Darrcuiln'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'you will receive the tuft of'}},
    },
}

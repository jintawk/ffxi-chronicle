-- Step progress for Sugarcoated Salvation (Seekers of Adoulin mission 4-5-3, mission page id 314). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_5_3_Sugarcoated_Salvation.lua. Ploh Trishbahk (Eastern Adoulin 257) plays 1537 on
-- any talk while this mission is current, no refusal path; its finish takes the "Suffering Sacchariferous" key item (2598,
-- temporary, from the last mission) and completes the mission. The Sepulcher ensign is the reward (it can already be owned), so
-- it is not used. Andreine's 8 and Levil's 40 are reminders. The adoulin line has no completed set: `min = 315`. No client
-- script is decoded for 1537.
return {
    title = 'Sugarcoated Salvation',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 314}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to ploh trishbahk for a'},
         done = {
            {t = 'event', zone = 257, event = 1537, why = 'Ploh Trishbahk 1537, finish completes the mission'},
            {t = 'ki', id = 2598, gained = false, why = '"Suffering Sacchariferous" handed over'},
            {t = 'mission', line = 'adoulin', min = 315, why = 'mission log: the line moved past Sugarcoated Salvation'},
         }},
    },
}

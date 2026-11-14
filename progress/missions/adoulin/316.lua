-- Step progress for Arciela's Resolve (Seekers of Adoulin mission 4-5-4, mission page id 316). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_5_4_Arcielas_Resolve.lua. The Royal Sepulcher (Rala Waterways 258) plays 368 on any
-- click while this mission is current, no refusal path, and its finish completes the mission. Ploh Trishbahk's 1546 and Levil's
-- 40 are reminders. The adoulin line has no completed set: `min = 317`. Bullet 1 (the way in) is a note on bullet 2. No client
-- script is decoded for 368.
return {
    title = "Arciela's Resolve",
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 316}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'enter rala waterways from eastern adoulin'}},
        {id = 's2', at = {n = 2, fp = 'head to n 10 very south'},
         done = {
            {t = 'event', zone = 258, event = 368, why = 'Royal Sepulcher 368, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 317, why = "mission log: the line moved past Arciela's Resolve"},
         }},
    },
}

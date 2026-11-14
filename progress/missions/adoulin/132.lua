-- Step progress for Budding Prospects (Seekers of Adoulin mission 2-1-1, mission id 132). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_1_0_Budding_Prospects.lua and the client scripts S4 256_Levil_01100091 (event 102)
-- and 256_Masad_01100165 (event 8, an empty cutscene). Levil's 102 ("We need information more than anything else ... the
-- Mummers' Coalition") plays only while this mission is current and is what bullet 1 asks for, so it proves that talk (nothing
-- later needs it). Masad's 8 plays only once Flavors of Our Lives is done, or its wait has passed, and its finish completes the
-- mission. Bullet 2 is the Flavors of Our Lives detour (a note on Masad's step). The adoulin line has no completed set, so the
-- completion is `min = 133`. The draft's `completed = true` matcher is dropped.
return {
    title = 'Budding Prospects',
    completes = 's3',
    known = {{t = 'mission', line = 'adoulin', eq = 132}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to the pioneers coalition and'},
         done = {
            {t = 'event', zone = 256, event = 102, why = 'Levil 102: his briefing, played only while this mission is current'},
            {t = 'chat', re = 'we need information more than anything else', why = 'Levil 102 (say #8504)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'if you haven t started the'}},
        {id = 's3', at = {n = 3, fp = 'go to the mummers coalition and'},
         done = {
            {t = 'event', zone = 256, event = 8, why = 'Masad 8: the mission scene, its finish completes'},
            {t = 'mission', line = 'adoulin', min = 133, why = 'mission log: the line moved past Budding Prospects'},
         }},
    },
}

-- Step progress for Tree Grafting (Seekers of Adoulin mission 4-3-4, mission id 284). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/soa/4_3_4_Tree_Grafting.lua. Levil (Western Adoulin 256) plays event 160 while the
-- mission is current and its finish completes it; 160 belongs to this mission alone in the client script (S4 256_Levil_01100091
-- lists no other owner). Ploh Trishbahk's 1530 is a reminder pointing to Levil and proves nothing. The adoulin line has no
-- completed set (`min = 285`).
return {
    title = 'Tree Grafting',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 284}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to levil at the pioneers'},
         done = {
            {t = 'event', zone = 256, event = 160, why = 'Levil 160, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 285, why = 'mission log: the line moved past Tree Grafting'},
         }},
    },
}

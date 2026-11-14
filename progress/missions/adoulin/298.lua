-- Step progress for Seeds of Doubt (Seekers of Adoulin mission 4-4-1, mission id 298). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/soa/4_4_1_Seeds_of_Doubt.lua and the client script S4 258_Chalvava_01102140 (event 367 has
-- no dialogue). Chalvava in Rala Waterways (zone 258) plays 367 while the mission is current and its finish completes it. Levil's
-- 40 and Ploh Trishbahk's 1540 are reminders. Bullet 1 (the way to Chalvava) is a note on bullet 2. The adoulin line has no
-- completed set (`min = 299`).
return {
    title = 'Seeds of Doubt',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 298}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'enter rala waterways from western adoulin'}},
        {id = 's2', at = {n = 2, fp = 'speak to chalvava for a cutscene'},
         done = {
            {t = 'event', zone = 258, event = 367, why = 'Chalvava 367, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 299, why = 'mission log: the line moved past Seeds of Doubt'},
         }},
    },
}

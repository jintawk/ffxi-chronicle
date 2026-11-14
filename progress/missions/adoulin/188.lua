-- Step progress for A Curse from the Past (Seekers of Adoulin mission, page id 188). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_1_2_A_Curse_from_the_Past.lua and the client scripts S4 257_Ploh_Trishbahk,
-- 257_Rigobertine, 257_Erminold. Ploh 1519 plays once, before any item is found (client text "Ingrrrid herself has left me with a
-- message for you."), and proves bullet 1. Rigobertine 1521 plays only without the Eternal flame and hands it over (key item 2456),
-- so the event and the key prove bullet 2. Fontis Xanira (Vial of untainted holy water, 2455) and the Sunrise Beacon (Piece of a
-- stone wall, 2454) give their key items only while the mission is at status 1, which Rigobertine's event sets, so each key proves
-- its bullet and implies bullet 2. The two can be done in either order, so each is a group of its own. Erminold 1525 plays only
-- when both are held, its finish completes the mission (client text "Well, what have we here? You must be the pioneer after that
-- weather vane."), so it proves bullet 5 and implies bullets 3 and 4. The Weather vane wings are the reward, so they are not used.
-- The four key items are deleted by the next mission, hence the min on bullet 5. The adoulin line (packet value = page id, no
-- completed set) moves past 188: `min = 189`. Bullet 6 is a note.
return {
    title = 'A Curse from the Past',
    completes = 's5',
    known = {{t = 'mission', line = 'adoulin', eq = 188}},
    groups = {
        main = {start = {{t = 'mission', line = 'adoulin', eq = 188, why = 'mission line: current mission = A Curse from the Past'}}},
        vial = {start = {{t = 'mission', line = 'adoulin', eq = 188, why = 'mission line: current mission = A Curse from the Past'}}},
        wall = {start = {{t = 'mission', line = 'adoulin', eq = 188, why = 'mission line: current mission = A Curse from the Past'}}},
    },
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ploh trishbahk k 9'},
         done = {
            {t = 'event', zone = 257, event = 1519, why = 'Ploh Trishbahk 1519: the list of items (plays once, only in this mission)'},
            {t = 'chat', re = 'ingrrrid herself has left me with a message for you', why = 'Ploh Trishbahk 1519 (say #8610)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to rigobertine in the south'},
         done = {
            {t = 'event', zone = 257, event = 1521, why = 'Rigobertine 1521: plays only without the Eternal flame, gives it'},
            {t = 'ki', id = 2456, gained = true, why = 'Eternal flame obtained'},
            {t = 'ki_have', id = 2456, have = true, why = 'Eternal flame held'},
            {t = 'chat', re = 'obtained key item: eternal flame', why = 'chat: key item obtained'},
         }},
        {id = 's3', group = 'vial', implies = {'s2'}, at = {n = 3, fp = 'go to platea triumphus in western'},
         done = {
            {t = 'ki', id = 2455, gained = true, why = 'Vial of untainted holy water obtained (Fontis Xanira)'},
            {t = 'ki_have', id = 2455, have = true, why = 'Vial of untainted holy water held'},
            {t = 'chat', re = 'obtained key item: vial of untainted holy water', why = 'chat: key item obtained'},
         }},
        {id = 's4', group = 'wall', implies = {'s2'}, at = {n = 4, fp = 'go to the western adoulin waterfront'},
         done = {
            {t = 'ki', id = 2454, gained = true, why = 'Piece of a stone wall obtained (Sunrise Beacon)'},
            {t = 'ki_have', id = 2454, have = true, why = 'Piece of a stone wall held'},
            {t = 'chat', re = 'obtained key item: piece of a stone wall', why = 'chat: key item obtained'},
         }},
        {id = 's5', implies = {'s3', 's4'}, at = {n = 5, fp = 'speak to erminold at j 10'},
         done = {
            {t = 'event', zone = 257, event = 1525, why = 'Erminold 1525: plays only with both items, its finish completes the mission'},
            {t = 'chat', re = 'well, what have we here%? you must be the pioneer after that weather vane', why = 'Erminold 1525 (say #8635)'},
            {t = 'mission', line = 'adoulin', min = 189, why = 'mission log: the line moved past A Curse from the Past'},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'after obtaining the 4 key items'}},
    },
}

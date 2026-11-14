-- Step progress for A Grave Mistake (Seekers of Adoulin mission 4-4-3, mission page id 302). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_4_3_A_Grave_Mistake.lua and the key item list. Stout Weir (Rala Waterways 258) plays 371
-- only while the Broken fuse (temporary key item 2601) is missing and its finish gives it, so the key item gain and 371 prove
-- bullet 3. Bullets 1 and 2 (click the three points: Sainene, the Waterway Overlook, Stout Weir) are notes on bullet 3: the
-- Overlook plays no event (a message only) and Sainene's 372 (and 371) show one point each, so nothing proves all three except
-- Ploh Trishbahk's 1534, which plays only once all three bits are set (Status 7) and whose finish takes the fuse and completes
-- the mission: it, the fuse leaving the key items and the line moving on prove bullet 4. Ploh's 1541 (not all clicked), Levil's
-- 40, Sainene's 320 and Stout Weir's 373 are reminders and prove nothing. The adoulin line has no completed set: `min = 303`.
-- The draft's `completed = true` could never match. No client script is decoded for these events.
return {
    title = 'A Grave Mistake',
    completes = 's4',
    known = {{t = 'mission', line = 'adoulin', eq = 302}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'enter the rala waterways and click'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'the 3 points are'}},
        {id = 's3', at = {n = 3, fp = 'you will receive a broken fuse'},
         done = {
            {t = 'ki', id = 2601, gained = true, why = 'Broken fuse obtained (Stout Weir)'},
            {t = 'ki_have', id = 2601, have = true, why = 'Broken fuse held'},
            {t = 'chat', re = 'obtained key item: broken fuse', why = 'chat: key item obtained'},
            {t = 'event', zone = 258, event = 371, why = 'Stout Weir 371: only without the fuse, finish gives it'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to castle adoulin and speak'},
         done = {
            {t = 'event', zone = 257, event = 1534, why = 'Ploh Trishbahk 1534: only with all three points clicked, finish completes the mission'},
            {t = 'ki', id = 2601, gained = false, why = 'Broken fuse handed over'},
            {t = 'mission', line = 'adoulin', min = 303, why = 'mission log: the line moved past A Grave Mistake'},
         }},
    },
}

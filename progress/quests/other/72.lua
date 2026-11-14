-- Step progress for Unforgiven (Other Areas quest 72). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Unforgiven.lua (Elysia 200 begins the quest; 201 is her reminder to find the
-- hairpin; the third-floor ??? gives the Alabaster hairpin, Temporary KI 609; Elysia 202 plays while it is held, takes it and sets
-- Prog 1; 203 is her reminder to talk to Pradiulot; Pradiulot 204 at Prog 1 completes the quest; after completion Elysia plays
-- 205 and then Pradiulot 206); client event script S4 026_Elysia_0101A044.txt (201 say #10849, 203 say #10867, 205 say #10889;
-- 200 and 202 are bare) and 026_Pradiulot_0101A042.txt (204 and 206 are bare). The draft piled Elysia 202, 203 and 201 on the
-- begin step; 202 is bullet 3. Bullet 5 is two cutscenes: Elysia 205 is a reach and Pradiulot 206 ends it.
return {
    title = 'Unforgiven',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to elysia first floor g'},
         done = {
            {t = 'event', zone = 26, event = 200, why = 'Elysia 200: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 26, event = 201, conf = 'inferred', why = 'Elysia 201: her reminder to find the hairpin'},
            {t = 'chat', re = 'I might have dropped the hairpin while carrying groceries from the upper level of the safehold%.', conf = 'inferred', why = 'Elysia 201 (say #10849)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head up to the third floor'},
         done = {
            {t = 'ki', id = 609, gained = true, why = 'Alabaster hairpin obtained'},
            {t = 'ki_have', id = 609, have = true, why = 'Alabaster hairpin held'},
            {t = 'chat', re = 'obtained key item: alabaster hairpin', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to elysia'},
         done = {
            {t = 'event', zone = 26, event = 202, after = 's1', why = 'Elysia 202: the hairpin held and taken (Prog 1)'},
            {t = 'ki', id = 609, gained = false, conf = 'inferred', why = 'Alabaster hairpin handed over'},
            {t = 'event', zone = 26, event = 203, conf = 'inferred', why = 'Elysia 203: her reminder to talk to Pradiulot (Prog 1)'},
            {t = 'chat', re = 'Have you found Pradiulot and told him that I will be waiting for him by the well%?', conf = 'inferred', why = 'Elysia 203 (say #10867)'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to pradiulot h 9'},
         done = {
            {t = 'event', zone = 26, event = 204, after = 's1', why = 'Pradiulot 204: completes the quest (Prog 1)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's5', kind = 'post', at = {n = 5, fp = 'for an additional cutscene that continues'},
         done = {
            {t = 'event', zone = 26, event = 206, after = 's4', why = 'Pradiulot 206: the closing cutscene'},
         },
         reach = {
            {t = 'event', zone = 26, event = 205, after = 's4', why = 'Elysia 205: the first after-quest cutscene'},
            {t = 'chat', re = 'Pradiulot was that upset%?', after = 's4', why = 'Elysia 205 (say #10889)'},
         }},
    },
}

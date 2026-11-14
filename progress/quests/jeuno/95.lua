-- Step progress for Lakeside Minuet (Jeuno quest 95). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Lakeside_Minuet.lua (Laila 10111 is the offer and only option 1 begins the
-- quest, so it is a reach; 10112 is her talk while accepted; Rhea Myuliah 10113 at Prog 0, 10114 her reminder at Prog 1;
-- Valderotaux 888 at Prog 1, 889 his reminder; Rhea 10115 at Prog 2 sets Prog 3; the Glowing Pebbles in Jugner Forest [S]
-- play 100 at Prog 3 and give the Stardust pebble; Laila 10118 with the pebble held runs quest:complete, takes the pebble
-- and has no item to refuse); client event scripts S4 244_Laila_010F40BD.txt, 244_Rhea_Myuliah_010F40BB.txt and
-- 244_Rhea_Myuliah_010F40BE.txt (10114 say #11836; the others are bare), 230_Valderotaux_010E60CD.txt (889 say #13464).
-- Key item 911 (stardust pebble) from res/key_items.lua; zone ids from res/zones.lua (244 Upper Jeuno, 230 Southern
-- San d'Oria, 82 Jugner Forest [S]). The pebble request (n=2) is part of the first cutscene and the trip to the past (n=6)
-- is a note on the pebbles. The quest log is set at s1, so it is not silent. Not repeatable (page meta).
return {
    title = 'Lakeside Minuet',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with laila at g 7 in'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Laila 10111, option 1)'},
            {t = 'event', zone = 244, event = 10112, conf = 'inferred', why = 'Laila 10112: her talk, only while accepted'},
         },
         reach = {{t = 'event', zone = 244, event = 10111, why = 'Laila 10111 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'she will then ask for a stardust'}},
        {id = 's3', at = {n = 3, fp = 'speak with the mithran dancer rhea'},
         done = {
            {t = 'event', zone = 244, event = 10113, why = 'Rhea Myuliah 10113 (Prog 0)'},
            {t = 'event', zone = 244, event = 10114, conf = 'inferred', why = 'Rhea Myuliah 10114: reminder at Prog 1'},
            {t = 'chat', re = 'If you have the courrrage to dance on the stage in the Lion Springs Tavern', conf = 'inferred', why = 'Rhea Myuliah 10114 (say #11836)'},
         }},
        {id = 's4', at = {n = 4, fp = 'head to lion springs tavern at'},
         done = {
            {t = 'event', zone = 230, event = 888, why = 'Valderotaux 888 (Prog 1)'},
            {t = 'event', zone = 230, event = 889, conf = 'inferred', why = 'Valderotaux 889: reminder at Prog 2 and later'},
            {t = 'chat', re = 'Your dancing style was%.%.%.quite unique%.%.%.', conf = 'inferred', why = 'Valderotaux 889 (say #13464)'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to rhea myuliah in upper'},
         done = {
            {t = 'event', zone = 244, event = 10115, why = 'Rhea Myuliah 10115 (Prog 2)'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'travel to the past and go'}},
        {id = 's7', at = {n = 7, fp = 'touch the glowing pebbles targetable'},
         done = {
            {t = 'event', zone = 82, event = 100, why = 'Glowing Pebbles 100 (Prog 3)'},
            {t = 'ki', id = 911, gained = true, why = 'stardust pebble obtained'},
            {t = 'ki_have', id = 911, have = true, why = 'stardust pebble held'},
            {t = 'chat', re = 'obtained key item: stardust pebble', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'speak with laila in upper jeuno'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 244, event = 10118, why = 'Laila 10118: the pebble handed over, runs quest:complete'},
            {t = 'ki', id = 911, gained = false, after = 's7', conf = 'inferred', why = 'stardust pebble handed over'},
         }},
    },
}

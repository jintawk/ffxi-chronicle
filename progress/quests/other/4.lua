-- Step progress for Expertise (quest other 4). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/RQ5_Expertise.lua (Take 61 has no menu and runs quest:begin, so it is the
-- accept; Take 65 is shared with four other quests and Rycharde 89 is the "no work" line, neither used; accepted, Valgeir
-- 102 asks for the ingredients (Prog 1), 104 is his reminder; trading exactly a Scream Fungus and a Slice of Land Crab Meat
-- is 103 (Prog 2, ready after 24 Vana'diel hours), 141 is "not done yet"; 105 hands over the Land crab bisque (key item 91)
-- and 142 is his talk afterwards; Take 62 takes the bisque and runs quest:complete, but the Tableware Set reward needs a free slot and the same event plays without one, so 62 is only a reach and the log bit and the key item loss prove the step; the dated log lines under the fifth
-- bullet are not steps). Client event scripts S4 249_Take_010F9008.txt (61 say #6928, 62 say #6934), 248_Valgeir_010F800B.txt
-- (102 say #6930, 103 say #6935, 104 say #6934, 105 say #6937, 141 say #6936, 142 say #6938). Not repeatable.
return {
    title = 'Expertise',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = '8 vanadiel days must pass after'}},
        {id = 's2', at = {n = 2, fp = 'speak to take in mhaura i'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Take 61 runs quest:begin)'},
            {t = 'event', zone = 249, event = 61, why = 'Take 61: the offer, no refusal'},
            {t = 'chat', re = "Hi, there%. You've been working for Rycharde for a while now", why = 'Take 61 (say #6928)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to valgeir in selbina i'},
         done = {
            {t = 'event', zone = 248, event = 102, why = 'Valgeir 102: asks for the ingredients'},
            {t = 'chat', re = 'You again! What is it this time%?', why = 'Valgeir 102 (say #6930)'},
            {t = 'event', zone = 248, event = 104, conf = 'inferred', why = 'Valgeir 104: his reminder, only after 102'},
            {t = 'chat', re = 'Where are those ingredients%?', conf = 'inferred', why = 'Valgeir 104 (say #6934)'},
         }},
        {id = 's4', at = {n = 4, fp = 'obtain 1 scream fungus and 1'},
         done = {
            {t = 'event', zone = 248, event = 103, why = 'Valgeir 103: both ingredients accepted'},
            {t = 'chat', re = 'Hmph%. So you found them, did you%?', why = 'Valgeir 103 (say #6935)'},
            {t = 'event', zone = 248, event = 141, conf = 'inferred', why = 'Valgeir 141: not done yet, only after 103'},
            {t = 'chat', re = "What now%? It's not done yet!", conf = 'inferred', why = 'Valgeir 141 (say #6936)'},
         }},
        {id = 's5', at = {n = 5, fp = 'wait 2 game days return to'},
         done = {
            {t = 'ki', id = 91, gained = true, why = 'land crab bisque obtained'},
            {t = 'ki_have', id = 91, have = true, why = 'land crab bisque held'},
            {t = 'event', zone = 248, event = 105, why = 'Valgeir 105: hands over the bisque'},
            {t = 'chat', re = 'Done! Now, take it and get out of here!', why = 'Valgeir 105 (say #6937)'},
            {t = 'chat', re = 'obtained key item: land crab bisque', why = 'chat: key item obtained'},
            {t = 'event', zone = 248, event = 142, conf = 'inferred', why = 'Valgeir 142: his talk after the bisque'},
            {t = 'chat', re = "What now%? It's done, so leave me in peace!", conf = 'inferred', why = 'Valgeir 142 (say #6938)'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to take and trade her'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 91, gained = false, why = 'land crab bisque taken (only inside quest:complete)'},
         },
         reach = {
            {t = 'event', zone = 249, event = 62, why = 'Take 62: the bisque trade (also plays with no room for the Tableware Set)'},
            {t = 'chat', re = "You went and brought me some of Valgeir's cooking%?", why = 'Take 62 (say #6934)'},
         }},
    },
}

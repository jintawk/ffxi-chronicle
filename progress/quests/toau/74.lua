-- Step progress for Waking the Colossus (Aht Urhgan quest 74). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Waking_the_Colossus.lua (Prog: 925 area-trigger cutscene sets 1 with no
-- choice; Imperial Whitegate 926 gives the Imperial missive and begins the quest on option 0; Audience Chamber 10115 sets 2,
-- 10116 gives the Jeunoan letter; Halver 567 / Iron Eater 968 / Kupipi 429 each give an approval letter on option 0 in any
-- order; Whitegate 927 swaps the five letters for the Present for Megomak; Acid-eaten Door 154 swaps it for the shopping list
-- on option 1, 155 takes 3 Slabs of Plumbago for the Lightning cell; blank lamp 306 sets 3, zone-in 307 in Alzadaal gives the
-- Whisper of radiance after the BCNM; Whitegate 928 (option 0) sets 5; Naja 929 pays the reward and completes only if the
-- reward could be given, so it replays on a full bag and is a reach). No client script for these actors, so no dialogue line
-- is usable beyond the key item messages. The three letters (bullet 4) are any order: no single one proves the bullet, so
-- the bullet is a branch (never ticked early) whose letters and talks are reaches, and the Jeunoan letter, which needs all three,
-- carries it by inference. Whitegate 928 (bullet 12) finishes only on option 0, so that bullet is a note on the reward talk. The Cast
-- metal plate named under bullet 7 comes from elsewhere (the Gates of Halvung), so it is not a signal. The Runic Seal /
-- BCNM entry (bullet 10) is shared by every battlefield: a note. Not repeatable.
return {
    title = 'Waking the Colossus',
    completes = 's13',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach naja salaheem in aht urhgan'},
         done = {
            {t = 'event', zone = 50, event = 925, why = 'area-trigger cutscene 925 that begins the quest (no choice), sets Prog 1'},
         }},
        {id = 's2', at = {n = 2, fp = 'examine imperial whitegate at aht urhgan'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 1240, gained = true, why = 'Imperial missive obtained'},
            {t = 'ki_have', id = 1240, have = true, why = 'Imperial missive held'},
            {t = 'chat', re = 'obtained key item: imperial missive', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 50, event = 926, why = 'Imperial Whitegate 926 offered (its finish needs option 0)'}}},
        {id = 's3', at = {n = 3, fp = 'examine the audience chamber in ru'},
         done = {
            {t = 'event', zone = 243, event = 10115, why = 'Audience Chamber 10115: cutscene with no choice, sets Prog 2'},
         }},
        {id = 's4', kind = 'branch', at = {n = 4, fp = 'you must speak to representatives from'},
         reach = {
            {t = 'ki', id = 1241, gained = true, why = "San d'Orian approval letter obtained"},
            {t = 'ki', id = 1242, gained = true, why = 'Bastokan approval letter obtained'},
            {t = 'ki', id = 1243, gained = true, why = 'Windurstian approval letter obtained'},
            {t = 'event', zone = 233, event = 567, why = 'Halver 567 offered (its finish needs option 0)'},
            {t = 'event', zone = 237, event = 968, why = 'Iron Eater 968 offered (its finish needs option 0)'},
            {t = 'event', zone = 242, event = 429, why = 'Kupipi 429 offered (its finish needs option 0)'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to the audience chamber in'},
         done = {
            {t = 'ki', id = 1244, gained = true, why = 'Jeunoan approval letter obtained'},
            {t = 'ki_have', id = 1244, have = true, why = 'Jeunoan approval letter held'},
            {t = 'chat', re = 'obtained key item: jeunoan approval letter', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 243, event = 10116, why = 'Audience Chamber 10116 offered once all three letters are held (its finish needs option 0)'}}},
        {id = 's6', at = {n = 6, fp = 'examine imperial whitegate at aht urhgan'},
         done = {
            {t = 'ki', id = 1245, gained = true, why = 'Present for Megomak obtained'},
            {t = 'ki_have', id = 1245, have = true, why = 'Present for Megomak held'},
            {t = 'chat', re = 'obtained key item: present for megomak', why = 'chat: key item obtained'},
            {t = 'ki', id = 1240, gained = false, conf = 'inferred', why = 'Imperial missive handed over'},
         },
         reach = {{t = 'event', zone = 50, event = 927, why = 'Imperial Whitegate 927 offered (its finish needs option 0)'}}},
        {id = 's7', at = {n = 7, fp = 'examine the acid eaten door in'},
         done = {
            {t = 'ki', id = 1247, gained = true, why = "Megomak's shopping list obtained"},
            {t = 'ki_have', id = 1247, have = true, why = "Megomak's shopping list held"},
            {t = 'chat', re = "obtained key item: megomak's shopping list", why = 'chat: key item obtained'},
            {t = 'ki', id = 1245, gained = false, conf = 'inferred', why = 'Present for Megomak handed over'},
         },
         reach = {{t = 'event', zone = 61, event = 154, why = 'Acid-eaten Door 154 offered (its finish needs option 1)'}}},
        {id = 's8', at = {n = 8, fp = 'trade 3 slabs of plumbago to'},
         done = {
            {t = 'event', zone = 61, event = 155, why = 'Acid-eaten Door 155: exactly three slabs traded'},
            {t = 'ki', id = 1246, gained = true, why = 'Lightning cell obtained'},
            {t = 'ki_have', id = 1246, have = true, why = 'Lightning cell held'},
            {t = 'chat', re = 'obtained key item: lightning cell', why = 'chat: key item obtained'},
         }},
        {id = 's9', at = {n = 9, fp = 'examine the blank target on the'},
         done = {
            {t = 'event', zone = 72, event = 306, why = 'blank lamp 306: cutscene with the Lightning cell held, sets Prog 3'},
         }},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'examine the runic seal in alzadaal'}},
        {id = 's11', at = {n = 11, fp = 'upon defeating the bcnm you will'},
         done = {
            {t = 'zonein', zone = 72, event = 307, why = 'zone-in cutscene 307 after the battlefield, gives the key item'},
            {t = 'ki', id = 1248, gained = true, why = 'Whisper of radiance obtained'},
            {t = 'ki_have', id = 1248, have = true, why = 'Whisper of radiance held'},
            {t = 'chat', re = 'obtained key item: whisper of radiance', why = 'chat: key item obtained'},
         }},
        {id = 's12', kind = 'note', with = 's13', at = {n = 12, fp = 'examine imperial whitegate at aht urhgan'}},
        {id = 's13', at = {n = 13, fp = 'speak to naja salaheem to choose'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 1248, gained = false, after = 's11', conf = 'inferred', why = 'Whisper of radiance handed over'},
         },
         reach = {{t = 'event', zone = 50, event = 929, why = 'Naja Salaheem 929 (replays when the reward cannot be given)'}}},
    },
}

-- Step progress for Chocobo's Wounds (Jeuno quest 4). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Chocobos_Wounds.lua (Brutus 71 is a two-menu offer and only option 1, the
-- "Nope, never." answer, begins the quest; while accepted Brutus talks 65 then 66 then 102 and the Chocobo talks 62 or 63;
-- trading Gausebit Wildgrass to the Chocobo plays 57, 58, 99, 59, 60 and 64 by the stage, 57 and 58 without using a grass,
-- and 73 inside the 45 second timer; the sixth, 64, runs quest:complete and gives the Chocobo license key item, so there
-- is no item to refuse). Brutus 66 is not used: it is also his plain talk before the quest. Client event scripts S4
-- 244_Brutus_010F400C.txt (71: the Nope, never. answer says #7124, or #7115 to #7117 after an earlier decline) and
-- 244_Chocobo_010F400A.txt (62 say #7137, 63 say #7165). Key item 138 from res/key_items.lua. The first bullet (the Chocobo on the Loose offer) and
-- grass hunt leave no trace of their own and stay plain bullets. Bullet 6 only points at the next quest, so it is a note.
-- Not repeatable.
return {
    title = "Chocobo's Wounds",
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'speak to him two more times'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Brutus 71, option 1)'},
            {t = 'chat', re = 'Of course you wouldn.t!', why = 'Brutus 71, Nope never. branch (say #7124)'},
            {t = 'chat', re = 'All right, then%.%.%. See that chocobo%? If it takes to you, I.ll let you ride%.', why = 'Brutus 71, Nope never. branch after a decline (say #7116)'},
            {t = 'event', zone = 244, event = 65, conf = 'inferred', why = 'Brutus 65: his talk, only while accepted at the first stage'},
            {t = 'event', zone = 244, event = 62, conf = 'inferred', why = 'Chocobo 62: only while accepted before the third feeding'},
         },
         reach = {{t = 'event', zone = 244, event = 71, why = 'Brutus 71 offered (its finish needs option 1)'}}},
        {id = 's4', at = {n = 4, fp = 'feed the chocobo standing next to'},
         done = {
            {t = 'event', zone = 244, event = 99, why = 'Chocobo 99: the third feeding, the first that uses a grass'},
            {t = 'event', zone = 244, event = 59, why = 'Chocobo 59: the fourth feeding'},
            {t = 'event', zone = 244, event = 60, why = 'Chocobo 60: the fifth feeding'},
            {t = 'event', zone = 244, event = 64, why = 'Chocobo 64: the sixth feeding'},
         },
         reach = {
            {t = 'event', zone = 244, event = 57, why = 'Chocobo 57: the first feeding (no grass used)'},
            {t = 'event', zone = 244, event = 58, why = 'Chocobo 58: the second feeding (no grass used)'},
         }},
        {id = 's5', at = {n = 5, fp = 'once the chocobo eats the gausebit'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 244, event = 64, why = 'Chocobo 64: the sixth feeding, runs quest:complete'},
            {t = 'ki', id = 138, gained = true, conf = 'inferred', why = 'Chocobo license obtained (reward)'},
            {t = 'chat', re = 'obtained key item: chocobo license', conf = 'inferred', why = 'chat: key item obtained'},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'you don t need to zone'}},
    },
}

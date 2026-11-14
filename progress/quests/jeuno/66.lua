-- Step progress for Searching for the Right Words (Jeuno quest 66). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Searching_for_the_Right_Words.lua. Kurou-Morou (Lower Jeuno 245) plays 17 at the
-- first talk (a bare cutscene), then 38 and 36 while the quest is not yet added; the quest is added only by Ilumida (Upper
-- Jeuno 244: 197 and 201 are the long and short offers and only option 1 begins it, so they are only a reach; 201's "What a kind
-- young lad/lady you are" plays on "Yes" only), so the log is silent before step 2; the ??? (qm2) in The Boyahda Tree (153) pops
-- Agas with only a shared "Something is not right!" line, and plays 14 after Agas falls, which gives key item 476 on option 0
-- (only a reach); Ilumida 198 runs quest:complete and cannot give the gil and Scroll of Sleepga II reward on a full bag while 198
-- still plays, so it is only a reach and the quest log's completed bit carries step 5 (the key item is taken only on success);
-- afterwards Kurou-Morou plays 154 when spoken to once more (the optional last bullet). Client event scripts S4
-- 245_Kurou_Morou_010F5022.txt (17, 154 bare; 38 say #8531, 36 say #8533) and 244_Ilumida_010F401B.txt (201 say #8130, 199
-- say #8134); event 14 in the Boyahda Tree is in LandSandBoat only (no decoded client script); key item 476 (moondrop) from
-- res/key_items.lua, used by no other quest. The spawn trip is a note: Agas's pop leaves no unique line. Not repeatable (page meta).
-- The Agas notes below the walkthrough are plain.
return {
    title = 'Searching for the Right Words',
    completes = 's5',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kurou morou after completing'},
         done = {
            {t = 'event', zone = 245, event = 17, why = 'Kurou-Morou 17: the first talk'},
            {t = 'event', zone = 245, event = 38, conf = 'inferred', why = 'Kurou-Morou 38: his talk once 17 is seen'},
            {t = 'chat', re = "Oh, what should I do!%? I don't want to regretaru", conf = 'inferred', why = 'Kurou-Morou 38 (say #8531)'},
            {t = 'event', zone = 245, event = 36, conf = 'inferred', why = 'Kurou-Morou 36: his hint once 17 is seen'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to ilumida upper jeuno g'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Ilumida 197 or 201, option 1)'},
            {t = 'chat', re = 'I appreciate that you would take on such a dangerous task', why = 'Ilumida 201: "Yes" (say #8130)'},
            {t = 'event', zone = 244, event = 199, conf = 'inferred', why = 'Ilumida 199: her talk, only while accepted before the Moondrop'},
         },
         reach = {{t = 'event', zone = 244, event = 197, why = 'Ilumida 197 offered (its finish needs option 1)'},
                  {t = 'event', zone = 244, event = 201, why = 'Ilumida 201 offered (its finish needs option 1)'}}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'travel to the boyahda tree and'}},
        {id = 's4', at = {n = 4, fp = 'once defeated examine the again between'},
         done = {
            {t = 'ki', id = 476, gained = true, why = 'moondrop obtained'},
            {t = 'ki_have', id = 476, have = true, why = 'moondrop held'},
            {t = 'chat', re = 'obtained key item: moondrop', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 153, event = 14, why = 'the ??? 14 (the Moondrop follows on option 0)'}}},
        {id = 's5', at = {n = 5, fp = 'return to upper jeuno and talk'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 476, gained = false, conf = 'inferred', why = 'moondrop handed over (taken only when the quest completes)'},
         },
         reach = {{t = 'event', zone = 244, event = 198, why = 'Ilumida 198 (also plays when the reward cannot be given)'}}},
        {id = 's6', kind = 'optional', at = {n = 6, fp = 'you may speak to kurou morou'},
         done = {
            {t = 'event', zone = 245, event = 154, why = 'Kurou-Morou 154: the confession cutscene, after completion'},
         }},
    },
}

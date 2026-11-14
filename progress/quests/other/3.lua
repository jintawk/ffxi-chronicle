-- Step progress for His Name Is Valgeir (quest other 3). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/RQ4_His_Name_is_Valgeir.lua (Rycharde 86 is the offer: its menu repeats
-- until Yes, but it is still only an offer, so a reach; accepting gives the Aragoneu pizza key item (id 90, used by no other
-- quest) and runs quest:begin; Take 65 is shared with four other quests and the "All right! Go to the port" line with The
-- Basics, so neither is used; Valgeir 100 plays only while the pizza is held, and its onEventFinish removes it, Valgeir 101
-- plays after delivery; Rycharde 88 plays once the pizza is gone and runs quest:complete; the free ferry ride, Felisa 230,
-- is an optional sub-bullet); client event scripts S4 249_Rycharde_010F9009.txt (86 say #6916, 88 say #6926),
-- 248_Valgeir_010F800B.txt (100 say #6923, 101 say #6929). Not repeatable.
return {
    title = 'His Name Is Valgeir',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to rycharde who gives you'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 90, gained = true, why = 'Aragoneu pizza obtained'},
            {t = 'ki_have', id = 90, have = true, why = 'Aragoneu pizza held'},
            {t = 'chat', re = 'obtained key item: aragoneu pizza', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 249, event = 86, why = 'Rycharde 86 offered (the pizza and the log follow)'}}},
        {id = 's2', at = {n = 2, fp = 'deliver the pizza to valgeir selbina'},
         done = {
            {t = 'ki', id = 90, gained = false, why = 'Aragoneu pizza handed over (Valgeir 100 removes it)'},
            {t = 'event', zone = 248, event = 100, why = 'Valgeir 100: the pizza delivered'},
            {t = 'chat', re = "What's all this%? I didn't order anything%.", why = 'Valgeir 100 (say #6923)'},
            {t = 'event', zone = 248, event = 101, conf = 'inferred', why = 'Valgeir 101: his talk after delivery'},
            {t = 'chat', re = "What now%? I've nothing to say to you%.", conf = 'inferred', why = 'Valgeir 101 (say #6929)'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to rycharde for your reward'},
         done = {
            {t = 'event', zone = 249, event = 88, why = 'Rycharde 88: asks how it went, runs quest:complete'},
            {t = 'chat', re = 'Oh%.%.%.your reward, right%.', why = 'Rycharde 88 (say #6926, both answers)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'you need to wait two possibly'}},
    },
}

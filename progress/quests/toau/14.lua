-- Step progress for Fear of the Dark II (Aht Urhgan quest 14). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Fear_of_the_Dark_2.lua (Suldiran 14 is the offer, a menu whose first row
-- begins the quest and whose second row refuses, so 14 is only a reach; while accepted his talk is 15; trading exactly two Imp
-- Wings plays 16, which runs quest:complete, whose reward is gil and a title only, so 16 never replays on a full bag; once
-- completed his talk is 17 and the same trade plays 18, which pays 200 gil again). LandSandBoat gives no second offer, so the
-- repeat (page meta) is only the paid trade and no run is restarted. Client event script S4 048_Suldiran_010301FE.txt (15 say
-- #7962, 16 say #7963); 17 and 18 have no body there. The Besieged note (bullet 1) is a note on the offer. Imp Wing (item 2163)
-- counts toward the trade bullet. Shared-signal audit (2026-10-31): "My charm requires" (Suldiran 15, #7962) is also Secodiand's
-- Fear of the Dark III talk (zone 132 event 159, #7919) and "Thank you! This should hold the darkness at bay" is the completion
-- line of Fear of the Dark I (Secodiand, zone 231, #12109) and III (event 160, #7920), so s2 drops its chat matcher (nothing
-- precedes it to gate on; the quest bit and event 15 carry it) and s3 keeps that line only as support after s2.
return {
    title = 'Fear of the Dark II',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'if suldiran is taken prisoner during'}},
        {id = 's2', at = {n = 2, fp = 'speak to suldiran to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Suldiran 14, first row)'},
            {t = 'event', zone = 48, event = 15, why = 'Suldiran 15: his talk while accepted'},
         },
         reach = {{t = 'event', zone = 48, event = 14, why = 'Suldiran 14 offered (its finish needs option 1)'}}},
        {id = 's3', at = {n = 3, fp = 'trade suldiran 2 imp wings to'}, count = {item = 2163, need = 2},
         done = {
            {t = 'event', zone = 48, event = 16, why = 'Suldiran 16: two Imp Wings accepted, runs quest:complete'},
            {t = 'chat', re = 'Thank you! This should hold the darkness at bay', after = 's2', why = 'Suldiran 16 (say #7963, shared with Fear of the Dark I and III)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 48, event = 17, why = 'Suldiran 17: his talk once completed'},
            {t = 'event', zone = 48, event = 18, why = 'Suldiran 18: the paid repeat trade, only once completed'},
         }},
    },
}

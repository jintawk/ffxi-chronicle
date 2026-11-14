-- Step progress for Trial-Size Trial by Lightning (other areas quest 28). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Mhaura/npcs/Lacia.lua (event 10025 is the offer and, on option 1 with a free slot, adds
-- the quest and the Mini Tuning Fork of Lightning, so the event and its lines also play on a refusal and the log's current bit
-- is the proof; 10018 and 10029 are her talks while accepted; 10028 plays after completion; the fork traded to Lacia plays
-- 10026, a warp offer that plays whether or not it is taken) and scripts/battlefields/Cloister_of_Storms/
-- trial-size_trial_by_lightning.lua (a win runs completeQuest). Client event script S4 249_Lacia_010F9069.txt (10018 say
-- #7375, 10028 say #7496, 10029 say #7502). Not repeatable. Preparing, the warp and entering the arena are notes.
return {
    title = 'Trial-Size Trial by Lightning',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with lacia in mhaura i'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Lacia 10025, option 1)'},
            {t = 'event', zone = 249, event = 10018, conf = 'inferred', why = 'Lacia 10018: reminder, only while accepted'},
            {t = 'chat', re = "If you don't prepare yourself for battle, you'll get beaten to a pulp", conf = 'inferred', why = 'Lacia 10018 (say #7375)'},
            {t = 'event', zone = 249, event = 10029, conf = 'inferred', why = 'Lacia 10029: a lost fork replaced, only while accepted'},
            {t = 'chat', re = 'Remember that you must fight the prime avatar as a level', conf = 'inferred', why = 'Lacia 10029 (say #7502)'},
         },
         reach = {{t = 'event', zone = 249, event = 10025, why = 'Lacia 10025 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'you may prepare for the upcoming'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'trade the fork to the lightning'}},
        {id = 's4', at = {n = 4, fp = 'defeat ramuh prime to complete quest'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (battle won)'},
            {t = 'event', zone = 249, event = 10028, why = 'Lacia 10028: her talk once the quest is done'},
            {t = 'chat', re = 'You defeated the prime avatar!%?', why = 'Lacia 10028 (say #7496)'},
         }},
    },
}

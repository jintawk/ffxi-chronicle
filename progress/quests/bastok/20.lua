-- Step progress for Rivals (Bastok quest 20). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Rivals.lua (Detzo 93 begins it at Bastok fame 3; trading the Mythril Sallet is
-- event 94, which runs quest:complete, gives the Wolf Gorget and returns the Sallet); client event script S4
-- 234_Detzo_010EA016.txt (93 and 94 are cutscenes with no decoded line). Bullet 1 (get the Sallet) is a note on the accept.
-- Full-inventory rule: 94 plays the same with a full bag (the Gorget may not fit), so it is `reach` only and the quest log
-- proves s3. The quest log is set at s2, so it is not silent.
return {
    title = 'Rivals',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'obtain a mythril sallet from the'}},
        {id = 's2', at = {n = 2, fp = 'speak to detzo to begin quest'},
         done = {
            {t = 'event', zone = 234, event = 93, why = 'Detzo 93'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade sallet to detzo to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 234, event = 94, why = 'Detzo 94: the Mythril Sallet trade (also plays with a full bag)'}}},
    },
}

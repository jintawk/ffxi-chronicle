-- Step progress for Sleepless Nights (San d'Oria quest 80). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Sleepless_Nights.lua (Paouala 85 option 0 begins the quest; 83 is his
-- reminder, only while it is accepted; trading the Jug of Mary's Milk is event 84 and completes it); client event scripts S4
-- 230_Paouala_010E60C9.txt (84 say #8924, 83 say #8923). The page has no bullet for the first talk (85), so the accept
-- signals (event 85, its accept line, the quest log's current bit) prove no step: the current bit and event 83 only mark
-- the trade as in progress (reach). The first two bullets are notes on the trade.
return {
    title = 'Sleepless Nights',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'mary s milk is a drop'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'can also be bought off an'}},
        {id = 's3', at = {n = 3, fp = 'obtain one and trade it paouala'},
         done = {
            {t = 'event', zone = 230, event = 84, why = 'Paouala 84: the milk accepted'},
            {t = 'chat', re = 'Thank you! My snoring will express gratitude mere words cannot!', why = 'Paouala 84 (say #8924)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'quest', current = true, why = 'quest log: accepted at Paouala 85'},
            {t = 'event', zone = 230, event = 83, why = 'Paouala 83: reminder, only while accepted'},
         }},
    },
}

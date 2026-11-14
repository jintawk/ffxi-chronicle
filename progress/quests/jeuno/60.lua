-- Step progress for Wings of Gold (Jeuno quest 60). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Wings_of_Gold.lua (Brutus, Upper Jeuno 244: 139 and 137 are the offer and only
-- option 1 begins the quest, so they are only a reach; 136 is his talk while accepted and without the Guiding bell; the Treasure
-- Chest in Middle or Upper Delkfutt's Tower gives key item 232 to a player with the quest accepted; 138 plays only with the
-- Guiding bell held and runs quest:complete, but the Barbaroi Axe reward cannot be given on a full bag while 138 still plays,
-- so 138 is only a reach and the quest log's completed bit carries the last step; the key item is taken only on success);
-- client event script S4 244_Brutus_010F400C.txt (136 say #7726, 138 say #7727); key item id from res/key_items.lua
-- (232 guiding bell, used by no other quest). Not repeatable (page meta).
return {
    title = 'Wings of Gold',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to brutus as a level'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Brutus 139 or 137, option 1)'},
            {t = 'event', zone = 244, event = 136, conf = 'inferred', why = 'Brutus 136: his talk, only while accepted'},
         },
         reach = {{t = 'event', zone = 244, event = 139, why = 'Brutus 139 offered (its finish needs option 1)'},
                  {t = 'event', zone = 244, event = 137, why = 'Brutus 137 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'kill monsters on the 7th to'}},
        {id = 's3', at = {n = 3, fp = 'use the key to open a'},
         done = {
            {t = 'ki', id = 232, gained = true, why = 'guiding bell obtained'},
            {t = 'ki_have', id = 232, have = true, why = 'guiding bell held'},
            {t = 'chat', re = 'obtained key item: guiding bell', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to brutus for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 232, gained = false, conf = 'inferred', why = 'guiding bell handed over (taken only when the quest completes)'},
         },
         reach = {{t = 'event', zone = 244, event = 138, why = 'Brutus 138 (also plays when the Barbaroi Axe cannot be given)'},
                  {t = 'chat', re = "Now we're talking! This'll make the chocobo's spirit happy!", why = 'Brutus 138 (say #7727)'}}},
    },
}

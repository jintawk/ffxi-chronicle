-- Step progress for Beauty and the Galka (Bastok quest 1). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Beauty_and_the_Galka.lua (Talib 2 is the offer, option 1 declines and only
-- option 0 begins the quest, so the quest log alone proves the accept; Talib 4 plays on a decline and again while the quest is
-- accepted, so it proves nothing; Parraggoh 7 re-offers it after a decline; Talib 3 takes the zinc ore and gives key item 2;
-- Parraggoh 10 runs quest:complete and removes the key item only after the completion succeeded; 8 and 9 are his idle lines
-- while the key item is not held, so they are not used); client event scripts S4 236_Talib_010EC008.txt (3 say #7368),
-- 234_Parraggoh_010EA00A.txt (10 say #10608/#10609); key item ids from res/key_items.lua (2 Palborough Mines logs).
-- Completion: the final event also plays when the item reward cannot be given (npcUtil.completeQuest fails in onEventFinish), so it is a
-- reach only and the quest log's completed bit and the key item's removal carries the last step.
return {
    title = 'Beauty and the Galka',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to talib to start quest'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (option 1 declines without it)'},
         },
         reach = {{t = 'event', zone = 236, event = 2, why = 'Talib 2 offered (its finish needs option 0)'},
                  {t = 'event', zone = 234, event = 7, why = 'Parraggoh 7: re-offered after a decline (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'trade a zinc ore to talib'},
         done = {
            {t = 'ki', id = 2, gained = true, why = 'Palborough Mines logs obtained'},
            {t = 'ki_have', id = 2, have = true, why = 'Palborough Mines logs held'},
            {t = 'event', zone = 236, event = 3, why = 'Talib 3: the zinc ore accepted'},
            {t = 'chat', re = "More people like you and Cornelia, and I'd be out of business", why = 'Talib 3 (say #7368)'},
            {t = 'chat', re = 'obtained key item: palborough mines logs', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to parraggoh in bastok mines'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 2, gained = false, why = 'Palborough Mines logs deleted (only after the completion succeeded)'},
         },
         reach = {
            {t = 'event', zone = 234, event = 10, why = 'Parraggoh 10: plays even when the Bronze Knife does not fit'},
            {t = 'chat', re = 'If you see Cornelia, send her my gratitude%.', why = 'Parraggoh 10 (say #10609)'},
            {t = 'chat', re = 'It may not be much of a reward, but I want you to have this%.', why = 'Parraggoh 10 (say #10608)'},
         }},
    },
}

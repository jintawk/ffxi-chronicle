-- Step progress for Shady Business (Bastok quest 8). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Shady_Business.lua (Talib 90 plays on every talk once Beauty and the Galka is
-- done, with no refusal path, and its finish begins the quest when it is still available; Talib 91 plays only on a trade of four
-- Chunks of Zinc Ore (item 642) and runs quest:complete; the quest can be completed without ever being begun); client event
-- script S4 236_Talib_010EC008.txt (90 say #7345, 91 say #7346). Repeatable, but a repeat needs no new accept (the trade alone),
-- so there is no observation that opens a second run and no `repeatable` entry (as in sandoria 5 and 15). The two tips after
-- the trade are notes on it.
-- Shared-signal audit: "Here's your money." is also Aquillina 219 in A Flash in the Pan (bastok 14) -> the chat now keys on
-- Talib 91's first line.
return {
    title = 'Shady Business',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to talib to start quest'},
         done = {
            {t = 'event', zone = 236, event = 90, why = 'Talib 90: the offer talk, begins the quest'},
            {t = 'chat', re = "I'll give you a good price for them%. Deal%?", why = 'Talib 90 (say #7345)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 'n2', kind = 'note', with = 's3', at = {n = 2, fp = 'obtain 4 zinc ore via'}},
        {id = 's3', at = {n = 3, fp = 'trade 4 zinc ore to talib'}, count = {item = 642, need = 4},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 236, event = 91, why = 'Talib 91: the four zinc ore accepted, runs quest:complete'},
            {t = 'chat', re = 'Good, you brought the', why = 'Talib 91 (say #7346)'},
         }},
        {id = 'n4', kind = 'note', with = 's3', at = {n = 4, fp = 'this is one of the best and'}},
        {id = 'n5', kind = 'note', with = 's3', at = {n = 5, fp = 'after the february 2014 version update'}},
    },
}

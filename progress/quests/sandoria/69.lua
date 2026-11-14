-- Step progress for The Merchant's Bidding (San d'Oria quest 69). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Merchants_Bidding.lua (Parvipon 90 option 1 begins the quest, 88 is his
-- reminder while it is accepted, 89 is the exact trade of 3 Rabbit Hide that completes it); client event script S4
-- 230_Parvipon_010E60C7.txt (90 say #8907 on the accept branch only, 88 say #8909, 89 say #8910); item id from res/items.lua.
-- Event 90 also plays on a refusal and, once the quest is done, as the "still in the market" reminder, so it only reaches s1.
-- Repeatable (page meta), but the repeat needs no new talk (the trade works in any state but available), so there is no
-- `repeatable` entry: nothing opens a second run, as in Tiger's Teeth (quest 23).
-- Shared-signal audit (2026-10-28): the accept chat is tightened to 'I knew I could count on you. Bring me' (Kurou-Morou in Lower Jeuno, Never to Return, says 'I knew I could count on you. I can't sleep...').
return {
    title = "The Merchant's Bidding",
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to parvipon the tanner in'},
         done = {
            {t = 'chat', re = 'I knew I could count on you%. Bring me', why = 'Parvipon 90, accepted (say #8907)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 230, event = 88, conf = 'inferred', why = 'Parvipon 88: reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 230, event = 90, why = 'Parvipon 90 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade parvipon rabbit hide x3 for'}, count = {item = 856, need = 3},
         done = {
            {t = 'event', zone = 230, event = 89, why = 'Parvipon 89: the exact trade'},
            {t = 'chat', re = 'Thank you for the help%. If you are interested, I always need more%.', why = 'Parvipon 89 (say #8910)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'repeat this quest as often as'}},
    },
}

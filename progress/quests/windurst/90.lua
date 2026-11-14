-- Step progress for Tuning In (Windurst quest 90). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Waters/npcs/Leepe-Hoppe.lua (884 offers and begins the quest, 885 is the
-- reminder, 886 is the trade of Magicked Steel Ingot, Spruce Lumber and Extra-fine File and runs quest:complete for 4,000
-- gil and a title, with no item reward to refuse); client event script S4 238_Leepe_Hoppe_010EE030.txt (885 say #10669; 884 and
-- 886 hold no text). The draft put the completion on bullet 1; it belongs to the trade (bullet 3), and the farming bullet (2) is a
-- note on it. The quest log is set at s1, so it is not silent. Not repeatable (page meta).
return {
    title = 'Tuning In',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with leepe hoppe on top'},
         done = {
            {t = 'event', zone = 238, event = 884, why = 'Leepe-Hoppe 884: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 238, event = 885, conf = 'inferred', why = 'Leepe-Hoppe 885: the reminder, only once accepted'},
            {t = 'chat', re = 'Bring me those items, I humbly implore you!', conf = 'inferred', why = 'Leepe-Hoppe 885 (say #10669)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'leepe hoppe requires 3 items all'}},
        {id = 's3', at = {n = 3, fp = 'you need to trade all 3'},
         done = {
            {t = 'event', zone = 238, event = 886, why = 'Leepe-Hoppe 886: the three items accepted'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

-- Step progress for The Antique Collector (Jeuno quest 25). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/The_Antique_Collector.lua (Imasuke, Port Jeuno: 13 is the offer, two menus, the
-- quest begins on option 1 only, so it is a reach; 14 is the reminder and plays only while accepted; 15 plays only for an
-- exact Kaiser Sword trade and runs quest:complete, whose reward is experience, gil, a key item and a title, nothing to
-- refuse); client event script S4 246_Imasuke_010F6008.txt (13 say #7077 on the final Yes branch, 14 say #7079, 15 say
-- #7080); item id from res/items.lua (16631 Kaiser Sword) and key item from res/key_items.lua (410 map of Delkfutt's Tower).
-- Bullet 2 is a drop to hunt (a Kaiser Sword can come from other places), so it is a note on the trade. Not repeatable.
-- The map (key item 410) is left out: map sellers hand it out too (scripts/globals/maps.lua), so it is no proof of this quest.
return {
    title = 'The Antique Collector',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to imasuke to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Imasuke 13, option 1)'},
            {t = 'chat', re = 'Super! Hurry back with', why = 'Imasuke 13, final Yes branch only (say #7077)'},
            {t = 'event', zone = 246, event = 14, why = 'Imasuke 14: the reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 246, event = 13, why = 'Imasuke 13 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to qufim island and kill'}},
        {id = 's3', at = {n = 3, fp = 'trade the kaiser sword to imasuke'},
         done = {
            {t = 'event', zone = 246, event = 15, why = 'Imasuke 15: the Kaiser Sword accepted'},
            {t = 'chat', re = "Tread carefully, and don't forget to check the map!", why = 'Imasuke 15 (say #7080)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 16631, lost = true, after = 's1', conf = 'inferred', why = 'Kaiser Sword gone (traded, or sold)'},
         }},
    },
}

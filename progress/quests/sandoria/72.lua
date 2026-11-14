-- Step progress for The Setting Sun (San d'Oria quest 72). Data only; see progress/quests/sandoria/27.lua for the format.
-- Bullets 2 and 3 (the island in Batallia Downs, defeat Ahtu for the Engraved Key) have no strong signal: the key is an item
-- that can come from elsewhere, the fight leaves no event, and the draft's magicked astrolabe (key item 2578) is named by
-- neither the page nor the script. They stay plain bullets. The draft also put Vamorcote's accepted-state talk (655) on the
-- last bullet: it is the reminder that plays while the quest is open, so it only shows the quest was accepted.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Setting_Sun.lua (Vamorcote 654 option 1 begins the quest; 655 is his
-- reminder while accepted; 658 is the exact trade of the Engraved Key and runs quest:complete); client event script S4
-- 231_Vamorcote_010E7086.txt (654 a menu "Accept his request?", 655 say #7261, 658 a cutscene).
return {
    title = 'The Setting Sun',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to vamorcote to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 231, event = 655, conf = 'inferred', why = 'Vamorcote 655: reminder, only once accepted'},
            {t = 'chat', re = 'The floor plans should be here, locked inside%.', conf = 'inferred', why = 'Vamorcote 655 (say #7261)'},
         },
         reach = {{t = 'event', zone = 231, event = 654, why = 'Vamorcote 654 offered (its finish needs option 1)'}}},
        {id = 's4', at = {n = 4, fp = 'trade the engraved key to vamorcote'},
         done = {
            {t = 'event', zone = 231, event = 658, why = 'Vamorcote 658: the Engraved Key trade'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

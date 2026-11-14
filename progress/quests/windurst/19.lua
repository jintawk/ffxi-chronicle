-- Step progress for The Postman Always K.O.'s Twice (Windurst quest 19). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Walls/npcs/Ambrosius.lua (48 is the offer and only option 0 adds the quest, so
-- it is a reach; 49 is his talk while accepted; 56 his talk once completed; the letter trade is 52/53/54/55 for one to four
-- letters while accepted, each runs completeQuest and pays gil, and 57 to 60 are the same trades once completed, which only
-- repay the gil); client event script S4 239_Ambrosius_010EF025.txt (49 say #7233). The quest is repeatable by trade alone
-- (the completed-state trades need no new accept), so there is no `repeatable` entry. The quest log is set at s1, so it is
-- not silent. The sub-bullets (where each letter drops) are indented, not steps; bullet 3 (more letters, more reward) is a
-- note on the trade.
return {
    title = "The Postman Always K.O.'s Twice",
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ambrosius to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 239, event = 49, why = 'Ambrosius 49: his talk, only while accepted'},
            {t = 'chat', re = 'Seems that all of our deliverymen let down their guard when crossing between the Tahrongi Canyon and East Sarutabaruta%.', why = 'Ambrosius 49 (say #7233)'},
         },
         reach = {{t = 'event', zone = 239, event = 48, why = 'Ambrosius 48 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'trade ambrosius one or all of'},
         done = {
            {t = 'event', zone = 239, event = 52, why = 'Ambrosius 52: one letter, completes'},
            {t = 'event', zone = 239, event = 53, why = 'Ambrosius 53: two letters, completes'},
            {t = 'event', zone = 239, event = 54, why = 'Ambrosius 54: three letters, completes'},
            {t = 'event', zone = 239, event = 55, why = 'Ambrosius 55: four letters, completes'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 239, event = 56, why = 'Ambrosius 56: his talk once completed'},
            {t = 'event', zone = 239, event = 57, why = 'Ambrosius 57: one letter, a repeat'},
            {t = 'event', zone = 239, event = 58, why = 'Ambrosius 58: two letters, a repeat'},
            {t = 'event', zone = 239, event = 59, why = 'Ambrosius 59: three letters, a repeat'},
            {t = 'event', zone = 239, event = 60, why = 'Ambrosius 60: four letters, a repeat'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'the more letters you turn in'}},
    },
}

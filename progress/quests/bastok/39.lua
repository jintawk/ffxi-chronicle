-- Step progress for Minesweeper (Bastok quest 39). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Minesweeper.lua (Gerbaum 108 begins the quest on finish, no refusal branch;
-- trading exactly 3 Zeruhn Soot is event 109, which runs quest:complete); client event script S4 234_Gerbaum_010EA00D.txt
-- (108 say #10819, 109 say #10821); item id from res/items.lua (560 Zeruhn Soot). The quest log is set at the accept. The
-- quest is repeatable, but a repeat needs no new accept (the trade alone, same event 109), so there is no `repeatable` entry.
return {
    title = 'Minesweeper',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'gerbaum asks you to exterminate the'},
         done = {
            {t = 'event', zone = 234, event = 108, why = 'Gerbaum 108: the quest begun'},
            {t = 'chat', re = "The government won't do anything about the monsters in the Zeruhn Mines%.", why = 'Gerbaum 108 (say #10819)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'collect 3 zeruhn soot either by'}},
        {id = 's3', at = {n = 3, fp = 'trade them to gerbaum for your'}, count = {item = 560, need = 3},
         done = {
            {t = 'event', zone = 234, event = 109, why = 'Gerbaum 109: 3 Zeruhn Soot accepted, completes the quest'},
            {t = 'chat', re = 'We could use more people like you!', why = 'Gerbaum 109 (say #10821)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

-- Step progress for Tiger's Teeth (San d'Oria quest 23). Data only; see progress/quests/sandoria/27.lua for the format.
-- One bullet: the trade that completes it. Taumila 574 (accept needs option 0) and 575 (accepted-state talk) are not the
-- trade, so the accepted quest log is only `reach`. A wrong trade plays 573 and is never proof.
-- Evidence: LandSandBoat scripts/quests/sandoria/Tigers_Teeth.lua (572 on an exact trade of 3 Black Tiger Fang; its finish
-- completes the quest and confirms the trade); client event script S4 230_Taumila_010E6035.txt (572 say #7999).
-- The quest is repeatable (a completed-state trade also plays 572 and pays 2,100 gil); no `repeatable` entry because the
-- quest-log matchers would match the first run's snapshot again and the one-step restart would reset on every log read.
return {
    title = "Tiger's Teeth",
    completes = 's1',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'trade black tiger fang x3 to'}, count = {item = 884, need = 3},
         done = {
            {t = 'event', zone = 230, event = 572, why = 'Taumila 572: the exact trade'},
            {t = 'chat', re = 'Ah! Thank you, thank you%.', why = 'Taumila 572 (say #7999)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'quest', current = true, why = 'quest log: accepted (Taumila 574, option 0)'}}},
    },
}

-- Step progress for Paying Lip Service (Windurst quest 60). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Tapoh_Lihzeh.lua (477 is the offer and addQuest needs option 1, so
-- it is only `reach`; 478 is her talk while accepted; trading 3 Beehive Chips or 2 Remi Shells is event 479, played while
-- accepted or already done, whose finish completes the quest without a refusal path; the trade works with no new talk, so a
-- repeat needs no event that opens a run and there is no `repeatable` entry); client event script S4
-- 241_Tapoh_Lihzeh_010F106A.txt (478 say #8694, 479 say #8695 and #8696). No `count`: either item completes the trade, so one
-- item count would be wrong half the time. The quest log is set at s1, so it is not silent.
return {
    title = 'Paying Lip Service',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to tapoh lihzeh just a'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 241, event = 478, conf = 'inferred', why = 'Tapoh Lihzeh 478: reminder, only once accepted'},
         },
         reach = {{t = 'event', zone = 241, event = 477, why = 'Tapoh Lihzeh 477 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade her either 3 beehive chips'},
         done = {
            {t = 'event', zone = 241, event = 479, why = 'Tapoh Lihzeh 479: the chips or shells accepted'},
            {t = 'chat', re = 'Mmm%.%.%. Thanks forrr bringing me such exceedingly good quality material%.', why = 'Tapoh Lihzeh 479 (say #8695, #8696)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'your reward depends on which items'}},
    },
}

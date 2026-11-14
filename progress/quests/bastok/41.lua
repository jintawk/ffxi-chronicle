-- Step progress for Buckets of Gold (Bastok quest 41). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Buckets_of_Gold.lua (Foss 271 begins the quest only on option 0, "Yes", a
-- refusal plays the same event; trading exactly 5 Rusty Buckets is event 272, which runs quest:complete); client event
-- script S4 235_Foss_010EB043.txt (271 option 0 branch say #7682, 272 say #7687); item id from res/items.lua (90 Rusty
-- Bucket). The quest log is set at the accept. The quest is repeatable, but a repeat needs no new accept (the trade alone,
-- same event 272), so there is no `repeatable` entry.
return {
    title = 'Buckets of Gold',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'start the quest by talking to'},
         done = {
            {t = 'chat', re = 'All right, then you got any', why = 'Foss 271, accepted (say #7682, option 0 branch)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         },
         reach = {{t = 'event', zone = 235, event = 271, why = 'Foss 271 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'once you accept obtain 5 rusty'}},
        {id = 's3', at = {n = 3, fp = 'trade the 5 rusty buckets to'}, count = {item = 90, need = 5},
         done = {
            {t = 'event', zone = 235, event = 272, why = 'Foss 272: 5 Rusty Buckets accepted, completes the quest'},
            {t = 'chat', re = "Right, that's five of 'em%.", why = 'Foss 272 (say #7687)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

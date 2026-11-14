-- Step progress for Ducal Hospitality (Jeuno quest 68). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Ducal_Hospitality.lua (Taillegeas 10057 is the offer and begins the quest on any
-- answer but option 10, so it is only a reach; 10059 plays only while the quest is accepted, or once a completed quest has been
-- restarted with an item set; trading exactly the requested items is event 10058, which runs quest:complete and pays 4000 gil,
-- no reward item; after a completion 10060 plays until the player zones). Client event script S4 243_Taillegeas_010F30B0.txt
-- (10059 say #12766/#12764/#12765, one variant per item set). Repeatable (page meta): a restarted run plays 10059 again, so
-- 10059 opens the next run and the quest-log matchers count for the first run only (run1). Bullet 2 is the item list (a note on
-- the trade). The quest log is set at s1, so it is not silent.
return {
    title = 'Ducal Hospitality',
    completes = 's3',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to taillegeas to begin this'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 243, event = 10059, why = 'Taillegeas 10059: his item list, only while accepted or restarted'},
            {t = 'chat', re = 'The following items have been requested', why = 'Taillegeas 10059 (say #12766, #12764, #12765)'},
         },
         reach = {{t = 'event', zone = 243, event = 10057, why = 'Taillegeas 10057 offered (option 10 declines)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'he will ask you to bring'}},
        {id = 's3', at = {n = 3, fp = 'trade taillegeas the items he requests'},
         done = {
            {t = 'event', zone = 243, event = 10058, why = 'Taillegeas 10058: the exact items traded, runs quest:complete'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
    },
}

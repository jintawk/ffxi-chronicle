-- Step progress for In a Pickle (Windurst quest 5). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Waters/npcs/Chamama.lua (654 is the offer menu and can be declined, as is
-- 661 on a repeat; 655 is the reminder while accepted; a stone traded at random plays 659, which completes the quest, or the
-- rejections 657 and 658, which keep the quest open and prove nothing; 662 is the same acceptance on a repeat). Disagreement
-- with the draft: bullet 3 is the note about rejected stones (the 657/658 retry), not the post-quest events 660 and 661 the
-- draft offered. Client event script S4 238_Chamama_010EE057.txt (654, 661 menu #9063; 655 say #9068; 659 and 662 say #9076).
-- Repeatable (page meta): the reminder 655 plays again after the repeat is accepted, so it opens the next run and the
-- quest-log matchers count for the first run only (run1). The quest log is set at s1, so it is not silent.
return {
    title = 'In a Pickle',
    completes = 's2',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to chamama to begin this'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 238, event = 655, conf = 'inferred', why = 'Chamama 655: reminder, only once accepted'},
         },
         reach = {
            {t = 'event', zone = 238, event = 654, why = 'Chamama 654 offered (its finish needs option 1)'},
            {t = 'event', zone = 238, event = 661, why = 'Chamama 661: repeat offered (its finish needs option 1)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade a smooth stone to chamama'},
         done = {
            {t = 'event', zone = 238, event = 659, why = 'Chamama 659: the stone accepted'},
            {t = 'event', zone = 238, event = 662, why = 'Chamama 662: the stone accepted on a repeat'},
            {t = 'chat', re = 'Ah! Now this is more like it%.', why = 'Chamama 659 and 662 (say #9076)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'chamama will not always accept the'}},
    },
}

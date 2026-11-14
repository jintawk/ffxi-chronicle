-- Step progress for Stardust (Bastok quest 24). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Stardust.lua (Baldric 554 begins it at Bastok fame 2; trading one Pinch of
-- Valkurm Sunsand is event 555, which runs quest:complete and pays 300 gil, no reward item; once complete, 554 plays again
-- after zoning and a second 555 repeats the reward); client event script S4 237_Baldric_010ED038.txt (554 say #7894/#7895,
-- 555 say #7897 with a placeholder). Repeatable (page meta): the completed-state 554 opens the next run, so the quest-log
-- matchers count for the first run only (run1). Bullet 2 (get the sunsand) is a note on the trade. The quest log is set
-- at s1, so it is not silent.
-- Shared-signal audit: the opening line "Hey, you're an adventurer, right?" is also Tami's in Groceries (bastok 37) -> the chat
-- now keys on the second line of 554, which only Baldric says.
return {
    title = 'Stardust',
    completes = 's3',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with baldric inside the darksteel'},
         done = {
            {t = 'event', zone = 237, event = 554, why = 'Baldric 554'},
            {t = 'chat', re = 'for one of my experiments', why = 'Baldric 554 (say #7894, its second line)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'obtain a valkurm sunsand either via'}},
        {id = 's3', at = {n = 3, fp = 'return to baldric and trade him'},
         done = {
            {t = 'event', zone = 237, event = 555, why = 'Baldric 555: the Valkurm Sunsand trade'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
    },
}

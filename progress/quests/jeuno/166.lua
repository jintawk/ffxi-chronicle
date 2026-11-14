-- Step progress for All in the Cards (Jeuno quest 166). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/All_in_the_Cards.lua (Chululu 10110 offers the quest first, 10113 offers it
-- again once completed; both are a menu and only option 0 gives the cards and begins it, so they are only a reach; 10114
-- plays only on a trade of the four different Tarut cards and runs quest:complete, with a gil and title reward and no
-- item to refuse; 10112, the daily new batch of cards, is shared with Collect Tarut Cards and is not used). Client event
-- script S4 245_Chululu_010F5023.txt: 10110 and 10113 say #10257 on the accepting branch only ("Oh, thank you ever so
-- much!", after the menu, the decline says #10256), 10114 says #7569 and #10263. The quest is repeatable (page meta): the
-- log marks the first run only (a finished quest keeps both bits on retail), so a later accept opens the next run.
-- Bullets 2, 3 and 5 are the cards, the trading and a daily-card note: notes.
return {
    title = 'All in the Cards',
    completes = 's4',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to chululu'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'chat', re = 'Oh, thank you ever so much!', why = 'Chululu 10110 / 10113, accepting branch only (say #10257)'},
         },
         reach = {
            {t = 'event', zone = 245, event = 10110, why = 'Chululu 10110 offered (its finish needs option 0)'},
            {t = 'event', zone = 245, event = 10113, why = 'Chululu 10113 offered again (its finish needs option 0)'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'you will randomly be given five'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'trade with other players until you'}},
        {id = 's4', at = {n = 4, fp = 'trade all four cards to chululu'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'event', zone = 245, event = 10114, why = 'Chululu 10114: the four cards accepted, runs quest:complete'},
            {t = 'chat', re = 'Yes, this is all of them!', why = 'Chululu 10114 (say #7569)'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'note every real life day you'}},
    },
}

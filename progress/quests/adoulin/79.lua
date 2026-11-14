-- Step progress for It Sets My Heart Aflutter (Adoulin quest 79). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/It_Sets_My_Heart_Aflutter.lua (Saldinor in Rala Waterways: 330 is the offer
-- with a menu, and only option 1 begins the quest, so 330 itself is only a reach and its "You have my gratitude" line, the
-- option 1 branch, proves the acceptance; 333 is his talk while accepted; trading exactly two Twitherym Wings plays 331, which
-- runs quest:complete, the reward being bayld and experience with no item; 329 once completed is not used). Once It Sets My
-- Heart Aflutter, A Good Pair of Crocs and A Shot in the Dark are all completed and the cycle's tracker is clear, Saldinor
-- plays 332, which deletes the quest and begins it again with no refusal: it opens the next run, so the quest log's bits count
-- for the first run only (run1). Client event script S4 258_Saldinor (330 say #7572, 331 say #7575, 332 say #7577, 333 say
-- #7574). Twitherym Wing is item 3930. Bullets 3 to 5 are notes on the repeat and the questline.
return {
    title = 'It Sets My Heart Aflutter',
    completes = 's2',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with saldinor in rala waterways'},
         done = {
            {t = 'chat', re = 'You have my gratitude%. The only way to resist the primordial darkness is with this kind of protection%.', why = 'Saldinor 330 (say #7572, the option 1 branch that begins the quest)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 258, event = 332, why = 'Saldinor 332: the repeat, deletes and begins the quest again'},
            {t = 'chat', re = 'My mother has fallen ill from worry%.', why = 'Saldinor 332 (say #7577)'},
            {t = 'event', zone = 258, event = 333, conf = 'inferred', why = 'Saldinor 333: plays only while accepted'},
            {t = 'chat', re = 'Have you forgotten what I need%?', conf = 'inferred', why = 'Saldinor 333 (say #7574)'},
         },
         reach = {{t = 'event', zone = 258, event = 330, why = 'Saldinor 330 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'obtain 2 twitherym wings and trade'}, count = {item = 3930, need = 2},
         done = {
            {t = 'event', zone = 258, event = 331, why = 'Saldinor 331: two Twitherym Wings traded, runs quest:complete'},
            {t = 'chat', re = 'You have done me a great service%.', why = 'Saldinor 331 (say #7575)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'repeat of this quest still give'}},
        {id = 's4', kind = 'note', with = 's2', at = {n = 4, fp = 'this quest is repeatable but only'}},
        {id = 's5', kind = 'note', with = 's2', at = {n = 5, fp = 'questline it sets my heart aflutter'}},
    },
}

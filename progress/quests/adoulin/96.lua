-- Step progress for A Shot in the Dark (Adoulin quest 96). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/A_Shot_in_the_Dark.lua (Pudith in Eastern Adoulin: 3011 is the offer with a
-- menu, and only the accepting option begins the quest, so 3011 itself is only a reach and its "Times are rough for my
-- family" line, the accepting branch, proves the acceptance; 3014 is her talk while accepted, repeating the request line that
-- the offer also says, so it is only inferred; trading exactly one Umbril Ooze plays 3012, which runs quest:complete, the
-- reward being bayld and experience with no item; 3010 once completed is not used). Once It Sets My Heart Aflutter, A Good
-- Pair of Crocs and this quest are all completed and the cycle's tracker is 2, Pudith plays 3013, which deletes the quest and
-- begins it again with no refusal: it opens the next run, so the quest log's bits count for the first run only (run1). Client
-- event script S4 257_Pudith_0110107D.txt (3011 say #8039, 3012 say #8046, 3013 say #8048, 3014 say #8044). Umbril Ooze is
-- item 3935. Bullets 3 and 4 are notes on the repeat and the questline.
return {
    title = 'A Shot in the Dark',
    completes = 's2',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to pudith west of the'},
         done = {
            {t = 'chat', re = 'Times are rough for my family%.', why = 'Pudith 3011 (say #8039, the accepting branch)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 257, event = 3013, why = 'Pudith 3013: the repeat, deletes and begins the quest again'},
            {t = 'chat', re = 'Why, hello again! You know, my hubby is still telling those wild stories of his, and his fear is starting to rub off on me all over again%.', why = 'Pudith 3013 (say #8048)'},
            {t = 'event', zone = 257, event = 3014, conf = 'inferred', why = 'Pudith 3014: plays only while accepted'},
            {t = 'chat', re = 'Take the law into your own hands%.', conf = 'inferred', why = 'Pudith 3014 (say #8044, also said by the 3011 offer)'},
         },
         reach = {{t = 'event', zone = 257, event = 3011, why = 'Pudith 3011 offered (its finish needs the accepting option)'}}},
        {id = 's2', at = {n = 2, fp = 'she ll ask for a jar'},
         done = {
            {t = 'event', zone = 257, event = 3012, why = 'Pudith 3012: an Umbril Ooze traded, runs quest:complete'},
            {t = 'chat', re = "I'm so glad you were able to make good on your promise when so many before you did not%.", why = 'Pudith 3012 (say #8046)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'questline is repeatable starting from it'}},
        {id = 's4', kind = 'note', with = 's2', at = {n = 4, fp = 'questline it sets my heart aflutter'}},
    },
}

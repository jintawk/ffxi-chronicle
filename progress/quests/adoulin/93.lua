-- Step progress for A Good Pair of Crocs (Adoulin quest 93). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/A_Good_Pair_of_Crocs.lua (Felmsy in Eastern Adoulin: 3001 is the offer with a
-- menu, and only option 1 begins the quest, so 3001 itself is only a reach and its "Just past here are the Yahse Hunting
-- Grounds" line, the "listen" branch that accepts, proves the acceptance; 3004 is his talk while accepted; trading exactly
-- one Velkk Mask or Velkk Necklace plays 3002, which runs quest:complete, the reward being bayld and experience with no
-- item; 3000 once completed is not used). Once It Sets My Heart Aflutter, this quest and A Shot in the Dark are all completed
-- and the cycle's tracker is 1, Felmsy plays 3003, which deletes the quest and begins it again with no refusal: it opens the
-- next run, so the quest log's bits count for the first run only (run1). Client event script S4 257_Felmsy_0110107C.txt (3001
-- say #8026, 3002 say #8031, 3003 say #8033, 3004 say #8030). Velkk Necklace is item 3928, Velkk Mask 3929. Bullets 3 and 4
-- are notes on the repeat and the questline.
return {
    title = 'A Good Pair of Crocs',
    completes = 's2',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to felmsy at the wharf'},
         done = {
            {t = 'chat', re = 'Just past here are the Yahse Hunting Grounds%.', why = 'Felmsy 3001 (say #8026, the branch that begins the quest)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 257, event = 3003, why = 'Felmsy 3003: the repeat, deletes and begins the quest again'},
            {t = 'chat', re = 'Hey! My favorite pioneer!', why = 'Felmsy 3003 (say #8033)'},
            {t = 'event', zone = 257, event = 3004, conf = 'inferred', why = 'Felmsy 3004: plays only while accepted'},
            {t = 'chat', re = 'Head to Yahse, kill as many of those nasty Velkk as you can, and collect', conf = 'inferred', why = 'Felmsy 3004 (say #8030)'},
         },
         reach = {{t = 'event', zone = 257, event = 3001, why = 'Felmsy 3001 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade a velkk mask or velkk'},
         done = {
            {t = 'event', zone = 257, event = 3002, why = 'Felmsy 3002: a Velkk Mask or Necklace traded, runs quest:complete'},
            {t = 'chat', re = 'Hey there%. Managed to kill a bunch of filthy Velkk scum, did you%?', why = 'Felmsy 3002 (say #8031)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'questline is repeatable starting from it'}},
        {id = 's4', kind = 'note', with = 's2', at = {n = 4, fp = 'questline it sets my heart aflutter'}},
    },
}

-- Step progress for Beyond Infinity (Jeuno quest 137). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/LB10_Beyond_Infinity.lua (the quest is begun by Prelude to Puissance or by an
-- option of the Nomad Moogle's shared 10045, so the quest log's current bit carries step 1; the Soul gem clasp is shared with
-- Prelude to Puissance and the battle win (32001) is the generic win event of four zones, so neither is used; once the
-- fight is won (Prog 1) his talk plays 10139, which runs quest:complete, pays no item and so cannot be refused, then "Your
-- level limit is now 99!" is shown); client event script S4 243_Nomad_Moogle_010F3075.txt (10139 owned by this quest
-- alone, say #12525). The fight bullets, the defeat rule and the optional Olde Rarab Tail errand from Degenhard (bullets
-- 7 to 10) have no signal that is specific to this quest and stay plain. Not repeatable (page meta). The quest log is set at
-- s1, so it is not silent.
return {
    title = 'Beyond Infinity',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after completing the previous quest the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's6', at = {n = 6, fp = 'warp back and talk to the'},
         done = {
            {t = 'event', zone = 243, event = 10139, why = 'Nomad Moogle 10139: the fight won, runs quest:complete'},
            {t = 'chat', re = "Ye've truly done it!", why = 'Nomad Moogle 10139 (say #12525)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'Your level limit is now 99!', why = 'Ru Lude Gardens text: level limit 99, shown once the quest is completed'},
         }},
    },
}

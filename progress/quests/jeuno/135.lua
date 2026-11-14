-- Step progress for Beyond the Stars (Jeuno quest 135). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/LB08_Beyond_the_Stars.lua (the Nomad Moogle's 10045 is shared by every Limit
-- Break quest from 6 to 10, so it and its lines prove nothing here; its option 9 begins the quest and only the quest log's
-- current bit carries step 1; trading exactly 10 Kindred's Crests with 5 merit points plays 10137 and sets Prog; the next
-- talk plays 10161, the Rock-Paper-Scissors fight, whose "Ready, kupo!?" menu has a "W-wait a minute" refusal and whose
-- finish runs quest:complete only on option 254, so 10161 is a reach and the quest log's completed bit carries the last step,
-- followed by "Your level limit is now 90!"); client event script S4 243_Nomad_Moogle_010F3075.txt (10137 say #12285, 10161
-- menu #12311). Item id 2955 Kindred's Crest from res/items.lua (only for the bag count). Bullets 3 and 4 (the talk that
-- starts the fight, the loss rule) stay plain. Not repeatable (page meta). The quest log is set at s1.
return {
    title = 'Beyond the Stars',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to the nomad moogle in'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade 10 kindred s crests to'}, count = {item = 2955, need = 10},
         done = {
            {t = 'event', zone = 243, event = 10137, why = 'Nomad Moogle 10137: the crests and merit points accepted'},
            {t = 'chat', re = "Well, it looks like you're all ready%.", why = 'Nomad Moogle 10137 (say #12285)'},
         }},
        {id = 's5', at = {n = 5, fp = 'win at the mini game and'},
         reach = {{t = 'event', zone = 243, event = 10161, why = 'Nomad Moogle 10161: the fight offered (its win needs option 254)'}},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'Your level limit is now 90!', why = 'Ru Lude Gardens text: level limit 90, shown once the quest is completed'},
         }},
    },
}

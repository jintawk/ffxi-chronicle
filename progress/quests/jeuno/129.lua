-- Step progress for Atop the Highest Mountains (Jeuno quest 129). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/LB02_Atop_the_Highest_Mountains.lua (Maat 82 is an Accept/Decline menu, option 1
-- begins the quest, so it is only a reach; 83 is his reminder while accepted without all three key items; with round, square
-- and triangular frigicite all held he plays 84, which completes the quest, pays no item and so cannot be refused, and takes
-- the three key items back); client event script S4 243_Maat_010F3031.txt (83 say #10413). Key item ids 222, 223, 224 from
-- res/key_items.lua. The frigicite comes from three ??? in Xarcabard in any order, so no one bullet is tied to one of them:
-- they are reaches of the last step, and the middle bullets stay plain. Maat's ids are unique to this quest. Not repeatable
-- (page meta). The quest log is set at s1, so it is not silent.
return {
    title = 'Atop the Highest Mountains',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to maat on a level'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 243, event = 83, conf = 'inferred', why = 'Maat 83: his reminder, only while accepted'},
            {t = 'chat', re = 'Many caverns to the north house fiends that can see the unseen%.', conf = 'inferred', why = 'Maat 83 (say #10413)'},
         },
         reach = {{t = 'event', zone = 243, event = 82, why = 'Maat 82 offered (its finish needs option 1)'}}},
        {id = 's3', kind = 'note', with = 's9', at = {n = 3, fp = 'the notorious monsters stand guard in'}},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'you also solo these notorious monsters'}},
        {id = 's9', at = {n = 9, fp = 'speak to maat once you have'},
         reach = {
            {t = 'ki', id = 222, gained = true, why = 'round frigicite obtained'},
            {t = 'ki', id = 223, gained = true, why = 'square frigicite obtained'},
            {t = 'ki', id = 224, gained = true, why = 'triangular frigicite obtained'},
         },
         done = {
            {t = 'event', zone = 243, event = 84, why = 'Maat 84: all three key items handed over, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'Your level limit is now 60%.', why = 'Ru Lude Gardens text: level limit 60, shown once the quest is completed'},
            {t = 'ki', id = 222, gained = false, conf = 'inferred', why = 'round frigicite handed over'},
            {t = 'ki', id = 223, gained = false, conf = 'inferred', why = 'square frigicite handed over'},
            {t = 'ki', id = 224, gained = false, conf = 'inferred', why = 'triangular frigicite handed over'},
         }},
    },
}

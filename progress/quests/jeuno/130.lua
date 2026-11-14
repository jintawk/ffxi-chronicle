-- Step progress for Whence Blows the Wind (Jeuno quest 130). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/LB03_Whence_Blows_the_wind.lua (Maat 85 is an Accept/Decline menu, option 1
-- begins the quest, so it is only a reach; 86 is his reminder while accepted without all three crests; with the Orcish,
-- Quadav and Yagudo crests all held he plays 87, which completes the quest, pays no item and so cannot be refused, and takes
-- the crests back); client event script S4 243_Maat_010F3031.txt (86 say #10423, P0-P2 = key items 336, 337, 338). Key item
-- ids 336 Orcish crest, 337 Quadav crest, 338 Yagudo crest from res/key_items.lua (only this quest uses them). The three
-- crests come from three ??? in any order and the page interleaves their routes, so no one bullet is tied to one crest: they
-- are reaches of the last step and the bullets between stay plain. The Magicite key items in bullet 2 are requirements, not
-- steps. Maat's ids are unique to this quest. Not repeatable (page meta). The quest log is set at s3, so it is not silent.
return {
    title = 'Whence Blows the Wind',
    completes = 's38',
    known = {{t = 'quest'}},
    steps = {
        {id = 's3', at = {n = 3, fp = 'speak to maat on a level'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 243, event = 86, conf = 'inferred', why = 'Maat 86: his reminder, only while accepted'},
            {t = 'chat', re = 'Bring those three items here to me%.', conf = 'inferred', why = 'Maat 86 (say #10423)'},
         },
         reach = {{t = 'event', zone = 243, event = 85, why = 'Maat 85 offered (its finish needs option 1)'}}},
        {id = 's38', at = {n = 38, fp = 'return to jeuno and speak to'},
         reach = {
            {t = 'ki', id = 336, gained = true, why = 'Orcish crest obtained'},
            {t = 'ki', id = 337, gained = true, why = 'Quadav crest obtained'},
            {t = 'ki', id = 338, gained = true, why = 'Yagudo crest obtained'},
         },
         done = {
            {t = 'event', zone = 243, event = 87, why = 'Maat 87: all three crests handed over, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'Your level limit is now 65%.', why = 'Ru Lude Gardens text: level limit 65, shown once the quest is completed'},
            {t = 'ki', id = 336, gained = false, conf = 'inferred', why = 'Orcish crest handed over'},
            {t = 'ki', id = 337, gained = false, conf = 'inferred', why = 'Quadav crest handed over'},
            {t = 'ki', id = 338, gained = false, conf = 'inferred', why = 'Yagudo crest handed over'},
         }},
    },
}

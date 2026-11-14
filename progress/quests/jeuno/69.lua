-- Step progress for In the Mood for Love (Jeuno quest 69). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/In_the_Mood_for_Love.lua (Odasel 10035 is a plain cutscene whose finish begins
-- the quest on any answer; 10037 is his talk while accepted; trading exactly one Chameleon Diamond is 10036, which runs
-- quest:complete and pays 4800 gil, no reward item; Matoaka 10039 plays only after completion, once, while the quest variable
-- Option is 1). Client event script S4 245_Odasel_010F502F.txt (10037 say #8727); Matoaka's 10039 has no text. Item id from
-- res/items.lua (1666 Chameleon Diamond). Bullet 2 (the Gigas drop) is a note on the trade. Not repeatable. The quest log is
-- set at s1, so it is not silent.
return {
    title = 'In the Mood for Love',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to odasel outside gems by'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 245, event = 10035, why = 'Odasel 10035: the cutscene that begins the quest'},
            {t = 'event', zone = 245, event = 10037, why = 'Odasel 10037: his talk, only while accepted'},
            {t = 'chat', re = 'Could I really find out which of those beauties had feelings for me if I had', why = 'Odasel 10037 (say #8727)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to lufaise meadows and defeat'}},
        {id = 's3', at = {n = 3, fp = 'trade the chameleon diamond to odasel'},
         done = {
            {t = 'event', zone = 245, event = 10036, why = 'Odasel 10036: the exact trade, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's4', kind = 'post', at = {n = 4, fp = 'speak to matoaka inside the shop'},
         done = {
            {t = 'event', zone = 245, event = 10039, after = 's3', why = 'Matoaka 10039: plays only after the completion'},
         }},
    },
}

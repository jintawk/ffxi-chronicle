-- Step progress for Breaking the Ice (Adoulin quest 54). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/Breaking_the_Ice.lua (Traiffeaux 24 is the offer and begins the quest only on
-- option 2, so the event itself plays on a refusal; 25 is his talk while accepted; trading exactly 3 Rabbit Hide and 1 Raaz Tusk
-- plays 26, which gives the earmuffs, runs quest:complete and gives "Fragmenting"; any other trade plays nothing). Client event
-- script S4 267_Traiffeaux_0110B16E.txt (24 says #7771 only on the branch that ends with option 2, #7756 on every attempt; 25 say
-- #7785; 26 is a bare cutscene). The draft proved bullet 2 with the #7756 line, which also plays on the refusals, and bullet 3
-- with the Baby rabbit memento (2649, a Mog Garden key item the page mentions as a tip); both are dropped. Bullet 3 only
-- restates what the cutscene asks for, so it is a note on the trade, like bullet 1. The reward key items (2461 and 2462, both
-- permanent) support the trade only. Bullet 5 restates them (a note); the link bullet 6 is not a step. Not repeatable.
return {
    title = 'Breaking the Ice',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'items needed that can be obtained'}},
        {id = 's2', at = {n = 2, fp = 'talk to traiffeaux at the fs'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Traiffeaux 24, option 2)'},
            {t = 'chat', re = 'You raise an interesting p%-point%.', why = 'Traiffeaux 24 (say #7771), the branch that ends with option 2'},
            {t = 'event', zone = 267, event = 25, why = 'Traiffeaux 25: his talk, plays only while accepted'},
            {t = 'chat', re = 'I am s%-sure you would be able to break the wall if you could hear the eye of the ice', why = 'Traiffeaux 25 (say #7785)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'he will then give you the'}},
        {id = 's4', at = {n = 4, fp = 'trade all four items to traiffeaux'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 267, event = 26, why = 'Traiffeaux 26: the exact trade accepted, runs quest:complete'},
            {t = 'ki', id = 2462, gained = true, conf = 'inferred', why = 'pair of fuzzy earmuffs obtained (reward)'},
            {t = 'ki', id = 2461, gained = true, conf = 'inferred', why = '"Fragmenting" obtained (reward)'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'after the cutscene is complete you'}},
    },
}

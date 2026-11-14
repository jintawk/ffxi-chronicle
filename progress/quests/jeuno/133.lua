-- Step progress for New Worlds Await (Jeuno quest 133). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/LB06_New_Worlds_Await.lua (the Nomad Moogle's 10045 is the one event every
-- Limit Break quest from 6 to 10 shares, and its option 5 begins this quest, so neither it nor its lines prove anything here
-- and the quest log's current bit carries step 1; trading exactly 5 Kindred's Seals with 3 merit points plays 10135, which
-- runs quest:complete, pays no item and so cannot be refused, then "Your level limit is now 80!" is shown); client event
-- script S4 243_Nomad_Moogle_010F3075.txt (10135 owned by this quest alone, say #12202). Item id 1127 Kindred's Seal from
-- res/items.lua (only for the bag count). Not repeatable (page meta). The quest log is set at s1, so it is not silent.
return {
    title = 'New Worlds Await',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to the nomad moogle in'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade the nomad moogle 5 kindred'}, count = {item = 1127, need = 5},
         done = {
            {t = 'event', zone = 243, event = 10135, why = 'Nomad Moogle 10135: the seals and merit points accepted, runs quest:complete'},
            {t = 'chat', re = "Spectacular! Stupendous! Let's get started, shall we%?", why = 'Nomad Moogle 10135 (say #12202)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'Your level limit is now 80!', why = 'Ru Lude Gardens text: level limit 80, shown once the quest is completed'},
         }},
    },
}

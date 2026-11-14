-- Step progress for Expanding Horizons (Jeuno quest 134). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/LB07_Expanding_Horizons.lua (the Nomad Moogle's 10045 is shared by every Limit
-- Break quest from 6 to 10, so it and its lines prove nothing here; its option 7 begins the quest and only the quest log's
-- current bit carries step 1; trading exactly 5 Kindred's Crests with 4 merit points plays 10136, which runs quest:complete,
-- pays no item and so cannot be refused, then "Your level limit is now 85!" is shown); client event script S4
-- 243_Nomad_Moogle_010F3075.txt (10136 owned by this quest alone, say #12236). Item id 2955 Kindred's Crest from res/items.lua
-- (only for the bag count). Not repeatable (page meta). The quest log is set at s1, so it is not silent.
return {
    title = 'Expanding Horizons',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to the nomad moogle in'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade the nomad moogle 5 kindred'}, count = {item = 2955, need = 5},
         done = {
            {t = 'event', zone = 243, event = 10136, why = 'Nomad Moogle 10136: the crests and merit points accepted, runs quest:complete'},
            {t = 'chat', re = 'Splendid! Superlative!', why = 'Nomad Moogle 10136 (say #12236)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'Your level limit is now 85!', why = 'Ru Lude Gardens text: level limit 85, shown once the quest is completed'},
         }},
    },
}

-- Step progress for The Starving (Adoulin quest 84). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/The_Starving.lua (Westerly Breeze in Western Adoulin: 3005 begins the quest with
-- no refusal, only on a Vana'diel day after Hunger Strikes and after zoning; 3006 is his talk while accepted but also plays on
-- a wrong trade, so it is only an inferred sign of acceptance; trading exactly one Goblin Drink plays 3007, whose finish runs
-- quest:complete, the reward being bayld and experience with no item, so it has no refusal; 3008 is a refused drink and is not
-- used). Client event script S4 256_Westerly_Breeze_01100120.txt (3005 say #8018, 3006 say #8022, 3007 say #8023). Goblin
-- Drink is item 4541. Not repeatable.
return {
    title = 'The Starving',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to westerly breeze at i'},
         done = {
            {t = 'event', zone = 256, event = 3005, why = 'Westerly Breeze 3005: the first talk, begins the quest'},
            {t = 'chat', re = 'Phew, my throat sure is dry, though%.%.%.', why = 'Westerly Breeze 3005 (say #8018)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 256, event = 3006, conf = 'inferred', why = 'Westerly Breeze 3006: plays only while accepted (also on a wrong trade)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade him a goblin drink to'},
         done = {
            {t = 'event', zone = 256, event = 3007, why = 'Westerly Breeze 3007: a Goblin Drink traded, runs quest:complete'},
            {t = 'chat', re = 'Yeeeeeeeees!', why = 'Westerly Breeze 3007 (say #8023)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

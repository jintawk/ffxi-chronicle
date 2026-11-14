-- Step progress for Hunger Strikes (Adoulin quest 76). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/Hunger_Strikes.lua (Westerly Breeze in Western Adoulin: 2530 begins the quest
-- with no refusal; while accepted a plain talk is 2531; trading exactly one Bowl of Wisdom Soup plays 2532, whose finish runs
-- quest:complete, the reward being bayld and experience with no item, so it has no refusal; a wrong food trade plays 2533 and is
-- not used). LandSandBoat lists 2531 and 2532 under the quest section without a zone: they are Westerly Breeze's, zone 256.
-- Client event script S4 256_Westerly_Breeze_01100120.txt (2530 say #7914, 2531 say #7918, 2532 say #7919). Not repeatable.
return {
    title = 'Hunger Strikes',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to westerly breeze at i'},
         done = {
            {t = 'event', zone = 256, event = 2530, why = 'Westerly Breeze 2530: the first talk, begins the quest'},
            {t = 'chat', re = "How am I supposed to work when they won't let me eat!%?", why = 'Westerly Breeze 2530 (say #7914)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 256, event = 2531, conf = 'inferred', why = 'Westerly Breeze 2531: plays only while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade a wisdom soup to him'},
         done = {
            {t = 'event', zone = 256, event = 2532, why = 'Westerly Breeze 2532: the soup traded, runs quest:complete'},
            {t = 'chat', re = "Yeeeeeeeeeeees! You got", why = 'Westerly Breeze 2532 (say #7919)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

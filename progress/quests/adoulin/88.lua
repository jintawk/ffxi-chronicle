-- Step progress for "Always more," Quoth the Ravenous (Adoulin quest 88). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Western_Adoulin/npcs/Westerly_Breeze.lua (the quest has no script of its own: Westerly
-- Breeze plays 3010 to begin it, at Adoulin fame 3, after zoning and a Vana'diel day since The Starving; onEventFinish adds the
-- quest with no refusal; 3011 is his talk while accepted; trading a Cursed Beverage while accepted plays 3012, whose finish
-- runs completeQuest, the reward being bayld and experience with no item, so it has no refusal; 3013 and 3014 are refused
-- drinks and are not used). Client event script S4 256_Westerly_Breeze_01100120.txt (3010 say #8032, 3011 say #8038; 3012
-- has no text). Cursed Beverage is item 4234. Not repeatable.
return {
    title = '"Always more," Quoth the Ravenous',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to westerly breeze at i'},
         done = {
            {t = 'event', zone = 256, event = 3010, why = 'Westerly Breeze 3010: the first talk, begins the quest'},
            {t = 'chat', re = "We've shared so many memories together, haven't we%?", why = 'Westerly Breeze 3010 (say #8032)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 256, event = 3011, conf = 'inferred', why = 'Westerly Breeze 3011: plays only while accepted'},
            {t = 'chat', re = "If you don't get me that sparkling pink drink", conf = 'inferred', why = 'Westerly Breeze 3011 (say #8038)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade him a cursed beverage to'},
         done = {
            {t = 'event', zone = 256, event = 3012, why = 'Westerly Breeze 3012: a Cursed Beverage traded while accepted, runs completeQuest'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

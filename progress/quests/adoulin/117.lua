-- Step progress for A Thirst Before Time (Adoulin quest 117). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script for Roskin, Polished Pebble, Palomel, the Well-Kept Cache or
-- Wegellion, so the page is the only source. Key items from res/key_items.lua: Weathered Haverton hat (2842, the sub-bullet
-- of n=6 says the NM drops it) and Forgotten memory (2840, n=7, "the Key Item"). The page ends the quest at the last Roskin
-- talk ("for a cutscene and the reward of your choice", n=11), so the log's completed bit belongs to n=11. n=12 hands the
-- hat to Wegellion for experience: the hat leaving the key items after n=6 proves it, and it can happen before or after n=11,
-- so it is a post bullet. The Roskin/Polished Pebble/Palomel talks and the zoning cutscene (n=2-5, 8-10) have no signal: left
-- plain. n=1 is a warning, not a step. Not repeatable.
return {
    title = 'A Thirst Before Time',
    completes = 's11',
    known = {{t = 'quest'}},
    steps = {
        {id = 's6', at = {n = 6, fp = 'examine it again to spawn a'},
         done = {
            {t = 'ki', id = 2842, gained = true, why = 'weathered Haverton hat dropped by the NM'},
            {t = 'ki_have', id = 2842, have = true, why = 'weathered Haverton hat held'},
            {t = 'chat', re = 'obtained key item: weathered haverton hat', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'examine the well kept cache again'},
         done = {
            {t = 'ki', id = 2840, gained = true, why = 'forgotten memory obtained'},
            {t = 'ki_have', id = 2840, have = true, why = 'forgotten memory held'},
            {t = 'chat', re = 'obtained key item: forgotten memory', why = 'chat: key item obtained'},
         }},
        {id = 's11', at = {n = 11, fp = 'return to roskin for a cutscene'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed at Roskin (reward of your choice)'},
         }},
        {id = 's12', kind = 'post', at = {n = 12, fp = 'speak to wegellion at f 9'},
         done = {
            {t = 'ki', id = 2842, gained = false, after = 's6', why = 'weathered Haverton hat handed to Wegellion'},
         }},
    },
}

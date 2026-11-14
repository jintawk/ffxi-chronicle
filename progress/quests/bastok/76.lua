-- Step progress for All by Myself (Bastok quest 76). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no script for the quest (only a commented-out line in Lamepaue's watcher) and the client event
-- scripts have no Marin or Ken, so no event is used. What is left are the quest log (accepted at Marin's first talk, completed
-- at her second, as the page's bullets say) and Ken's escort award (key item 993 in res/key_items.lua), handed over at the exit
-- of Dangruf Wadi. The tip bullets, Ken's messages and the cutscene and Ken-start bullets (n=2 to 26) have no strong signal and
-- stay plain bullets. The quest is repeatable, but a repeat leaves no trace of its own (the log bits stay set and Marin's
-- talks have no event ids), so there is no `repeatable` entry and a repeat is not tracked.
return {
    title = 'All by Myself',
    completes = 's28',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to marin and accept the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's27', at = {n = 27, fp = 'after ken despawns marin will appear'},
         done = {
            {t = 'ki', id = 993, gained = true, why = "Ken's escort award obtained"},
            {t = 'ki_have', id = 993, have = true, why = "Ken's escort award held"},
            {t = 'chat', re = "obtained key item: ken's escort award", why = 'chat: key item obtained'},
         }},
        {id = 's28', at = {n = 28, fp = 'return to bastok markets and speak'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

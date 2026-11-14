-- Step progress for The Opo-opo and I (Outlands quest 11). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Kazham/npcs/Lulupp.lua (217 is the offer after the scent: a menu whose first choice, "Opo?",
-- runs addQuest, so the log's current bit and that branch's line "You don't have to be afrrraid!" prove s1; 207 and 242 are his
-- talks while accepted, before and after the first trade; 219 is the correct rod trade, 229 the wrong-order trade, 239 the retry
-- talk, so the last two are no proof) and Nenepp.lua (241 is the tenth, correct trade: it plays on any correct trade, but completes
-- the quest and gives the crown only with four free slots, so it reaches the chain and the log's completed bit proves it).
-- The ten Opo-opos' own events (198 to 250) are the trade chain and are not listed one by one. Client event scripts S4
-- 250_Lulupp_010FA048.txt (217 say #10418, 219 say #10414) and 250_Nenepp_010FA051.txt (241 say #10459). Bullet 2 is the list of
-- trades in order (a table follows it); bullets 3 to 6 are plain tips and not steps. The quest log is set at s1, so it is not
-- silent. Not repeatable.
return {
    title = 'The Opo-opo and I',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'once you have finished even more'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Lulupp 217, first choice)'},
            {t = 'chat', re = "You don't have to be afrrraid!", why = 'Lulupp 217 (say #10418, accept branch)'},
            {t = 'event', zone = 250, event = 207, conf = 'inferred', why = 'Lulupp 207: his talk while accepted, before the rod'},
            {t = 'event', zone = 250, event = 242, conf = 'inferred', why = 'Lulupp 242: his talk once the rod is traded'},
         },
         reach = {{t = 'event', zone = 250, event = 217, why = 'Lulupp 217 offered (its finish needs the first choice)'}}},
        {id = 's2', at = {n = 2, fp = 'you must trade these items in'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Nenepp 241, with four free slots for the crown)'},
         },
         reach = {
            {t = 'event', zone = 250, event = 219, after = 's1', why = 'Lulupp 219: the first correct trade (the rod)'},
            {t = 'event', zone = 250, event = 241, after = 's1', why = 'Nenepp 241: the last correct trade (completes only with four free slots)'},
            {t = 'chat', re = 'Long live the king! Opo%-opo!', after = 's1', why = 'Nenepp 241 (say #10459)'},
         }},
    },
}

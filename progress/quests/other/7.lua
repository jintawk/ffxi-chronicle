-- Step progress for Orlando's Antiques (quest other 7). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Mhaura/npcs/Orlando.lua (event 101 plays only while the quest is available, has no menu
-- and its finish adds the quest, so it is the accept; 103 is his talk once the quest is accepted or completed, it needs the
-- Chocobo License; trading exactly eight of one of the listed items is event 102, which pays and completes the quest, for
-- the accepted quest and for any repeat after a 103 talk; 100 is the refusal line). Client event script S4
-- 249_Orlando_010F9013.txt (101 say #6965, 103 say #6974); event 102 has no body in the script. Repeatable (page meta): after
-- a finished run a 103 talk opens the next run, so the quest-log matchers count for the first run only (run1). Eight
-- different items are accepted, so there is no `count`.
return {
    title = "Orlando's Antiques",
    completes = 's2',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to orlando to begin this'},
         done = {
            {t = 'event', zone = 249, event = 101, why = 'Orlando 101: the offer, no refusal'},
            {t = 'chat', re = 'Ah! You can ride chocobos, I see%.', why = 'Orlando 101 (say #6965)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 249, event = 103, conf = 'inferred', why = 'Orlando 103: his talk once accepted, and the start of a repeat'},
            {t = 'chat', re = 'So, how goes the hunt%?', conf = 'inferred', why = 'Orlando 103 (say #6974)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade orlando eight 8 of any'},
         done = {
            {t = 'event', zone = 249, event = 102, why = 'Orlando 102: eight of one item accepted, runs the completion'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
    },
}

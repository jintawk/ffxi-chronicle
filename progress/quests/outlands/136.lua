-- Step progress for The Sahagin's Stash (Outlands quest 136). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/The_Sahagins_Stash.lua (Laisrean 33 is the offer, played on a decline too and only
-- option 1 begins the quest; while accepted his talk is 34, or 35 with the Sea serpent statue held; the Sea Serpent Grotto ??? plays event 1
-- while the statue is not held and its finish gives key item 296; 35's finish runs quest:complete and only then takes the statue, and the
-- reward includes a scroll, so 35 also plays on a full bag). Client event script S4 252_Laisrean_010FC01B.txt (33 say #10282 on the Yes
-- branch, 34 say #10285, 35 say #10288). Key item 296 from res/key_items.lua. The grotto directions (n=2 to n=8) are notes on the ???
-- step. Event 35 is reach, and the log's completed bit or the statue leaving the key items (it is taken only after the quest completed)
-- proves s10. The ??? event is not used: the grotto has no client script of its own for it and the key item says the same. Not repeatable.
return {
    title = "The Sahagin's Stash",
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to laisrean in norg at'},
         done = {
            {t = 'chat', re = "Great! If it wasn't for you, who knows what I'd do%.", why = 'Laisrean 33, Yes branch only (say #10282)'},
            {t = 'quest', current = true, why = 'quest log: accepted (Laisrean 33, option 1)'},
            {t = 'event', zone = 252, event = 34, conf = 'inferred', why = 'Laisrean 34: his talk while accepted'},
            {t = 'chat', re = 'Before the Sahagin took over, the pirates here used to use the grotto as a storage area%.', conf = 'inferred', why = 'Laisrean 34 (say #10285)'},
         },
         reach = {{t = 'event', zone = 252, event = 33, why = 'Laisrean 33 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's9', at = {n = 2, fp = 'exit norg into sea serpent grotto'}},
        {id = 's3', kind = 'note', with = 's9', at = {n = 3, fp = 'head south until you reach the'}},
        {id = 's4', kind = 'note', with = 's9', at = {n = 4, fp = 'turn south at j 5'}},
        {id = 's5', kind = 'note', with = 's9', at = {n = 5, fp = 'head east at j 10'}},
        {id = 's6', kind = 'note', with = 's9', at = {n = 6, fp = 'turn east at k 12'}},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'go past the silver door at'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'fall off the path to the'}},
        {id = 's9', at = {n = 9, fp = 'follow this path until you find'},
         done = {
            {t = 'ki', id = 296, gained = true, after = 's1', why = 'sea serpent statue obtained (the Sea Serpent Grotto ???)'},
            {t = 'ki_have', id = 296, have = true, after = 's1', why = 'sea serpent statue held'},
            {t = 'chat', re = 'obtained key item: sea serpent statue', after = 's1', why = 'chat: key item obtained'},
            {t = 'event', zone = 252, event = 35, after = 's1', conf = 'inferred', why = 'Laisrean 35: plays only with the statue held'},
         }},
        {id = 's10', at = {n = 10, fp = 'return to laisrean for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Laisrean 35)'},
            {t = 'ki', id = 296, gained = false, after = 's9', why = 'sea serpent statue taken, only after the quest was completed'},
         },
         reach = {
            {t = 'event', zone = 252, event = 35, after = 's9', why = 'Laisrean 35 (also plays when the bag is full: nothing is given)'},
            {t = 'chat', re = "You're back! You did it! I can't believe it!", after = 's9', why = 'Laisrean 35 (say #10288)'},
         }},
    },
}

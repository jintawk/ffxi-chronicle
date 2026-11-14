-- Step progress for Black Market (Outlands quest 130). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Norg/npcs/Muzaffar.lua (event 15 is the offer, option 1 adds the quest; 16 is his reminder while
-- the quest is accepted or completed; a trade of four Northern Fur, Eastern Pottery or Southern Mummy plays 17, 18 or 19 after the trade
-- is taken, pays gil (no item, so no refusal) and completes the quest only if it was still accepted, then 20 plays). Client event script
-- S4 252_Muzaffar_010FC018.txt (15 say #10167 on the Yes branch, 16 say #10172, 17 to 19 say #10173, 20 say #10175). The quest is
-- repeatable: after the first completion every further set plays 17 to 19 again with no new accept (the quest log is not touched), so
-- the trade restarts the quest log's first run as a new run (s1 is not needed on a repeat) and the log's bits count for the first run
-- only (run1). The Auction House tip (n=3) is a note on the trade step.
return {
    title = 'Black Market',
    completes = 's2',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s2'}, skip = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to muzaffar to begin the'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (Muzaffar 15, option 1; first run only)'},
            {t = 'chat', re = "That's the answer I was lookin' for!", why = 'Muzaffar 15, Yes branch only (say #10167)'},
            {t = 'event', zone = 252, event = 16, conf = 'inferred', why = 'Muzaffar 16: his reminder, only once accepted'},
            {t = 'chat', re = 'You already forgot what I want you to bring%?', conf = 'inferred', why = 'Muzaffar 16 (say #10172)'},
         },
         reach = {{t = 'event', zone = 252, event = 15, why = 'Muzaffar 15 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'bring him either 4 eastern pottery'},
         done = {
            {t = 'event', zone = 252, event = 17, why = 'Muzaffar 17: four Northern Fur taken'},
            {t = 'event', zone = 252, event = 18, why = 'Muzaffar 18: four Eastern Pottery taken'},
            {t = 'event', zone = 252, event = 19, why = 'Muzaffar 19: four Southern Mummy taken'},
            {t = 'chat', re = "If it isn't a set of", why = 'Muzaffar 17 to 19 (say #10173)'},
            {t = 'event', zone = 252, event = 20, why = 'Muzaffar 20: plays only after a set was paid'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'all the required items can be'}},
    },
}

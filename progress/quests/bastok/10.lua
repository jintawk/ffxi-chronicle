-- Step progress for Breaking Stones (Bastok quest 10). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Breaking_Stones.lua (Horatius 100 is the offer and only option 0 begins the
-- quest; Horatius 101 plays only on a Dangruf Stone trade and runs quest:complete, and also runs on any later repeat);
-- scripts/zones/Dangruf_Wadi/npcs/qm2.lua (the ??? plays event 110 on every examine and gives the stone with option 0, with
-- any quest status; text "Obtained: <item>." from the zone's IDs.lua); client event script S4 235_Horatius_010EB002.txt (100
-- say #7475 on the Yes branch only, 101 say #7481); item id from res/items.lua (553 Dangruf Stone). The page's ??? bullet is
-- the stone pickup, so it is a step with the pickup as proof. A repeat needs no new accept, but a new stone after a finished
-- run opens the next one (the Siren's Tear pattern); the log marks the first run only.
-- Shared-signal audit: the Dangruf Stone (item 553, its ??? at event 191/110, the "Obtained" line) is also fetched for Aht Urhgan
-- An Empty Vessel and Jeuno LB09 Dormant Powers Dislodged -> shared with those quests, gated after s1; item_have 553 dropped.
-- A restart after a finished run still opens on any new stone (the repeat has no other trace).
-- Repeat runs are not tracked: `repeatable.restart` removed, because a new tear/stone (also fetched for other quests) would reopen a finished page. First run and its completion stay.
return {
    title = 'Breaking Stones',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with horatius inside of the'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'chat', re = 'Let me introduce myself%. I am Horatius, the foremost gem collector in all of Bastok%.', why = 'Horatius 100, Yes branch only (say #7475)'},
         },
         reach = {{t = 'event', zone = 235, event = 100, why = 'Horatius 100 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'inside dangruf wadi head to the'},
         reach = {
            {t = 'event', zone = 191, event = 110, after = 's1', why = '??? examined (plays whether or not the stone is taken)'},
         },
         done = {
            {t = 'chat', re = 'Obtained: Dangruf Stone', after = 's1', why = 'ITEM_OBTAINED from the ??? (qm2.lua)'},
            {t = 'item', id = 553, gained = true, after = 's1', why = 'Dangruf Stone gained'},
         }},
        {id = 's3', at = {n = 3, fp = 'head back to horatius for your'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'event', zone = 235, event = 101, why = 'Horatius 101: the stone accepted, runs quest:complete'},
            {t = 'chat', re = 'What a strange, wondrous stone%.%.%.', why = 'Horatius 101 (say #7481)'},
            {t = 'item', id = 553, lost = true, after = 's2', conf = 'inferred', why = 'Dangruf Stone gone (traded, or dropped)'},
         }},
    },
}

-- Step progress for Making the Grade (Windurst quest 4). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Making_the_Grade.lua (Fuepepe 442 is the offer menu and can be declined;
-- 443 is his talk while the sheets are still missing; the exact Pile of answer sheets trade at Prog 0 plays 455 and sets
-- Prog 1, then 456 is his talk; Koru-Moru 285 is the exact trade at Prog 1, which confirms it, gives the Tattered test sheet
-- and sets Prog 2, while 287 is the same trade or a talk with the sheets at the WRONG progress, so it proves nothing, and
-- 286 is his talk afterwards; Fuepepe 458 at Prog 2 or 3 completes the quest, but the Scroll of Aspir reward cannot be given
-- on a full bag while 458 still plays, so it is only a reach and the quest log's completed bit carries the last step; 459
-- plays once completed; Chomoro-Kyotoro 460 at Prog 2 takes the sheet back). Disagreements with the draft: 287 was offered
-- as proof of the Koru-Moru trade, 456 (Prog 1, after the Fuepepe trade) was offered as the reward step, 446 and 445 are
-- optional hints that play at any time while accepted, and the draft's post bullet cannot be reached after completion (the
-- quest is over, only 459 plays), so the "Optional dialogue" bullet is an optional step proved by 460. Client event scripts
-- S4 238_Fuepepe_010EE036.txt (442 menu #8388, 443 say #8393, 456 say #8417, 459 say #8425) and 239_Koru_Moru_010EF021.txt
-- (285, 286 say #7772); key item id from res/key_items.lua (125 tattered test sheet). The quest log is set at s1, so it is
-- not silent.
return {
    title = 'Making the Grade',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to fuepepe in the east'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 238, event = 443, conf = 'inferred', why = 'Fuepepe 443: reminder, only once accepted'},
            {t = 'chat', re = 'Please bring back the answer papers to me%.', conf = 'inferred', why = 'Fuepepe 443 (say #8393)'},
         },
         reach = {{t = 'event', zone = 238, event = 442, why = 'Fuepepe 442 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade the test answers to fuepepe'},
         done = {
            {t = 'event', zone = 238, event = 455, why = 'Fuepepe 455: the answer sheets accepted'},
            {t = 'event', zone = 238, event = 456, conf = 'inferred', why = 'Fuepepe 456: his talk once the sheets are handed in'},
            {t = 'chat', re = 'Please take the answer sheets to the principal%.', conf = 'inferred', why = 'Fuepepe 456 (say #8417)'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade the test answers to koru'},
         done = {
            {t = 'event', zone = 239, event = 285, why = 'Koru-Moru 285: the exact trade at the right progress'},
            {t = 'ki', id = 125, gained = true, why = 'tattered test sheet obtained'},
            {t = 'ki_have', id = 125, have = true, why = 'tattered test sheet held'},
            {t = 'chat', re = 'obtained key item: tattered test sheet', why = 'chat: key item obtained'},
            {t = 'event', zone = 239, event = 286, conf = 'inferred', why = 'Koru-Moru 286: his talk once the trade is done'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to fuepepe for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 238, event = 459, conf = 'inferred', why = 'Fuepepe 459: plays only once completed'},
         },
         reach = {{t = 'event', zone = 238, event = 458, why = 'Fuepepe 458 (also plays when the Scroll of Aspir cannot be given)'}}},
        {id = 's5', kind = 'optional', at = {n = 5, fp = 'you can use the tattered test'},
         done = {
            {t = 'event', zone = 238, event = 460, why = 'Chomoro-Kyotoro 460: the sheet used'},
            {t = 'ki', id = 125, gained = false, why = 'tattered test sheet taken back at Chomoro-Kyotoro 460'},
         }},
    },
}

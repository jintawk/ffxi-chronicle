-- Step progress for Northward (Jeuno quest 24). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Northward.lua (Radeivepart, Ru'Lude Gardens: 159 is his menu and carries the
-- state in P0, 1 = the offer whose option 0 begins the quest, so it is only a reach, 2 = accepted, 3 = completed; the Yes
-- branch says "I knew you were the one!"; 61 plays only for an exact Flame Degen trade and runs quest:complete, whose reward
-- is experience, gil, a key item and a title, nothing to refuse); client event script S4 243_Radeivepart_010F3021.txt (159
-- say #10261 on the Yes branch and #10263 at P0 = 2, 61 say #10264); item id from res/items.lua (16522 Flame Degen) and key
-- item from res/key_items.lua (412 map of Castle Zvahl). Bullet 2 lists where a Flame Degen can come from, so it is a note on
-- the trade (an item held proves nothing: it can be had before the quest). Not repeatable.
-- The map (key item 412) is left out: map sellers hand it out too (scripts/globals/maps.lua), so it is no proof of this quest.
return {
    title = 'Northward',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'radeivepart requests that you bring him'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Radeivepart 159, option 1)'},
            {t = 'chat', re = 'I knew you were the one!', why = 'Radeivepart 159, Yes branch only (say #10261)'},
            {t = 'event', zone = 243, event = 159, p = {[0] = 2}, why = 'Radeivepart 159, P0 = 2: accepted and waiting for the Flame Degen'},
         },
         reach = {{t = 'event', zone = 243, event = 159, p = {[0] = 1}, why = 'Radeivepart 159, P0 = 1: the offer (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'a flame degen can be obtained'}},
        {id = 's3', at = {n = 3, fp = 'trade the flame degen to radeivepart'},
         done = {
            {t = 'event', zone = 243, event = 61, why = 'Radeivepart 61: the Flame Degen accepted'},
            {t = 'chat', re = 'Good job! I knew you could do it%. But be on your guard%.', why = 'Radeivepart 61 (say #10264)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 16522, lost = true, after = 's1', conf = 'inferred', why = 'Flame Degen gone (traded, or sold)'},
         }},
    },
}

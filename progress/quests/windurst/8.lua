-- Step progress for Making Amens! (Windurst quest 8). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Port_Windurst/npcs/Kuroido-Moido.lua (event 280 starts the quest and the client script
-- has no menu in it, so nothing can refuse it; 283 is the reminder while accepted and the wand is not held; 284 is the
-- hand-in, which completes the quest and takes the Broken wand, with gil, title and fame only as reward, so nothing in it can
-- refuse; 286 plays only once completed) and zones/Garlaige_Citadel/npcs/Mashira.lua (event 11 is a three-option menu that
-- also serves Rubbish Day, option 0 gives the Broken wand while the quest is accepted, so the event is only a reach and the
-- key item is the proof); client event scripts S4 240_Kuroido_Moido_010F0012.txt (283 say #3791) and 200_Mashira_010C8159.txt
-- (11 menu #7240); key item id from res/key_items.lua (128 broken wand). Bullet 3 (kill Fallen Evacuees for the Garlaige Key)
-- is left a plain bullet: the key is a drop that only an item gain could show, and an item alone proves nothing. Bullets 2
-- and 4 are travel and key-use directions and are notes on the Mashira talk. Not repeatable (page meta). The quest log is
-- set at s1, so it is not silent.
-- Shared-signal audit: Mashira event 200:11 is also Rubbish Day's menu (jeuno/13): shared with jeuno/13, gated after s1.
return {
    title = 'Making Amens!',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kuroido moido to begin'},
         done = {
            {t = 'event', zone = 240, event = 280, why = 'Kuroido-Moido 280: the quest begun'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 240, event = 283, conf = 'inferred', why = 'Kuroido-Moido 283: reminder, only once accepted'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'head to garlaige citadel'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'head past the first two banishing'}},
        {id = 's5', at = {n = 5, fp = 'speak to mashira in the incinerator'},
         done = {
            {t = 'ki', id = 128, gained = true, why = 'broken wand obtained'},
            {t = 'ki_have', id = 128, have = true, why = 'broken wand held'},
            {t = 'chat', re = 'obtained key item: broken wand', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 200, event = 11, after = 's1', why = 'Mashira 11 offered (the wand needs option 0)'}}},
        {id = 's6', at = {n = 6, fp = 'return to kuroido moido for your'},
         done = {
            {t = 'event', zone = 240, event = 284, why = 'Kuroido-Moido 284: the wand handed in'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 128, gained = false, conf = 'inferred', why = 'broken wand handed over'},
            {t = 'event', zone = 240, event = 286, conf = 'inferred', why = 'Kuroido-Moido 286: plays only once completed'},
         }},
    },
}

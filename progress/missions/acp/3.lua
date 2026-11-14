-- Step progress for Gatherer of Light (II) (A Crystalline Prophecy mission 4, mission id 3). Data only; see progress/missions/acp/1.lua.
-- Evidence: LandSandBoat scripts/zones/Qufim_Island/npcs/qm3.lua (zone 126): on this mission the first examine starts the battle
-- (LandSandBoat has no event for it yet and prints "Confrontation Battles are not working yet"), the second examine plays event 34
-- and its onEventFinish completes the mission and sets Those Who Lurk in Shadows (I). Event 34 is LandSandBoat's only id for the
-- cutscene (no decoded client script for this NPC), so the acp line moving to 4 backs it and covers a character that finished before
-- installing Chronicle. The Amber Key (key item 1107, res/key_items.lua) is the battle reward (page bullet 4); its only source is the
-- battle, so its gain proves that bullet (the Treasure Coffer, Lower Jeuno 245 event 10099, shows the same menu for every key and
-- deletes the key only when a prize is given, Treasure_Coffer_Tenshodo.lua givePrize). Bullets 1 to 3 (prepare, examine to begin,
-- the waves) have no event of their own and are notes on bullet 4. The repeat bullets 6 to 8 (re-obtain the three Seedspall key items
-- and fight again for another Amber Key) share their key items and the Amber Key gain with the first run, so they cannot be told
-- apart by a signal and are notes on the key's use, bullet 9, a post step: the Amber Key leaving the key items, counted only once
-- the cutscene is done (a first key opened before the cutscene would otherwise tick the cutscene by inference). The draft made the
-- Seedspall re-obtain bullet a step on three key items at once, so one gain would have ticked it.
return {
    title = 'Gatherer of Light (II)',
    completes = 's5',
    known = {{t = 'mission', line = 'acp', eq = 3}},
    groups = {main = {start = {{t = 'mission', line = 'acp', min = 3, why = 'mission line: Gatherer of Light (II) is current'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'prepare to battle trust magic can'}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'examine the at g 6 in'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'several waves of seed mandragoras will'}},
        {id = 's4', at = {n = 4, fp = 'after killing several waves of seed'},
         done = {
            {t = 'ki', id = 1107, gained = true, why = 'Amber Key obtained (the six waves of Seed Mandragoras beaten)'},
            {t = 'ki_have', id = 1107, have = true, why = 'Amber Key held'},
            {t = 'chat', re = 'obtained key item: amber key', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'examine the again for a cutscene'},
         done = {
            {t = 'event', zone = 126, event = 34, why = 'qm3 34: the cutscene after the battle, completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'acp', min = 4, why = 'mission line: Those Who Lurk in Shadows (I) is current, Gatherer of Light (II) is done'},
         }},
        {id = 's6', kind = 'note', with = 's9', at = {n = 6, fp = 're obtain a seedspall roseum seedspall'}},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'travel to qufim island and examine'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'when you ve defeated all six'}},
        {id = 's9', kind = 'post', at = {n = 9, fp = 'use the amber key level 50'},
         done = {
            {t = 'ki', id = 1107, gained = false, after = 's5', why = 'Amber Key used at the Treasure Coffer (deleted when the prize is given)'},
         }},
    },
}

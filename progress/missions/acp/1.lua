-- Step progress for The Echo Awakens (A Crystalline Prophecy mission 2, mission id 1). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Qufim_Island/npcs/qm3.lua (the ??? at G-6, zone 126): onTrade with Seedspall Lux, Luna and
-- Astrum (items 2740 to 2742) while this mission is current plays event 31 and, in onEventFinish, completes the mission and sets the
-- next one (Gatherer of Light (I)). Event 31 plays only on that trade (no refusal path), so it proves the trade; the acp line moving
-- to 2 (core/data's "Current ACP Mission", the only ACP read: there is no completed set for acp) proves it too, and covers a
-- character that finished before installing Chronicle. LandSandBoat is the only source for the event id (no client script for this
-- NPC is decoded). The Seedspalls are items and can be gathered anywhere, so the collect bullet is a note.
-- The page's last three bullets are the repeat for the Crimson Key, which exists only after the mission is done: Squintrox Dryeyes
-- (Port Jeuno 246, event 323, a menu that plays on any visit and proves nothing) hands over the Crimson Key (key item 1105,
-- res/key_items.lua) for the three Seedspalls, once a day; the key's only source is that trade, so its gain proves bullet 4. The
-- Treasure Coffer (Lower Jeuno 245, event 10099, the same menu for every key) deletes the key only when a prize is given
-- (Treasure_Coffer_Tenshodo.lua givePrize), so the key leaving the key items proves bullet 5. Both are post steps. A repeat only
-- re-ticks them. The draft had no marker for bullet 2 (event 31 and the line now prove it) and made the key bullets plain steps.
return {
    title = 'The Echo Awakens',
    completes = 's2',
    known = {{t = 'mission', line = 'acp', eq = 1}},
    groups = {main = {start = {{t = 'mission', line = 'acp', min = 1, why = 'mission line: The Echo Awakens is current'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'collect the following 3 items'}},
        {id = 's2', at = {n = 2, fp = 'trade the 3 seedspalls to the'},
         done = {
            {t = 'event', zone = 126, event = 31, why = 'qm3 31: the three Seedspalls accepted, completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'acp', min = 2, why = 'mission line: Gatherer of Light (I) is current, The Echo Awakens is done'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'collect the 3 seedspalls again'}},
        {id = 's4', kind = 'post', at = {n = 4, fp = 'head to port jeuno and trade'},
         done = {
            {t = 'ki', id = 1105, gained = true, why = 'Crimson Key obtained (Squintrox Dryeyes)'},
            {t = 'ki_have', id = 1105, have = true, why = 'Crimson Key held'},
            {t = 'chat', re = 'obtained key item: crimson key', why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'post', at = {n = 5, fp = 'use the crimson key level 30'},
         done = {
            {t = 'ki', id = 1105, gained = false, why = 'Crimson Key used at the Treasure Coffer (deleted when the prize is given)'},
         }},
    },
}

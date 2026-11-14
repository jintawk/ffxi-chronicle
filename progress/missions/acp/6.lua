-- Step progress for Those Who Lurk in Shadows (III) (A Crystalline Prophecy mission 7, mission id 6). Data only; see progress/missions/acp/1.lua.
-- Evidence: LandSandBoat scripts/battlefields/QuBia_Arena/those_who_lurk_in_shadows.lua, zones/QuBia_Arena/npcs/Burning_Circle.lua
-- (zone 206) and zones/QuBia_Arena/IDs.lua. The battlefield needs the Mark of Seed (key item 1091, res/key_items.lua) and takes it
-- at the entry with "Lost key item: <keyitem>." (LOST_KEYITEM, text 6399), so the Mark leaving the key items proves that the fight
-- began (bullet 1: the cutscene, then examine again). The cutscene is the Burning Circle's event 5 (LandSandBoat completes the
-- previous mission there; its code is disabled and the id is LandSandBoat's only), kept as `reach`. The win (onEventFinishWin)
-- completes this mission, moves the line to Remember Me in Your Dreams and gives the Ivory Key (key item 1109) while this mission
-- or a later one is current, so the Ivory Key gain and the acp line having moved to 7 prove bullet 3 (`completes`). The repeat
-- bullets 4 and 5 (re-obtain a Mark of Seed, fight again for another Ivory Key) reuse the same signals as the first run, so they
-- are notes on bullet 6, the key use, a post step: the Ivory Key leaving the key items (the Treasure Coffer, Lower Jeuno 245 event
-- 10099, deletes it when a prize is given). Bullet 2 lists the four opponents and is a note. The draft had no marker for bullet 1
-- (it only noted that the Mark of Seed is taken at the entry) and made bullets 4 to 6 plain steps.
return {
    title = 'Those Who Lurk in Shadows (III)',
    completes = 's3',
    known = {{t = 'mission', line = 'acp', eq = 6}},
    groups = {main = {start = {{t = 'mission', line = 'acp', min = 6, why = 'mission line: Those Who Lurk in Shadows (III) is current'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the burning circle qu bia'},
         done = {
            {t = 'ki', id = 1091, gained = false, why = 'Mark of Seed taken at the Qu Bia Arena battlefield entry'},
            {t = 'chat', re = 'lost key item: mark of seed', why = 'Qu Bia Arena text 6399 (LOST_KEYITEM) at the entry'},
         },
         reach = {
            {t = 'event', zone = 206, event = 5, why = 'Burning Circle 5: the cutscene before the fight (LandSandBoat)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you will face 4 opponents in'}},
        {id = 's3', at = {n = 3, fp = 'when the battle is completed there'},
         done = {
            {t = 'ki', id = 1109, gained = true, why = 'Ivory Key obtained (the battlefield won)'},
            {t = 'ki_have', id = 1109, have = true, why = 'Ivory Key held'},
            {t = 'chat', re = 'obtained key item: ivory key', why = 'chat: key item obtained'},
            {t = 'mission', line = 'acp', min = 7, why = 'mission line: Remember Me in Your Dreams is current, Those Who Lurk in Shadows (III) is done'},
         }},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 're obtain a mark of seed'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'repeat the mission to receive another'}},
        {id = 's6', kind = 'post', at = {n = 6, fp = 'use the ivory key level 70'},
         done = {
            {t = 'ki', id = 1109, gained = false, why = 'Ivory Key used at the Treasure Coffer (deleted when the prize is given)'},
         }},
    },
}

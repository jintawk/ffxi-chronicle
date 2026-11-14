-- Step progress for Ode of Life Bestowing (A Crystalline Prophecy mission 11, mission id 10). Data only; see progress/missions/acp/1.lua.
-- Evidence: res/key_items.lua only. LandSandBoat's script for this mission is an empty stub (scripts/missions/acp/11_Ode_Of_Life_Bestowing.lua)
-- and its Qe'Iov Gate and battlefield are not implemented, so no event is used. By the same rule as Those Who Lurk in Shadows
-- (III) (see progress/missions/acp/6.lua) the fight takes the Omnis Stone (key item 1104) at the entry, which is why the page says
-- to re-obtain one for a repeat, and the win gives the Ebon Key (1110); the Ebon Key's only source is the fight (the Treasure Coffer,
-- Lower Jeuno 245 event 10099, deletes it when a prize is given). Bullet 2 is the fight: the Ebon Key gain and the acp line moving to
-- 11 prove it and complete the mission, the Omnis Stone leaving the key items (and its "Lost key item" line) shows the fight began
-- and is `reach`. Bullet 1 (the gate's cutscene) has no event of its own and is a note on it, bullet 3 is the boss description.
-- The repeat bullets 4 and 5 (re-obtain the Omnis Stone, fight again for another Ebon Key) reuse the first run's signals, so
-- they are notes on bullet 6, the key use, a post step (the Ebon Key leaving the key items). The draft made bullets 4 to 6 plain
-- steps and had no marker for the fight.
return {
    title = 'Ode of Life Bestowing',
    completes = 's2',
    known = {{t = 'mission', line = 'acp', eq = 10}},
    groups = {main = {start = {{t = 'mission', line = 'acp', min = 10, why = 'mission line: Ode of Life Bestowing is current'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'examine the qe iov gate in'}},
        {id = 's2', at = {n = 2, fp = 'examine it again to begin the'},
         done = {
            {t = 'ki', id = 1110, gained = true, why = 'Ebon Key obtained (the fight won)'},
            {t = 'ki_have', id = 1110, have = true, why = 'Ebon Key held'},
            {t = 'chat', re = 'obtained key item: ebon key', why = 'chat: key item obtained'},
            {t = 'mission', line = 'acp', min = 11, why = 'mission line: A Crystalline Prophecy (Fin.) is current, Ode of Life Bestowing is done'},
         },
         reach = {
            {t = 'ki', id = 1104, gained = false, why = 'Omnis Stone taken at the Qe Iov Gate battlefield entry'},
            {t = 'chat', re = 'lost key item: omnis stone', why = 'Lost key item line at the entry'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'instead of normal melee attacks it'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 're obtain an omnis stone from'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'repeat the mission as described above'}},
        {id = 's6', kind = 'post', at = {n = 6, fp = 'use the ebon key level 75'},
         done = {
            {t = 'ki', id = 1110, gained = false, why = 'Ebon Key used at the Treasure Coffer (deleted when the prize is given)'},
         }},
    },
}

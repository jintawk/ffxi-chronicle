-- Step progress for To Each His Own Right (Windurst mission 3-1, mission id 10). Data only; see progress/missions/windurst/1.lua
-- for the format notes. Evidence: LandSandBoat scripts/missions/windurst/3_1_To_Each_His_Own_Right.lua and the client event
-- scripts (S4 pseudo) 242_Kupipi, 242_Rhy_Epocan, 240_Hakkuru_Rinkuru; key item id from res/key_items.lua.
-- The page has no accept bullet: it starts at Kupipi (event 103, a progressEvent at status 0 that hands over the Starway Stairway
-- bauble; the Permanent key item can already be held, so it only supports). Each later talk is a progressEvent at its own
-- status: Rhy Epocan 107, Hakkuru-Rinkuru 147, the Castle Oztroja trap door 43 (zone 151, LandSandBoat only; fired by either of
-- two NPCs), Rhy Epocan 114 completes. Kupipi 104, Rhy Epocan 108, Hakkuru-Rinkuru 148 and Kupipi 113 are the reminders played
-- at the status each step leaves behind, so each also proves its step. The Sibyl Guard lines (109 to 112) and the post-mission
-- events (115 to 118, 162) are not used.
return {
    title = 'To Each His Own Right',
    completes = 's5',
    known = {{t = 'mission', line = 'windurst', eq = 10}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kupipi in heavens tower'},
         done = {
            {t = 'event', zone = 242, event = 103, why = 'Kupipi 103: the Starway Stairway bauble handed over'},
            {t = 'ki', id = 36, gained = true, why = 'Starway Stairway bauble obtained (given with event 103)'},
            {t = 'event', zone = 242, event = 104, why = 'Kupipi 104, her reminder at status 1'},
            {t = 'chat', re = 'When visiting the upper floors of the tower, you must be on your', why = 'Kupipi 104 (say #147)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to rhy epocan at the'},
         done = {
            {t = 'event', zone = 242, event = 107, why = 'Rhy Epocan 107: the cutscene at the top of the tower (status 1 to 2)'},
            {t = 'event', zone = 242, event = 108, why = 'Rhy Epocan 108, his reminder at status 2'},
            {t = 'chat', re = 'Orastery minister, Ajido%-Marujido%.%.%.', why = 'Rhy Epocan 108 (say #179)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to hakkuru rinkuru at the'},
         done = {
            {t = 'event', zone = 240, event = 147, why = 'Hakkuru-Rinkuru 147: hints on Ajido-Marujido (status 2 to 3)'},
            {t = 'event', zone = 240, event = 148, why = 'Hakkuru-Rinkuru 148, his reminder at status 3'},
            {t = 'chat', re = 'Or more to the point, why would our ding%-a%-ling minister head off to such a dangerous place as Castle Oztroja on his own%?', why = 'Hakkuru-Rinkuru 148 (say #3491)'},
         }},
        {id = 's4', at = {n = 4, fp = 'go to castle oztroja and fall'},
         done = {
            {t = 'event', zone = 151, event = 43, why = 'Castle Oztroja 43: the trap door cutscene (status 3 to 4)'},
            {t = 'event', zone = 242, event = 113, why = 'Kupipi 113, her line at status 4'},
            {t = 'chat', re = 'Have I seen the Orastery minister%? He just stormed out of here a few minutes ago%.', why = 'Kupipi 113 (say #189)'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to rhy epocan to complete'},
         done = {
            {t = 'mission', line = 'windurst', eq = 10, completed = true, why = 'mission log: To Each His Own Right completed'},
            {t = 'event', zone = 242, event = 114, why = 'Rhy Epocan 114: mission completed'},
         }},
    },
}

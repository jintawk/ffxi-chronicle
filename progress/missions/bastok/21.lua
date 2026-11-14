-- Step progress for Enter the Talekeeper (Bastok mission 8-2, mission id 21). Data only; see progress/missions/bastok/15.lua.
-- Evidence: LandSandBoat scripts/missions/bastok/8_2_Enter_the_Talekeeper.lua. A gate guard hands the mission out (event 1001,
-- option 21); the nation line moving to id 21 opens the group (s1 becomes next). Drake Fang (Zeruhn Mines 172): 202 at status 0
-- (sets 1), 203 at status 1 to 3 (a plain reminder, say #7403, only possible after 202), 204 at status 4 (sets 5 and moves you to
-- Bastok Mines). The first ??? (qm5, Kuftal Tunnel 174) plays event 12 at status 1, a yes/no menu: status 2 and "The piece of wood
-- fell off the cliff!" (Kuftal IDs.lua 7359) only on option 0, so event 12 also plays on a decline and is not proof; the FELL line
-- is. The second ??? (qm6) spawns the three ghosts at status 2 ("You sense an evil presence...", a generic phrase: bullet 5 is a
-- note) and plays event 13 at status 3 (sets 4 and gives the Old piece of wood, key item 293). The completion is the zone-in event
-- 176 in Bastok Mines (234, a continuation of Drake Fang 204 at status 5): it completes the mission and takes the Old piece of wood.
-- The Gumbah, Detzo and Iron Eater cutscenes (183, 184, 769) are the indented optional line, not a step. Event bodies 202 to 204 and
-- 12, 13, 176 are not decoded.
return {
    title = 'Enter the Talekeeper',
    completes = 's7',
    known = {{t = 'mission', line = 'bastok', min = 0}},
    groups = {main = {start = {{t = 'mission', line = 'bastok', eq = 21, completed = false, why = 'mission line: current mission = Enter the Talekeeper'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'visit drake fang in zeruhn mines'},
         done = {
            {t = 'event', zone = 172, event = 202, why = 'Drake Fang 202 (status 0 only)'},
            {t = 'event', zone = 172, event = 203, conf = 'inferred', why = 'Drake Fang 203: reminder, only after 202'},
            {t = 'chat', re = "When you find proof of Werei's journey, bring it here%.", conf = 'inferred', why = 'Drake Fang 203 (say #7403), only after 202'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head for kuftal tunnel map 1'}},
        {id = 's3', at = {n = 3, fp = 'interact with the you ll receive'},
         done = {
            {t = 'chat', re = 'The piece of wood fell off the cliff!', why = 'the first ??? answered yes (Kuftal Tunnel text 7359)'},
         },
         reach = {
            {t = 'event', zone = 174, event = 12, why = 'qm5 12 offered (its finish needs option 0)'},
         }},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'sneak up and head down around'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'checking the will spawn 3 level'}},
        {id = 's6', at = {n = 6, fp = 'check the again for a cutscene'},
         done = {
            {t = 'event', zone = 174, event = 13, why = 'qm6 13 (status 3 only)'},
            {t = 'ki', id = 293, gained = true, why = 'Old piece of wood obtained'},
            {t = 'ki_have', id = 293, have = true, why = 'Old piece of wood held'},
            {t = 'chat', re = 'obtained key item: old piece of wood', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to drake fang for a'},
         done = {
            {t = 'mission', line = 'bastok', eq = 21, completed = true, why = 'mission log: Enter the Talekeeper completed'},
            {t = 'event', zone = 172, event = 204, why = 'Drake Fang 204 (status 4 only)'},
            {t = 'zonein', zone = 234, event = 176, why = 'Bastok Mines zone-in event 176: completes the mission'},
         }},
    },
}

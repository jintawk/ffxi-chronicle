-- Step progress for The Horutoto Ruins Experiment (Windurst mission 1-1, mission id 0). Data only; see
-- progress/missions/sandoria/0.lua (the same shape: id 0, accept at a gate guard) and progress/missions/bastok/15.lua.
-- Evidence: LandSandBoat scripts/missions/windurst/1_1_The_Horutoto_Ruins_Experiment.lua. The four gate guards offer it (Janshura-
-- Rashura 83 in Port Windurst 240, Zokima-Rokima 96 in Windurst Walls 239, Mokyokyo 118 in Windurst Waters 238, Rakoh Buuma 121 in
-- Windurst Woods 241) and the accept is option 1 of the same event, so the offers play on a decline too and sit in `reach`; the
-- nation line moving to id 0 (65535 before; completing sets it back and adds id 0 to the completed set) is the accept proof.
-- The reminder events at the guards (89, 99, 123, 127) are not used: LandSandBoat itself notes retail fires a different id for
-- Mokyokyo. Hakkuru-Rinkuru (Port Windurst 240): 90 at status 1 (sets 2), 91 at status 2 (reminder, only after 90), 94 at status
-- 4 (completes the mission and takes the Cracked Mana Orb, key item 28). Sama Gohjima (East Sarutabaruta 116) plays event 53 (say
-- #7416) only at status 2 (his usual talk is event 43): the optional bullet. The Gate: Magical Gizmo in the Inner Horutoto Ruins
-- (192) plays event 42 at status 2 (sets 3); the six gizmos play a success event (48, 50, 52, 54, 56 or 58, gives the orb and
-- sets 4) or a failure event (49, 51, 53, 55, 57, 59, the orb is not broken: not listed). The pseudo-code has no zone 192 script, so
-- those ids come from LandSandBoat. Event bodies 83, 90, 94 are empty in the pseudo-code.
return {
    title = 'The Horutoto Ruins Experiment',
    completes = 's10',
    known = {{t = 'mission', line = 'windurst', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to any windurstian gate guard'},
         done = {
            {t = 'mission', line = 'windurst', eq = 0, completed = false, why = 'mission line: current mission = The Horutoto Ruins Experiment'},
         },
         reach = {
            {t = 'event', zone = 240, event = 83, why = 'Janshura-Rashura 83 offered (its finish needs option 1)'},
            {t = 'event', zone = 239, event = 96, why = 'Zokima-Rokima 96 offered (its finish needs option 1)'},
            {t = 'event', zone = 238, event = 118, why = 'Mokyokyo 118 offered (its finish needs option 1)'},
            {t = 'event', zone = 241, event = 121, why = 'Rakoh Buuma 121 offered (its finish needs option 1)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head for the orastery in port'},
         done = {
            {t = 'event', zone = 240, event = 90, why = 'Hakkuru-Rinkuru 90 (status 1 only)'},
            {t = 'event', zone = 240, event = 91, conf = 'inferred', why = 'Hakkuru-Rinkuru 91: reminder, only after 90'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'make your way to j 7'}},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'optional speak to sama gohjima near'},
         done = {
            {t = 'event', zone = 116, event = 53, why = 'Sama Gohjima 53 (status 2 only)'},
            {t = 'chat', re = 'The ministerrr of the Orastery is in the laborrratory beneath here%.', why = 'Sama Gohjima 53 (say #7416)'},
         }},
        {id = 's5', kind = 'note', with = 's8', at = {n = 5, fp = 'head down the stairs to the'}},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'inside you ll be in the'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'run to the other side and'}},
        {id = 's8', at = {n = 8, fp = 'check the gate magical gizmo at'},
         done = {
            {t = 'event', zone = 192, event = 42, why = 'Gate: Magical Gizmo 42 (status 2 only)'},
         }},
        {id = 's9', at = {n = 9, fp = 'now head back out and check'},
         done = {
            {t = 'ki', id = 28, gained = true, why = 'Cracked Mana Orb obtained'},
            {t = 'ki_have', id = 28, have = true, why = 'Cracked Mana Orb held'},
            {t = 'chat', re = 'obtained key item: cracked mana orb', why = 'chat: key item obtained'},
            {t = 'event', zone = 192, event = 48, why = 'Gizmo 1 success'},
            {t = 'event', zone = 192, event = 50, why = 'Gizmo 2 success'},
            {t = 'event', zone = 192, event = 52, why = 'Gizmo 3 success'},
            {t = 'event', zone = 192, event = 54, why = 'Gizmo 4 success'},
            {t = 'event', zone = 192, event = 56, why = 'Gizmo 5 success'},
            {t = 'event', zone = 192, event = 58, why = 'Gizmo 6 success'},
         }},
        {id = 's10', at = {n = 10, fp = 'head back to hakkuru rinkuru and'},
         done = {
            {t = 'mission', line = 'windurst', eq = 0, completed = true, why = 'mission log: The Horutoto Ruins Experiment completed'},
            {t = 'event', zone = 240, event = 94, why = 'Hakkuru-Rinkuru 94 (status 4): the orb handed in, completes the mission'},
         }},
    },
}

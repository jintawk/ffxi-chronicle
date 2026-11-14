-- Step progress for Sisters in Arms (ASA mission 12, mission id 11). Data only; see progress/missions/asa/0.lua.
-- Evidence: none in LandSandBoat (scripts/missions/asa/12_Sisters_In_Arms.lua is an empty TODO) and no client script; the steps
-- rest on the sixteen Tablet of Hexes key items (res/key_items.lua 1218 to 1233) and the asa line. The page says at least one
-- tablet is needed for the Mahogany Door cutscene at the cap, so the bullet that lists where the tablets glow (bullet 2) is the
-- collection step and any one tablet gained or held proves it (pickups, not rewards). The door cutscene (bullet 3, which also
-- names the next battlefield) completes the mission: the asa line moves to 12 (no completed set, so `min = 12`). Bullet 1 gives
-- the goal and is a note.
return {
    title = 'Sisters in Arms',
    completes = 's3',
    known = {{t = 'mission', line = 'asa', eq = 11}},
    groups = {main = {start = {{t = 'mission', line = 'asa', eq = 11, completed = false, why = 'mission line: current mission = Sisters in Arms'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'your goal is to get to'}},
        {id = 's2', at = {n = 2, fp = 'tablets can be found at the'},
         done = {
            {t = 'ki', id = 1218, gained = true, why = 'Tablet of Hexes: Greed obtained'},
            {t = 'ki_have', id = 1218, have = true, why = 'Tablet of Hexes: Greed held'},
            {t = 'ki', id = 1219, gained = true, why = 'Tablet of Hexes: Envy obtained'},
            {t = 'ki_have', id = 1219, have = true, why = 'Tablet of Hexes: Envy held'},
            {t = 'ki', id = 1220, gained = true, why = 'Tablet of Hexes: Malice obtained'},
            {t = 'ki_have', id = 1220, have = true, why = 'Tablet of Hexes: Malice held'},
            {t = 'ki', id = 1221, gained = true, why = 'Tablet of Hexes: Deceit obtained'},
            {t = 'ki_have', id = 1221, have = true, why = 'Tablet of Hexes: Deceit held'},
            {t = 'ki', id = 1222, gained = true, why = 'Tablet of Hexes: Pride obtained'},
            {t = 'ki_have', id = 1222, have = true, why = 'Tablet of Hexes: Pride held'},
            {t = 'ki', id = 1223, gained = true, why = 'Tablet of Hexes: Bale obtained'},
            {t = 'ki_have', id = 1223, have = true, why = 'Tablet of Hexes: Bale held'},
            {t = 'ki', id = 1224, gained = true, why = 'Tablet of Hexes: Despair obtained'},
            {t = 'ki_have', id = 1224, have = true, why = 'Tablet of Hexes: Despair held'},
            {t = 'ki', id = 1225, gained = true, why = 'Tablet of Hexes: Regret obtained'},
            {t = 'ki_have', id = 1225, have = true, why = 'Tablet of Hexes: Regret held'},
            {t = 'ki', id = 1226, gained = true, why = 'Tablet of Hexes: Rage obtained'},
            {t = 'ki_have', id = 1226, have = true, why = 'Tablet of Hexes: Rage held'},
            {t = 'ki', id = 1227, gained = true, why = 'Tablet of Hexes: Agony obtained'},
            {t = 'ki_have', id = 1227, have = true, why = 'Tablet of Hexes: Agony held'},
            {t = 'ki', id = 1228, gained = true, why = 'Tablet of Hexes: Dolor obtained'},
            {t = 'ki_have', id = 1228, have = true, why = 'Tablet of Hexes: Dolor held'},
            {t = 'ki', id = 1229, gained = true, why = 'Tablet of Hexes: Rancor obtained'},
            {t = 'ki_have', id = 1229, have = true, why = 'Tablet of Hexes: Rancor held'},
            {t = 'ki', id = 1230, gained = true, why = 'Tablet of Hexes: Strife obtained'},
            {t = 'ki_have', id = 1230, have = true, why = 'Tablet of Hexes: Strife held'},
            {t = 'ki', id = 1231, gained = true, why = 'Tablet of Hexes: Penury obtained'},
            {t = 'ki_have', id = 1231, have = true, why = 'Tablet of Hexes: Penury held'},
            {t = 'ki', id = 1232, gained = true, why = 'Tablet of Hexes: Blight obtained'},
            {t = 'ki_have', id = 1232, have = true, why = 'Tablet of Hexes: Blight held'},
            {t = 'ki', id = 1233, gained = true, why = 'Tablet of Hexes: Death obtained'},
            {t = 'ki_have', id = 1233, have = true, why = 'Tablet of Hexes: Death held'},
         }},
        {id = 's3', at = {n = 3, fp = 'in the sacrificial chamber check the'},
         done = {
            {t = 'mission', line = 'asa', min = 12, why = 'mission line: past Sisters in Arms (Project: Shantottofication is 12)'},
         }},
    },
}

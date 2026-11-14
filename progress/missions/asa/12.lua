-- Step progress for Project: Shantottofication (ASA mission 13, mission id 12). Data only; see progress/missions/asa/0.lua.
-- Evidence: none in LandSandBoat (scripts/missions/asa/13_Project_Shantottofication.lua is an empty TODO) and no client script; the
-- page says the tablet key items (1218 to 1233) are consumed on entry and that the fight can be entered without any, so a tablet
-- leaving proves the entry (bullet 1) but its absence proves nothing, and a player with no tablet gets the step inferred from the
-- end. The win pays the Tonberry key (1189, a reward, not used) and completes the mission: the asa line moves to 13 (no completed
-- set, so `min = 13`), bullet 4. Bullets 2 and 3 describe the fight and are notes.
return {
    title = 'Project: Shantottofication',
    completes = 's4',
    known = {{t = 'mission', line = 'asa', eq = 12}},
    groups = {main = {start = {{t = 'mission', line = 'asa', eq = 12, completed = false, why = 'mission line: current mission = Project: Shantottofication'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after the initial cutscene click the'},
         done = {
            {t = 'ki', id = 1218, gained = false, why = 'Tablet of Hexes: Greed consumed on entry'},
            {t = 'ki', id = 1219, gained = false, why = 'Tablet of Hexes: Envy consumed on entry'},
            {t = 'ki', id = 1220, gained = false, why = 'Tablet of Hexes: Malice consumed on entry'},
            {t = 'ki', id = 1221, gained = false, why = 'Tablet of Hexes: Deceit consumed on entry'},
            {t = 'ki', id = 1222, gained = false, why = 'Tablet of Hexes: Pride consumed on entry'},
            {t = 'ki', id = 1223, gained = false, why = 'Tablet of Hexes: Bale consumed on entry'},
            {t = 'ki', id = 1224, gained = false, why = 'Tablet of Hexes: Despair consumed on entry'},
            {t = 'ki', id = 1225, gained = false, why = 'Tablet of Hexes: Regret consumed on entry'},
            {t = 'ki', id = 1226, gained = false, why = 'Tablet of Hexes: Rage consumed on entry'},
            {t = 'ki', id = 1227, gained = false, why = 'Tablet of Hexes: Agony consumed on entry'},
            {t = 'ki', id = 1228, gained = false, why = 'Tablet of Hexes: Dolor consumed on entry'},
            {t = 'ki', id = 1229, gained = false, why = 'Tablet of Hexes: Rancor consumed on entry'},
            {t = 'ki', id = 1230, gained = false, why = 'Tablet of Hexes: Strife consumed on entry'},
            {t = 'ki', id = 1231, gained = false, why = 'Tablet of Hexes: Penury consumed on entry'},
            {t = 'ki', id = 1232, gained = false, why = 'Tablet of Hexes: Blight consumed on entry'},
            {t = 'ki', id = 1233, gained = false, why = 'Tablet of Hexes: Death consumed on entry'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'the fight is against d shantotto'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'once one or the other reaches'}},
        {id = 's4', at = {n = 4, fp = 'successful completion of the fight will'},
         done = {
            {t = 'mission', line = 'asa', min = 13, why = 'mission line: past Project: Shantottofication (An Uneasy Peace is 13)'},
         }},
    },
}

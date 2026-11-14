-- Step progress for Fountain of Trouble (ASA mission 9, mission id 8). Data only; see progress/missions/asa/0.lua.
-- Evidence: none in LandSandBoat (scripts/missions/asa/09_Fountain_Of_Trouble.lua is an empty TODO) and no client script; the steps
-- rest on the eight sap crystal key items (res/key_items.lua 1210 to 1217: fire, water, wind, earth, lightning, ice, light, dark)
-- and the asa line. The page needs one or more saps before the Moon Spiral cutscene (bullet 3), and the bullet that lists where
-- the saps glow (bullet 2) is the collection step; any one sap gained or held proves it (pickups, not rewards, and one is
-- enough). The asa line moving to 9 (no completed set, so `min = 9`) is the cutscene and completes the mission. Bullet 1
-- describes what the saps do and is a note.
return {
    title = 'Fountain of Trouble',
    completes = 's3',
    known = {{t = 'mission', line = 'asa', eq = 8}},
    groups = {main = {start = {{t = 'mission', line = 'asa', eq = 8, completed = false, why = 'mission line: current mission = Fountain of Trouble'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'the 8 elemental saps can be'}},
        {id = 's2', at = {n = 2, fp = 'the elemental saps appear as glowing'},
         done = {
            {t = 'ki', id = 1210, gained = true, why = 'fire sap crystal obtained'},
            {t = 'ki_have', id = 1210, have = true, why = 'fire sap crystal held'},
            {t = 'ki', id = 1211, gained = true, why = 'water sap crystal obtained'},
            {t = 'ki_have', id = 1211, have = true, why = 'water sap crystal held'},
            {t = 'ki', id = 1212, gained = true, why = 'wind sap crystal obtained'},
            {t = 'ki_have', id = 1212, have = true, why = 'wind sap crystal held'},
            {t = 'ki', id = 1213, gained = true, why = 'earth sap crystal obtained'},
            {t = 'ki_have', id = 1213, have = true, why = 'earth sap crystal held'},
            {t = 'ki', id = 1214, gained = true, why = 'lightning sap crystal obtained'},
            {t = 'ki_have', id = 1214, have = true, why = 'lightning sap crystal held'},
            {t = 'ki', id = 1215, gained = true, why = 'ice sap crystal obtained'},
            {t = 'ki_have', id = 1215, have = true, why = 'ice sap crystal held'},
            {t = 'ki', id = 1216, gained = true, why = 'light sap crystal obtained'},
            {t = 'ki_have', id = 1216, have = true, why = 'light sap crystal held'},
            {t = 'ki', id = 1217, gained = true, why = 'dark sap crystal obtained'},
            {t = 'ki_have', id = 1217, have = true, why = 'dark sap crystal held'},
         }},
        {id = 's3', at = {n = 3, fp = 'once one or more saps are'},
         done = {
            {t = 'mission', line = 'asa', min = 9, why = 'mission line: past Fountain of Trouble (Battaru Royale is 9)'},
         }},
    },
}

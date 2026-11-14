-- Step progress for Shantotto in Chains (ASA mission 8, mission id 7). Data only; see progress/missions/asa/0.lua.
-- Evidence: none in LandSandBoat (scripts/missions/asa/08_Shantotto_In_Chains.lua is an empty TODO) and no client script; the steps
-- rest on the six fragment key items (res/key_items.lua: red 1204, beige 1205, green 1206, yellow 1207, purple 1208, blue 1209)
-- and the asa line. The six fragments (bullets 4 to 9) drop from six different monsters and can be taken in any order, so each is
-- a group of one step opened by the line reaching 7 (a single group would infer the unseen ones done); they share a strip row. A
-- fragment is a drop, not a reward, so the key item gained or held is proof. The closing cutscene at the door (bullet 10, the asa
-- line moving to 8; no completed set, so `min = 8`) implies every fragment and stays to do until then (the main group has no
-- start, so it does not open with the fragments). The door click (bullet 1) leaves no signal and bullets 2 and 3 stay plain.
return {
    title = 'Shantotto in Chains',
    completes = 's10',
    known = {{t = 'mission', line = 'asa', eq = 7}},
    groups = {
        f_blue = {start = {{t = 'mission', line = 'asa', eq = 7, completed = false, why = 'mission line: current mission = Shantotto in Chains'}}},
        f_purple = {start = {{t = 'mission', line = 'asa', eq = 7, completed = false, why = 'mission line: current mission = Shantotto in Chains'}}},
        f_yellow = {start = {{t = 'mission', line = 'asa', eq = 7, completed = false, why = 'mission line: current mission = Shantotto in Chains'}}},
        f_green = {start = {{t = 'mission', line = 'asa', eq = 7, completed = false, why = 'mission line: current mission = Shantotto in Chains'}}},
        f_red = {start = {{t = 'mission', line = 'asa', eq = 7, completed = false, why = 'mission line: current mission = Shantotto in Chains'}}},
        f_beige = {start = {{t = 'mission', line = 'asa', eq = 7, completed = false, why = 'mission line: current mission = Shantotto in Chains'}}},
    },
    steps = {
        {id = 's4', group = 'f_blue', at = {n = 4, fp = 'luminous blue fragment from lode golem'},
         done = {
            {t = 'ki', id = 1209, gained = true, why = 'luminous blue fragment obtained'},
            {t = 'ki_have', id = 1209, have = true, why = 'luminous blue fragment held'},
         }},
        {id = 's5', group = 'f_purple', at = {n = 5, fp = 'luminous purple fragment from fired urn'},
         done = {
            {t = 'ki', id = 1208, gained = true, why = 'luminous purple fragment obtained'},
            {t = 'ki_have', id = 1208, have = true, why = 'luminous purple fragment held'},
         }},
        {id = 's6', group = 'f_yellow', at = {n = 6, fp = 'luminous yellow fragment from steely weapon'},
         done = {
            {t = 'ki', id = 1207, gained = true, why = 'luminous yellow fragment obtained'},
            {t = 'ki_have', id = 1207, have = true, why = 'luminous yellow fragment held'},
         }},
        {id = 's7', group = 'f_green', at = {n = 7, fp = 'luminous green fragment from holey horror'},
         done = {
            {t = 'ki', id = 1206, gained = true, why = 'luminous green fragment obtained'},
            {t = 'ki_have', id = 1206, have = true, why = 'luminous green fragment held'},
         }},
        {id = 's8', group = 'f_red', at = {n = 8, fp = 'luminous red fragment from skeleton scuffler'},
         done = {
            {t = 'ki', id = 1204, gained = true, why = 'luminous red fragment obtained'},
            {t = 'ki_have', id = 1204, have = true, why = 'luminous red fragment held'},
         }},
        {id = 's9', group = 'f_beige', at = {n = 9, fp = 'luminous beige fragment from blest bones'},
         done = {
            {t = 'ki', id = 1205, gained = true, why = 'luminous beige fragment obtained'},
            {t = 'ki_have', id = 1205, have = true, why = 'luminous beige fragment held'},
         }},
        {id = 's10', implies = {'s4', 's5', 's6', 's7', 's8', 's9'}, at = {n = 10, fp = 'this is the cutscene that will'},
         done = {
            {t = 'mission', line = 'asa', min = 8, why = 'mission line: past Shantotto in Chains (Fountain of Trouble is 8)'},
         }},
    },
}

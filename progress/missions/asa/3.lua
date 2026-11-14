-- Step progress for Sugar-coated Directive (ASA mission 4, mission id 3). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/asa/04_Sugar-Coated_Directive.lua. The asa line moves to 3 when That Which Curdles Blood
-- completes, in the same finish that hands out the six Domina seals (key items 1191 to 1196, a reward of mission id 2), so the
-- line proves bullet 1 and the seals are not used. A protocrystal NPC in each cloister (Flames 207, Frost 203, Gales 201, Storms
-- 202, Tides 211, Tremors 209) plays event 2 only with its seal and a won battlefield, and its finish removes the seal and gives
-- the counterseal: the seal leaving the key items (gained = false) is the attach, bullet 3 (any of the six; at least three are
-- needed and the page lets you pick which, so it is one bullet and not a group). The seals also leave in the cleanup at the end of
-- bullet 4, which only repeats a step already done. Trodden Snow (126) event 45 plays only with three counterseals, and its finish
-- pays the gil, removes every seal and counterseal and completes the mission, so it proves bullet 4. The asa line moves to 4 (no
-- completed set, so `min = 4`). Bullets 6 to 13 are the Bird key repeat: their signals are reward key items or the same cleanup
-- deletions, so they stay plain bullets. Bullets 2 and 5 are notes.
return {
    title = 'Sugar-coated Directive',
    completes = 's4',
    known = {{t = 'mission', line = 'asa', eq = 3}},
    groups = {main = {start = {{t = 'mission', line = 'asa', eq = 3, completed = false, why = 'mission line: current mission = Sugar-coated Directive'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'you are given 6 key item'},
         done = {
            {t = 'mission', line = 'asa', eq = 3, completed = false, why = 'mission line: current mission = Sugar-coated Directive (the seals come with it)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'click each protocrystal once then click'}},
        {id = 's3', at = {n = 3, fp = 'after the battle click the crystal'},
         done = {
            {t = 'ki', id = 1191, gained = false, why = "Domina's scarlet seal attached at the protocrystal"},
            {t = 'ki', id = 1192, gained = false, why = "Domina's cerulean seal attached at the protocrystal"},
            {t = 'ki', id = 1193, gained = false, why = "Domina's emerald seal attached at the protocrystal"},
            {t = 'ki', id = 1194, gained = false, why = "Domina's amber seal attached at the protocrystal"},
            {t = 'ki', id = 1195, gained = false, why = "Domina's violet seal attached at the protocrystal"},
            {t = 'ki', id = 1196, gained = false, why = "Domina's azure seal attached at the protocrystal"},
         }},
        {id = 's4', at = {n = 4, fp = 'once at least 3 counterseals are'},
         done = {
            {t = 'event', zone = 126, event = 45, why = 'Trodden Snow 45: three counterseals shown (its finish completes)'},
            {t = 'mission', line = 'asa', min = 4, why = 'mission line: past Sugar-coated Directive (Enemy of the Empire (I) is 4)'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'you will receive a gil reward'}},
    },
}

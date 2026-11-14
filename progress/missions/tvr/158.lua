-- Step progress for Zhuu Buxu's Gambit (The Voracious Resurgence mission 2-3, page id 158). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr script is a stub (no events, no key items), so the proof is the key items and the mission log. Temporary key item 3229
-- "star-crested summons" (not the Windurst mission's old id 158) is gained at bullet 1 and 3230 "strange doll" at bullet 4, after the Yagudo Lookout fight;
-- no other script or page hands out either. Neither is the reward (20,000 gil). The tvr line has no completed set, so the end is `min = 168` (Star Onion Fortune).
-- Bullets 2, 3 and 5 have no signal of their own and stay plain bullets; a talk or a fight is not proof here.
return {
    title = "Zhuu Buxu's Gambit",
    completes = 's5',
    known = {{t = 'mission', line = 'tvr', min = 158, max = 167}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kupipi in heavens tower'},
         done = {
            {t = 'ki', id = 3229, gained = true, why = '"star-crested summons" obtained'},
            {t = 'ki_have', id = 3229, have = true, why = '"star-crested summons" held'},
         }},
        {id = 's4', at = {n = 4, fp = 'touch the worn chest again after'},
         done = {
            {t = 'ki', id = 3230, gained = true, why = '"strange doll" obtained'},
            {t = 'ki_have', id = 3230, have = true, why = '"strange doll" held'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to tosuka porika in windurst'},
         done = {
            {t = 'mission', line = 'tvr', min = 168, why = "mission log: the line moved past Zhuu Buxu's Gambit"},
         }},
    },
}

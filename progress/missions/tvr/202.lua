-- Step progress for Claidie's Concern (The Voracious Resurgence mission 3-2, page id 202). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr script is a stub, so the proof is a key item and the mission log. Bullet 3 harvests the Attohwa Chasm point that gives
-- 3256 "solidago flower"; no other script gives it and it is not the reward (20,000 gil). The tvr line has no completed set, so the end is `min = 210`
-- (Curilla Unleashed). Bullets 1, 2 and 4 are talks and cutscenes with no signal of their own and stay plain bullets.
return {
    title = "Claidie's Concern",
    completes = 's5',
    known = {{t = 'mission', line = 'tvr', min = 202, max = 209}},
    steps = {
        {id = 's3', at = {n = 3, fp = 'head to attohwa chasm with some'},
         done = {
            {t = 'ki', id = 3256, gained = true, why = '"solidago flower" obtained'},
            {t = 'ki_have', id = 3256, have = true, why = '"solidago flower" held'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to halver for the final'},
         done = {
            {t = 'mission', line = 'tvr', min = 210, why = "mission log: the line moved past Claidie's Concern"},
         }},
    },
}

-- Step progress for Curilla Unleashed (The Voracious Resurgence mission 3-3, page id 210). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr script is a stub, so the proof is a key item and the mission log. Bullet 1 (a sub-bullet) hands out 3257 "missive to
-- Altennia" after Halver's cutscene; no other script gives it and it is not the reward (Twinned Shield). The tvr line has no completed set, so the
-- end is `min = 228` (Run, Excenmille, Run!). Bullets 2 to 8 (travel, claw marks, Trion's fight) have no signal of their own and stay plain bullets.
return {
    title = 'Curilla Unleashed',
    completes = 's9',
    known = {{t = 'mission', line = 'tvr', min = 210, max = 227}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with halver for a cutscene'},
         done = {
            {t = 'ki', id = 3257, gained = true, why = '"missive to Altennia" obtained'},
            {t = 'ki_have', id = 3257, have = true, why = '"missive to Altennia" held'},
         }},
        {id = 's9', at = {n = 9, fp = 'speak with curilla in the temple'},
         done = {
            {t = 'mission', line = 'tvr', min = 228, why = 'mission log: the line moved past Curilla Unleashed'},
         }},
    },
}

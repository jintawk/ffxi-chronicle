-- Step progress for The Doll Whisperer (The Voracious Resurgence mission 2-5, page id 178). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr script is a stub, so the proof is a key item and the mission log. Bullet 5 hands out 3233 "magicked doll" from Kohlo-Lakolo
-- after the Chepelle fight; no other script gives it and it is not the reward (Maat's Mix, Perfect Lucky Egg). The tvr line has no completed set, so the
-- end is `min = 192` (Dancing Prince). Bullets 1 to 4 have no signal of their own (a talk, a cutscene, a fight) and stay plain bullets.
return {
    title = 'The Doll Whisperer',
    completes = 's6',
    known = {{t = 'mission', line = 'tvr', min = 178, max = 191}},
    steps = {
        {id = 's5', at = {n = 5, fp = 'return to kohlo lakolo for another'},
         done = {
            {t = 'ki', id = 3233, gained = true, why = '"magicked doll" obtained'},
            {t = 'ki_have', id = 3233, have = true, why = '"magicked doll" held'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to kupipi for the final'},
         done = {
            {t = 'mission', line = 'tvr', min = 192, why = 'mission log: the line moved past The Doll Whisperer'},
         }},
    },
}

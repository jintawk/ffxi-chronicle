-- Step progress for Dancing Prince (The Voracious Resurgence mission 3-1, page id 192). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr script is a stub, so the proof is key items and the mission log. 3254 "Orcish battle plan" is handed out on defeating the
-- Orcish Bewitcher (a sub-bullet of bullet 5, so it proves the fight) and 3255 "Quemaricond's report" at bullet 6; neither is the reward (20,000 gil) and
-- no other script gives them. The tvr line has no completed set, so the end is `min = 202` (Claidie's Concern). Bullets 1 to 3 (talks) stay plain bullets.
return {
    title = 'Dancing Prince',
    completes = 's7',
    known = {{t = 'mission', line = 'tvr', min = 192, max = 201}},
    steps = {
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'head to monastic cavern from the'}},
        {id = 's5', at = {n = 5, fp = 'touch the ritual site at the'},
         done = {
            {t = 'ki', id = 3254, gained = true, why = '"Orcish battle plan" obtained on defeating the Orcish Bewitcher'},
            {t = 'ki_have', id = 3254, have = true, why = '"Orcish battle plan" held'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to quemaricond for a cutscene'},
         done = {
            {t = 'ki', id = 3255, gained = true, why = '"Quemaricond\'s report" obtained'},
            {t = 'ki_have', id = 3255, have = true, why = '"Quemaricond\'s report" held'},
         }},
        {id = 's7', at = {n = 7, fp = 'speak with rahal for the final'},
         done = {
            {t = 'mission', line = 'tvr', min = 202, why = 'mission log: the line moved past Dancing Prince'},
         }},
    },
}

-- Step progress for Oshasha Violation (The Voracious Resurgence mission 9-1, page id 508). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr scripts are all stubs (9_1_Oshasha_Violation.lua), so no event or csid is used. Bullet 4 (examine the
-- Bibliomaniac's Lair after the fight) is proven by key item 3302 "Liber Daemonium", handed out after that cutscene; the reward is 20,000 gil.
-- Page 516 only mentions it in its description and 542 takes it over, so it belongs to this page. Bullet 5 is the line moving to 516
-- (Phantasmic Heroes). Bullets 1 to 3 are cutscenes or the fight with no signal and stay plain bullets.
return {
    title = 'Oshasha Violation',
    completes = 's5',
    known = {{t = 'mission', line = 'tvr', min = 508, max = 515}},
    steps = {
        {id = 's4', at = {n = 4, fp = 'examine the bibliomaniac s lair again'},
         done = {
            {t = 'ki', id = 3302, gained = true, why = "Liber Daemonium obtained after the Bibliomaniac's Lair cutscene"},
            {t = 'ki_have', id = 3302, have = true, why = 'Liber Daemonium held'},
            {t = 'chat', re = 'obtained key item: liber daemonium', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to andreine for the final'},
         done = {
            {t = 'mission', line = 'tvr', min = 516, why = 'mission log: the line moved past Oshasha Violation'},
         }},
    },
}

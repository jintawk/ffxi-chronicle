-- Step progress for Maat on the Rampage (The Voracious Resurgence mission 8-1, page id 468). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr scripts are all stubs (8_1_Maat_on_the_Rampage.lua), so no event or csid is used. Three bullets hand out a
-- temporary key item after their cutscene and the page says so: bullet 1 3297 "cloth-lined basket", bullet 2 3298 "map to the woman's
-- home", bullet 6 3299 "Maat's pillow". None is the reward (Beastmen's Seals) and no other page uses them. Bullet 7 is the line moving
-- to 484 (Not Just a Pretty Face). Bullets 3 to 5 are cutscenes or the fight with no signal and stay plain bullets.
return {
    title = 'Maat on the Rampage',
    completes = 's7',
    known = {{t = 'mission', line = 'tvr', min = 468, max = 483}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with maat in ru lude'},
         done = {
            {t = 'ki', id = 3297, gained = true, why = 'cloth-lined basket obtained after the Maat cutscene'},
            {t = 'ki_have', id = 3297, have = true, why = 'cloth-lined basket held'},
            {t = 'chat', re = 'obtained key item: cloth%-lined basket', why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak with muckvix in lower jeuno'},
         done = {
            {t = 'ki', id = 3298, gained = true, why = "map to the woman's home obtained after the Muckvix cutscene"},
            {t = 'ki_have', id = 3298, have = true, why = "map to the woman's home held"},
            {t = 'chat', re = "obtained key item: map to the woman's home", why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'click the goblin festival site once'},
         done = {
            {t = 'ki', id = 3299, gained = true, why = "Maat's pillow obtained after the Goblin Festival Site cutscene"},
            {t = 'ki_have', id = 3299, have = true, why = "Maat's pillow held"},
            {t = 'chat', re = "obtained key item: maat's pillow", why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to maat for the final'},
         done = {
            {t = 'mission', line = 'tvr', min = 484, why = 'mission log: the line moved past Maat on the Rampage'},
         }},
    },
}

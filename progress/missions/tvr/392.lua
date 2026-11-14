-- Step progress for Nii's Last Stand (The Voracious Resurgence mission 6-2, page id 392). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr scripts are all stubs (6_2_Niis_Last_Stand.lua), so no event or csid is used. Bullet 5 is proven by the
-- temporary key item 3269 "aspirant's canteen" (res/key_items.lua), which the page hands out after the Aspirants' Grounds cutscene; it is
-- not the reward (Tokkosho) and no other page uses it. Bullet 8 is the line moving to 414 (Dance of the Tengu), which ends the page.
-- Bullets 1 to 4, 6 and 7 are cutscenes or the fight with no signal and stay plain bullets.
return {
    title = "Nii's Last Stand",
    completes = 's8',
    known = {{t = 'mission', line = 'tvr', min = 392, max = 413}},
    steps = {
        {id = 's5', at = {n = 5, fp = 'head to k 7 ethereal ingress'},
         done = {
            {t = 'ki', id = 3269, gained = true, why = "aspirant's canteen obtained after the Aspirants' Grounds cutscene"},
            {t = 'ki_have', id = 3269, have = true, why = "aspirant's canteen held"},
            {t = 'chat', re = "obtained key item: aspirant's canteen", why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'after successfully completing the fight you'},
         done = {
            {t = 'mission', line = 'tvr', min = 414, why = "mission log: the line moved past Nii's Last Stand"},
         }},
    },
}

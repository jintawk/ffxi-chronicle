-- Step progress for Naja the Ambitious (The Voracious Resurgence, page id 286). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr scripts are all stubs (scripts/missions/tvr/*, no event or status to trace), so no scene is proof here.
-- Bullet 4 is proven by key item 3259 "lock of golden hair" (res/key_items.lua, temporary): the page hands it out with the cutscene after the
-- Returned Soulflayer fight, it is not the mission's reward (the Ziamet armour is), and no LandSandBoat script uses it elsewhere.
-- Bullet 5 is the line moving past the page: the tvr line holds the page id and the next page is 298 (BENCHMARK, tvr read on 2026-11-06),
-- so the completion is `min = 298`. Bullets 1 and 3 (accept cutscene, the fight) have no signal of their own and stay plain bullets.
return {
    title = 'Naja the Ambitious',
    completes = 's5',
    known = {{t = 'mission', line = 'tvr', min = 286, max = 297}},
    steps = {
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'head to wajaom woodlands h 13'}},
        {id = 's4', at = {n = 4, fp = 'select the savage scars again for'},
         done = {
            {t = 'ki', id = 3259, gained = true, why = 'lock of golden hair obtained (cutscene after the Returned Soulflayer)'},
            {t = 'ki_have', id = 3259, have = true, why = 'lock of golden hair held'},
            {t = 'chat', re = 'obtained key item: lock of golden hair', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to speak with naja salaheem'},
         done = {
            {t = 'mission', line = 'tvr', min = 298, why = 'mission log: the line moved past Naja the Ambitious'},
         }},
    },
}

-- Step progress for Star Onion Fortune (The Voracious Resurgence mission 2-4, page id 168). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr script is a stub, so the proof is a key item and the mission log. Bullet 7 says each party member receives 3232 "sublime lucky
-- egg" on killing the Templar Crawler, which also puts the fight bullet behind it; the reward is oden, not the egg. 3231 "piece of evidence" is only
-- examined at bullet 3 (the page never says where it is handed out), so it is not tied to a bullet and maps nothing. The end is `min = 178` (The Doll
-- Whisperer): the tvr line has no completed set. Bullets 1, 2, 4, 5, 6 have no signal of their own and stay plain bullets.
return {
    title = 'Star Onion Fortune',
    completes = 's8',
    known = {{t = 'mission', line = 'tvr', min = 168, max = 177}},
    steps = {
        {id = 's7', at = {n = 7, fp = 'each party member will receive a'},
         done = {
            {t = 'ki', id = 3232, gained = true, why = '"sublime lucky egg" obtained after the Templar Crawler'},
            {t = 'ki_have', id = 3232, have = true, why = '"sublime lucky egg" held'},
         }},
        {id = 's8', at = {n = 8, fp = 'return to kohlo lakolo for a'},
         done = {
            {t = 'mission', line = 'tvr', min = 178, why = 'mission log: the line moved past Star Onion Fortune'},
         }},
    },
}

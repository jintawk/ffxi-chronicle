-- Step progress for Shield of Diplomacy (Treasures of Aht Urhgan, mission id 21). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/22_Shield_of_Diplomacy.lua: Navukgo Execution Chamber (64) zone-in cutscene 1 plays only at
-- status 0 and sets status 1; the Decorative Bronze Gate (_1s0) plays event 2 only at status 1 and sets status 2; the Khimaira 13
-- win (battlefield exit 32001, any win in that zone, not used) completes the mission, so the fight bullet is proved by the mission
-- line. Bullet 1 (travel) is a note with s2, bullet 4 (enter the battlefield) has no event of its own and is a note with s5,
-- bullets 6 and 7 are fight notes with s5.
return {
    title = 'Shield of Diplomacy',
    completes = 's5',
    known = {{t = 'mission', line = 'toau', eq = 21}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'travel to navukgo execution chamber'}},
        {id = 's2', at = {n = 2, fp = 'you will get a cutscene when'},
         done = {
            {t = 'zonein', zone = 64, event = 1, why = "Navukgo Execution Chamber zone-in cutscene 1 (status 0 only, LandSandBoat)"},
         }},
        {id = 's3', at = {n = 3, fp = 'examine the decorative bronze gate for'},
         done = {
            {t = 'event', zone = 64, event = 2, why = "Decorative Bronze Gate 2 (status 1 only)"},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'examine the gate once more to'}},
        {id = 's5', at = {n = 5, fp = 'the fight is against khimaira 13'},
         done = {
            {t = 'mission', line = 'toau', eq = 21, completed = true, why = "mission log: Shield of Diplomacy completed (the Khimaira 13 win)"},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'khimaira 13 uses the following special'}},
        {id = 's7', kind = 'note', with = 's5', at = {n = 7, fp = 'lady karababa will assist you in'}},
    },
}

-- Step progress for Sweets for the Soul (Treasures of Aht Urhgan, mission id 18). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/19_Sweets_for_the_Soul.lua: entering the Shararat Teahouse trigger area (Whitegate 50) plays
-- event 3092, which completes the mission. The draft used Abquhbah 3106 (a first-talk cutscene that only sets SeenAbquhbah, the
-- bullet is not about him): dropped.
return {
    title = 'Sweets for the Soul',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 18}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter the shararat teahouse in aht'},
         done = {
            {t = 'event', zone = 50, event = 3092, why = "Shararat Teahouse trigger area 3092: completes the mission"},
            {t = 'mission', line = 'toau', eq = 18, completed = true, why = "mission log: Sweets for the Soul completed"},
         }},
    },
}

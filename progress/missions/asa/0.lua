-- Step progress for A Shantotto Ascension (ASA mission 1, mission id 0). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/asa/01_A_Shantotto_Ascension.lua (the zone-in cutscene 510 in Windurst Walls from Windurst
-- Woods or Waters, then 514, whose finish completes the mission; LandSandBoat itself marks the 510 -> 514 hand-off as a guess) and
-- the client script S4 239_actor_010EF0AC (events 510, 514, 511): event 514 is Shantotto's opening speech (say_as #9746, "The time
-- has come for us to make our meteoric rise."), so the event and the line prove the start scene. The zone-in 510 is only `reach`:
-- the page has a postpone route (bullets 2 and 3, the Tales' Beginning book) and nothing shows that 510 does not play on a
-- postponement. The asa line (data.get_mission_read, value = mission id) moves to 1 when the mission completes and has no completed
-- set, so the completion is `min = 1`, not `completed = true`. Bullets 2 and 3 are the postponed route: notes on the start step.
return {
    title = 'A Shantotto Ascension',
    completes = 's1',
    known = {{t = 'mission', line = 'asa', eq = 0}},
    groups = {main = {start = {{t = 'mission', line = 'asa', eq = 0, completed = false, why = 'mission line: current mission = A Shantotto Ascension'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into windurst walls from windurst'},
         done = {
            {t = 'event', zone = 239, event = 514, why = 'Windurst Walls 514: the opening scene (its finish completes the mission)'},
            {t = 'chat', re = 'The time has come for us to make our meteoric rise%.', why = "Shantotto's opening speech (say_as #9746)"},
            {t = 'mission', line = 'asa', min = 1, why = 'mission line: past A Shantotto Ascension (Burgeoning Dread is 1)'},
         },
         reach = {
            {t = 'zonein', zone = 239, event = 510, why = 'Windurst Walls zone-in 510 (also plays when the start is postponed)'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'if you chose to postpone the'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'use the tales beginning book at'}},
    },
}

-- Step progress for Where Two Paths Converge (Bastok mission 9-2, mission id 23). Data only; see progress/missions/bastok/15.lua.
-- Evidence: LandSandBoat scripts/missions/bastok/9_2_Where_Two_Paths_Converge.lua. A gate guard hands the mission out (event 1001,
-- option 23); the nation line moving to id 23 opens the group (s1 becomes next). Iron Eater (Metalworks 237): 780 at status 0
-- (sets 1), 769 at status 1 (also the Enter the Talekeeper afterglow event, so not used), 782 at status 2 (completes the mission
-- and hands out the Bastokan Flag, which can already be owned or wait for room: only the event counts). The Throne Room battle
-- (zone 165) sets status 2 through the battlefield exit event 32001, which has no signal of its own, so the bullets between the
-- two Iron Eater talks are notes. Bullets 6 and 7 are one event (782): bullet 6 is a note on bullet 7. The Notes section's
-- strategy bullets are tips, not steps, and are left unlisted. Event bodies 780 and 782 are empty in 237_Iron_Eater_010ED030.txt.
return {
    title = 'Where Two Paths Converge',
    completes = 's7',
    known = {{t = 'mission', line = 'bastok', min = 0}},
    groups = {main = {start = {{t = 'mission', line = 'bastok', eq = 23, completed = false, why = 'mission line: current mission = Where Two Paths Converge'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to iron eater in metalworks'},
         done = {
            {t = 'event', zone = 237, event = 780, why = 'Iron Eater 780 (status 0 only)'},
         }},
        {id = 's2', kind = 'note', with = 's7', at = {n = 2, fp = 'make your way to the throne'}},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'gather up and enter the where'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'you ll be facing a two'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'win the fight for another cutscene'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'return to the president s office'}},
        {id = 's7', at = {n = 7, fp = 'you will be rewarded and complete'},
         done = {
            {t = 'mission', line = 'bastok', eq = 23, completed = true, why = 'mission log: Where Two Paths Converge completed'},
            {t = 'event', zone = 237, event = 782, why = 'Iron Eater 782 (status 2): completes the mission'},
         }},
    },
}

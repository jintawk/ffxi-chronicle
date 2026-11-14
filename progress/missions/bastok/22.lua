-- Step progress for The Salt of the Earth (Bastok mission 9-1, mission id 22). Data only; see progress/missions/bastok/15.lua.
-- Evidence: LandSandBoat scripts/missions/bastok/9_1_The_Salt_of_the_Earth.lua. A gate guard hands the mission out (event 1001,
-- option 22); the nation line moving to id 22 opens the group (s1 becomes next). Alois (Metalworks 237): 773 at status 0 (sets 1),
-- 774 at status 1 (a reminder, only after 773), 775 at status 3 (salt not yet inspected, only after the Miraclesalt), 776 at
-- status 4 (completes the mission). Dancing Wolf (Rabao 247): 102 at status 1 (sets 2), 103 at status 2 (reminder), 104 at status 3
-- (sets 4), 105 at status 4 (reminder). The ??? (qm2) in Gustav Tunnel (212) spawns Gigaplasm at status 2 with "You have a bad
-- feeling about this place." (a generic phrase, so bullet 4 is a note) and gives the Miraclesalt (key item 477, res/key_items.lua)
-- at status 3 once the slimes are dead. The Notes section's two strategy bullets are tips, not steps, and are left unlisted;
-- Franziska 777 and 779 (the optional Cornelia cutscene after the mission) have no bullet. Event bodies 773, 776, 102 and 104 are empty
-- in the pseudo-code.
return {
    title = 'The Salt of the Earth',
    completes = 's7',
    known = {{t = 'mission', line = 'bastok', min = 0}},
    groups = {main = {start = {{t = 'mission', line = 'bastok', eq = 22, completed = false, why = 'mission line: current mission = The Salt of the Earth'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'visit alois in the president s'},
         done = {
            {t = 'event', zone = 237, event = 773, why = 'Alois 773 (status 0 only)'},
            {t = 'event', zone = 237, event = 774, conf = 'inferred', why = 'Alois 774: reminder, only after 773'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to rabao and speak to'},
         done = {
            {t = 'event', zone = 247, event = 102, why = 'Dancing Wolf 102 (status 1 only)'},
            {t = 'event', zone = 247, event = 103, conf = 'inferred', why = 'Dancing Wolf 103: reminder, only after 102'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'proceed to gustav tunnel g 6'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'checking the will spawn gigaplasm a'}},
        {id = 's5', at = {n = 5, fp = 'defeat all of them and sneak'},
         done = {
            {t = 'ki', id = 477, gained = true, why = 'Miraclesalt obtained'},
            {t = 'ki_have', id = 477, have = true, why = 'Miraclesalt held'},
            {t = 'chat', re = 'obtained key item: miraclesalt', why = 'chat: key item obtained'},
            {t = 'event', zone = 237, event = 775, conf = 'inferred', why = 'Alois 775: only at status 3, after the Miraclesalt'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to rabao and speak to'},
         done = {
            {t = 'event', zone = 247, event = 104, why = 'Dancing Wolf 104 (status 3 only)'},
            {t = 'event', zone = 247, event = 105, conf = 'inferred', why = 'Dancing Wolf 105: reminder, only after 104'},
         }},
        {id = 's7', at = {n = 7, fp = 'head back to alois to finish'},
         done = {
            {t = 'mission', line = 'bastok', eq = 22, completed = true, why = 'mission log: The Salt of the Earth completed'},
            {t = 'event', zone = 237, event = 776, why = 'Alois 776 (status 4): completes the mission'},
         }},
    },
}

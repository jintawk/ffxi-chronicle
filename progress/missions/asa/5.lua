-- Step progress for Enemy of the Empire (II) (ASA mission 6, mission id 5). Data only; see progress/missions/asa/0.lua.
-- Evidence: none in LandSandBoat (scripts/missions/asa/06_Enemy_Of_The_Empire_II.lua is an empty TODO) and no client script, so the
-- steps rest on key items the page names and on the asa line. The Black book (key item 1203, a reward of the previous mission) is
-- taken the moment the Outcropping fight starts (bullet 3 and the note on the previous page), so the key item leaving is the fight
-- start. The Cactuar key that pays the win (1186) is a reward and may already be held, so bullet 6 has no signal of its own and
-- stays a plain bullet, and so do the first Outcropping cutscene (bullet 1) and bullets 8 to 13 (the daily Cactuar key repeat, all
-- reward key items). The closing cutscene (bullet 7) completes the mission: the asa line moves to 6 (no completed set, so
-- `min = 6`). Bullets 2, 4 and 5 describe the fight and are notes.
return {
    title = 'Enemy of the Empire (II)',
    completes = 's7',
    known = {{t = 'mission', line = 'asa', eq = 5}},
    groups = {main = {start = {{t = 'mission', line = 'asa', eq = 5, completed = false, why = 'mission line: current mission = Enemy of the Empire (II)'}}}},
    steps = {
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'the following fight is trivial at'}},
        {id = 's3', at = {n = 3, fp = 'interacting with the outcropping again will'},
         done = {
            {t = 'ki', id = 1203, gained = false, why = 'Black book taken when the fight starts'},
         }},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'the 3 agents start off untargetable'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'at some point either time elapsed'}},
        {id = 's7', at = {n = 7, fp = 'interact with the outcropping again for'},
         done = {
            {t = 'mission', line = 'asa', min = 6, why = 'mission line: past Enemy of the Empire (II) (Sugar-coated Subterfuge is 6)'},
         }},
    },
}

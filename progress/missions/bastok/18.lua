-- Step progress for The Final Image (Bastok mission 7-1, mission id 18). Data only; see progress/missions/bastok/15.lua.
-- Evidence: LandSandBoat scripts/missions/bastok/7_1_The_Final_Image.lua. A gate guard hands the mission out (event 1001, option 18);
-- the page has no bullet for it, so the nation line moving to id 18 opens the group (s1 becomes next). Cid (Metalworks 237) plays
-- 763 at status 0 (sets 1) and 764 at status 2 (completes the mission and takes the Reinforced cermet, key item 289); they are
-- bullets 1 and 6 of the page, the proposer had merged them into one step. The ??? (qm2) in Ro'Maeve (122) on its first checks
-- plays "A chill runs down your spine." (RoMaeve IDs.lua 7416; a generic phrase, so not proof: bullet 4 is a note) while it pops the two
-- Mokkurkalfi, and on the check after one is dead it gives the Reinforced cermet and sets status 2. Event bodies 763 and 764 are
-- empty in 237_Cid_010ED02B.txt. Bullets 2 and 3 are the instructions and the ??? locations: notes.
return {
    title = 'The Final Image',
    completes = 's6',
    known = {{t = 'mission', line = 'bastok', min = 0}},
    groups = {main = {start = {{t = 'mission', line = 'bastok', eq = 18, completed = false, why = 'mission line: current mission = The Final Image'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to cid in the metalworks'},
         done = {
            {t = 'event', zone = 237, event = 763, why = 'Cid 763 (status 0 only)'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'you will be instructed to go'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'you are looking for a which'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'check the to spawn 2 golem'}},
        {id = 's5', at = {n = 5, fp = 'check the again to receive the'},
         done = {
            {t = 'ki', id = 289, gained = true, why = 'Reinforced cermet obtained'},
            {t = 'ki_have', id = 289, have = true, why = 'Reinforced cermet held'},
            {t = 'chat', re = 'obtained key item: reinforced cermet', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to cid for another cutscene'},
         done = {
            {t = 'mission', line = 'bastok', eq = 18, completed = true, why = 'mission log: The Final Image completed'},
            {t = 'event', zone = 237, event = 764, why = 'Cid 764 (status 2): the cermet handed in, completes the mission'},
         }},
    },
}

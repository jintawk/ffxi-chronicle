-- Step progress for Teodor's Summons (Seekers of Adoulin mission, page id 342). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_3_0_Teodors_Summons.lua. The Alpine Trail (Kamihr Drifts 267) plays 61 on any talk while
-- the mission is current and only option 1 goes on, so 61 is `reach` for bullet 2. Option 1 sets status 1 and sends you to Mount Kamihr
-- (282), whose onZoneIn plays cutscene 7 only at status 1; that zone-in proves bullet 2 (the accepted talk). The "I thought he was a
-- libertine" choice of bullet 3 is inside cutscene 7, and its finish always completes the mission and gives the Ash runic board (key
-- item 2626, temporary), so the key gain and the line (`min = 343`; the adoulin line has no completed set, packet value = page id)
-- prove bullet 3. Bullet 1 (where the last cutscene puts you) and bullet 4 (the board, a reward) are notes. Levil's 40 is a reminder.
-- The draft's `completed = true` matcher was dropped.
return {
    title = "Teodor's Summons",
    completes = 's3',
    known = {{t = 'mission', line = 'adoulin', eq = 342}},
    groups = {main = {start = {{t = 'mission', line = 'adoulin', eq = 342, why = "mission line: current mission = Teodor's Summons"}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'following the previous cutscene you will'}},
        {id = 's2', at = {n = 2, fp = 'head to kamihr drifts h 5'},
         done = {
            {t = 'zonein', zone = 282, event = 7, why = 'Mount Kamihr zone-in 7: only plays after the Alpine Trail was accepted'},
         },
         reach = {
            {t = 'event', zone = 267, event = 61, why = 'Alpine Trail 61: the cutscene offer (only option 1 goes on)'},
         }},
        {id = 's3', implies = {'s2'}, at = {n = 3, fp = 'select i thought he was a'},
         done = {
            {t = 'ki', id = 2626, gained = true, why = 'Ash runic board obtained (cutscene 7 finish, completes the mission)'},
            {t = 'mission', line = 'adoulin', min = 343, why = 'mission line: the line moved past Teodor\'s Summons'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'you will receive an ash runic'}},
    },
}

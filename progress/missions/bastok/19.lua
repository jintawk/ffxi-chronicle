-- Step progress for On My Way (Bastok mission 7-2, mission id 19). Data only; see progress/missions/bastok/15.lua.
-- Evidence: LandSandBoat scripts/missions/bastok/7_2_On_My_Way.lua. A gate guard hands the mission out (event 1001, option 19);
-- the page has no bullet for it, so the nation line moving to id 19 opens the group (s1 becomes next). Karst (Metalworks 237)
-- plays 765 at status 0 (sets 1) and 766 at status 3 (completes the mission: the nation line goes back to 65535 and 19 enters the
-- completed set; the Letter from Werei is NOT taken here). Hilda (Port Bastok 236) plays 255 at status 1 (sets 2). Winning the
-- On My Way battlefield (Waughroon Shrine) hands out the Letter from Werei (key item 290, res/key_items.lua) and sets status 3;
-- the entry cutscene and the fight leave no signal of their own, so bullet 4 is a note on the key item. After the mission is
-- complete Gumbah (Bastok Mines 234) plays 175 (first talk, sets GumbahDialog) and then 177, which takes the letter: bullet 7 is
-- a post step on 177 (event 175 plays on the way and proves nothing). Cornelia's door (_6lg, 237) plays 621 or 622 once after the
-- completion (Stage 1): the optional Notes bullet. Event bodies 765, 766, 255, 177 are empty in the pseudo-code.
return {
    title = 'On My Way',
    completes = 's6',
    known = {{t = 'mission', line = 'bastok', min = 0}},
    groups = {main = {start = {{t = 'mission', line = 'bastok', eq = 19, completed = false, why = 'mission line: current mission = On My Way'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with the president karst in'},
         done = {
            {t = 'event', zone = 237, event = 765, why = 'Karst 765 (status 0 only)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak with hilda at the steaming'},
         done = {
            {t = 'event', zone = 236, event = 255, why = 'Hilda 255 (status 1 only)'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'you will have to travel to'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'interact with the burning circle to'}},
        {id = 's5', at = {n = 5, fp = 'upon completion you will receive a'},
         done = {
            {t = 'ki', id = 290, gained = true, why = 'Letter from Werei obtained (battlefield won)'},
            {t = 'ki_have', id = 290, have = true, why = 'Letter from Werei held'},
            {t = 'chat', re = 'obtained key item: letter from werei', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to the metalworks and speak'},
         done = {
            {t = 'mission', line = 'bastok', eq = 19, completed = true, why = 'mission log: On My Way completed'},
            {t = 'event', zone = 237, event = 766, why = 'Karst 766 (status 3): completes the mission'},
         }},
        {id = 's7', kind = 'post', at = {n = 7, fp = 'speak to gumbah in bastok mines'},
         done = {
            {t = 'event', zone = 234, event = 177, why = 'Gumbah 177: the Letter from Werei delivered'},
         }},
        {id = 's8', kind = 'optional', at = {n = 8, fp = 'cornelia s door behind president karst'},
         done = {
            {t = 'event', zone = 237, event = 621, why = "Cornelia's door 621 (after the mission)"},
            {t = 'event', zone = 237, event = 622, why = "Cornelia's door 622 (after the mission, all three quests done)"},
         }},
    },
}

-- Step progress for Lost for Words (Windurst mission 2-1, mission id 3). Data only; see progress/missions/windurst/1.lua for the
-- format notes. Evidence: LandSandBoat scripts/missions/windurst/2_1_Lost_for_Words.lua and the client event scripts (S4 pseudo)
-- 238_Tosuka_Porika, 241_Nanaa_Mihgo; key item ids from res/key_items.lua.
-- The page has no accept bullet: it starts at Tosuka-Porika (event 160, progressEvent at status 1; her 161 is the reminder at
-- status 2). Nanaa Mihgo's offer 165 is a Listen / Refuse menu (option 1 = listen gives the Lapis monocle, 2 = refuse gives
-- nothing), so the event alone proves nothing: the Lapis monocle key item and her status-3 reminder 166 prove step 2. The Lapis
-- coral comes from the right Fossil Rock in the Maze of Shakhrami (a key item message, no event). Nanaa 169 takes the coral and
-- monocle and gives the Hideout key; 170 and 173 are her reminders at the next two statuses. The Mahogany Door in the Inner
-- Horutoto Ruins (zone 192) plays 46 and takes the Hideout key; the House of the Hero door in Windurst Walls plays 337; Tosuka-Porika
-- 168 completes the mission. Her 169 after completion is post-mission dialogue and is not used. The travel bullets (n = 3, 4, 7, 8)
-- are notes.
return {
    title = 'Lost for Words',
    completes = 's11',
    known = {{t = 'mission', line = 'windurst', eq = 3}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head for the optistery on the'},
         done = {
            {t = 'event', zone = 238, event = 160, why = 'Tosuka-Porika 160: the mission briefing at status 1'},
            {t = 'event', zone = 238, event = 161, why = 'Tosuka-Porika 161, her reminder at status 2'},
            {t = 'chat', re = 'I wonder if that so%-called Mithran Cat Burglar really has one of our restricted books%.', why = 'Tosuka-Porika 161 (say #7685)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to j 3 in windurst'},
         done = {
            {t = 'ki', id = 88, gained = true, why = 'Lapis monocle obtained (only when she is heard out)'},
            {t = 'event', zone = 241, event = 166, why = 'Nanaa Mihgo 166, her reminder at status 3'},
            {t = 'chat', re = 'In the Tahrongi Canyon, there is a serrries of caves called the Maze of Shakhrami%.', why = 'Nanaa Mihgo 166 (say #7838)'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'now make your way to the'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'inside head for g 6 on'}},
        {id = 's5', at = {n = 5, fp = 'check each fossil rock until you'},
         done = {
            {t = 'ki', id = 68, gained = true, why = 'Lapis coral obtained from the right Fossil Rock'},
         }},
        {id = 's6', at = {n = 6, fp = 'make your way back to nanaa'},
         done = {
            {t = 'event', zone = 241, event = 169, why = 'Nanaa Mihgo 169: the Hideout key handed over'},
            {t = 'chat', re = 'So, you came thrrrough with it%?', why = 'Nanaa Mihgo 169 (say #7845)'},
            {t = 'ki', id = 67, gained = true, why = 'Hideout key obtained (given with event 169)'},
            {t = 'event', zone = 241, event = 170, why = 'Nanaa Mihgo 170, her reminder at status 5'},
            {t = 'chat', re = "We'll carry out our little trrransaction at my hideout, deep in the Horutoto Ruins%.", why = 'Nanaa Mihgo 170 (say #7847)'},
         }},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'head to east sarutabaruta and enter'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'head to the southwest room containing'}},
        {id = 's9', at = {n = 9, fp = 'check the mahogany door for a'},
         done = {
            {t = 'event', zone = 192, event = 46, why = 'Inner Horutoto Ruins 46: the Mahogany Door cutscene (takes the Hideout key)'},
            {t = 'ki', id = 67, gained = false, why = 'Hideout key taken at the Mahogany Door'},
            {t = 'event', zone = 241, event = 173, why = 'Nanaa Mihgo 173, her reminder at status 6'},
            {t = 'chat', re = "I can't stand the sight of you%.", why = 'Nanaa Mihgo 173 (say #7851)'},
         }},
        {id = 's10', at = {n = 10, fp = 'head to the house of the hero'},
         done = {
            {t = 'event', zone = 239, event = 337, why = 'Windurst Walls 337: the House of the Hero door cutscene'},
         }},
        {id = 's11', at = {n = 11, fp = 'make your way back to windurst waters'},
         done = {
            {t = 'mission', line = 'windurst', eq = 3, completed = true, why = 'mission log: Lost for Words completed'},
            {t = 'event', zone = 238, event = 168, why = 'Tosuka-Porika 168: mission completed'},
            {t = 'chat', re = 'Did that so%-called Mithran Cat Burglar really have her paws on one of our restricted books%?', why = 'Tosuka-Porika 168 (say #7700)'},
         }},
    },
}

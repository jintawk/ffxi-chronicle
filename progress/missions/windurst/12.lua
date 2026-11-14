-- Step progress for A New Journey (Windurst mission 3-3, mission id 12). Data only; see progress/missions/windurst/1.lua for the
-- format notes. Evidence: LandSandBoat scripts/missions/windurst/3_3_A_New_Journey.lua and the client event scripts (S4 pseudo)
-- 243_Pakh_Jatalfih, 242_Foo_Beibo, 242_Rhy_Epocan; key item id from res/key_items.lua.
-- The page has no accept bullet (it starts at the Vestal Chamber door) and most of its 33 bullets are travel, floor-by-floor climb
-- directions and tips for getting a Delkfutt Key, which comes from Porphyrion with or without the mission and so proves nothing.
-- Only the four bullets that end in a mission event are mapped; every other bullet stays a plain bullet. Step 1: the Vestal
-- Chamber door in Heavens Tower, event 153 (progressEvent at status 0; gives the Letter to the ambassador). Step 2: Pakh
-- Jatalfih in Ru'Lude Gardens, event 43 (takes the letter; his 68 is the reminder at status 2). Step 3: the Cermet Door in
-- Lower Delkfutt's Tower (zone 184), event 2 from LandSandBoat, played only at status 2 with the Delkfutt Key held or traded. Step 4:
-- Pakh Jatalfih 141 (status 3, "let him acknowledge your return") then the Windurstian Embassy door (_6r8), event 40 at status 4,
-- which completes the mission; 141 only marks the step as reached. The Sibyl Guard lines (160 to 162) and 155 are reminders.
-- Pakh Jatalfih's 68 line (say #10057) is not matched: Goggehn and Nelcabrit say the same opening sentence in Ru'Lude Gardens, so it is generic chat.
return {
    title = 'A New Journey',
    completes = 's4',
    known = {{t = 'mission', line = 'windurst', eq = 12}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'check the vestal chamber door at'},
         done = {
            {t = 'event', zone = 242, event = 153, why = 'Heavens Tower 153: the Vestal Chamber door cutscene, Letter to the ambassador handed over'},
            {t = 'ki', id = 30, gained = true, why = 'Letter to the ambassador obtained (given with event 153)'},
            {t = 'event', zone = 242, event = 162, why = 'Foo Beibo 162, his line at status 1'},
            {t = 'chat', re = 'How go your adventures%? Are you finally starting to make a name for yourself in Windurst%?', why = 'Foo Beibo 162 (say #320)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak with pakh jatalfih at the'},
         done = {
            {t = 'event', zone = 243, event = 43, why = 'Pakh Jatalfih 43: the letter handed over (status 1 to 2)'},
            {t = 'ki', id = 30, gained = false, why = 'Letter to the ambassador handed over'},
            {t = 'event', zone = 243, event = 68, why = 'Pakh Jatalfih 68, his reminder at status 2'},
         }},
        {id = 's3', at = {n = 31, fp = 'once you reach the basement head'},
         done = {
            {t = 'event', zone = 184, event = 2, why = "Lower Delkfutt's Tower 2: the Cermet Door cutscene (status 2 to 3)"},
         }},
        {id = 's4', at = {n = 32, fp = 'return to the windurstian embassy in'},
         done = {
            {t = 'mission', line = 'windurst', eq = 12, completed = true, why = 'mission log: A New Journey completed'},
            {t = 'event', zone = 243, event = 40, why = "Ru'Lude Gardens 40: the Windurstian Embassy door cutscene, mission completed"},
         },
         reach = {
            {t = 'event', zone = 243, event = 141, why = 'Pakh Jatalfih 141, welcomes you back at status 3'},
            {t = 'chat', re = 'Welcome back! The ambassador has returned, and wants to see you%.', why = 'Pakh Jatalfih 141 (say #10061)'},
         }},
    },
}

-- Step progress for Magicite (Windurst mission 4-1, mission id 13). Data only; see progress/missions/windurst/1.lua for the format
-- notes. Evidence: LandSandBoat scripts/missions/windurst/4_1_Magicite.lua and the client event scripts (S4 pseudo)
-- 243_Pakh_Jatalfih, 245_Aldo, 150_Magicite (Monastic Cavern), 148_Magicite (Qulun Dome), 152_Magicite (Altar Room); key item ids
-- from res/key_items.lua.
-- The page is an overview (n = 1 to 7) followed by long sections for the quests and the three Magicite. Step 2 is the embassy
-- door scene (_6r8, event 131 from LandSandBoat): both menu answers carry on and only a cancelled event leaves the mission
-- unstarted, so the event proves nothing; the nation line moving to 13 does, with the Archducal audience permit as support (a
-- Permanent key item, it can already be held). Step 3: the Audience Chamber door (_6r9) event 128 at status 1, which gives the
-- Letter to Aldo. Step 4: Aldo (Lower Jeuno) event 152, which takes the letter. The three Magicite (Optistone in the Monastic
-- Cavern, Orastone in the Altar Room, Aurastone in Qulun Dome) can be taken in any order and sit after the final bullets in page
-- order, so they are left as plain bullets (a later step done would show the completing steps done early); the overview bullet
-- "Obtain the 3 Magicite" (n = 5) is a note. Step 6: the Audience Chamber door event 60, which needs all three and takes them.
-- Step 7: Pakh Jatalfih event 37 completes (mission:complete). Bullets 58 and 59 repeat 6 and 7 at the end of the page and are
-- left unmapped for the same reason. Events 80 and 184 (Yagudo torch), 23 and 0 belong to quests with their own pages.
return {
    title = 'Magicite',
    completes = 's7',
    known = {{t = 'mission', line = 'windurst', eq = 13}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'to flag the mission head to'},
         done = {
            {t = 'mission', line = 'windurst', eq = 13, completed = false, why = 'mission line: current mission = Magicite'},
            {t = 'ki', id = 56, gained = true, why = 'Archducal audience permit obtained (given at the embassy door)'},
         }},
        {id = 's3', at = {n = 3, fp = 'click on the door to the'},
         done = {
            {t = 'event', zone = 243, event = 128, why = "Ru'Lude Gardens 128: the Audience Chamber door cutscene, Letter to Aldo handed over"},
            {t = 'ki', id = 22, gained = true, why = 'Letter to Aldo obtained (given with event 128)'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to aldo in lower jeuno'},
         done = {
            {t = 'event', zone = 245, event = 152, why = 'Aldo 152: the letter handed over, Silver bell'},
            {t = 'ki', id = 22, gained = false, why = 'Letter to Aldo handed over'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'obtain the 3 magicite key items'}},
        {id = 's6', at = {n = 6, fp = 'click the audience chamber in ru'},
         done = {
            {t = 'event', zone = 243, event = 60, why = "Ru'Lude Gardens 60: the Audience Chamber door cutscene with all three Magicite (they are taken)"},
            {t = 'ki', id = 14, gained = false, why = 'Magicite: Optistone handed over'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to pakh jatalfih in the'},
         done = {
            {t = 'mission', line = 'windurst', eq = 13, completed = true, why = 'mission log: Magicite completed'},
            {t = 'event', zone = 243, event = 37, why = 'Pakh Jatalfih 37: mission completed'},
            {t = 'chat', re = "I'm sorry, but you've got no time to rest! Our beloved Windurst is in grave danger!", why = 'Pakh Jatalfih 37 (say #10191)'},
         }},
    },
}

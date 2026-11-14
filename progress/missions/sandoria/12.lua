-- Step progress for Appointment to Jeuno (San d'Oria mission 3-3, mission id 12). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/3_3_Appointment_to_Jeuno.lua; client event scripts S4 233_Halver_010E9007.txt (508),
-- 243_Nelcabrit_010F3001.txt (42, 140); key item 30 (letter to the ambassador) from res/key_items.lua.
-- The page has no accept bullet (the menu 1009/2009, option 12, is not a step here) and spends bullets 4 to 31 on travel, gear and a
-- floor-by-floor guide through Delkfutt's Tower, which prove nothing; only the story steps are mapped and the rest keep their plain
-- bullets. Halver 508 (status 0 only) sends you to the Great Hall; the Door: Great Hall (233, event 537, status 2, LandSandBoat only:
-- no client script for the door) hands over the letter (KI 30); Nelcabrit 42 (Ru'Lude Gardens 243, status 3; the client body is empty,
-- the id is in the NPC's event list) takes it; the Cermet Door in Lower Delkfutt's Tower (184, event 0, status 4, with the Delkfutt
-- key traded or held; LandSandBoat's `mission:progressCutscene(0)`) is bullet 32; the Door: San d'Orian Emb. in Ru'Lude Gardens
-- (243, event 39, status 5, LandSandBoat only) completes the mission, and Nelcabrit 140 ("Welcome back", status 5) is a reminder that
-- plays only after the cutscene.
-- Event 140 replays at status 5 and only event 39 runs mission:complete (3_3_Appointment_to_Jeuno.lua:163,172,179-181), so 140 is reach, not done.
-- The draft only knew Arsha / Chupaile / Nelcabrit guesses and a 'min' mission proof; those are dropped.
return {
    title = 'Appointment to Jeuno',
    completes = 's33',
    known = {{t = 'mission', line = 'sandoria', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to halver in chateau d'},
         done = {
            {t = 'event', zone = 233, event = 508, why = 'Halver 508: the audience announced (status 0 only)'},
            {t = 'chat', re = "I've been waiting for you, .*you are to report to the Embassy of San d'Oria at Jeuno%.", why = 'Halver 508 (say #7105)'},
         }},
        {id = 's2', at = {n = 2, fp = 'click the door great hall behind'},
         done = {
            {t = 'event', zone = 233, event = 537, why = 'Door: Great Hall 537: the audience with the king (status 2, LandSandBoat)'},
            {t = 'ki', id = 30, gained = true, why = 'letter to the ambassador obtained'},
            {t = 'chat', re = 'obtained key item: letter to the ambassador', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to the san d orian'},
         done = {
            {t = 'event', zone = 243, event = 42, why = 'Nelcabrit 42: the letter handed in (status 3)'},
            {t = 'ki', id = 30, gained = false, conf = 'inferred', why = 'letter to the ambassador handed over'},
         }},
        {id = 's32', at = {n = 32, fp = 'once you reach the basement head'},
         done = {
            {t = 'event', zone = 184, event = 0, why = "Cermet Door in Lower Delkfutt's Tower: the key cutscene (status 4, LandSandBoat)"},
         }},
        {id = 's33', at = {n = 33, fp = 'return to the san d orian'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 12, completed = true, why = 'mission log: Appointment to Jeuno completed'},
            {t = 'event', zone = 243, event = 39, why = "Door: San d'Orian Emb. 39: completes (status 5, LandSandBoat)"},
         },
         reach = {
            {t = 'event', zone = 243, event = 140, why = 'Nelcabrit 140: replays at status 5 until the door cutscene 39 plays; it does not complete'},
            {t = 'chat', re = 'Welcome back%. Her Excellency has returned and is waiting for you%.', why = 'Nelcabrit 140 (say #10059), a reminder that does not complete'},
         }},
    },
}

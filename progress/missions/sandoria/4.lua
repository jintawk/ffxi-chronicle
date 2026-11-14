-- Step progress for The Davoi Report (San d'Oria mission 2-2, mission id 4). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/2_2_The_Davoi_Report.lua; client event scripts S4 230_Ambrotien_010E6062.txt,
-- 230_Endracion_010E6061.txt, 231_Grilau_010E7022.txt (accept: say #7294, #60 in Grilau), 149_Zantaviat_010951E6.txt (100, 104);
-- key items 103 (lost document) and 44 (Temple Knights' Davoi report) from res/key_items.lua.
-- The menu is 1009/2009 (option 104 accepts), so the accept is proved by the line only the accept branch says and the nation line
-- moving to id 4 (completed = false, run1 as in the pilot). Zantaviat 100 plays at status 0 only; 104 only while the lost document is
-- held (it takes it and gives the report). The lost document comes from the "!" at the pond (mission:keyItem), so its gain proves
-- bullet 4. Turning in is two different things: a first completion plays the gate guard's 2028 / 1028 (it does not complete; the
-- Door: Papal Chambers, event 695 from LandSandBoat, does), a repeat plays 2006 / 1006, which completes at the gate guard. So the
-- completing step s7 carries 695 plus the repeat events, and s6 (the gate guard) the first-time events plus 2006 / 1006 (it is
-- behind them). No client script exists for the door (695 is LandSandBoat's). The draft guessed the completion, took 695 for the
-- gate guard bullet and used a 'min = 5' mission guess; fixed. Bullet 8 only restates the completion: a note on bullet 7.
return {
    title = 'The Davoi Report',
    completes = 's7',
    known = {{t = 'mission', line = 'sandoria', min = 0}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to any gate guard and'},
         done = {
            {t = 'chat', re = "The scout's name is Zantaviat%. He's somewhere in Davoi, but where I cannot say%.", why = 'a gate guard, accepted (say #7294)'},
            {t = 'mission', line = 'sandoria', eq = 4, completed = false, run1 = true, why = 'mission line: current mission = The Davoi Report'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'make your way to davoi to'}},
        {id = 's3', at = {n = 3, fp = 'talk to the npc zantaviat just'},
         done = {
            {t = 'event', zone = 149, event = 100, why = 'Zantaviat 100: the first talk, status 0 only'},
            {t = 'chat', re = "A message%? Finally! I am Zantaviat of the Temple Knights%.", why = 'Zantaviat 100 (say #7424)'},
         }},
        {id = 's4', at = {n = 4, fp = 'walk south until you reach a'},
         done = {
            {t = 'ki', id = 103, gained = true, why = 'lost document obtained (the "!" at the pond)'},
            {t = 'chat', re = 'obtained key item: lost document', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to zantaviat to recieve the'},
         done = {
            {t = 'event', zone = 149, event = 104, why = 'Zantaviat 104: only with the lost document held'},
            {t = 'chat', re = "You found the page! Well done%.", why = 'Zantaviat 104 (say #7434)'},
            {t = 'ki', id = 44, gained = true, why = "Temple Knights' Davoi report obtained"},
            {t = 'chat', re = "obtained key item: temple knights' davoi report", why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to a gate guard'},
         done = {
            {t = 'event', zone = 230, event = 2028, why = 'Ambrotien 2028: the report, first completion (sent on to the Door)'},
            {t = 'event', zone = 230, event = 1028, why = 'Endracion 1028: the report, first completion'},
            {t = 'event', zone = 231, event = 1028, why = 'Grilau 1028: the report, first completion'},
            {t = 'chat', re = "You were told to hand the .* to Prince Pieuje personally%?", why = 'gate guard 2028 / 1028 (say #9254)'},
            {t = 'event', zone = 230, event = 2006, why = 'Ambrotien 2006: the report, repeat (completes)'},
            {t = 'event', zone = 230, event = 1006, why = 'Endracion 1006: the report, repeat (completes)'},
            {t = 'event', zone = 231, event = 1006, why = 'Grilau 1006: the report, repeat (completes)'},
         }},
        {id = 's7', at = {n = 7, fp = 'examine the door papal chambers which'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 4, completed = true, why = 'mission log: The Davoi Report completed'},
            {t = 'event', zone = 231, event = 695, why = 'Door: Papal Chambers 695: the report delivered (LandSandBoat)'},
            {t = 'event', zone = 230, event = 2006, why = 'Ambrotien 2006: repeat, completes at the gate guard'},
            {t = 'event', zone = 230, event = 1006, why = 'Endracion 1006: repeat, completes at the gate guard'},
            {t = 'event', zone = 231, event = 1006, why = 'Grilau 1006: repeat, completes at the gate guard'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'after the cutscene the mission will'}},
    },
}

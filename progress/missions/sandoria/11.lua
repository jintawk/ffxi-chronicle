-- Step progress for The Crystal Spring (San d'Oria mission 3-2, mission id 11). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/3_2_The_Crystal_Spring.lua; client event scripts S4 230_Ambrotien_010E6062.txt,
-- 230_Endracion_010E6061.txt, 231_Grilau_010E7022.txt (accept: say #7317), 233_Chalvatot_010E900E.txt (556, say_as #7652).
-- The menu is 1009/2009 (option 111 accepts), so the accept is proved by the line only the accept branch says and the nation line
-- moving to id 11 (completed = false, run1 as in the pilot). The Crystal Bass trade plays 2030 / 1030 for the first completion
-- (status 0 to 2) and 2013 / 1013 for a repeat, which completes the mission at the gate guard; a wrong trade plays nothing. After a
-- first trade the gate guard's talk is 2031 / 1031 (status 2 only: "Bandits infiltrating Chateau d'Oraguille", say #9262), which
-- also proves bullet 4. The Chateau zone-in cutscene is the 0x00A event 555 (from Northern San d'Oria at status 2, LandSandBoat
-- only; the live addon does not read 0x00A yet, so Chalvatot infers it). Chalvatot 556 (status 3) completes the first run. The
-- repeat's 2013 / 1013 are also on the completing step s6. The Crystal Bass (item 4528) and the fishing guide bullets are not
-- steps; the draft knew none of this (all notes).
return {
    title = 'The Crystal Spring',
    completes = 's6',
    known = {{t = 'mission', line = 'sandoria', min = 0}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'talk to any gate guard and'},
         done = {
            {t = 'chat', re = "Ah, that reminds me%-%-have you any fishing gear%?", why = 'a gate guard, accepted (say #7317)'},
            {t = 'mission', line = 'sandoria', eq = 11, completed = false, run1 = true, why = 'mission line: current mission = The Crystal Spring'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'buy a crystal bass from the'}},
        {id = 's4', at = {n = 4, fp = 'trade the crystal bass to the'},
         done = {
            {t = 'event', zone = 230, event = 2030, why = 'Ambrotien 2030: the Crystal Bass accepted, first completion'},
            {t = 'event', zone = 230, event = 1030, why = 'Endracion 1030: the Crystal Bass accepted, first completion'},
            {t = 'event', zone = 231, event = 1030, why = 'Grilau 1030: the Crystal Bass accepted, first completion'},
            {t = 'event', zone = 230, event = 2031, why = 'Ambrotien 2031: talk after the trade, status 2 only'},
            {t = 'event', zone = 230, event = 1031, why = 'Endracion 1031: talk after the trade, status 2 only'},
            {t = 'event', zone = 231, event = 1031, why = 'Grilau 1031: talk after the trade, status 2 only'},
            {t = 'chat', re = "Bandits infiltrating Chateau d'Oraguille is unprecedented in history!", why = 'gate guard 2031 / 1031 (say #9262)'},
         }},
        {id = 's5', at = {n = 5, fp = 'enter chateau d oraguille for a'},
         done = {
            {t = 'zonein', zone = 233, event = 555, why = "Chateau d'Oraguille zone-in cutscene 555 (LandSandBoat onZoneIn, status 2)"},
         }},
        {id = 's6', at = {n = 6, fp = 'talk to chalvatot located in the'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 11, completed = true, why = 'mission log: The Crystal Spring completed'},
            {t = 'event', zone = 233, event = 556, why = 'Chalvatot 556: completes the first run'},
            {t = 'chat', re = "Chalvatot, what has happened in my mother's chambers%?", why = 'Chalvatot 556 (say_as #7652)'},
            {t = 'event', zone = 230, event = 2013, why = 'Ambrotien 2013: the Crystal Bass accepted, repeat (completes)'},
            {t = 'event', zone = 230, event = 1013, why = 'Endracion 1013: the Crystal Bass accepted, repeat (completes)'},
            {t = 'event', zone = 231, event = 1013, why = 'Grilau 1013: the Crystal Bass accepted, repeat (completes)'},
         }},
    },
}

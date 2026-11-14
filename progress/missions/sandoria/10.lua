-- Step progress for Infiltrate Davoi (San d'Oria mission 3-1, mission id 10). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/3_1_Infiltrate_Davoi.lua; client event scripts S4 230_Ambrotien_010E6062.txt,
-- 230_Endracion_010E6061.txt, 231_Grilau_010E7022.txt, 149_Zantaviat_010951E6.txt, 149_Quemaricond_010951D7.txt; key items 237
-- (Royal Knights' Davoi report), 104/105/106 (East/South/North Block code) from res/key_items.lua.
-- The page holds two runs: the first completion (bullets 2 to 6) and the repeat (8 to 12, a branch: no restart machinery, the
-- repeat's own events mark its bullets). The menu is 1009/2009 (option 110 accepts). First run: the client's accept branch for a
-- first completion is not decoded (the P5 bit 15 test jumps to a stub), so the accept is proved by the nation line moving to id 10
-- (completed = false, run1 as in the pilot) or by the gate guard's talk after it, event 2029 / 1029 (plays only with this mission
-- current at status 0; "Prince Trion has called for you", say #9258). The Door: Prince Royal's Rm events 553 (status 0, takes you
-- to status 2) and 554 (status 4, completes and takes the Royal Knights' Davoi report) have no client script (the door is not in
-- the S4 NPC set); the ids are LandSandBoat's. The Davoi zone-in cutscene is the 0x00A event 116 (status 2): `zonein`; the live
-- addon does not read 0x00A yet, so the next step infers it. Quemaricond 117 (status 3) hands the report (KI 237). The repeat:
-- accept line "The situation in Davoi worsens by the day." (say #7310, the L_165B branch, repeat only), Zantaviat 102 (status 0)
-- and 105 (status 9, takes the three codes) and the gate guard 1012 / 2012 (status 10, completes). Bullet 11 (three codes) has no
-- single signal (they come in any order), so it is an unproved branch bullet, shown done once Zantaviat 105 is seen. The draft
-- offered neither the zone-in nor the repeat events and used a 'min = 11' style mission guess; fixed.
return {
    title = 'Infiltrate Davoi',
    completes = 's6',
    known = {{t = 'mission', line = 'sandoria', min = 0}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'accept the mission infiltrate davoi from'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 10, completed = false, run1 = true, why = 'mission line: current mission = Infiltrate Davoi'},
            {t = 'event', zone = 230, event = 2029, why = 'Ambrotien 2029: Prince Trion has called for you (mission current, status 0)'},
            {t = 'event', zone = 230, event = 1029, why = 'Endracion 1029: Prince Trion has called for you'},
            {t = 'event', zone = 231, event = 1029, why = 'Grilau 1029: Prince Trion has called for you'},
            {t = 'chat', re = "Prince Trion has called for you%. Head to his chamber inside Chateau d'Oraguille", why = 'gate guard 2029 / 1029 (say #9258)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to prince trion who can'},
         done = {
            {t = 'event', zone = 233, event = 553, why = 'Door: Prince Royal\'s Rm 553: the briefing (LandSandBoat)'},
         }},
        {id = 's4', at = {n = 4, fp = 'zone into davoi for a'},
         done = {
            {t = 'zonein', zone = 149, event = 116, why = 'Davoi zone-in cutscene 116 (LandSandBoat onZoneIn, status 2)'},
         }},
        {id = 's5', at = {n = 5, fp = 'speak with quemaricond patrolling around h'},
         done = {
            {t = 'event', zone = 149, event = 117, why = 'Quemaricond 117: the report handed over'},
            {t = 'ki', id = 237, gained = true, why = "Royal Knights' Davoi report obtained"},
            {t = 'chat', re = "obtained key item: royal knights' davoi report", why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to prince trion to complete'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 10, completed = true, why = 'mission log: Infiltrate Davoi completed'},
            {t = 'event', zone = 233, event = 554, why = "Door: Prince Royal's Rm 554: the report delivered, completes (LandSandBoat)"},
         }},
        {id = 's8', kind = 'branch', at = {n = 8, fp = 'talk to any gate guard and'},
         done = {
            {t = 'chat', re = 'The situation in Davoi worsens by the day%.', why = 'a gate guard, repeat accepted (say #7310)'},
         }},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'make your way to davoi zone'}},
        {id = 's10', kind = 'branch', at = {n = 10, fp = 'when you enter davoi speak with'},
         done = {
            {t = 'event', zone = 149, event = 102, why = 'Zantaviat 102: the repeat briefing, status 0'},
            {t = 'chat', re = "Ah, it's you, .*I was waiting for you%.", why = 'Zantaviat 102 (say #7437)'},
         }},
        {id = 's11', kind = 'branch', at = {n = 11, fp = 'you will need to find 3'}, done = {}},
        {id = 's12', kind = 'branch', at = {n = 12, fp = 'return to zantaviat then return to'},
         done = {
            {t = 'event', zone = 149, event = 105, why = 'Zantaviat 105: the three codes handed in, status 9'},
            {t = 'chat', re = "That's all three blocks covered%.", why = 'Zantaviat 105 (say #7448)'},
            {t = 'event', zone = 230, event = 2012, why = 'Ambrotien 2012: the repeat completed'},
            {t = 'event', zone = 230, event = 1012, why = 'Endracion 1012: the repeat completed'},
            {t = 'event', zone = 231, event = 1012, why = 'Grilau 1012: the repeat completed'},
            {t = 'chat', re = "You've returned! Zantaviat told me everything%.", why = 'gate guard 1012 / 2012 (say #7311)'},
         }},
    },
}

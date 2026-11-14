-- Step progress for The Ruins of Fei'Yin (San d'Oria mission 5-1, mission id 14). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/5_1_The_Ruins_of_FeiYin.lua; client event scripts S4 230_Ambrotien_010E6062.txt,
-- 230_Endracion_010E6061.txt, 231_Grilau_010E7022.txt (accept: say #7335, #101 in Grilau), 233_Halver_010E9007.txt (533);
-- key items 72 (new Fei'Yin seal) and 73 (burnt seal) from res/key_items.lua, zones 204 (Fei'Yin) from res/zones.lua.
-- The menu is 1009/2009 (option 14 accepts and sets status 9), so the accept is proved by the line only the accept branch says and the
-- nation line moving to id 14 (completed = false, run1 as in the pilot). The pre-accept prompts 62 / 61 / 52 play without the mission
-- and are not used. The King Destin cutscene is the 0x00A event 509 in the Chateau (from Northern San d'Oria, status 0, before the
-- accept; LandSandBoat only) and the Zeid cutscene the 0x00A event 1 in Fei'Yin (status 10); the live addon does not read 0x00A yet,
-- so later steps infer them. Halver 533 (status 9) gives the new Fei'Yin seal. The burnt seal (KI 73) is handed out only by the
-- Qu'Bia Arena victory (32001, the battlefield win); Halver 534 (status 12, needs the burnt seal; no client body, LandSandBoat's id)
-- completes the mission. The Archlich fight bullets (6, 7) are indented-style information and not steps. The draft guessed the
-- completion and used 'min = 15' as a mission proof; fixed.
return {
    title = "The Ruins of Fei'Yin",
    completes = 's9',
    known = {{t = 'mission', line = 'sandoria', min = 0}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'zone into chateau d oraguille for'},
         done = {
            {t = 'zonein', zone = 233, event = 509, why = "Chateau d'Oraguille zone-in cutscene 509 (LandSandBoat onZoneIn, status 0)"},
         }},
        {id = 's3', at = {n = 3, fp = 'visit any gate guard and accept'},
         done = {
            {t = 'chat', re = "I'm not sure what it's about, but you'd best make haste%. The monarlais is not to be kept waiting!", why = 'a gate guard, accepted (say #7335)'},
            {t = 'mission', line = 'sandoria', eq = 14, completed = false, run1 = true, why = "mission line: current mission = The Ruins of Fei'Yin"},
         }},
        {id = 's4', at = {n = 4, fp = 'return to chateau d oraguille and'},
         done = {
            {t = 'event', zone = 233, event = 533, why = 'Halver 533: the expedition, hands over the new Fei\'Yin seal (status 9)'},
            {t = 'chat', re = "We've come to a decision at last, .*We will send an expedition to the accursed Northlands%.", why = 'Halver 533 (say #7141)'},
            {t = 'ki', id = 72, gained = true, why = "new Fei'Yin seal obtained"},
            {t = 'chat', re = "obtained key item: new fei'yin seal", why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'go to fei yin located in'},
         done = {
            {t = 'zonein', zone = 204, event = 1, why = "Fei'Yin zone-in cutscene 1 with Zeid (LandSandBoat onZoneIn, status 10)"},
         }},
        {id = 's8', at = {n = 8, fp = 'when you win you ll be'},
         done = {
            {t = 'ki', id = 73, gained = true, why = 'burnt seal obtained (the Qu\'Bia Arena victory)'},
            {t = 'chat', re = 'obtained key item: burnt seal', why = 'chat: key item obtained'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to halver to complete the'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 14, completed = true, why = "mission log: The Ruins of Fei'Yin completed"},
            {t = 'event', zone = 233, event = 534, why = 'Halver 534: the burnt seal handed in, completes (LandSandBoat)'},
         }},
    },
}

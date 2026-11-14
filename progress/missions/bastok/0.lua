-- Step progress for The Zeruhn Report (Bastok mission 1-1, mission id 0). Data only; see progress/missions/sandoria/0.lua for the
-- mission format. Evidence: LandSandBoat scripts/missions/bastok/1_1_The_Zeruhn_Report.lua; client event scripts S4
-- 172_Makarim_010AC064.txt (121: say #7339 and #7340); key item 1 Zeruhn report (res/key_items.lua).
-- The four gate guards (Argus, Cleades, Rashid, Malduc) offer it with event 1000, which also plays on a decline, and the accept's own line
-- ("You accept the mission", YOU_ACCEPT_THE_MISSION) is the same text for every Bastok mission, so only the nation line moving to 0
-- proves the accept (the matcher is completed = false so a completion read cannot restart a run). Makarim 121 (Zeruhn Mines, zone 172)
-- gives the Zeruhn report when it plays without one in hand (Rasmus 120 is a separate cutscene and the bullets do not name him). Naji 710
-- (Metalworks, zone 237) takes the report and completes; its body is empty in the client scripts, so its id comes from LandSandBoat.
-- The report is an intermediate key item, not a reward.
return {
    title = 'The Zeruhn Report',
    completes = 's4',
    known = {{t = 'mission', line = 'bastok', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to any bastokan gate guard'},
         done = {
            {t = 'mission', line = 'bastok', eq = 0, completed = false, why = 'mission log: current mission = The Zeruhn Report'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you will have to head to'}},
        {id = 's3', at = {n = 3, fp = 'speak to makarim in zeruhn mines'},
         done = {
            {t = 'event', zone = 172, event = 121, why = 'Makarim 121: the Zeruhn report'},
            {t = 'chat', re = 'My report is ready%.', why = 'Makarim 121 (say #7339)'},
            {t = 'ki', id = 1, gained = true, why = 'Zeruhn report obtained'},
            {t = 'ki_have', id = 1, have = true, why = 'Zeruhn report held'},
            {t = 'chat', re = 'obtained key item: zeruhn report', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to naji in the metalworks'},
         done = {
            {t = 'mission', line = 'bastok', eq = 0, completed = true, why = 'mission log: The Zeruhn Report completed'},
            {t = 'event', zone = 237, event = 710, why = 'Naji 710: the report handed over, completes'},
         }},
    },
}

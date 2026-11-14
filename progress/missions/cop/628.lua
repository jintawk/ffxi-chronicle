-- Step progress for More Questions than Answers (Chains of Promathia 6-3, mission id 628). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/6_3_More_Questions_than_Answers.lua; client scripts 243_Pherimociel_010F300F.txt
-- (10049, body empty; 10053 and 10063 are reminders, dropped) and 248_Mathilde_010F801B.txt (10005, body empty). Pherimociel 10049
-- (Ru'Lude Gardens 243, status 0) starts it; the Audience Chamber door (_6r9, event 10050, status 1; LandSandBoat's id) is bullet 2;
-- Mathilde 10005 (Selbina 248, status 2) completes. The draft had these on the wrong bullets (10050 on bullet 1, the Auchefort 10054
-- reminder with its chat line on bullet 2); both are corrected here.
return {
    title = 'More Questions than Answers',
    completes = 's3',
    known = {{t = 'mission', line = 'cop', eq = 628}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with pherimociel at g 6'},
         done = {
            {t = 'event', zone = 243, event = 10049, why = 'Pherimociel 10049 (status 0 only)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head up the stairs and examine'},
         done = {
            {t = 'event', zone = 243, event = 10050, why = 'Audience Chamber door 10050 (status 1 only, LandSandBoat)'},
         }},
        {id = 's3', at = {n = 3, fp = 'travel to h 9 in selbina'},
         done = {
            {t = 'mission', line = 'cop', eq = 628, completed = true, why = 'mission log: More Questions than Answers completed'},
            {t = 'event', zone = 248, event = 10005, why = 'Mathilde 10005: completes (status 2)'},
         }},
    },
}

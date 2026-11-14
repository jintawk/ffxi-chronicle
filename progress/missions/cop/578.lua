-- Step progress for For Whom the Verse is Sung (Chains of Promathia 6-1, mission id 578). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/6_1_For_Whom_the_Verse_is_Sung.lua; client script 243_Pherimociel_010F300F.txt lists
-- events 10046 and 10052 (10046 body empty; 10052 is the reminder, dropped). Pherimociel 10046 (Ru'Lude Gardens 243, status 0), the
-- Marble Bridge door (_6s1, Upper Jeuno 244, event 10011, status 1; LandSandBoat's id) and the Ru'Lude Gardens zone-in cutscene
-- 10047 (status 2; LandSandBoat's id), which completes the mission. The draft had no completing step: the zone-in on bullet 3 is it.
return {
    title = 'For Whom the Verse is Sung',
    completes = 's3',
    known = {{t = 'mission', line = 'cop', eq = 578}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with pherimociel at g 6'},
         done = {
            {t = 'event', zone = 243, event = 10046, why = 'Pherimociel 10046 (status 0 only)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to the marble bridge f'},
         done = {
            {t = 'event', zone = 244, event = 10011, why = 'Marble Bridge door 10011 (status 1 only, LandSandBoat)'},
         }},
        {id = 's3', at = {n = 3, fp = 'finally zone back into ru lude'},
         done = {
            {t = 'mission', line = 'cop', eq = 578, completed = true, why = 'mission log: For Whom the Verse is Sung completed'},
            {t = 'zonein', zone = 243, event = 10047, why = "Ru'Lude Gardens zone-in cutscene 10047: completes (status 2, LandSandBoat)"},
         }},
    },
}

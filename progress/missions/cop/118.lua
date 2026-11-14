-- Step progress for Below the Arks (Chains of Promathia 1-2, mission id 118). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/1_2_Below_the_Arks.lua and helpers.lua; client event scripts S4
-- 243_Pherimociel_010F300F.txt (event 24, no decoded body; 25 is the reminder at status 1), 243_Rainhard_010F300E.txt (event 34,
-- say #11062). Pherimociel 24 plays only at status 0 and starts the mission (no choice, so no refusal branch); the cop line moving
-- to 118 backs it. Bullet 2 (the three Promyvions) completes the mission in LandSandBoat after the first sealed memory (the Light of
-- Holla / Dem / Mea key item and mission:complete in spireEventFinish; the other two are left to The Mothercrystals), so the page's
-- "each of the three" is marked by the mission log completing; the Light key items are not used (a Promyvion can be re-sealed and
-- the Light items prove only that one crag, not the bullet). Rainhard 34 is an optional reminder that plays only while the mission
-- is current (status 1). Harith (bullet 4) has no event in the mission script and stays a plain bullet. The draft's High Wind 33,
-- Monberaux 9 and Pherimociel 25 are reminders and are dropped.
return {
    title = 'Below the Arks',
    completes = 's2',
    known = {{t = 'mission', line = 'cop', eq = 118}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to ru lude gardens and'},
         done = {
            {t = 'event', zone = 243, event = 24, why = 'Pherimociel 24: the mission begins (status 0 only)'},
            {t = 'mission', line = 'cop', eq = 118, completed = false, why = 'mission log: current mission = Below the Arks'},
         }},
        {id = 's2', at = {n = 2, fp = 'you must now complete each of'},
         done = {
            {t = 'mission', line = 'cop', eq = 118, completed = true, why = 'mission log: Below the Arks completed (first Promyvion sealed)'},
         }},
        {id = 's3', kind = 'optional', at = {n = 3, fp = 'optional speak with rainhard ru lude'},
         done = {
            {t = 'event', zone = 243, event = 34, why = 'Rainhard 34 (status 1 only)'},
            {t = 'chat', re = 'If you have any business with the archduke or the ducal scientists, please leave your message with us', why = 'Rainhard 34 (say #11062)'},
         }},
    },
}

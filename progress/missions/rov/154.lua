-- Step progress for Crashing Waves (Rhapsodies of Vana'diel mission 2-2, page id 154; LandSandBoat enum 46, page id = enum + 108).
-- Data only; see progress/missions/adoulin/140.lua for the format. Evidence: LandSandBoat scripts/missions/rov/2_02_Crashing_Waves.lua.
-- Walking into the trigger area at (H-7) near the palace in Ru'Lude Gardens (zone 243) plays event 10244 (progressEvent) while this
-- mission is current, once Chains of Promathia 3-2 is behind the player and the characters are available; that is bullet 1. Its finish
-- gives Cipher: Tenzen II and completes the mission, unless the bag is full: then it keeps a variable and the Mystic Retriever hands the
-- cipher over later, and that is when the mission completes. So the scene proves bullet 1 and only the line moving on proves bullet 2
-- ("obtain the Cipher: Tenzen II to complete"); the cipher is the reward, so it is not used. Event 10245 (the "unable to proceed"
-- notice, shown once when the characters are not available) is the refusal and is not used. No client script is decoded for either
-- event, and no other script plays 10244 in zone 243. The rov line has no completed set: the completion is `min = 156` (Call to Serve,
-- enum 48 + 108).
return {
    title = 'Crashing Waves',
    completes = 's2',
    known = {{t = 'mission', line = 'rov', eq = 154}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to ru lude gardens and'},
         done = {
            {t = 'event', zone = 243, event = 10244, why = "Ru'Lude Gardens trigger area (H-7), event 10244: the cutscene"},
         }},
        {id = 's2', at = {n = 2, fp = 'you must obtain the cipher tenzen'},
         done = {
            {t = 'mission', line = 'rov', min = 156, why = 'mission log: the line moved past Crashing Waves (cipher received, mission complete)'},
         }},
    },
}

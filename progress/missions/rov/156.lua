-- Step progress for Call to Serve (Rhapsodies of Vana'diel mission 2-3, page id 156; LandSandBoat enum 48, page id = enum + 108).
-- Data only; see progress/missions/adoulin/140.lua for the format. Evidence: LandSandBoat scripts/missions/rov/2_03_Call_to_Serve.lua.
-- Zoning into Port Jeuno (zone 246) plays zone-in scene 399 while this mission is current and the characters are available (bullet 1;
-- the same zone-in plays 402, a once-only "unable to proceed" notice, when they are not: that is the refusal and is not used). Its
-- finish gives Cipher: Prishe II and completes the mission, unless the bag is full: then it keeps a variable and the Mystic Retriever
-- hands the cipher over later, and that is when the mission completes. So the scene proves bullet 1 and only the line moving on proves
-- bullet 4 ("obtain the Cipher: Prishe II to complete"); the cipher is the reward, so it is not used. The other 399s in LandSandBoat
-- (windurst 8-2 and 9-2) are in Windurst zones. No client script is decoded for the zone-in. The rov line has no
-- completed set: the completion is `min = 158` (Numbering Days, enum 50 + 108). Bullets 2 and 3 (which CoP missions block the scene,
-- the message shown) and bullet 5 (the Reisenjima Orb background) are plain bullets, as the draft's note on bullet 5 led into nothing.
return {
    title = 'Call to Serve',
    completes = 's4',
    known = {{t = 'mission', line = 'rov', eq = 156}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into port jeuno for a'},
         done = {
            {t = 'zonein', zone = 246, event = 399, why = 'Port Jeuno zone-in scene 399: the cutscene'},
         }},
        {id = 's4', at = {n = 4, fp = 'you must obtain the cipher prishe'},
         done = {
            {t = 'mission', line = 'rov', min = 158, why = 'mission log: the line moved past Call to Serve (cipher received, mission complete)'},
         }},
    },
}

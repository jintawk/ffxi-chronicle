-- Step progress for The Merciless One (Seekers of Adoulin mission, page id 186). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_1_1_The_Merciless_One.lua and quests/hiddenQuests/Trust_Ingrid.lua. The Castle
-- Adoulin gates trigger area (Eastern Adoulin 257) plays event 1509 unconditionally while the mission is current, and its finish
-- completes the mission, so the event proves bullet 1 (the draft put it on bullet 2, the Trust bullet, which it does not prove).
-- Bullet 2 is the Ingrid Trust, which Rigobertine offers after the mission (event 5062, played on any talk and also on a refusal,
-- so it proves nothing), and no client script or LandSandBoat text the check reads carries a line that separates the accept, so
-- it is a note on bullet 1. The adoulin line (packet value = page id, no completed set) moves past 186: `min = 187`.
return {
    title = 'The Merciless One',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 186}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach the castle adoulin gates in'},
         done = {
            {t = 'event', zone = 257, event = 1509, why = 'Eastern Adoulin castle gates area 1509: the cutscene, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 187, why = 'mission log: the line moved past The Merciless One'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'after completing this mission speaking to'}},
    },
}

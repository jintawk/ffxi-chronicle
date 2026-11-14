-- Step progress for Royal Blessings (Seekers of Adoulin mission 4-6-2, mission page id 324). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_6_2_Royal_Blessings.lua. Levil (Western Adoulin 256) plays 178 on any talk while
-- this mission is current and its finish completes the mission (LandSandBoat notes there is no game-day wait before it, contrary
-- to the page's bullet 1). The client script for 178 is empty. Bullets 1 and 3 (the wait, the menu answers) are notes on bullet 2.
-- The adoulin line has no completed set: `min = 325`.
return {
    title = 'Royal Blessings',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 324}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'wait until the next game day'}},
        {id = 's2', at = {n = 2, fp = 'speak to levil in western adoulin'},
         done = {
            {t = 'event', zone = 256, event = 178, why = 'Levil 178, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 325, why = 'mission log: the line moved past Royal Blessings'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'select strange can you be more'}},
    },
}

-- Step progress for A Stone's Throw Away (Adoulin quest 56). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/A_Stones_Throw_Away.lua (Apolliane 2571 is shown while the quest is available
-- and quest:begin runs on its finish with no option; while accepted her talk is 2572; trading exactly one Marble Nugget (mined
-- on this character) plays 2573, which runs quest:complete and gives "Demolishing" (2206, a reward key item, so supporting
-- only); any other trade plays nothing). The log is flagged at the first bullet, so it is not silent. Bullet 2 (mine the nugget)
-- has no signal of its own (an item gain proves nothing alone) and bullet 9 is a hint: both are notes on the trade. The
-- "Location of known mining points" list (bullets 12 to 23) is a reference list and is left unmapped. Client event script S4
-- 265_Apolliane_011092FD.txt (2571 say #7528, 2572 say #7535, 2573 say #7539).
return {
    title = "A Stone's Throw Away",
    completes = 's11',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to apolliane to start the'},
         done = {
            {t = 'event', zone = 265, event = 2571, why = 'Apolliane 2571: the offer, begins the quest with no option'},
            {t = 'chat', re = 'The Morimar Basalt Fields are riddled with walls and crags made of hardened magma%.', why = 'Apolliane 2571 (say #7528)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 265, event = 2572, conf = 'inferred', why = 'Apolliane 2572: her talk while accepted'},
            {t = 'chat', re = 'Remember%-%-I require that you dig one up with your own tools%.', conf = 'inferred', why = 'Apolliane 2572 (say #7535)'},
         }},
        {id = 's2', kind = 'note', with = 's11', at = {n = 2, fp = 'mine a marble nugget'}},
        {id = 's9', kind = 'note', with = 's11', at = {n = 9, fp = 'mining points in morimar basalt fields'}},
        {id = 's11', at = {n = 11, fp = 'trade your marble nugget to apolliane'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 265, event = 2573, why = 'Apolliane 2573: the nugget accepted, runs quest:complete'},
            {t = 'chat', re = 'Well done! One who is able to find a stone such as this surely has what it takes to navigate the perilous terrain of the basalt fields%.', why = 'Apolliane 2573 (say #7539)'},
         }},
    },
}

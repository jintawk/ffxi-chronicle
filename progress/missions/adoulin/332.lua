-- Step progress for A Portent Most Ominous (Seekers of Adoulin mission, page id 332). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_1_3_A_Portent_Most_Ominous.lua. The Aged Stump (Leafallia 281) plays 10 as a plain
-- progress event with no refusal path, and its finish gives the Sky blue pome and Sun yellow pome (key items 2622, 2623) and completes
-- the mission, so the event, the two gains and the line prove bullet 2. Levil's 40 is a reminder and proves nothing. Bullet 1 (enter
-- Leafallia) has no event of its own, so it is a note on bullet 2. The adoulin line has no completed set (packet value = page id), so
-- the completion is `min = 333`. The draft's `completed = true` matcher and the held-key-item snapshots (the pomes can be used up later)
-- were dropped.
return {
    title = 'A Portent Most Ominous',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 332}},
    groups = {main = {start = {{t = 'mission', line = 'adoulin', eq = 332, why = 'mission line: current mission = A Portent Most Ominous'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'enter leafallia'}},
        {id = 's2', at = {n = 2, fp = 'click the aged stump for a'},
         done = {
            {t = 'event', zone = 281, event = 10, why = 'Aged Stump 10: finish gives both pomes and completes the mission'},
            {t = 'ki', id = 2622, gained = true, why = 'Sky blue pome obtained'},
            {t = 'ki', id = 2623, gained = true, why = 'Sun yellow pome obtained'},
            {t = 'mission', line = 'adoulin', min = 333, why = 'mission log: the line moved past A Portent Most Ominous'},
         }},
    },
}

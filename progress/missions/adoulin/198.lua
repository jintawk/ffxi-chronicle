-- Step progress for The Smallest of Favors (Seekers of Adoulin mission, page id 198). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_2_2_The_Smallest_of_Favors.lua. Zoning into Ceizak Battlegrounds (zone 261) from
-- Western Adoulin once the one-day timer has passed plays zone-in cutscene 20, and its finish always completes the mission. Levil
-- 141 is a reminder and proves nothing. Bullet 1 is the wait, a note on the zone-in. The adoulin line (packet value = page id,
-- no completed set) moves past 198: `min = 199`.
return {
    title = 'The Smallest of Favors',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 198}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'wait a game day from the'}},
        {id = 's2', at = {n = 2, fp = 'zone into ceizak battlegrounds from western'},
         done = {
            {t = 'zonein', zone = 261, event = 20, why = 'Ceizak Battlegrounds zone-in 20: its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 199, why = 'mission log: the line moved past The Smallest of Favors'},
         }},
    },
}

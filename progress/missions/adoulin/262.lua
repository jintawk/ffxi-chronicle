-- Step progress for A Day in the Life of a Pioneer (Seekers of Adoulin mission 4-1-5, page id 262). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_1_5_A_Day_in_the_Life_of_a_Pioneer.lua. Levil (Western Adoulin 256) plays event 159 only
-- once a Vana'diel day has passed and the player has zoned (before that he plays reminder 164, which proves nothing); event 159's finish
-- completes the mission (the client body is empty). Bullet 2 (the "What happened after that?" choice) is inside the same cutscene,
-- so it is a note. The line has no completed set, so the end is `min = 263`.
return {
    title = 'A Day in the Life of a Pioneer',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 262}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to levil at the pioneers'},
         done = {
            {t = 'event', zone = 256, event = 159, why = 'Levil 159: the cutscene (next day only; finish completes)'},
            {t = 'mission', line = 'adoulin', min = 263, why = 'mission log: the line moved past A Day in the Life of a Pioneer'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'choose what happened after that to'}},
    },
}

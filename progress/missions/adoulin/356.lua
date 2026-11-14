-- Step progress for Abomination (Seekers of Adoulin mission, page id 356). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_4_1_Abomination.lua (the battlefield itself is not implemented there). Winning the
-- fight puts you in Ra'Kaznar Turris (277), whose onZoneIn plays 4 only at status 1; its finish sets status 2 and sends you to Ceizak
-- Battlegrounds (261), whose onZoneIn plays 29 only at status 2, and the finish of 29 completes the mission. So both zone-ins and
-- the line (`min = 357`; the adoulin line has no completed set, packet value = page id) prove bullet 3 ("after winning you will be
-- thrown into another cutscene", then back in Ceizak). The draft put zone-in 4 on bullet 1, but it plays after the win, not on
-- entering. Bullet 1 (examine the Postern to enter) has no signal of its own (the entry id 32001 is a battlefield entry/exit id,
-- and the Awakened crystallized psyche is already owned from the previous mission), so it is a note, as is bullet 2.
return {
    title = 'Abomination',
    completes = 's3',
    known = {{t = 'mission', line = 'adoulin', eq = 356}},
    groups = {main = {start = {{t = 'mission', line = 'adoulin', eq = 356, why = 'mission line: current mission = Abomination'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'examine the ominous postern in ra'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you will be assisted by arciela'}},
        {id = 's3', at = {n = 3, fp = 'after winning you will be thrown'},
         done = {
            {t = 'zonein', zone = 277, event = 4, why = "Ra'Kaznar Turris zone-in 4: only plays after the won fight"},
            {t = 'zonein', zone = 261, event = 29, why = 'Ceizak Battlegrounds zone-in 29, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 357, why = 'mission line: the line moved past Abomination'},
         }},
    },
}

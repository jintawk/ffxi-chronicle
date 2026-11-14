-- Step progress for Reckoning (Seekers of Adoulin mission, page id 352). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_4_0_Reckoning.lua (the battlefield itself is not implemented there). Winning the fight
-- puts you in Ra'Kaznar Turris (277), whose onZoneIn plays 3 only at status 1; its finish completes the mission and gives the Awakened
-- crystallized psyche (key item 2628), so the zone-in, the key gain and the line (`min = 353`; the adoulin line has no completed set,
-- packet value = page id) prove bullet 2. Bullet 1 (examine the Postern to enter the fight) has no signal of its own: the entry event
-- 32001 is a battlefield entry/exit id, and the Crystallized psyche (2632) is also handed out by the previous mission, so neither
-- proves it; it is a note on bullet 2.
return {
    title = 'Reckoning',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 352}},
    groups = {main = {start = {{t = 'mission', line = 'adoulin', eq = 352, why = 'mission line: current mission = Reckoning'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'examine the ominous postern to enter'}},
        {id = 's2', at = {n = 2, fp = 'upon winning the battle you will'},
         done = {
            {t = 'zonein', zone = 277, event = 3, why = 'Ra\'Kaznar Turris zone-in 3 after the win, finish completes the mission'},
            {t = 'ki', id = 2628, gained = true, why = 'Awakened crystallized psyche obtained (zone-in 3 finish)'},
            {t = 'mission', line = 'adoulin', min = 353, why = 'mission line: the line moved past Reckoning'},
         }},
    },
}

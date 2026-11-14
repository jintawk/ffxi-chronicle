-- Step progress for Awakening (Zilart mission 17, mission id 30). Data only; see progress/missions/sandoria/12.lua.
-- The zilart line carries completed ids only, so the mission matcher is a completion.
-- Evidence: LandSandBoat scripts/missions/rotz/17_Awakening.lua; client script 252_Gilgamesh_010FC003.txt (event 177 with its lines,
-- 176 listed without a body). The two bullets are independent (the page says any order; each sets its own bit of the mission status),
-- so each has its own group and a done step in one never ticks the other. Bullet 1: the Norg zone-in cutscene 176 (once) or, when it
-- does not play, Gilgamesh 177 (say #10806, plays whenever the mission is current). Bullet 2: the Neptune's Spire Inn door in Lower
-- Jeuno (`_6tc`, 245, event 20, once; LandSandBoat, the client script is not decoded). The mission itself is completed by choosing a
-- reward at Gilgamesh 232/234 after zoning to Ru'Lude Gardens, which the page leaves to Shadows of the Departed and has no bullet
-- for, so there is no `completes` step; a completed id (inferred) ticks both bullets for a character who finished it earlier.
-- `known` is the previous mission (id 28) or anything after it completed. The draft's second bullet was a note; it is a real step.
return {
    title = 'Awakening',
    known = {{t = 'mission', line = 'zilart', min = 28, completed = true}},
    groups = {
        main = {start = {{t = 'mission', line = 'zilart', min = 28, completed = true}}},
        door = {start = {{t = 'mission', line = 'zilart', min = 28, completed = true}}},
    },
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter norg for a cutscene with'},
         done = {
            {t = 'zonein', zone = 252, event = 176, why = 'Norg zone-in cutscene 176 (once, LandSandBoat)'},
            {t = 'chat', re = "Arrrg, the Zilarrrt's dream of Paradise may be over, but that doesn't change the fact that them beastmen still be crawlin' over the face of Vana'diel%.", why = 'Gilgamesh 177 (say #10806)'},
            {t = 'event', zone = 252, event = 177, why = 'Gilgamesh 177: the talk while the mission is current'},
            {t = 'mission', line = 'zilart', eq = 30, completed = true, conf = 'inferred', why = 'mission log: Awakening completed, which needs both bullets'},
         }},
        {id = 's2', group = 'door', at = {n = 2, fp = 'click on the neptune s spire'},
         done = {
            {t = 'event', zone = 245, event = 20, why = "Neptune's Spire Inn door (_6tc) 20: the Aldo cutscene (once, LandSandBoat)"},
            {t = 'mission', line = 'zilart', eq = 30, completed = true, conf = 'inferred', why = 'mission log: Awakening completed, which needs both bullets'},
         }},
    },
}

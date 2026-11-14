-- Step progress for Run, Excenmille, Run! (The Voracious Resurgence mission 3-4, page id 228). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr script is a stub, so the proof is a key item and the mission log. 3258 "Carmine Swallows' map" is handed out after the
-- Ferric Stench fight (a sub-bullet of bullet 5, so it proves the fight); no other script gives it and it is not the reward (Hi-Elixir Tank). The tvr
-- line has no completed set, so the end is `min = 240` (Of Knights and Orcs). Bullet 1 (the optional Doll Gizmo, an item) and the talks stay plain bullets.
return {
    title = 'Run, Excenmille, Run!',
    completes = 's7',
    known = {{t = 'mission', line = 'tvr', min = 228, max = 239}},
    steps = {
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'head to beaucedine glacier'}},
        {id = 's5', at = {n = 5, fp = 'touch the ferric stench h 8'},
         done = {
            {t = 'ki', id = 3258, gained = true, why = '"Carmine Swallows\' map" obtained after the Ferric Stench fight'},
            {t = 'ki_have', id = 3258, have = true, why = '"Carmine Swallows\' map" held'},
         }},
        {id = 's7', at = {n = 7, fp = 'touch the point of interest at'},
         done = {
            {t = 'mission', line = 'tvr', min = 240, why = 'mission log: the line moved past Run, Excenmille, Run!'},
         }},
    },
}

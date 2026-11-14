-- Step progress for A Place to Return (Chains of Promathia 6-2, mission id 618). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/6_2_A_Place_to_Return.lua; client script 243_Pherimociel_010F300F.txt (event 28, say
-- #11098). The Ru'Lude Gardens trigger area plays 10048 at status 0 (LandSandBoat's id, no client body); Pherimociel 28 plays at
-- status 1 (LandSandBoat does not gate the gate on it, but it is the talk the bullet names; no other LandSandBoat script plays event
-- 28 in Ru'Lude Gardens); the Dilapidated Gate (_0p0, Misareaux Coast 25) event 10 plays only once all three Warders are dead and
-- completes the mission, so it also covers the spawn bullets (3 and 4, notes: checking the gate to spawn them has no event).
-- Dropped from the draft: the Adolie / Chapi Galepilai / Colti / Neraf-Najiruf / Auchefort lines (carried over from other
-- missions) and the guessed completion.
return {
    title = 'A Place to Return',
    completes = 's5',
    known = {{t = 'mission', line = 'cop', eq = 618}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head toward the palace in ru'},
         done = {
            {t = 'event', zone = 243, event = 10048, why = "Ru'Lude Gardens palace trigger area 10048 (status 0 only)"},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to pherimociel at g 6'},
         done = {
            {t = 'event', zone = 243, event = 28, why = 'Pherimociel 28 (status 1)'},
            {t = 'chat', re = 'One of the armada warships is missing!', why = 'Pherimociel 28 (say #11098)'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'travel to i 11 in misareaux'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'checking the dilapidated gate will spawn'}},
        {id = 's5', at = {n = 5, fp = 'after you defeat the warders check'},
         done = {
            {t = 'mission', line = 'cop', eq = 618, completed = true, why = 'mission log: A Place to Return completed'},
            {t = 'event', zone = 25, event = 10, why = 'Dilapidated Gate 10: completes (status 1, all three Warders dead, LandSandBoat)'},
         }},
    },
}

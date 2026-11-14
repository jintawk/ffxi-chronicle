-- Step progress for Maiden of the Dusk (Wings of the Goddess, mission id 50). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/51_Maiden_of_the_Dusk.lua. The Veridical Conflux (Grauberg [S] 89) plays 38 for the
-- warp offer, and a refusal plays it too (it sets Option), so it is only reach; the accepted warp lands in Walk of Echoes (182) with
-- the status-1 zone-in cutscene 4. The Ornate Door plays 5 at status 2; the Primal glow is consumed on entering the battlefield
-- (LandSandBoat TODO from retail). The win (32001, shared with every Walk of Echoes fight) is followed by the zone-in cutscenes 6,
-- 7, 8 (statuses 4 to 6) and 9, which runs mission:complete. A defeat is answered by the Conflux 44 (status above 0, no Primal
-- glow, timer over), which hands a new Primal glow: the last bullet, a branch. The Moonshade earring is the reward and not used.
return {
    title = 'Maiden of the Dusk',
    completes = 's4',
    known = {{t = 'mission', line = 'wotg', eq = 50}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the veridical conflux in grauberg'},
         done = {
            {t = 'zonein', zone = 182, event = 4, why = 'Walk of Echoes zone-in 4 (status 1, after accepting the warp)'},
         },
         reach = {{t = 'event', zone = 89, event = 38, why = 'Veridical Conflux 38: the warp offer (a refusal plays it too)'}}},
        {id = 's2', at = {n = 2, fp = 'examine the ornate door north of'},
         done = {
            {t = 'event', zone = 182, event = 5, why = 'Ornate Door 5 (status 2): the first cutscene'},
            {t = 'ki', id = 1731, gained = false, why = 'Primal glow used up on entering the battlefield'},
         }},
        {id = 's3', at = {n = 3, fp = 'your opponent in this bc is'},
         done = {
            {t = 'zonein', zone = 182, event = 6, why = 'Walk of Echoes zone-in 6 (status 4, only after the win)'},
            {t = 'zonein', zone = 182, event = 7, conf = 'inferred', why = 'Walk of Echoes zone-in 7 (status 5), after 6'},
            {t = 'zonein', zone = 182, event = 8, conf = 'inferred', why = 'Walk of Echoes zone-in 8 (status 6), after 7'},
         }},
        {id = 's4', at = {n = 4, fp = 'the mission will be complete after'},
         done = {
            {t = 'zonein', zone = 182, event = 9, why = 'Walk of Echoes zone-in 9 (status 7): the ten minute cutscene, completes the mission'},
            {t = 'mission', line = 'wotg', eq = 50, completed = true, why = 'mission log: Maiden of the Dusk completed'},
         }},
        {id = 's5', kind = 'branch', at = {n = 5, fp = 'if you are defeated wait for'},
         done = {
            {t = 'event', zone = 89, event = 44, why = 'Veridical Conflux 44: a new Primal glow after a defeat'},
         }},
    },
}

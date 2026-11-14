-- Step progress for A Dreamy Interlude (Wings of the Goddess, mission id 47). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/48_A_Dreamy_Interlude.lua: the Veridical Conflux (Grauberg [S] 89) plays 36 only once
-- the must-zone and the one-day timer are over and its finish runs mission:complete with no option test; before that it plays 27
-- (oncePerZone), which proves nothing.
return {
    title = 'A Dreamy Interlude',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 47}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the veridical conflux in grauberg'},
         done = {
            {t = 'event', zone = 89, event = 36, why = 'Veridical Conflux 36: the cutscene, completes the mission'},
            {t = 'mission', line = 'wotg', eq = 47, completed = true, why = 'mission log: A Dreamy Interlude completed'},
         }},
    },
}

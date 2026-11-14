-- Step progress for Glimmer of Life (Wings of the Goddess, mission id 43). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/44_Glimmer_of_Life.lua: the Veridical Conflux (Grauberg [S] 89) plays 34 only once the
-- must-zone and the one-day timer are over, and its finish runs mission:complete with no option test. The page says nothing else.
return {
    title = 'Glimmer of Life',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 43}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after waiting an in game day'},
         done = {
            {t = 'event', zone = 89, event = 34, why = 'Veridical Conflux 34: the cutscene, completes the mission'},
            {t = 'mission', line = 'wotg', eq = 43, completed = true, why = 'mission log: Glimmer of Life completed'},
         }},
    },
}

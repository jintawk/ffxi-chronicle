-- Step progress for Cait in the Woods (Wings of the Goddess, mission id 48). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/49_Cait_in_the_Woods.lua: the Blank Target (East Ronfaure [S] 81) plays 16 with no
-- conditions beyond the mission, and its finish runs mission:complete and hands the Ronfaure dawndrop. The dawndrop is the reward
-- and is not used.
return {
    title = 'Cait in the Woods',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 48}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the blank target at east'},
         done = {
            {t = 'event', zone = 81, event = 16, why = 'Blank Target 16: the cutscene, completes the mission'},
            {t = 'mission', line = 'wotg', eq = 48, completed = true, why = 'mission log: Cait in the Woods completed'},
         }},
    },
}

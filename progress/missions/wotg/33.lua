-- Step progress for The Hunter Ensnared (Wings of the Goddess mission id 33). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/34_The_Hunter_Ensnared.lua. Rally Point: Red (Xarcabard [S] 137) plays event 24 with no
-- menu and no condition beyond the mission being current; its finish completes the mission. No client script exists for this id.
return {
    title = 'The Hunter Ensnared',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 33}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the rally point red back'},
         done = {
            {t = 'mission', line = 'wotg', eq = 33, completed = true, why = 'mission log: The Hunter Ensnared completed'},
            {t = 'event', zone = 137, event = 24, why = 'Rally Point: Red 24: completes the mission'},
         }},
    },
}

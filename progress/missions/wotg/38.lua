-- Step progress for By the Fading Light (Wings of the Goddess mission id 38). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/39_By_the_Fading_Light.lua. Rally Point: Red (Xarcabard [S] 137) plays event 41 with no
-- menu; its finish completes the mission. No client script exists for this id.
return {
    title = 'By the Fading Light',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 38}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the rally point red in'},
         done = {
            {t = 'mission', line = 'wotg', eq = 38, completed = true, why = 'mission log: By the Fading Light completed'},
            {t = 'event', zone = 137, event = 41, why = 'Rally Point: Red 41: completes the mission'},
         }},
    },
}

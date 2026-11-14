-- Step progress for The Battle of Xarcabard (Wings of the Goddess mission id 29). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/30_The_Battle_of_Xarcabard.lua. Xarcabard [S] (137) zone-in cutscene 17 plays at Status 0
-- (sets Status 1); Rally Point: Red event 18 plays at Status 1 and its finish completes the mission. The draft had bullet 2 as a note
-- on bullet 1 because no bullet named the Rally Point as an NPC; it is the completing step. No client script exists for either id.
return {
    title = 'The Battle of Xarcabard',
    completes = 's2',
    known = {{t = 'mission', line = 'wotg', eq = 29}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into xarcabard s for a'},
         done = {
            {t = 'zonein', zone = 137, event = 17, why = 'Xarcabard [S] zone-in cutscene 17 (Status 0, LandSandBoat)'},
         }},
        {id = 's2', at = {n = 2, fp = 'examine the rally point red at'},
         done = {
            {t = 'mission', line = 'wotg', eq = 29, completed = true, why = 'mission log: The Battle of Xarcabard completed'},
            {t = 'event', zone = 137, event = 18, why = 'Rally Point: Red 18 (Status 1): completes the mission'},
         }},
    },
}

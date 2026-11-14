-- Step progress for A Spoonful of Sugar (Wings of the Goddess mission 11, mission id 10). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/11_A_Spoonful_of_Sugar.lua. The mission is one talk: Raustigne in Southern San d'Oria
-- [S] (zone 80) plays event 87 while it is current (no condition, no refusal), and its finish calls mission:complete. The draft
-- was right.
return {
    title = 'A Spoonful of Sugar',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 10}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to the victory gate at'},
         done = {
            {t = 'event', zone = 80, event = 87, why = 'Raustigne 87: completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 10, completed = true, why = 'mission log: A Spoonful of Sugar completed'},
         }},
    },
}

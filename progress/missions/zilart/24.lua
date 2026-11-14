-- Step progress for The Gate of the Gods (Zilart mission 13, mission id 24). Data only; see progress/missions/sandoria/12.lua.
-- The zilart line carries completed ids only, so the mission matcher is a completion.
-- Evidence: LandSandBoat scripts/missions/rotz/13_The_Gate_of_the_Gods.lua and zones/Hall_of_the_Gods/npcs/Shimmering_Circle.lua;
-- client script 251_Shimmering_Circle_010FB007.txt (event 10 listed under this mission, empty body). The Shimmering Circle (Hall of
-- the Gods 251, event 10) lifts you up once this mission or a later one is current, with no menu: bullet 1. Zoning into Ru'Aun
-- Gardens (130) plays the zone-in cutscene 51 and completes the mission (LandSandBoat; the client has no script for a zone-in
-- event). `known` is the previous mission (id 23) or anything after it completed. The draft proved bullet 2 with a current-value
-- matcher on the zilart line, which carries none; dropped.
return {
    title = 'The Gate of the Gods',
    completes = 's2',
    known = {{t = 'mission', line = 'zilart', min = 23, completed = true}},
    groups = {main = {start = {{t = 'mission', line = 'zilart', min = 23, completed = true}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after the last cutscene where you'},
         done = {
            {t = 'event', zone = 251, event = 10, why = 'Shimmering Circle 10: lifted up to the sky (this mission or later is current)'},
         }},
        {id = 's2', at = {n = 2, fp = 'run forward to zone into ru'},
         done = {
            {t = 'mission', line = 'zilart', eq = 24, completed = true, why = 'mission log: The Gate of the Gods completed'},
            {t = 'zonein', zone = 130, event = 51, why = "Ru'Aun Gardens zone-in cutscene 51: completes the mission (LandSandBoat)"},
         }},
    },
}

-- Step progress for The Will of the World (Wings of the Goddess mission 24, mission id 24). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/25_The_Will_of_the_World.lua; client event script S4 080_Raustigne_010501EF.txt (event 149
-- exists with an empty body). Raustigne (Southern San d'Oria [S] 80) plays 149 on every talk while this mission is current; there is no
-- menu and its finish completes the mission. The three leading bullets are addon and settings tips for the cutscene, notes on the step
-- they lead into. The draft is kept.
return {
    title = 'The Will of the World',
    completes = 's4',
    known = {{t = 'mission', line = 'wotg', eq = 24}},
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'disable fastcs lua unload fastcs only'}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'lower frame rate config frameratedivisor 2'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'disable timers unload timers try this'}},
        {id = 's4', at = {n = 4, fp = 'speak to raustigne in southern san'},
         done = {
            {t = 'event', zone = 80, event = 149, why = 'Raustigne 149: the cutscene, completes the mission'},
            {t = 'mission', line = 'wotg', eq = 24, completed = true, why = 'mission log: The Will of the World completed'},
         }},
    },
}

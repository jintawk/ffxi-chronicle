-- Step progress for Thick Shells (San d'Oria quest 117). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Port_San_dOria/npcs/Vounebariont.lua (516 plays on every talk at fame 2 and its
-- finish adds the quest when it is available; 568 is the low-fame talk; an exact trade of 5 Beetle Shells plays 514 in any
-- state but available and its finish pays gil and fame, completing the quest when it is accepted, with no item reward);
-- client event script S4 232_Vounebariont_010E8040.txt (516 say #7608, 514 #7614). Repeatable, but a repeat needs no new
-- accept (the trade alone), so there is no `repeatable` entry, as in Tiger's Teeth (quest 23).
return {
    title = 'Thick Shells',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to vounebariont to begin this'},
         done = {
            {t = 'event', zone = 232, event = 516, why = 'Vounebariont 516: the talk that adds the quest'},
            {t = 'chat', re = "Hmm%.%.%. You don't look like the riffraff we get around here%.", why = 'Vounebariont 516 (say #7608)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade vounebariont 5 beetle shells to'}, count = {item = 889, need = 5},
         done = {
            {t = 'event', zone = 232, event = 514, why = 'Vounebariont 514: the exact trade'},
            {t = 'chat', re = "You're back, and with the shells as requested!", why = 'Vounebariont 514 (say #7614)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

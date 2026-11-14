-- Step progress for The Real Gift (other areas quest 22). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/The_Real_Gift.lua (Oswald 73 is the offer and begins the quest only on
-- option 50; 74 is his reminder while accepted; 75 is the Shall Shell accepted and runs quest:complete; 76 plays after
-- completion and is not used). Client event script S4 248_Oswald_010F8013.txt (73 accept branch say #6810, 75 say #6820).
-- Not repeatable.
return {
    title = 'The Real Gift',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to oswald to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Oswald 73, option 50)'},
            {t = 'chat', re = "I know I might seem stubborn, but you're my only hope%.", why = 'Oswald 73, accept branch (say #6810)'},
            {t = 'event', zone = 248, event = 74, conf = 'inferred', why = 'Oswald 74: reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 248, event = 73, why = 'Oswald 73 offered (its finish needs option 50)'}}},
        {id = 's2', at = {n = 2, fp = 'trade oswald a shall shell to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 248, event = 75, why = 'Oswald 75: the Shall Shell accepted, runs quest:complete'},
            {t = 'chat', re = 'Goodness, you found one! Thank you so much!', why = 'Oswald 75 (say #6820)'},
         }},
    },
}

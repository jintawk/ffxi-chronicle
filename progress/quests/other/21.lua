-- Step progress for The Gift (other areas quest 21). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/The_Gift.lua (Oswald 70 is the offer and begins the quest only on option 50,
-- the "Of course." branch, so the event alone is a reach; 71 is his reminder while accepted; 72 is the Danceshroom accepted and
-- runs quest:complete; 78 plays after completion and is not used). Client event script S4 248_Oswald_010F8013.txt (70 accept
-- branch say #6799, 72 say #6803). Not repeatable.
return {
    title = 'The Gift',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to oswald to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Oswald 70, option 50)'},
            {t = 'chat', re = 'Thank you very much%. He wanted', why = 'Oswald 70, accept branch (say #6799)'},
            {t = 'event', zone = 248, event = 71, conf = 'inferred', why = 'Oswald 71: reminder, only while accepted'},
            {t = 'chat', re = "They say they're really hard to come by%.", conf = 'inferred', why = 'Oswald 71 (say #6800)'},
         },
         reach = {{t = 'event', zone = 248, event = 70, why = 'Oswald 70 offered (its finish needs option 50)'}}},
        {id = 's2', at = {n = 2, fp = 'trade oswald a danceshroom to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 248, event = 72, why = 'Oswald 72: the Danceshroom accepted, runs quest:complete'},
            {t = 'chat', re = 'This is all I have to give%.', why = 'Oswald 72 (say #6803)'},
         }},
    },
}

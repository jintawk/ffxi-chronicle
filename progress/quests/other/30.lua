-- Step progress for Recycling Rods (other areas quest 30). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Recycling_Rods.lua (Keshab-Menjab 313 is the offer and begins the quest only
-- on option 1; 315 is his reminder while accepted; 316 is a wrong trade and is a refusal; a Cleanly Snapped Rod traded plays 317
-- and runs quest:complete; 314 plays after completion and is not used). Client event script S4 249_Keshab_Menjab_010F9070.txt
-- (313 accept branch say #7591, 315 say #7595, 317 say #7598). The fishing and Lancet Jagil bullets are notes (the rod can
-- come from elsewhere). Not repeatable.
return {
    title = 'Recycling Rods',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to keshab menjab at the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Keshab-Menjab 313, option 1)'},
            {t = 'chat', re = "That's the spirit! Now get out there and start snip%-snappin' some poles", why = 'Keshab-Menjab 313, accept branch (say #7591)'},
            {t = 'event', zone = 249, event = 315, conf = 'inferred', why = 'Keshab-Menjab 315: reminder, only while accepted'},
            {t = 'chat', re = 'Recently I\'ve been receiving a lot of crabby complaints', conf = 'inferred', why = 'Keshab-Menjab 315 (say #7595)'},
         },
         reach = {{t = 'event', zone = 249, event = 313, why = 'Keshab-Menjab 313 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'head to bibiki bay purgonorgo isle'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'defeat lancet jagils to obtain a'}},
        {id = 's4', at = {n = 4, fp = 'return the rod to keshab menjab'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 249, event = 317, why = 'Keshab-Menjab 317: the clean rod accepted, runs quest:complete'},
            {t = 'chat', re = 'Oh! What a clean break! Even I can fix this guy!', why = 'Keshab-Menjab 317 (say #7598)'},
         }},
    },
}

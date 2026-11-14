-- Step progress for An Explorer's Footsteps (other areas quest 19). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/An_Explorers_Footsteps.lua (Abelard 40 offers, quest:begin only on option
-- 100; the monument trade gives the Clay Tablet with no event; Abelard 41 (requested tablet) and 46 (another tablet) are the
-- accepted tablet trades, 45 is the refusal (already traded) and is not used; 47 is the 17th tablet and runs quest:complete;
-- 43/49 are his reminders while accepted). Client event script S4 248_Abelard_010F800F.txt (the "What a relief!" line is on
-- the accept branch only; "Well?" and the offer lines play on both). The quest completes only after all 17 monuments, so s3
-- ticks on the first tablet and s4 waits for the last. Not repeatable.
return {
    title = "An Explorer's Footsteps",
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to abelard g 9 to'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Abelard 40, option 100)'},
            {t = 'chat', re = 'What a relief! Well, there\'s no time to lose', why = 'Abelard 40, accept branch (say #6772)'},
            {t = 'event', zone = 248, event = 43, conf = 'inferred', why = 'Abelard 43: monument clue, only while accepted'},
            {t = 'event', zone = 248, event = 49, conf = 'inferred', why = 'Abelard 49: monument clue, only while accepted'},
         },
         reach = {{t = 'event', zone = 248, event = 40, why = 'Abelard 40 offered (its finish needs option 100)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'trade the selbina clay to a'}},
        {id = 's3', at = {n = 3, fp = 'return to abelard and trade the'},
         done = {
            {t = 'event', zone = 248, event = 41, why = 'Abelard 41: the requested tablet accepted'},
            {t = 'event', zone = 248, event = 46, why = 'Abelard 46: another tablet accepted'},
            {t = 'event', zone = 248, event = 47, why = 'Abelard 47: the last tablet accepted'},
            {t = 'chat', re = "At last! You've done it!", why = 'Abelard 41 (say #6776)'},
            {t = 'chat', re = "This isn't the one I asked for", why = 'Abelard 46 (say #6777)'},
         }},
        {id = 's4', at = {n = 4, fp = 'repeat for the remaining stone monuments'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 248, event = 47, why = 'Abelard 47: the 17th tablet, runs quest:complete'},
            {t = 'chat', re = "You're back! And with the last one!", why = 'Abelard 47 (say #6785)'},
         }},
    },
}

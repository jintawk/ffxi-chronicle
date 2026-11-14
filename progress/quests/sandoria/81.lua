-- Step progress for Lufet's Lake Salt (San d'Oria quest 81). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Lufets_Lake_Salt.lua (Nogelle 12 option 0 begins the quest; 10 is his
-- reminder, only while it is accepted; trading 3 Chunks of Lufet Salt is event 11 and completes it; 522 is the line after
-- completion); client event scripts S4 232_Nogelle_010E800E.txt (12 accept branch say #7466, 10 say #7468, 11 say #7469).
-- Event 12 and its other lines also play on a refusal, so only the accept line proves s1.
return {
    title = "Lufet's Lake Salt",
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to nogelle who asks for'},
         done = {
            {t = 'chat', re = 'Thank you! You can find', why = 'Nogelle 12, accepted (say #7466)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 232, event = 10, conf = 'inferred', why = 'Nogelle 10: reminder, only while accepted'},
            {t = 'chat', re = 'Remember, you can get', conf = 'inferred', why = 'Nogelle 10 (say #7468)'},
         },
         reach = {{t = 'event', zone = 232, event = 12, why = 'Nogelle 12 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'lufet salt drops off river crabs'}},
        {id = 's3', at = {n = 3, fp = 'trade her the three salts to'},
         done = {
            {t = 'event', zone = 232, event = 11, why = 'Nogelle 11: the salts accepted'},
            {t = 'chat', re = 'Yes! This should give our beans a bang!', why = 'Nogelle 11 (say #7469)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

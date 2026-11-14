-- Step progress for Till Death Do Us Part (Bastok quest 18). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Till_Death_Do_Us_Part.lua (Romilda 128 begins it at Bastok fame 3 once Forever to
-- Hold is done, 127 is her plain line at lower fame; trading the Cotton Gloves is event 129, which runs quest:complete and pays
-- 2,000 gil, no reward item); client event script S4 236_Romilda_010EC02D.txt (128 say #7554, 127 only #7552/#7553, 129 say
-- #7557). Bullet 1 (zone once after Forever to Hold) is a note on the accept. The quest log is set at s2, so it is not silent.
return {
    title = 'Till Death Do Us Part',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you must have zoned once after'}},
        {id = 's2', at = {n = 2, fp = 'talk to romilda who wants to'},
         done = {
            {t = 'event', zone = 236, event = 128, why = 'Romilda 128'},
            {t = 'chat', re = 'I should give Qiji something back for his present this time, too%.', why = 'Romilda 128 (say #7554)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'once you ve got it trade'},
         done = {
            {t = 'event', zone = 236, event = 129, why = 'Romilda 129: the Cotton Gloves trade'},
            {t = 'chat', re = 'Hmm%? You! What are you giving her%?', why = 'Romilda 129 (say #7557)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

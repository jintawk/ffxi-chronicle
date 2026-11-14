-- Step progress for Forever to Hold (Bastok quest 17). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Forever_to_Hold.lua (Qiji 123 begins the quest at Bastok fame 2; trading the
-- Brass Hairpin to Qiji himself is event 124, which completes nothing and only plays while accepted; trading it to Romilda is
-- event 125; Qiji 126 then runs quest:complete and pays 300 gil, no reward item); client event scripts S4
-- 236_Qiji_010EC02C.txt (123 say #7543/#7544, 124 say #7545, 126 say #7551) and 236_Romilda_010EC02D.txt (125 say #7547).
-- Bullet 2 (where to get the hairpin) is a note on the trade. The quest log is set at s1, so it is not silent.
return {
    title = 'Forever to Hold',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to qiji who wants to'},
         done = {
            {t = 'event', zone = 236, event = 123, why = 'Qiji 123'},
            {t = 'chat', re = 'I want to give my wife Romilda here a present%.', why = 'Qiji 123 (say #7543)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 236, event = 124, conf = 'inferred', why = 'Qiji 124: the hairpin offered to him, only while accepted'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'brass hairpins can be bought off'}},
        {id = 's3', at = {n = 3, fp = 'trade the hairpin to romilda who'},
         done = {
            {t = 'event', zone = 236, event = 125, why = 'Romilda 125: the hairpin trade'},
            {t = 'chat', re = 'Qiji, look at what this nice person gave me!', why = 'Romilda 125 (say #7547)'},
         }},
        {id = 's4', at = {n = 4, fp = 'talk to qiji to obtain your'},
         done = {
            {t = 'event', zone = 236, event = 126, why = 'Qiji 126'},
            {t = 'chat', re = "Well, as long as she's happy, I can't complain%.", why = 'Qiji 126 (say #7551)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

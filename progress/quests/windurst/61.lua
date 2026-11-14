-- Step progress for The Amazin' Scorpio (Windurst quest 61). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Soni-Muni.lua (481 is the offer, played only while the quest is
-- available, and its finish adds the quest with no choice; 482 is his talk while accepted; trading a Scorpion Stinger is event
-- 484, which only plays while accepted and whose finish completes the quest with fame, a title and gil only, so a full bag
-- cannot refuse it; 485 is his talk after completion) and Gottah_Maporushanoh.lua (483 accepted, 486 done; she is not on the
-- page, so those are unused); client event script S4 241_Soni_Muni_010F10B3.txt (481 say #8700, 482 say #8704, 484 say #8708,
-- 485 say #8722). The draft made the trade a note; it is the quest's completing step. The stinger hunt has no strong signal
-- (the item also comes from the auction house) and is a note on the trade. The quest log is set at s1, so it is not silent.
return {
    title = "The Amazin' Scorpio",
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to soni muni in windurst'},
         done = {
            {t = 'event', zone = 241, event = 481, why = 'Soni-Muni 481: the offer, adds the quest'},
            {t = 'chat', re = "Soni%-Muni's me name%.", why = 'Soni-Muni 481 (say #8700)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 241, event = 482, conf = 'inferred', why = 'Soni-Muni 482: reminder, only once accepted'},
            {t = 'chat', re = 'My mate Gottah over there has lost all motivation as of late%.', conf = 'inferred', why = 'Soni-Muni 482 (say #8704)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'obtain a scorpion stinger'}},
        {id = 's3', at = {n = 3, fp = 'trade the scorpion stinger to soni'},
         done = {
            {t = 'event', zone = 241, event = 484, why = 'Soni-Muni 484: the Scorpion Stinger accepted'},
            {t = 'chat', re = 'Whoa, looky%-looky', why = 'Soni-Muni 484 (say #8708)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 241, event = 485, conf = 'inferred', why = 'Soni-Muni 485: his talk after completion'},
            {t = 'chat', re = "That's what I've been sayin'%-wayin' all this time!", conf = 'inferred', why = 'Soni-Muni 485 (say #8722)'},
         }},
    },
}

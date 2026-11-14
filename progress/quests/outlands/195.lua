-- Step progress for The Kuftal Tour (Outlands quest 195). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/The_Kuftal_Tour.lua (Datta 74 is the offer and begins the quest on finish, no
-- choice; the ??? (qm5) in Kuftal Tunnel plays 14 only for a party of two or more, everyone level 40 or below and within 15 yalms,
-- and sets Prog 1; Datta 75 at Prog 1 completes); client event script S4 247_Datta_010F702F.txt (74 say #10220, 75 say #10224).
-- The tunnel's event script is not in the client dump, so event 14 comes from LandSandBoat only and is gated after the offer.
-- The party bullet is a note on the ??? step. Not repeatable.
return {
    title = 'The Kuftal Tour',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to datta to begin the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Datta 74)'},
            {t = 'event', zone = 247, event = 74, why = 'Datta 74: begins the quest'},
            {t = 'chat', re = "I'm planning a tour that will take people to all the mysterious places that can be found on Zepwell Island%.%.%.", why = 'Datta 74 (say #10220)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'form a party with at least'}},
        {id = 's3', at = {n = 3, fp = 'head to kuftal tunnel and examine'},
         done = {
            {t = 'event', zone = 174, event = 14, after = 's1', why = 'Kuftal Tunnel ??? 14: the cutscene, only for a qualifying party'},
         }},
        {id = 's4', at = {n = 4, fp = 'once you get the cutscene in'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 247, event = 75, why = 'Datta 75: plays at Prog 1 only, runs quest:complete'},
            {t = 'chat', re = "Huh%? It's definitely not a place for sightseeing%?", why = 'Datta 75 (say #10224)'},
         }},
    },
}

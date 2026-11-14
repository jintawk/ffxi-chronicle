-- Step progress for Two Horn the Savage (Aht Urhgan quest 17). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Two_Horn_the_Savage.lua (a Prog state machine: Milazahn 594 is the offer and
-- only option 1 begins the quest, so 594 is a reach; Cacaroon has no event at Prog 0 in LandSandBoat, so bullet 2 has no signal
-- and is a note; trading exactly 1,000 gil plays 595 and sets Prog 1; from Prog 1 on Cacaroon's talk is 608, once per zone;
-- the Mamook Viscous Liquid plays 212 at Prog 1 and sets 2, at Prog 2 it spawns the Mamool Ja with only a system message and no
-- event, killing it sets 3, and at Prog 3 it plays 213 and sets 4; Milazahn 596 at Prog 4 runs quest:complete, whose reward is
-- an Imperial Mythril Piece, so 596 replays on a full bag and is only a reach, with its opening line: the completed bit proves
-- the last bullet). Events 212 and 213 are also used in Arrapago Reef (zone 54) by The Die Is Cast, so the zone is part of the
-- match. Client event scripts S4 050_Cacaroon_010320EC.txt (608 say #9404) and 050_Milazahn_01032059.txt (596 say #9351); the
-- other events have no text. The Mamook entry (bullet 4) is a note on the first cutscene, the spawn bullet (6) a note on the
-- final one. Not repeatable.
return {
    title = 'Two Horn the Savage',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to milazahn for a cutscene'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Milazahn 594, option 1)'},
         },
         reach = {{t = 'event', zone = 50, event = 594, why = 'Milazahn 594 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak to cacaroon g 11 for'}},
        {id = 's3', at = {n = 3, fp = 'trade cacaroon 1 000 gil for'},
         done = {
            {t = 'event', zone = 50, event = 595, why = 'Cacaroon 595: the 1,000 gil accepted, only at Prog 0, sets Prog 1'},
            {t = 'event', zone = 50, event = 608, why = 'Cacaroon 608: only from Prog 1 on'},
            {t = 'chat', re = 'Mamoook very spoooky place%.', why = 'Cacaroon 608 (say #9404)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'zone into mamook from the mamool'}},
        {id = 's5', at = {n = 5, fp = 'head northwest to e 8 and'},
         done = {
            {t = 'event', zone = 65, event = 212, why = 'Viscous Liquid 212: only at Prog 1, sets Prog 2'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'examine the viscous liquid again to'}},
        {id = 's7', at = {n = 7, fp = 'examine the viscous liquid after the'},
         done = {
            {t = 'event', zone = 65, event = 213, why = 'Viscous Liquid 213: only at Prog 3 (the Mamool Ja dead), sets Prog 4'},
         }},
        {id = 's8', at = {n = 8, fp = 'return to milazahn for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 50, event = 596, why = 'Milazahn 596 (replays if the Imperial Mythril Piece cannot be given)'},
            {t = 'chat', re = 'So it was just a regular Mamool Ja', why = 'Milazahn 596 (say #9351)'},
         }},
    },
}

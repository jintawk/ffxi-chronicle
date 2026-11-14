-- Step progress for The Sacred Katana (Outlands quest 140). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/SAM_AF1_The_Sacred_Katana.lua (Jaucribaix 139 is the offer and only option 1
-- begins the quest, so the event is a reach and the accept line is the proof; the ??? in the Sanctuary of Zi'Tah pops Isonade on
-- a Sack of Fish Bait trade (no event) and gives the Handful of crystal scales key item (453) on the re-examine; Jaucribaix 141
-- is the Mumeito trade, played only with the scales held, and runs quest:complete and takes the scales). Ranemaud 144/145 (a
-- replacement Mumeito for 30,000 gil) sit under bullet 5 as a sub-bullet and prove nothing of the quest, so they are not used,
-- nor is the Mumeito gain (it can come from elsewhere). Client event script S4 252_Jaucribaix_010FC010.txt (139 accept branch
-- say #10644, 141 say #10652). The quest log is set at s1, so it is not silent. The page says repeatable after a memory reset;
-- nothing observable marks a second run (LandSandBoat has none), so there is no `repeatable` entry.
return {
    title = 'The Sacred Katana',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to norg and talk to'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Jaucribaix 139, option 1)'},
            {t = 'chat', re = 'Spoken like a true samurai%.', why = 'Jaucribaix 139, accept branch (say #10644)'},
         },
         reach = {{t = 'event', zone = 252, event = 139, why = 'Jaucribaix 139 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'travel to the the sanctuary of'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'trade the fish bait to the'}},
        {id = 's4', at = {n = 4, fp = 're examine the to obtain the'},
         done = {
            {t = 'ki', id = 453, gained = true, why = 'handful of crystal scales obtained'},
            {t = 'ki_have', id = 453, have = true, why = 'handful of crystal scales held'},
            {t = 'chat', re = 'obtained key item: handful of crystal scales', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to norg and trade your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 252, event = 141, why = 'Jaucribaix 141: the Mumeito trade, runs quest:complete'},
            {t = 'chat', re = 'I see you have successfully obtained the materials necessary for the forging of the sacred katana%.', why = 'Jaucribaix 141 (say #10652)'},
            {t = 'ki', id = 453, gained = false, conf = 'inferred', why = 'handful of crystal scales handed over'},
         }},
    },
}

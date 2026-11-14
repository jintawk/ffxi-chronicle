-- Step progress for The Sand Charm (quest other 8). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/The_Sand_Charm.lua (a Prog chain before the quest log: Blandine 125 at
-- Prog 0 sets Prog 1, Zexu 123 at Prog 1 sets 2, Blandine 124 at Prog 2 sets 3, each with no menu and owned by this quest
-- alone; Celestina 126 at Prog 3 is the offer with a Yes/No menu, so it is a reach, and the "There's something that Father
-- told me" line plays on Yes only, which is when the log flags the quest; trading the Sand Charm is event 127, which runs
-- quest:complete; Blandine 128 and 129 are after-completion talk and have no bullet). The log is silent until Celestina's
-- accept, so steps one to three are unknown, not to do, before it. The line #6980 is shared by Blandine 124 and 125 and is
-- not used. Client event scripts S4 249_Blandine_010F9021.txt (124 say #6983), 249_Zexu_010F9019.txt (123 say #6978),
-- 249_Celestina_010F900C.txt (126 say #6995, 127 say #7001). Sand Charm id 13095. Not repeatable.
return {
    title = 'The Sand Charm',
    completes = 's5',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's4'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to blandine to begin this'},
         done = {
            {t = 'event', zone = 249, event = 125, why = 'Blandine 125: only at Prog 0, sets Prog 1'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to zexu'},
         done = {
            {t = 'event', zone = 249, event = 123, why = 'Zexu 123: only at Prog 1, sets Prog 2'},
            {t = 'chat', re = "Yeah, breaks me 'eart to see 'er%.", why = 'Zexu 123 (say #6978)'},
         }},
        {id = 's3', at = {n = 3, fp = 'exit the dock then talk to'},
         done = {
            {t = 'event', zone = 249, event = 124, why = 'Blandine 124: only at Prog 2, sets Prog 3'},
            {t = 'chat', re = 'What are you talking about, Celestina%?', why = 'Blandine 124 (say #6983)'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to celestina in the nearby'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Celestina 126, Yes)'},
            {t = 'chat', re = "There's something that Father told me once that might help us", why = 'Celestina 126, accepted (say #6995)'},
         },
         reach = {{t = 'event', zone = 249, event = 126, why = 'Celestina 126 offered (plays on No too)'}}},
        {id = 's5', at = {n = 5, fp = 'trade celestina a sand charm to'}, count = {item = 13095, need = 1},
         done = {
            {t = 'event', zone = 249, event = 127, why = 'Celestina 127: the Sand Charm accepted, runs quest:complete'},
            {t = 'chat', re = "I've thought long and hard since we last spoke, and I've decided to stand by Mother's side and believe in Father's return%.", why = 'Celestina 127 (say #7001)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

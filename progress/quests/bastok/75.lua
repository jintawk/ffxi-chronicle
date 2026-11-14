-- Step progress for Out of the Depths (Bastok quest 75). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Out_of_the_Depths.lua (Ayame 859 begins the quest only on option 3, so only the
-- log proves it; Ravorara 307 at Prog 0 sets Prog 1; Brakobrik 2 sets Prog 2 only on its second menu choice, and its line
-- "Do you really getting me?" plays only on that choice; the ash trade (event 4) plays on every outcome, so the key items
-- Dusty tome, Pointed jug, Cracked club and Peeling hairpin (597-600) prove s5; the Old nametag (601) is the reward of the
-- "No Thanks" trade of the last ash, bullet n=7, and is handed to Ravorara with event 309 option 5 (bullet n=8); Pavvke 238
-- needs Prog 4 and completes). Client event scripts S4 011_Brakobrik_0100B0E1.txt (event 2 branch at 0035, say #7734),
-- 236_Ravorara_010EC08F.txt (311 say #9159), 237_Ayame_010ED02F.txt, 234_Pavvke_010EA037.txt. The draft put the Old nametag
-- on the first trade; it belongs to bullet n=7. The four Ravorara hand-ins (n=6) leave no strong trace of their own (only a
-- key item lost each time) and stay a plain bullet; the nametag trade, which needs all four, infers them.
return {
    title = 'Out of the Depths',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to ayame for a starting'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 237, event = 860, conf = 'inferred', why = 'Ayame 860: reminder, only while accepted'},
            {t = 'chat', re = 'A beastman lair has appeared in North Gustaberg%.', conf = 'inferred', why = 'Ayame 860 (say #9936)'},
         },
         reach = {{t = 'event', zone = 237, event = 859, why = 'Ayame 859 offered (its finish needs option 3)'}}},
        {id = 's2', at = {n = 2, fp = 'go to port bastok and talk'},
         done = {
            {t = 'event', zone = 236, event = 307, why = 'Ravorara 307: the first talk, only at Prog 0'},
         }},
        {id = 's3', at = {n = 3, fp = 'go to oldton movalpolos and talk'},
         done = {
            {t = 'chat', re = 'Do you really getting me%?', why = 'Brakobrik 2, second menu choice only (say #7734)'},
         },
         reach = {{t = 'event', zone = 11, event = 2, why = 'Brakobrik 2 offered (its finish needs option 2)'}}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'kill ancient bombs in oldton movalpolos'}},
        {id = 's5', at = {n = 5, fp = 'trade between 1 to 4 hoary'},
         done = {
            {t = 'ki', id = 597, gained = true, why = 'dusty tome obtained'},
            {t = 'ki', id = 598, gained = true, why = 'pointed jug obtained'},
            {t = 'ki', id = 599, gained = true, why = 'cracked club obtained'},
            {t = 'ki', id = 600, gained = true, why = 'peeling hairpin obtained'},
            {t = 'ki_have', id = 597, have = true, why = 'dusty tome held'},
            {t = 'ki_have', id = 598, have = true, why = 'pointed jug held'},
            {t = 'ki_have', id = 599, have = true, why = 'cracked club held'},
            {t = 'ki_have', id = 600, have = true, why = 'peeling hairpin held'},
            {t = 'chat', re = 'obtained key item: dusty tome', why = 'chat: key item obtained'},
            {t = 'chat', re = 'obtained key item: pointed jug', why = 'chat: key item obtained'},
            {t = 'chat', re = 'obtained key item: cracked club', why = 'chat: key item obtained'},
            {t = 'chat', re = 'obtained key item: peeling hairpin', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to oldton movalpolos and trade'},
         done = {
            {t = 'ki', id = 601, gained = true, why = 'old nametag obtained'},
            {t = 'ki_have', id = 601, have = true, why = 'old nametag held'},
            {t = 'chat', re = 'obtained key item: old nametag', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'return to port bastok and talk'},
         done = {
            {t = 'ki', id = 601, gained = false, why = 'old nametag handed over (Ravorara 309 option 5)'},
            {t = 'event', zone = 236, event = 311, conf = 'inferred', why = 'Ravorara 311: reminder, only at Prog 4'},
            {t = 'chat', re = 'If we imposify upon the person to whom this name belongs, we can determinate the accuracy of my hypothesis%.', conf = 'inferred', why = 'Ravorara 311 (say #9159)'},
         }},
        {id = 's9', at = {n = 9, fp = 'go to bastok mines and talk'},
         done = {
            {t = 'event', zone = 234, event = 238, why = 'Pavvke 238: only at Prog 4, completes the quest'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

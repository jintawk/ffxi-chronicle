-- Step progress for A Question of Faith (Bastok quest 77). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/A_Question_of_Faith.lua (Ayame 875 always begins the quest when it finishes;
-- Virnage 239 gives the Dawn talisman only on option 1, so it also plays on a refusal and only the key item proves the step;
-- 242 plays only while the talisman is held; Rakorok pops Bugallug with the line "Aaaltaaanaaa... Diiieee!!!" (Oldton
-- Movalpolos IDs.lua 7750, used nowhere else) and event 6 takes the talisman at Prog 1; Virnage 241 needs Prog 1 and
-- completes); client event scripts S4 237_Ayame_010ED02F.txt, 234_Virnage_010EA06A.txt, 011_Rakorok_0100B0E5.txt (event 6);
-- key item 610 from res/key_items.lua.
return {
    title = 'A Question of Faith',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to ayame for a cut'},
         done = {
            {t = 'event', zone = 237, event = 875, why = 'Ayame 875: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'go to bastok mines and talk'},
         done = {
            {t = 'ki', id = 610, gained = true, why = 'Dawn talisman obtained'},
            {t = 'ki_have', id = 610, have = true, why = 'Dawn talisman held'},
            {t = 'chat', re = 'obtained key item: dawn talisman', why = 'chat: key item obtained'},
            {t = 'event', zone = 234, event = 242, conf = 'inferred', why = 'Virnage 242: only plays while the talisman is held'},
            {t = 'chat', re = 'Would you be willing to discover the truth behind this theological enigma%?', conf = 'inferred', why = 'Virnage 242 (say #12145)'},
         },
         reach = {{t = 'event', zone = 234, event = 239, why = 'Virnage 239 offered (its finish needs option 1)'}}},
        {id = 's3', at = {n = 3, fp = 'go to oldton movalpolos and talk'},
         done = {
            {t = 'chat', re = 'Aaaltaaanaaa%.%.%. Diiieee!!!', why = 'Rakorok pops Bugallug (Oldton Movalpolos text 7750)'},
         }},
        {id = 's4', at = {n = 4, fp = 'after defeating bugallug talk with rakorok'},
         done = {
            {t = 'event', zone = 11, event = 6, why = 'Rakorok 6: only at Prog 1 (Bugallug dead) with the talisman'},
            {t = 'ki', id = 610, gained = false, why = 'Dawn talisman taken (event 6 is the only way)'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to bastok mines and talk'},
         done = {
            {t = 'event', zone = 234, event = 241, why = 'Virnage 241: only at Prog 1, completes the quest'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

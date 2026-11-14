-- Step progress for Return to the Depths (Bastok quest 78). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Return_to_the_Depths.lua (Ayame 879 always begins the quest; the zone-in
-- cutscene 40 in Oldton Movalpolos sets Prog 1; Muckvix 99 takes the garlic and gives the Letter from Muckvix, 46 is his
-- reminder at Prog 2; Magriffon 299 (Prog 2) takes the letter and 301 is the 10,000 gil trade that gives Providence pot and
-- Letter from Magriffon; Muckvix 100 swaps them for the Pungent providence pot, 47 is his reminder at Prog 5; zone-in 41 and
-- Tarnotik 42 move Prog 5 to 7, 43 is Tarnotik's reminder, 44 the Ahriman Tears trade; Ayame 881 needs Prog 10 but also plays when the Bowyer Ring cannot be given, so it is only a reach and the completed bit carries the last step;
-- Ravorara 313 plays on any visit with the pot but pays only on option 1, so the pot lost proves the optional sale); client
-- event scripts S4 237_Ayame_010ED02F.txt (880 say #10029), 245_Muckvix_010F5019.txt (46 say #8980, 47 say #8978); key item ids
-- from res/key_items.lua. The draft's zone-in 40 sat on the Ayame step (it belongs to bullet n=2), its zone-in 41 on the
-- completion (it belongs to n=7) and Muckvix 46 on n=6 (it is the reminder after n=4). Tarnotik 42 and the Mine Shaft
-- events are empty in the client scripts, so whether a refused question also plays them is unknown: 42 is only a reach.
-- No strong signal exists for the garlic (n=3), the Shaft Entrance (n=9) or the fight (n=10: event 32001 in Mine Shaft #2716
-- is shared with other battlefields); those and the tip bullets stay plain bullets.
return {
    title = 'Return to the Depths',
    completes = 's11',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to ayame for a cut'},
         done = {
            {t = 'event', zone = 237, event = 879, why = 'Ayame 879: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 237, event = 880, conf = 'inferred', why = 'Ayame 880: reminder at Prog 0, only while accepted'},
            {t = 'chat', re = 'Find the one in Movalpolos who can help us with the Moblin language%.', conf = 'inferred', why = 'Ayame 880 (say #10029)'},
         }},
        {id = 's2', at = {n = 2, fp = 'go to oldton movalpolos for a'},
         done = {
            {t = 'zonein', zone = 11, event = 40, why = 'Oldton Movalpolos zone-in cutscene 40 (Prog 0)'},
         }},
        {id = 's4', at = {n = 4, fp = 'go to lower jeuno and trade'},
         done = {
            {t = 'event', zone = 245, event = 99, why = 'Muckvix 99: the garlic accepted'},
            {t = 'ki', id = 628, gained = true, why = 'letter from Muckvix obtained'},
            {t = 'ki_have', id = 628, have = true, why = 'letter from Muckvix held'},
            {t = 'chat', re = 'obtained key item: letter from muckvix', why = 'chat: key item obtained'},
            {t = 'event', zone = 245, event = 46, conf = 'inferred', why = 'Muckvix 46: reminder, only at Prog 2'},
            {t = 'chat', re = 'Take that letter to the tactician in Kazham%.', conf = 'inferred', why = 'Muckvix 46 (say #8980)'},
         }},
        {id = 's5', at = {n = 5, fp = 'go to kazham and talk with'},
         done = {
            {t = 'event', zone = 250, event = 301, why = 'Magriffon 301: the 10,000 gil trade'},
            {t = 'ki', id = 630, gained = true, why = 'providence pot obtained'},
            {t = 'ki_have', id = 630, have = true, why = 'providence pot held'},
            {t = 'chat', re = 'obtained key item: providence pot', why = 'chat: key item obtained'},
            {t = 'ki', id = 629, gained = true, why = 'letter from Magriffon obtained'},
            {t = 'ki_have', id = 629, have = true, why = 'letter from Magriffon held'},
            {t = 'chat', re = 'obtained key item: letter from magriffon', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 250, event = 299, why = 'Magriffon 299: the first talk, takes the Letter from Muckvix'}}},
        {id = 's6', at = {n = 6, fp = 'return to lower jeuno and talk'},
         done = {
            {t = 'event', zone = 245, event = 100, why = 'Muckvix 100: both key items delivered'},
            {t = 'ki', id = 625, gained = true, why = 'pungent providence pot obtained'},
            {t = 'ki_have', id = 625, have = true, why = 'pungent providence pot held'},
            {t = 'chat', re = 'obtained key item: pungent providence pot', why = 'chat: key item obtained'},
            {t = 'ki', id = 630, gained = false, conf = 'inferred', why = 'providence pot handed over'},
            {t = 'ki', id = 629, gained = false, conf = 'inferred', why = 'letter from Magriffon handed over'},
            {t = 'event', zone = 245, event = 47, conf = 'inferred', why = 'Muckvix 47: reminder, only at Prog 5'},
            {t = 'chat', re = 'That pot is jammed with stuff that smells of Goblins%.', conf = 'inferred', why = 'Muckvix 47 (say #8978)'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to oldton movalpolos for a'},
         done = {
            {t = 'event', zone = 11, event = 43, conf = 'inferred', why = 'Tarnotik 43: reminder, only at Prog 7 or later'},
         },
         reach = {
            {t = 'zonein', zone = 11, event = 41, why = 'Oldton Movalpolos zone-in cutscene 41 (Prog 5)'},
            {t = 'event', zone = 11, event = 42, why = 'Tarnotik 42 offered (its questions may be refused)'},
         }},
        {id = 's8', at = {n = 8, fp = 'if you are in a party'},
         done = {
            {t = 'event', zone = 11, event = 44, why = 'Tarnotik 44: the Ahriman Tears accepted'},
         }},
        {id = 's11', at = {n = 11, fp = 'return to metalworks and talk with'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 237, event = 881, why = 'Ayame 881: plays at Prog 10 even if the Bowyer Ring cannot be given'}}},
        {id = 's12', kind = 'optional', at = {n = 12, fp = 'optional followup talk to the tarutaru'},
         done = {
            {t = 'ki', id = 625, gained = false, after = 's11', why = 'pungent providence pot sold to Ravorara (313, option 1)'},
         }},
    },
}

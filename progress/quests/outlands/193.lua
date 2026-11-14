-- Step progress for The Missing Piece (Outlands quest 193). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/The_Missing_Piece.lua (Alfesar 6 begins the quest on finish, no choice; the ???
-- in the Quicksand Caves gives the Ancient tablet fragment (Prog 1); Alfesar 8 takes it and gives the Tablet of ancient magic and
-- the Letter from Alfesar (Prog 2), 9 is his reminder after that; Charlaimagnat 703 takes both and starts a one-minute wait
-- (Prog 3), 704 is the wait line, 705 completes); client event scripts S4 247_Alfesar_010F700A.txt (6 say #9993, 7 say #10002,
-- 8 say #10004, 9 say #10006) and 231_Charlaimagnat_010E70C7.txt (703 say #12791, 705 say #12795; #12794 plays on 703 and 704,
-- so it is not used). The draft put the fragment on the Alfesar bullet; it proves the Quicksand Caves bullet (the ???), which
-- is a step of its own. The "Ah, you must be the adventurer" lines carry the player's name, so the patterns use the sentences after it.
return {
    title = 'The Missing Piece',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to alfesar who asks you'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Alfesar 6)'},
            {t = 'event', zone = 247, event = 6, why = 'Alfesar 6: begins the quest'},
            {t = 'chat', re = "I am Alfesar, a friar from the San d'Oria Cathedral%.", why = 'Alfesar 6 (say #9993)'},
            {t = 'event', zone = 247, event = 7, conf = 'inferred', why = 'Alfesar 7: his reminder, only while accepted and the fragment not found'},
            {t = 'chat', re = 'The tablet I have was found in the Quicksand Caves', conf = 'inferred', why = 'Alfesar 7 (say #10002)'},
         }},
        {id = 's2', at = {n = 2, fp = 'the ancient tablet fragment is found'},
         done = {
            {t = 'ki', id = 274, gained = true, why = 'Ancient tablet fragment obtained'},
            {t = 'ki_have', id = 274, have = true, why = 'Ancient tablet fragment held'},
            {t = 'chat', re = 'obtained key item: ancient tablet fragment', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to alfesar who gives you'},
         done = {
            {t = 'event', zone = 247, event = 8, why = 'Alfesar 8: the fragment taken, tablet and letter given'},
            {t = 'chat', re = 'Please take the completed', why = 'Alfesar 8 (say #10004)'},
            {t = 'ki', id = 277, gained = true, why = 'Tablet of ancient magic obtained'},
            {t = 'ki', id = 278, gained = true, why = 'Letter from Alfesar obtained'},
            {t = 'chat', re = 'obtained key item: tablet of ancient magic', why = 'chat: key item obtained'},
            {t = 'chat', re = 'obtained key item: letter from alfesar', why = 'chat: key item obtained'},
            {t = 'event', zone = 247, event = 9, conf = 'inferred', why = 'Alfesar 9: his reminder, only after the tablet is given'},
            {t = 'chat', re = 'Please hand this letter of introduction and the', conf = 'inferred', why = 'Alfesar 9 (say #10006)'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to charlaimagnat northern san d'},
         done = {
            {t = 'event', zone = 231, event = 703, why = 'Charlaimagnat 703: the tablet and letter taken'},
            {t = 'chat', re = 'I have recently received correspondence from Alfesar%.', why = 'Charlaimagnat 703 (say #12791)'},
            {t = 'ki', id = 277, gained = false, conf = 'inferred', why = 'Tablet of ancient magic handed over'},
            {t = 'ki', id = 278, gained = false, conf = 'inferred', why = 'Letter from Alfesar handed over'},
            {t = 'event', zone = 231, event = 704, conf = 'inferred', why = 'Charlaimagnat 704: the wait line, only after 703'},
         }},
        {id = 's5', at = {n = 5, fp = 'zone and return to charlaimagnat after'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 231, event = 705, why = 'Charlaimagnat 705: runs quest:complete'},
            {t = 'chat', re = 'I have finished deciphering the spell%.', why = 'Charlaimagnat 705 (say #12795)'},
         }},
    },
}

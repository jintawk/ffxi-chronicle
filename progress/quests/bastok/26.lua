-- Step progress for Cid's Secret (Bastok quest 26). Data only; see progress/quests/sandoria/27.lua for the format.
-- The completing event and its line are a reach, not proof: with an item reward LandSandBoat plays them on a full-bag refusal too, so the quest log's completed bit carries the last step.
-- Evidence: LandSandBoat scripts/quests/bastok/Cids_Secret.lua (Cid 507 begins the quest; Hilda 132 is her plain talk once
-- accepted and sets Prog 1; Hilda 133 is the Rolanberry trade, only played with the right trade at Prog 1; Cid 508 is the
-- reminder at Prog 1 without the letter, 509 plays with the Unfinished letter and completes); client event scripts S4
-- 237_Cid_010ED02B.txt (507 say #7917, 508 say #7922, 509 say #7925) and 236_Hilda_010EC040.txt (132 say #7571, 133 say
-- #7575); key item 114 from res/key_items.lua. Cid 502 is not used: it is shared with two other quests. Disagreements with
-- the draft: Hilda 132 is her plain talk (bullet 3), not the trade, so it no longer proves bullet 5; Cid 508 is the reminder
-- (it proves bullet 3 was reached), not the completion.
return {
    title = "Cid's Secret",
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to cid to begin the'},
         done = {
            {t = 'event', zone = 237, event = 507, why = 'Cid 507'},
            {t = 'chat', re = "I've heard good things about you%.", why = 'Cid 507 (say #7917)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to port bastok home point'}},
        {id = 's3', at = {n = 3, fp = 'locate hilda at e 6 and'},
         done = {
            {t = 'event', zone = 236, event = 132, why = 'Hilda 132: her plain talk once accepted, sets Prog 1'},
            {t = 'chat', re = "Yes%? If there's anything you can do to help%?", why = 'Hilda 132 (say #7571)'},
            {t = 'event', zone = 237, event = 508, conf = 'inferred', why = 'Cid 508: reminder, only once Hilda 132 has set Prog 1'},
            {t = 'chat', re = "And to lure it out, you'll need to use", conf = 'inferred', why = 'Cid 508 (say #7922)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'obtain a rolanberry 874 in one'}},
        {id = 's5', at = {n = 5, fp = 'trade the rolanberry 874 to hilda'},
         done = {
            {t = 'event', zone = 236, event = 133, why = 'Hilda 133: the Rolanberry accepted'},
            {t = 'chat', re = "Isn't this%.%.%.%? Yes, it is", why = 'Hilda 133 (say #7575)'},
            {t = 'ki', id = 114, gained = true, why = 'unfinished letter obtained'},
            {t = 'ki_have', id = 114, have = true, why = 'unfinished letter held'},
            {t = 'chat', re = 'obtained key item: unfinished letter', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to cid and speak with'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 114, gained = false, conf = 'inferred', why = 'unfinished letter handed over'},
         },
         reach = {
            {t = 'event', zone = 237, event = 509, why = 'Cid 509: the letter, completes'},
            {t = 'chat', re = 'I%-I see%. Ms%. Hilda said that, huh%?', why = 'Cid 509 (say #7925)'},
         }},
    },
}

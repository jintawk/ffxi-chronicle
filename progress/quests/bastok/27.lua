-- Step progress for The Usual (Bastok quest 27). Data only; see progress/quests/sandoria/27.lua for the format.
-- The completing event and its line are a reach, not proof: with an item reward LandSandBoat plays them on a full-bag refusal too, so the quest log's completed bit carries the last step.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Usual.lua (Hilda 134 is the offer and begins the quest only on option 0,
-- so it is a reach, not proof; Hilda 135 is the King Truffle trade, played only for a matching trade without the invitation;
-- Raibaht 510 is a plain cutscene with no menu (client script) that sets Prog 1; Hilda 136 plays only at Prog 1 and
-- completes); client event scripts S4 236_Hilda_010EC040.txt (135 say #7587, 136 say #7591) and 237_Raibaht_010ED02C.txt
-- (510 say #7929); key item 127 from res/key_items.lua. Disagreement with the draft: Raibaht 510 is proof of bullet 3
-- (the draft left it a reach and the step unmapped), because the event has no choice to refuse.
return {
    title = 'The Usual',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to hilda to begin the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         },
         reach = {{t = 'event', zone = 236, event = 134, why = 'Hilda 134 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'trade a king truffle to hilda'},
         done = {
            {t = 'event', zone = 236, event = 135, why = 'Hilda 135: the King Truffle accepted'},
            {t = 'chat', re = 'Oh, my! Wherever did you find this%?', why = 'Hilda 135 (say #7587)'},
            {t = 'ki', id = 127, gained = true, why = 'Steaming Sheep invitation obtained'},
            {t = 'ki_have', id = 127, have = true, why = 'Steaming Sheep invitation held'},
            {t = 'chat', re = 'obtained key item: steaming sheep invitation', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'travel to the metalworks and speak'},
         done = {
            {t = 'event', zone = 237, event = 510, why = 'Raibaht 510: the invitation delivered (no menu in the event)'},
            {t = 'chat', re = 'An invitation from the Steaming Sheep%?', why = 'Raibaht 510 (say #7929)'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to the steaming sheep restaurant'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 127, gained = false, conf = 'inferred', why = 'Steaming Sheep invitation handed over'},
         },
         reach = {
            {t = 'event', zone = 236, event = 136, why = 'Hilda 136: plays only once Raibaht has the invitation'},
            {t = 'chat', re = 'Did you give my letter to my customer%?', why = 'Hilda 136 (say #7591)'},
         }},
    },
}

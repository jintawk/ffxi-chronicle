-- Step progress for A Taste for Meat (San d'Oria quest 100). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/A_Taste_for_Meat.lua (the quest is never flagged: trading 5 Slices of Hare Meat
-- to Thierride is event 528, which begins and completes it in one step, while a wrong trade is the separate refusal event 529;
-- Antreneau 527 at Prog 0 sets Prog 1; Thierride 526 plays only at Prog 1); client event scripts S4 232_Antreneau_010E800D.txt
-- (527 say #7438) and 232_Thierride_010E800A.txt (526 say #7447, 528 say #7452). Item 4358 from res/items.lua. Bullet 3 (the
-- Grilled Hare from Antreneau, event 530) is left unmapped: 530 plays whether or not the reward fits (the item is given after
-- the event, with a separate event 538 on a full bag), and the item itself can come from elsewhere, so no strong signal proves
-- it. The quest log shows nothing until the trade, so s1 is unknown, not "to do", before s2 (the pilot's hand mapping).
return {
    title = 'A Taste for Meat',
    completes = 's2',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to antreneau then thierride'},
         done = {
            {t = 'event', zone = 232, event = 527, why = 'Antreneau 527: only at Prog 0, sets Prog 1'},
            {t = 'chat', re = "Egads, I'm hungry!", why = 'Antreneau 527 (say #7438)'},
            {t = 'event', zone = 232, event = 526, conf = 'inferred', why = 'Thierride 526: plays only at Prog 1'},
            {t = 'chat', re = 'If only I had five', conf = 'inferred', why = 'Thierride 526 (say #7447)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade 5 hare meat to thierride'}, count = {item = 4358, need = 5},
         done = {
            {t = 'event', zone = 232, event = 528, why = 'Thierride 528: the five slices accepted, quest begun and completed (a wrong trade is 529)'},
            {t = 'chat', re = 'Altana bless you!', why = 'Thierride 528 (say #7452)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

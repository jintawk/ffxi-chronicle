-- Step progress for Brygid the Stylist Returns (Bastok quest 74). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Brygid_the_Stylist_Returns.lua (Brygid 380 always begins the quest when its event
-- finishes; 382 plays only when the requested body and legs pieces are worn and is the menu of 13 bodies; 385 reminds about the
-- Subligar once a body was chosen; 383 is the Subligar trade but plays before the reward is handed over, so a full bag refuses
-- it and it proves nothing; the reward bodies (items 14401-14413, option 1-13) and the completed bit prove the last step);
-- client event script S4 235_Brygid_010EB025.txt. The quest is repeatable and a repeat is begun by 380 again (LandSandBoat
-- deletes the old log entry first), so the log marks the first run only and the next 380 after a finished run opens the next.
-- The request bullet (n=2) is a note on the return step; the draft's robe-only line of 380 is not shown to every player.
return {
    title = 'Brygid the Stylist Returns',
    completes = 's4',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to brygid on any job'},
         done = {
            {t = 'event', zone = 235, event = 380, why = 'Brygid 380: begins the quest'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'she will request one body and'}},
        {id = 's3', at = {n = 3, fp = 'when you return to her wearing'},
         done = {
            {t = 'event', zone = 235, event = 382, why = 'Brygid 382: both requested pieces worn, the 13 bodies offered'},
            {t = 'event', zone = 235, event = 385, conf = 'inferred', why = 'Brygid 385: Subligar reminder, only after a body was chosen'},
         }},
        {id = 's4', at = {n = 4, fp = 'when you select the body armor'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'item', id = 14401, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 1)'},
            {t = 'item', id = 14402, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 2)'},
            {t = 'item', id = 14403, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 3)'},
            {t = 'item', id = 14404, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 4)'},
            {t = 'item', id = 14405, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 5)'},
            {t = 'item', id = 14406, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 6)'},
            {t = 'item', id = 14407, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 7)'},
            {t = 'item', id = 14408, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 8)'},
            {t = 'item', id = 14409, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 9)'},
            {t = 'item', id = 14410, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 10)'},
            {t = 'item', id = 14411, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 11)'},
            {t = 'item', id = 14412, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 12)'},
            {t = 'item', id = 14413, gained = true, conf = 'inferred', why = 'Brygid reward body gained (option 13)'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'you can repeat this quest as'}},
    },
}

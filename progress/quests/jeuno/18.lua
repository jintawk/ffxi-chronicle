-- Step progress for The Lost Cardian (Jeuno quest 18). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Lower_Jeuno/npcs/Teigero-Bangero.lua (29 is the first talk, plays only at
-- theLostCardianVar 0 and sets it to 1), Panta-Putta.lua (30 plays only at var >= 1 while the quest is available and sets it
-- to 2, so it proves Teigero-Bangero was spoken to first) and Naruru.lua (31, a plain talk that gates nothing), and
-- scripts/zones/Upper_Jeuno/npcs/Monberaux.lua (33 is the long cutscene at var 2, 34 the short one at var 3; only option 0
-- completes the quest, option 1 sets var 3: bullet 3 is the cutscene itself, so 33 and 34 prove it, and the log's completed bit
-- proves bullet 4 alone). The quest is never accepted, so the log is silent until it completes: the group is silent until bullet 4.
-- Bozz (Upper Jeuno G-9) has no quest script (zones/Upper_Jeuno/DefaultActions.lua: a plain event 35), so bullet 2 is a note on
-- Monberaux. Bullet 1 names three NPCs but only Teigero-Bangero and Panta-Putta gate the quest in LandSandBoat. Client event
-- scripts S4 245_Panta_Putta_010F5016.txt (30 say #7347), 245_Teigero_Bangero_010F5014.txt (29 say #7342), 245_Naruru_010F5015.txt
-- (31 say #7345) and 244_Monberaux_010F4001.txt (33 and 34 are bare cutscenes); the reward key item (Two of Swords, 58) is from
-- res/key_items.lua. Not repeatable.
return {
    title = 'The Lost Cardian',
    completes = 's4',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's4'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to naruru teigero bangero and'},
         done = {
            {t = 'event', zone = 245, event = 30, why = 'Panta-Putta 30: plays only after Teigero-Bangero (var >= 1)'},
            {t = 'chat', re = "What was I thinking, fighting that guy%? I should've listened to Two%.", why = 'Panta-Putta 30 (say #7347)'},
         },
         reach = {
            {t = 'event', zone = 245, event = 29, why = 'Teigero-Bangero 29: the first talk'},
            {t = 'event', zone = 245, event = 31, why = 'Naruru 31: a plain talk'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak to bozz upper jeuno g'}},
        {id = 's3', at = {n = 3, fp = 'speak to monberaux upper jeuno g'},
         done = {
            {t = 'event', zone = 244, event = 33, why = 'Monberaux 33: the long cutscene the bullet asks for (its finish needs option 0 to complete)'},
            {t = 'event', zone = 244, event = 34, why = 'Monberaux 34: the short cutscene (its finish needs option 0 to complete)'},
         }},
        {id = 's4', at = {n = 4, fp = 'after the cutscene the quest will'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 58, gained = true, conf = 'inferred', why = 'Two of Swords obtained (reward)'},
         }},
    },
}

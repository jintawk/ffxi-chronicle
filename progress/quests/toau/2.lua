-- Step progress for Olduum (Aht Urhgan quest 2). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Olduum.lua (Dkhaaya 4 begins the quest and gives Dkhaaya's research journal,
-- key item 767, with no refusal; while accepted without a cell his talk is 5; mining at the Excavation Site in Aydeewa
-- Subterrane gives one of the key items 768 electrocell, 769 electropot, 770 electrolocomotive on a 50% roll, but its event 0
-- also plays on the failed roll, so the key items prove the bullet and the event is not used; holding one, Dkhaaya's talk is 6,
-- which runs quest:complete and deletes the cell, but quest:complete is also what hands over the Lightning Band, so 6 may
-- replay on a full bag and is only a reach: the completed bit and the cell's loss prove the return bullet; once completed
-- Dkhaaya 7 is his plain talk (option 99 asks for a reissue) and is not used; on a repeat the cell is mined again (restart at
-- the mining bullet; the journal is not given twice) and Dkhaaya 8 takes it and gives the Band. Trading the Lightning Band to the
-- Wajaom Woodlands Leypoint plays 2, which only plays with a free slot, and gives the Olduum Ring. Client event scripts S4
-- 050_Dkhaaya_01032114.txt (5 say #4924) and 051_Leypoint_01033232.txt (2 has no text); key item ids from res/key_items.lua.
-- The cell is mined in the room at H-9; the pickaxe bullet is a note on it.
return {
    title = 'Olduum',
    completes = 's5',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s4'}, skip = {'s2'}},
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'make sure you do not leave'}},
        {id = 's2', at = {n = 2, fp = 'speak to dkhaaya for a cutscene'},
         done = {
            {t = 'ki', id = 767, gained = true, why = "Dkhaaya's research journal obtained"},
            {t = 'ki_have', id = 767, have = true, why = "Dkhaaya's research journal held"},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 4, why = 'Dkhaaya 4: the offer, begins the quest with no refusal'},
            {t = 'chat', re = "obtained key item: dkhaaya's research journal", why = 'chat: key item obtained'},
            {t = 'event', zone = 50, event = 5, conf = 'inferred', why = 'Dkhaaya 5: his talk while accepted and holding no cell'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'enter aydeewa subterrane through the cave'}},
        {id = 's4', at = {n = 4, fp = 'head to the room at h'},
         done = {
            {t = 'ki', id = 768, gained = true, why = 'electrocell obtained'},
            {t = 'ki_have', id = 768, have = true, why = 'electrocell held'},
            {t = 'chat', re = 'obtained key item: electrocell', why = 'chat: key item obtained'},
            {t = 'ki', id = 769, gained = true, why = 'electropot obtained'},
            {t = 'ki_have', id = 769, have = true, why = 'electropot held'},
            {t = 'chat', re = 'obtained key item: electropot', why = 'chat: key item obtained'},
            {t = 'ki', id = 770, gained = true, why = 'electrolocomotive obtained'},
            {t = 'ki_have', id = 770, have = true, why = 'electrolocomotive held'},
            {t = 'chat', re = 'obtained key item: electrolocomotive', why = 'chat: key item obtained'},
            {t = 'event', zone = 50, event = 6, conf = 'inferred', why = 'Dkhaaya 6: plays only while holding a cell'},
            {t = 'event', zone = 50, event = 8, conf = 'inferred', why = 'Dkhaaya 8 (a repeat): plays only while holding a cell'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to dkhaaya who will reward'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 768, gained = false, why = 'electrocell handed over'},
            {t = 'ki', id = 769, gained = false, why = 'electropot handed over'},
            {t = 'ki', id = 770, gained = false, why = 'electrolocomotive handed over'},
         },
         reach = {
            {t = 'event', zone = 50, event = 6, why = 'Dkhaaya 6 (replays if the Band cannot be given)'},
            {t = 'event', zone = 50, event = 8, why = 'Dkhaaya 8 (a repeat; gives the Band only with a free slot)'},
         }},
        {id = 's6', kind = 'post', at = {n = 6, fp = 'at this point the quest is'},
         done = {
            {t = 'event', zone = 51, event = 2, after = 's5', why = 'Leypoint 2: the Lightning Band traded, only with a free slot'},
         }},
    },
}

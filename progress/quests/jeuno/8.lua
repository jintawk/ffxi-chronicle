-- Step progress for The Kind Cardian (Jeuno quest 8). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Apururu.lua (while the quest is accepted she plays 392, the
-- cutscene, and only option 1 moves on, so it is a reach; then 393 asks for the Ten of Cups; trading the card plays 397,
-- which deletes the Two of Swords and cannot be refused; then 398), zones/Lower_Jeuno/npcs/Panta-Putta.lua (35 is the finish,
-- but the reward is a Green Cape that needs a free slot, so 35 is only a reach and the log's completed bit proves the last
-- step; 76 is his talk once completed), zones/Upper_Jeuno/npcs/Monberaux.lua (32 plays only while the quest is accepted and
-- The Lost Cardian is done). The quest is begun by The Lost Cardian's last event, which also hands out the Two of Swords, so
-- the log already shows it before the first bullet. Client event scripts S4 241_Apururu_010F1014.txt (393 say #8470, 398 say
-- #8481), 244_Monberaux_010F4001.txt (32 say #7083) and 245_Panta_Putta_010F5016.txt (76 say #7389). Key item 58 from
-- res/key_items.lua. The first bullet (family dialogue) has no event of its own, the Ten of Cups hunt leaves no trace, and the
-- trip to the ruins is a note on the hand-in. Not repeatable.
return {
    title = 'The Kind Cardian',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'speak to apururu windurst woods h'},
         done = {
            {t = 'event', zone = 241, event = 393, conf = 'inferred', why = 'Apururu 393: plays only after the cutscene 392 finished with option 1'},
            {t = 'chat', re = 'The Ten of Cups is the opposing card to our poor little Cardian', conf = 'inferred', why = 'Apururu 393 (say #8470)'},
         },
         reach = {{t = 'event', zone = 241, event = 392, why = 'Apururu 392 (the cutscene; its finish needs option 1)'}}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'head to west sarutabaruta f 11'}},
        {id = 's5', at = {n = 5, fp = 'give the ten of cups item'},
         done = {
            {t = 'event', zone = 241, event = 397, why = 'Apururu 397: the Ten of Cups accepted, the Two of Swords deleted'},
            {t = 'ki', id = 58, gained = false, after = 's2', conf = 'inferred', why = 'Two of Swords handed over'},
            {t = 'event', zone = 241, event = 398, conf = 'inferred', why = 'Apururu 398: plays only after the card is handed over'},
            {t = 'chat', re = "Tell this child's friends back in Jeuno", conf = 'inferred', why = 'Apururu 398 (say #8481)'},
         }},
        {id = 's6', kind = 'optional', at = {n = 6, fp = 'optional return to monberaux for some'},
         done = {
            {t = 'event', zone = 244, event = 32, why = 'Monberaux 32: only while The Kind Cardian is accepted'},
            {t = 'chat', re = 'All you need to do is take the Cardian to the Manustery in Windurst%.', why = 'Monberaux 32 (say #7083)'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to panta putta lower jeuno'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 245, event = 76, after = 's5', conf = 'inferred', why = 'Panta-Putta 76: plays only once The Kind Cardian is completed'},
            {t = 'chat', re = "I'm sure Two and I will keep on arguing", after = 's5', conf = 'inferred', why = 'Panta-Putta 76 (say #7389)'},
         },
         reach = {{t = 'event', zone = 245, event = 35, after = 's5', why = 'Panta-Putta 35 (also plays when the Green Cape cannot be given)'}}},
    },
}

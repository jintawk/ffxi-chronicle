-- Step progress for A Squire's Test II (San d'Oria quest 19). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/A_Squires_Test_II.lua (Balasiel 625 begins the quest unconditionally; 630
-- is his accepted-state talk without the key item; qm3 in Ordelle's Caves gives the Stalactite dew; 626 needs the dew,
-- completes the quest and takes it); client event script S4 230_Balasiel_010E603F.txt (625 say #7947, 630 say #7953,
-- 626 say #7959); key item 141 from res/key_items.lua. The travel bullet (n=2) has no signal of its own: a note on n=3.
return {
    title = "A Squire's Test II",
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to balasiel to start the'},
         done = {
            {t = 'event', zone = 230, event = 625, why = 'Balasiel 625: begins the quest'},
            {t = 'chat', re = "Ah, you've come quite a way since last we met, I see%.", why = 'Balasiel 625 (say #7947)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 230, event = 630, conf = 'inferred', why = 'Balasiel 630: plays only once accepted'},
            {t = 'chat', re = 'Come to think of it, the time I sent another to the waterfall', conf = 'inferred', why = 'Balasiel 630 (say #7953)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'proceed to ordelle s caves at'}},
        {id = 's3', at = {n = 3, fp = 'examine the in the pool of'},
         done = {
            {t = 'ki', id = 141, gained = true, why = 'stalactite dew obtained'},
            {t = 'ki_have', id = 141, have = true, why = 'stalactite dew held'},
            {t = 'chat', re = 'obtained key item: stalactite dew', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to balasiel to complete the'},
         done = {
            {t = 'event', zone = 230, event = 626, why = 'Balasiel 626: completes the quest'},
            {t = 'chat', re = "Ah, you're back, and in one piece!", why = 'Balasiel 626 (say #7959)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 141, gained = false, conf = 'inferred', why = 'stalactite dew handed over'},
         }},
    },
}

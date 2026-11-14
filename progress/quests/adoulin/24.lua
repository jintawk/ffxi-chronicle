-- Step progress for Legacies Lost and Found (Adoulin quest 24). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no decoded client event (Octavien's and Ohruru's cutscenes are bare in S4), so the
-- signals are key items and the log, read from BG-wiki's walkthrough. Octavien starts the quest and hands over the Letter (2357);
-- each Strange Apparatus hands over one rune stone (2358 to 2365, one per element) and the three off-element ones a Stone of
-- unknown runic origins (2366 to 2368); Ohruru's quiz hands over "Secrets of Runic Enhancement" (2369); the Barrel takes it and,
-- the next day, completes the quest. Ids from res/key_items.lua (all temporary). The draft made the eight stones the proof of
-- bullet 3, but the bullet needs three of eight and one stone proves one: the stones are only progress on it (a branch with reach,
-- shown done once a later step is). It also put the completed bit on bullet 6; the quest completes at the Barrel (bullet 8),
-- whose hand-over of the Secrets is the reach. The Ohruru cutscenes (2 and 5) and the Octavien talk (7) have no signal of their
-- own and are notes. Not repeatable.
return {
    title = 'Legacies Lost and Found',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'eastern adoulin i 8'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Octavien)'},
            {t = 'ki', id = 2357, gained = true, why = 'letter from Octavien obtained'},
            {t = 'ki_have', id = 2357, have = true, why = 'letter from Octavien held'},
            {t = 'chat', re = 'obtained key item: letter from octavien', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'port windurst e 7'}},
        {id = 's3', kind = 'branch', at = {n = 3, fp = 'travel to at least three of'},
         reach = {
            {t = 'ki', id = 2358, gained = true, after = 's1', why = 'stone of Ignis obtained'},
            {t = 'ki', id = 2359, gained = true, after = 's1', why = 'stone of Gelus obtained'},
            {t = 'ki', id = 2360, gained = true, after = 's1', why = 'stone of Flabra obtained'},
            {t = 'ki', id = 2361, gained = true, after = 's1', why = 'stone of Tellus obtained'},
            {t = 'ki', id = 2362, gained = true, after = 's1', why = 'stone of Sulpor obtained'},
            {t = 'ki', id = 2363, gained = true, after = 's1', why = 'stone of Unda obtained'},
            {t = 'ki', id = 2364, gained = true, after = 's1', why = 'stone of Lux obtained'},
            {t = 'ki', id = 2365, gained = true, after = 's1', why = 'stone of Tenebrae obtained'},
         }},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'optional the remaining strange apparatuses are'},
         done = {
            {t = 'ki', id = 2366, gained = true, after = 's1', why = 'stone of unknown runic origins obtained'},
            {t = 'ki', id = 2367, gained = true, after = 's1', why = 'stone of unknown runic origins obtained'},
            {t = 'ki', id = 2368, gained = true, after = 's1', why = 'stone of unknown runic origins obtained'},
            {t = 'chat', re = 'obtained key item: stone of unknown runic origins', why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'port windurst e 7'}},
        {id = 's6', at = {n = 6, fp = 'after this cutscene the player receives'},
         done = {
            {t = 'ki', id = 2369, gained = true, why = '"Secrets of Runic Enhancement" obtained'},
            {t = 'ki_have', id = 2369, have = true, why = '"Secrets of Runic Enhancement" held'},
            {t = 'chat', re = 'obtained key item: .?secrets of runic enhancement', why = 'chat: key item obtained'},
         }},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'eastern adoulin i 8'}},
        {id = 's8', at = {n = 8, fp = 'western adoulin i 4'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'ki', id = 2369, gained = false, after = 's6', why = 'Secrets of Runic Enhancement handed over at the Barrel'},
         }},
    },
}

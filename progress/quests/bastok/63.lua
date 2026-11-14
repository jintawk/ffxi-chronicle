-- Step progress for Lovers in the Dusk (Bastok quest 63). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Lovers_in_the_Dusk.lua (Carmelo 275 gives the "Chanson de Liberte" 342 and begins
-- the quest at its finish; 276 is his accepted-state talk; the Sanctuary of Zi'Tah ??? plays 204 only at dusk, completes the
-- quest and takes the key item); client event script S4 236_Carmelo_010EC00C.txt (275 is bare, 276 say #8804); key item from
-- res/key_items.lua. The Zi'Tah zone has no decoded client script: event 204 is LandSandBoat's. Not repeatable.
return {
    title = 'Lovers in the Dusk',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'zone after completing a test of'}},
        {id = 's2', at = {n = 2, fp = 'speak with carmelo to begin quest'},
         done = {
            {t = 'event', zone = 236, event = 275, why = 'Carmelo 275: the quest offered, begun and the key item given at its finish'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 342, gained = true, why = '"Chanson de Liberte" obtained'},
            {t = 'ki_have', id = 342, have = true, why = '"Chanson de Liberte" held'},
            {t = 'chat', re = 'obtained key item: "chanson de liberte"', why = 'chat: key item obtained'},
            {t = 'event', zone = 236, event = 276, conf = 'inferred', why = 'Carmelo 276: accepted-state talk, only after 275'},
            {t = 'chat', re = 'The road before you is long, but I know you will succeed in your task%.', conf = 'inferred', why = 'Carmelo 276 (say #8804)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'travel to h 8 of the'}},
        {id = 's4', at = {n = 4, fp = 'touch the between 16 00 18'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 342, gained = false, conf = 'inferred', why = '"Chanson de Liberte" handed over'},
         },
         reach = {{t = 'event', zone = 121, event = 204, why = 'Zi\'Tah ??? 204: plays only at dusk (a full bag plays it too, no completion)'}}},
    },
}

-- Step progress for Undying Flames (San d'Oria quest 26). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Northern_San_dOria/npcs/Pagisalis.lua (562 offers the quest and addQuest needs
-- option 0; 565 plays only while it is accepted; 563 is a trade of 2 Beeswax, but with no free slot it plays and the
-- quest is NOT completed, so 563 is only `reach`; the completion is the quest log, with Friar's Rope as a reward item);
-- client event script S4 231_Pagisalis_010E7020.txt (562 say #11353 is the option 0 branch only).
return {
    title = 'Undying Flames',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to pagisalis located in the'},
         done = {
            {t = 'chat', re = 'Altana smiles on the generous%.', why = 'Pagisalis 562 (say #11353, option 0 branch)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 231, event = 565, conf = 'inferred', why = 'Pagisalis 565: plays only once accepted'},
         },
         reach = {{t = 'event', zone = 231, event = 562, why = 'Pagisalis 562 offered (accepting needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'trade him 2 beeswax to complete'}, count = {item = 913, need = 2},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 13211, gained = true, conf = 'inferred', why = "Friar's Rope gained (reward)"},
         },
         reach = {{t = 'event', zone = 231, event = 563, why = 'Pagisalis 563: a trade made (a full bag plays it too, no completion)'}}},
    },
}

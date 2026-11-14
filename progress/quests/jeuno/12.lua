-- Step progress for A Minstrel in Despair (Jeuno quest 12). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/A_Minstrel_In_Despair.lua (the quest is never begun, only completed: trading
-- the Poetic Parchment to Mertaire plays 101, which runs quest:complete with gil only, so there is no refusal). The Song Runes
-- event 2 here is only a failsafe that gives the parchment again and also belongs to The Old Monument, so it is not used.
-- Mertaire 101 has no text in the client script (S4 245_Mertaire_010F501C.txt lists it). Not repeatable.
return {
    title = 'A Minstrel in Despair',
    completes = 's1',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to mertaire and trade the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 245, event = 101, why = 'Mertaire 101: the Poetic Parchment accepted, runs quest:complete'},
         }},
    },
}

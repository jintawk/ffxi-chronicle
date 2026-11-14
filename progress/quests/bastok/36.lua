-- Step progress for The Wisdom of Elders (Bastok quest 36). Data only; see progress/quests/sandoria/27.lua for the format.
-- The completing event and its line are a reach, not proof: with an item reward LandSandBoat plays them on a full-bag refusal too, so the quest log's completed bit carries the last step.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Wisdom_of_Elders.lua (Benita 174 is a plain progress event that begins the
-- quest with no option test; Tete 175 is a one-time event that exists only while accepted and sets Prog 1; Benita 176 plays
-- only for a trade of exactly one Pinch of Bomb Ash and runs quest:complete); client event scripts S4 236_Benita_010EC03A.txt
-- (174 say #7641, 176 say #7646) and 236_Tete_010EC02E.txt (175 say #7645). Disagreement with the draft: none of substance.
return {
    title = 'The Wisdom of Elders',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with benita to begin quest'},
         done = {
            {t = 'event', zone = 236, event = 174, why = 'Benita 174: begins the quest'},
            {t = 'chat', re = 'Take my word for it, housework is not easy%.', why = 'Benita 174 (say #7641)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to tete at i 5'},
         done = {
            {t = 'event', zone = 236, event = 175, why = 'Tete 175: exists only while accepted'},
            {t = 'chat', re = 'I keep telling my daughter%-in%-law about it, but young people these days never listen to what their elders tell them%.', why = 'Tete 175 (say #7645)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'obtain a bomb ash from the'}},
        {id = 's4', at = {n = 4, fp = 'trade bomb ash to benita to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 236, event = 176, why = 'Benita 176: the Bomb Ash accepted, completes'},
            {t = 'chat', re = 'Is this it%? This can clear chimneys%?', why = 'Benita 176 (say #7646)'},
         }},
    },
}

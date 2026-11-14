-- Step progress for Fear of Flying (Bastok quest 35). Data only; see progress/quests/sandoria/27.lua for the format.
-- The completing event and its line are a reach, not proof: with an item reward LandSandBoat plays them on a full-bag refusal too, so the quest log's completed bit carries the last step.
-- Evidence: LandSandBoat scripts/quests/bastok/Fear_of_Flying.lua (Kurando 170 is a plain progress event that begins the quest
-- with no option test; Kurando 171 plays only for a trade of exactly one Silkworm Egg and runs quest:complete; 172 and 173
-- only exist once completed); client event script S4 236_Kurando_010EC021.txt (170 say #7633, 171 say #7636). The Rolanberry
-- bullets (2 to 4) have no event, key item or line of their own (the egg is an NM drop), so they are notes on the hand-in.
-- Kurando 172 is the post-completion chatter and is not used. Disagreement with the draft: none of substance.
return {
    title = 'Fear of Flying',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kurando to begin quest'},
         done = {
            {t = 'event', zone = 236, event = 170, why = 'Kurando 170: begins the quest'},
            {t = 'chat', re = 'Do I like airships%? Are you crazy!%?', why = 'Kurando 170 (say #7633)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'travel to rolanberry fields and proceed'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'look for the nm silk caterpillar'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'upon defeating the nm you will'}},
        {id = 's5', at = {n = 5, fp = 'return to kurando and trade him'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 236, event = 171, why = 'Kurando 171: the Silkworm Egg accepted, completes'},
            {t = 'chat', re = "You got it! Magnificent! But wasn't the beast horrible, as I said it would be%?", why = 'Kurando 171 (say #7636)'},
         }},
    },
}

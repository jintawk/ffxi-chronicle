-- Step progress for The Return of the Adventurer (Bastok quest 30). Data only; see progress/quests/sandoria/27.lua for the format.
-- The completing event and its line are a reach, not proof: with an item reward LandSandBoat plays them on a full-bag refusal too, so the quest log's completed bit carries the last step.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Return_of_the_Adventurer.lua (Gwill 242 is a plain progress event that
-- begins the quest with no option test; Gwill 243 plays only for a trade of exactly one Stick of Cinnamon and completes);
-- client event script S4 235_Gwill_010EB005.txt (242 say #7627; 243 has no dialogue). Disagreement with the draft: it proved
-- the cinnamon bullet by the Kazham airship pass key item, which is only one of two ways to reach the vendor and says nothing
-- about owning the cinnamon, so the bullet is a note on the trade it feeds.
return {
    title = 'The Return of the Adventurer',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'obtain a cinnamon from the auction'}},
        {id = 's2', at = {n = 2, fp = 'speak with gwill to begin quest'},
         done = {
            {t = 'event', zone = 235, event = 242, why = 'Gwill 242: begins the quest'},
            {t = 'chat', re = "Hi! You're the adventurer who helped Michea make her present, aren't you%?", why = 'Gwill 242 (say #7627)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'when cutscene ends trade him the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 235, event = 243, why = 'Gwill 243: the Stick of Cinnamon accepted, completes'},
         }},
    },
}

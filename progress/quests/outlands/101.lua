-- Step progress for VW Op. 054: Elshimo List (Outlands quest 101). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script (the quest id exists in globals/quests.lua only) and no client script for Hildegard in Kazham,
-- so no event, line or key item of its own is known. The page's Ashen stratum abyssite is given by Voidwatch Ops: Border
-- Crossing (page outlands 100) and is only held here, so it proves nothing (the draft's gain of KI 1447 was wrong). The only
-- signals are the quest log's current bit, set when Hildegard starts the quest (bullet 1), and its completed bit (bullet 3,
-- the hand-in); this is a weaker mapping than the others, resting on the log alone. The three Tier I Voidwatch battles
-- (bullet 2) leave no known trace, so they are a note on the hand-in. Not repeatable.
return {
    title = 'VW Op. 054: Elshimo List',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after starting voidwatch ops border crossing'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Hildegard)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'engage in and complete the 3'}},
        {id = 's3', at = {n = 3, fp = 'return to hildegard to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

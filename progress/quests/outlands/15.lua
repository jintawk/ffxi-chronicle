-- Step progress for Trial-Size Trial by Fire (Outlands quest 15). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Kazham/npcs/Dodmos.lua and scripts/battlefields/Cloister_of_Flames/trial-size_trial_by_fire.lua.
-- Dodmos 286 is the offer, a menu ("Are you really sure?"): only the first choice runs addQuest and gives the Mini Tuning Fork of
-- Fire (item 1544), and only with a free slot, so the log's current bit proves the accept and the offer only reaches it; 290 is his
-- talk when the fork was lost (inferred: it plays whenever accepted without the fork). 287 is the fork trade, a menu: only the first
-- choice ("Off to ...!") warps to the Cloister of Flames, and its line "Sir, our adventurer has completed ... preparations and
-- requests a warp" is on that branch alone. The trade is optional (the player can walk, and the NPC stops warping after the first
-- win), so bullet 2 is optional and never inferred. Entering the arena (bullet 3) has no verified trace, so it is a note.
-- The win runs completeQuest (a battlefield result, no event of its own): the log's completed bit proves s4, and Dodmos 289 is
-- his talk after completion. Dodmos 272 is also played during Trial by Fire (page outlands 12), so it is not used here. Client
-- event script S4 250_Dodmos_010FA06B.txt (286 say #10587, 287 say #10592, 289 say #10598, 290 say #10604). The quest log is set
-- at s1, so it is not silent. Not repeatable.
return {
    title = 'Trial-Size Trial by Fire',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with dodmos in kazham j'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Dodmos 286, first choice, fork given)'},
            {t = 'event', zone = 250, event = 290, conf = 'inferred', why = 'Dodmos 290: only while accepted without the fork'},
            {t = 'chat', re = 'Remember that you must fight the prime avatar as a level', conf = 'inferred', why = 'Dodmos 290 (say #10604)'},
         },
         reach = {
            {t = 'event', zone = 250, event = 286, why = 'Dodmos 286 offered (its finish needs the first choice)'},
            {t = 'chat', re = 'The researcher who made the', why = 'Dodmos 286 (say #10587, first choice; the fork needs a free slot)'},
         }},
        {id = 's2', kind = 'optional', at = {n = 2, fp = 'you may prepare for the upcoming'},
         done = {
            {t = 'chat', re = 'preparations and requests a warp%.', after = 's1', why = 'Dodmos 287 (say #10592, warp choice only)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'trade the fork to the fire'}},
        {id = 's4', at = {n = 4, fp = 'defeat ifrit prime to complete quest'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the win runs completeQuest)'},
            {t = 'event', zone = 250, event = 289, after = 's1', conf = 'inferred', why = 'Dodmos 289: his talk once the quest is completed'},
            {t = 'chat', re = 'You defeated the prime avatar!%?', after = 's1', conf = 'inferred', why = 'Dodmos 289 (say #10598)'},
         }},
    },
}

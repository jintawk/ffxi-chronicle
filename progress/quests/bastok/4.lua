-- Step progress for The Quadav's Curse (Bastok quest 4). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Quadavs_Curse.lua (Corann 80 has no option and its finish begins the quest;
-- Corann 81 plays only on a Quadav Backplate trade and runs quest:complete); client event script S4 236_Corann_010EC031.txt
-- (80 say #7495, 81 say #7496). The backplate bullet is a note on the trade it feeds.
-- Completion: the final event also plays when the item reward cannot be given (npcUtil.completeQuest fails in onEventFinish after the
-- cutscene), so it is a reach only and the quest log's completed bit carries the last step.
return {
    title = "The Quadav's Curse",
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to corann to start the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 236, event = 80, why = 'Corann 80: begins the quest'},
            {t = 'chat', re = 'I need something big enough to hide my whole body!', why = 'Corann 80 (say #7495)'},
         }},
        {id = 'n2', kind = 'note', with = 's3', at = {n = 2, fp = 'obtain a quadav backplate either from'}},
        {id = 's3', at = {n = 3, fp = 'turn in backplate to corann to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 236, event = 81, why = 'Corann 81: plays even when the reward item does not fit'},
            {t = 'chat', re = 'Finally, I can sleep in peace!', why = 'Corann 81 (say #7496)'},
         }},
    },
}

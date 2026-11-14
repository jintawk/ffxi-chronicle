-- Step progress for Out of One's Shell (Bastok quest 5). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Out_of_Ones_Shell.lua (Ronan 82 has no option and its finish begins the quest;
-- Ronan 84 plays only on a trade of three Shell Bugs with Prog 0 and sets Prog 1 and must-zone; Ronan 85 then plays until the
-- player zones, so it only follows the trade; Ronan 86 plays only after zoning and runs quest:complete); client event script
-- S4 236_Ronan_010EC030.txt (82 say #7498, 84/85 say #7506, 86 say #7509). The page says the quest does not appear in the game's
-- own log, but LandSandBoat adds it at Ronan 82, so the log bit is kept as one signal among others. The Baby eft memento in the
-- sub-bullet is only a way to get shell bugs (an indented bullet), so it is not used.
-- Completion: the final event also plays when the item reward cannot be given (npcUtil.completeQuest fails in onEventFinish after the
-- cutscene), so it is a reach only and the quest log's completed bit carries the last step.
return {
    title = "Out of One's Shell",
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ronan to activate quest'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 236, event = 82, why = 'Ronan 82: begins the quest'},
            {t = 'chat', re = "You! You're the one who gave my son that cursed thing, aren't you!%?", why = 'Ronan 82 (say #7498)'},
         }},
        {id = 'n2', kind = 'note', with = 's3', at = {n = 2, fp = 'this quest will not show up'}},
        {id = 's3', at = {n = 3, fp = 'obtain 3 shell bugs from quadavs'},
         done = {
            {t = 'event', zone = 236, event = 84, why = 'Ronan 84: the three shell bugs accepted'},
            {t = 'chat', re = "I'll go do it right away!", why = 'Ronan 84 / 85 (say #7506)'},
            {t = 'event', zone = 236, event = 85, conf = 'inferred', why = 'Ronan 85: only after the trade, until the player zones'},
         }},
        {id = 's4', at = {n = 4, fp = 'zone out leave the area and'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 236, event = 86, why = 'Ronan 86: plays even when the reward item does not fit'},
            {t = 'chat', re = 'That trick of yours worked!', why = 'Ronan 86 (say #7509)'},
         }},
    },
}

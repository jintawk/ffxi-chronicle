-- Step progress for Scooped! (Windurst quest 38). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Scooped.lua (Naiko-Paneiko 676 begins the quest on any outcome; 677 is his
-- reminder while accepted; 680 plays on the exact trade of one Bronze Box and completes the quest for gil and fame, with no
-- item reward, so it cannot fail). The draft put the reminder 677 on the trade step, where it would have ticked the step on
-- any talk after accepting; it proves the first step instead. Bullets 1, 3 and 4 are a hint and the fishing directions, notes
-- on the steps they lead into. No client event scripts exist for Naiko-Paneiko's quest events, so there are no dialogue lines.
return {
    title = 'Scooped!',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you must zone after completing making'}},
        {id = 's2', at = {n = 2, fp = 'speak to naiko paneiko to begin'},
         done = {
            {t = 'event', zone = 238, event = 676, why = 'Naiko-Paneiko 676: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 238, event = 677, conf = 'inferred', why = 'Naiko-Paneiko 677: reminder, only while accepted'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'head to the ferry mhaura selbina'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'the crabs will drop the bronze'}},
        {id = 's5', at = {n = 5, fp = 'trade the bronze box to naiko'},
         done = {
            {t = 'event', zone = 238, event = 680, why = 'Naiko-Paneiko 680: the Bronze Box accepted'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

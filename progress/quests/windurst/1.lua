-- Step progress for A Feather in One's Cap (Windurst quest 1). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Waters/npcs/Baren-Moren.lua (event 75 offers the quest and its menu can be
-- declined, so it only proves the offer; option 1 adds the quest; 78 is the reminder while it is accepted, so it follows the
-- accept; trading three Giant Bird Feathers plays 79 only when they are held, and 79 completes the quest and pays 1,500 gil
-- with fame alone as reward, so nothing in it can refuse); client event script S4 238_Baren_Moren_010EE044.txt (79: "Obtained
-- [P0] gil." print #6556; 75 and 78 have no body in the client scripts, their csids are in the LandSandBoat script).
-- The draft put the completion on the "asks you to get" bullet; the trade is bullet 3. Repeatable (page meta): after
-- completion 75 is offered again and the repeat sets a variable instead of the quest-log bit, so the reminder 78 opens the
-- next run and the quest-log matchers count for the first run only (run1). Bullet 1 (zone first) is a note on the offer.
-- The quest log is set at s2, so it is not silent.
return {
    title = "A Feather in One's Cap",
    completes = 's3',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s2'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you must zone after completing the'}},
        {id = 's2', at = {n = 2, fp = 'baren moren asks you to get'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 238, event = 78, conf = 'inferred', why = 'Baren-Moren 78: reminder, only once accepted'},
         },
         reach = {{t = 'event', zone = 238, event = 75, why = 'Baren-Moren 75 offered (its finish needs option 1)'}}},
        {id = 's3', at = {n = 3, fp = 'trade all three at one time'},
         done = {
            {t = 'event', zone = 238, event = 79, why = 'Baren-Moren 79: the three Giant Bird Feathers accepted'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
    },
}

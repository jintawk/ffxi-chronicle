-- Step progress for Skyward Ho, Voidwatcher! (Outlands quest 104). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script exist for this quest, so the page is the only source: the quest is
-- "automatically flagged" the moment Kieran gives Ashen stratum abyssite III for VW Op. 115 (n=1), so the log's current bit belongs
-- to s1; Gilgamesh in Norg "completes the quest" (n=4), so the completed bit belongs to s4. Key item 1449 (res/key_items.lua) is
-- the reward of the previous quest, so it only supports s1. The battle and Kieran bullets leave no trace of their own and are
-- notes on the step they lead into. Not repeatable.
return {
    title = 'Skyward Ho, Voidwatcher!',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after completing vw op 115 li'},
         done = {
            {t = 'quest', current = true, why = 'quest log: flagged automatically with the previous quest\'s reward (page, n=1)'},
            {t = 'ki', id = 1449, gained = true, conf = 'inferred', why = 'ashen stratum abyssite III obtained (previous quest reward)'},
            {t = 'ki_have', id = 1449, have = true, conf = 'inferred', why = 'ashen stratum abyssite III held'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'engage in and complete the 3'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'after defeating all 3 return to'}},
        {id = 's4', at = {n = 4, fp = 'return to norg and speak to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Gilgamesh, page n=4)'},
         }},
    },
}

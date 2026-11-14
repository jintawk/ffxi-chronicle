-- Step progress for VW Op. 115: Li'Telor Variant (Outlands quest 103). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script exist for this quest (Kieran's Voidwatch events are in no S4 pseudo-code
-- file), so the page is the only source: the quest is flagged when Kieran gives Ashen stratum abyssite II (n=3) and "automatically
-- finishes" at the last Kieran talk, which gives Ashen stratum abyssite III and begins the next quest (n=5). The log's current bit
-- therefore belongs to s3 and the completed bit to s5. Both key items are quest rewards (res/key_items.lua 1448, 1449) and so only
-- support their step. The talk, cutscene and battle bullets leave no trace of their own and are notes on the step they lead into.
-- Not repeatable.
return {
    title = "VW Op. 115: Li'Telor Variant",
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'talk to kieran after completing voidwatch'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak to gilgamesh in norg for'}},
        {id = 's3', at = {n = 3, fp = 'return to kieran for a cutscene'},
         done = {
            {t = 'quest', current = true, why = 'quest log: flagged when Kieran gives the abyssite (page, n=3)'},
            {t = 'ki', id = 1448, gained = true, conf = 'inferred', why = 'ashen stratum abyssite II obtained (reward)'},
            {t = 'ki_have', id = 1448, have = true, conf = 'inferred', why = 'ashen stratum abyssite II held'},
            {t = 'chat', re = 'obtained key item: ashen stratum abyssite ii', conf = 'inferred', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'engage in and complete the three'}},
        {id = 's5', at = {n = 5, fp = 'return to kieran which will automatically'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Kieran, automatic)'},
            {t = 'ki', id = 1449, gained = true, conf = 'inferred', why = 'ashen stratum abyssite III obtained (reward)'},
            {t = 'ki_have', id = 1449, have = true, conf = 'inferred', why = 'ashen stratum abyssite III held'},
            {t = 'chat', re = 'obtained key item: ashen stratum abyssite iii', conf = 'inferred', why = 'chat: key item obtained'},
         }},
    },
}

-- Step progress for Flower Child (Windurst quest 65). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Flower_Child.lua (every contact with Ojha Rhawash is event 10000, told apart by
-- P2: 10 a plain talk, 2 a Lilac traded, 1 another flower, 0 a wrong item, and 4 or 5 the same trades after completion; the
-- client script 239_Ojha_Rhawash_010EF065.txt reads P2 into L1 and tests L1 == 10 first, P1 = 239 her zone). The quest begins
-- on any first contact except the Lilac, and completes when the Lilac trade ends with option 3002 (quest:complete with a fame
-- reward only, so there is no refusal path); Ojha has no distinctive chat line in the decoded script. The quest log
-- is silent until that first contact, which is the optional talk or a wrong trade, so the steps before the hand-in are unknown
-- until the log or the trade shows them; the Lilac hunt is a note.
return {
    title = 'Flower Child',
    completes = 's3',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', kind = 'optional', at = {n = 1, fp = 'optional talk to ojha rhawash'},
         done = {
            {t = 'event', zone = 239, event = 10000, p = {[2] = 10}, why = 'Ojha Rhawash 10000, P2 = 10: a plain talk'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'she won t come out and'}},
        {id = 's3', at = {n = 3, fp = 'trade it to her to complete'},
         done = {
            {t = 'event', zone = 239, event = 10000, p = {[2] = 2}, why = 'Ojha Rhawash 10000, P2 = 2: a Lilac traded'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 239, event = 10000, p = {[2] = 4}, conf = 'inferred', why = 'Ojha Rhawash 10000, P2 = 4: a Lilac traded after completion'},
         }},
    },
}

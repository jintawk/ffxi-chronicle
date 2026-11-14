-- Step progress for Lerene's Lament (Adoulin quest 126). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/Lerenes_Lament.lua (Lerene 22 offers the quest and only option 2 begins it, so
-- the log's current bit is the accept; while accepted her talk is 23 and trading exactly two Squares of Ancestral Cloth plays 24,
-- which gives Lerene's paten and runs quest:complete: the reward has no item, so there is no refusal); client event script S4
-- 274_Lerene_011121EA.txt (22: the Yes branch, option 2, says #7816, the No branch #7817; 23 says #7818). Key item 2504 from
-- res/key_items.lua; it is a reward, so it only supports the trade. Not repeatable.
return {
    title = "Lerene's Lament",
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to lerene at the entrance'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Lerene 22, option 2)'},
            {t = 'chat', re = 'Excellent! The two of us will make the perfect team%.', why = 'Lerene 22, Yes branch only (say #7816)'},
            {t = 'event', zone = 274, event = 23, conf = 'inferred', why = 'Lerene 23: her talk, only while accepted'},
            {t = 'chat', re = "The shadows located here within Ra'Kaznar have got to have what I seek%.", conf = 'inferred', why = 'Lerene 23 (say #7818)'},
         },
         reach = {{t = 'event', zone = 274, event = 22, why = 'Lerene 22 offered (its finish needs option 2)'}}},
        {id = 's2', at = {n = 2, fp = 'trade her two ancestral cloth to'}, count = {item = 8751, need = 2},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 274, event = 24, why = 'Lerene 24: the exact trade of two cloth, runs quest:complete'},
            {t = 'ki', id = 2504, gained = true, conf = 'inferred', why = "Lerene's paten obtained (reward)"},
         }},
    },
}

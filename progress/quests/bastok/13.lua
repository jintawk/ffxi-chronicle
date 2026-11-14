-- Step progress for The Elvaan Goldsmith (Bastok quest 13). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Elvaan_Goldsmith.lua (Michea 215 begins the quest in Bastok Markets and is
-- also his talk while it is accepted; trading one Copper Ingot is event 216, which runs quest:complete and pays 180 gil, no
-- reward item); client event script S4 235_Michea_010EB02C.txt (215 say #7597, 216 say #7600). Repeatable at Bastok fame 1 after
-- zoning (page meta): a completed-state talk plays 215 again, so 215 opens the next run and the quest-log matchers count for the
-- first run only (run1). Bullets 3 to 9 are indented sub-bullets (where to buy and craft the ingot), not steps. The quest log is
-- set at s1, so it is not silent.
return {
    title = 'The Elvaan Goldsmith',
    completes = 's10',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to michea to start quest'},
         done = {
            {t = 'event', zone = 235, event = 215, why = 'Michea 215'},
            {t = 'chat', re = "I'm a goldsmith%.%.%.yes, I know that most people think the Elvaan are no good at that kind of craft%.", why = 'Michea 215 (say #7597)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
         }},
        {id = 's2', kind = 'note', with = 's10', at = {n = 2, fp = 'obtain a copper ingot from either'}},
        {id = 's10', at = {n = 10, fp = 'trade the ingot to michea to'},
         done = {
            {t = 'event', zone = 235, event = 216, why = 'Michea 216: the Copper Ingot trade'},
            {t = 'chat', re = "Thank you! With this, I can finally complete my customer's order%.", why = 'Michea 216 (say #7600)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
        {id = 's11', kind = 'note', with = 's10', at = {n = 11, fp = 'may be repeated by zoning out'}},
    },
}

-- Step progress for Toraimarai Turmoil (Windurst quest 80). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Toraimarai_Turmoil.lua (Ohbiru-Dohbiru 785 offers the quest, which begins and gives
-- the Rhinostery certificate only for option 1, so it is a reach; 786 is his reminder while accepted; 791 is the accepted trade of
-- 3 Starmite Shells and its finish runs quest:complete, which pays gil and fame only, so it has no refusal path). Key item 267 and
-- item 906 from res/key_items.lua and res/items.lua. The quest repeats at Ohbiru-Dohbiru, but the repeat offer (795) plays
-- whatever the answer is and the certificate is already held, so nothing opens a run that is not also played on a refusal: no
-- `repeatable` entry. Sub-bullets (the Starmite route) are not steps. The quest log is set at s1, so it is not silent.
return {
    title = 'Toraimarai Turmoil',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ohbiru dohbiru for a'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 267, gained = true, why = 'Rhinostery certificate obtained'},
            {t = 'ki_have', id = 267, have = true, why = 'Rhinostery certificate held'},
            {t = 'chat', re = 'obtained key item: rhinostery certificate', why = 'chat: key item obtained'},
            {t = 'event', zone = 238, event = 786, conf = 'inferred', why = 'Ohbiru-Dohbiru 786: reminder, only once accepted'},
         },
         reach = {{t = 'event', zone = 238, event = 785, why = 'Ohbiru-Dohbiru 785 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade ohbiru dohbiru 3 starmite shells'}, count = {item = 906, need = 3},
         done = {
            {t = 'event', zone = 238, event = 791, why = 'Ohbiru-Dohbiru 791: the 3 Starmite Shells accepted'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

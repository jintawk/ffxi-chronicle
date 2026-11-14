-- Step progress for Warding Vampires (San d'Oria quest 79). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Warding_Vampires.lua (Maloquedil 24 option 1 begins the quest; 22 is his
-- reminder, only while it is accepted; trading 2 Bulbs of Shaman Garlic is event 23, which completes it); client event
-- scripts S4 231_Maloquedil_010E709F.txt (24 accept branch say #12115, 22 say #12117, 23 say #12118); item 1018 from
-- res/items.lua. The quest is repeatable (page meta): a new accept after a finished run opens the next run. The quest log's
-- bits are first-run only because retail keeps the current bit after completion. Event 24 and its other lines also play on
-- a refusal (and the "I still seek" line after completion), so only the accept line proves s1.
return {
    title = 'Warding Vampires',
    completes = 's2',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to maloquedil to begin this'},
         done = {
            {t = 'chat', re = 'What a relief! Eh%? My breath a little strong for you%?', why = 'Maloquedil 24, accepted (say #12115)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
            {t = 'event', zone = 231, event = 22, conf = 'inferred', why = 'Maloquedil 22: reminder, only while accepted'},
            {t = 'chat', re = 'Those Orcish cursemakers in Davoi carry', conf = 'inferred', why = 'Maloquedil 22 (say #12117)'},
         },
         reach = {{t = 'event', zone = 231, event = 24, why = 'Maloquedil 24 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade him 2 shaman garlic to'}, count = {item = 1018, need = 2},
         done = {
            {t = 'event', zone = 231, event = 23, why = 'Maloquedil 23: the garlic accepted'},
            {t = 'chat', re = "Ah! I can't thank you enough%.", why = 'Maloquedil 23 (say #12118)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed'},
         }},
    },
}

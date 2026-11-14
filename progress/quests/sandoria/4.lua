-- Step progress for Father and Son (San d'Oria quest 4). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Father_and_Son.lua (Ailbeche 508 begins the quest; Exoroche 542 plays only
-- while it is accepted and sets Prog 1; Ailbeche 509 needs Prog 1 and completes it); client event scripts S4
-- 231_Ailbeche_010E7009.txt (508 say #11211, 509 say #11217) and 230_Exoroche_010E603C.txt (542 say #7846). Helbort 593 is
-- a shop greeting that also plays without the quest, so it proves nothing (the draft used it). The quest log is set at s1.
-- Full-inventory rule (coordinator, 2026-10-28): an event whose finish can fail on a full bag (giveItem or a reward item)
-- plays the same either way, so it and its lines are `reach` only; the quest log or a success-only signal proves the step.
return {
    title = 'Father and Son',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to ailbeche to start the'},
         done = {
            {t = 'event', zone = 231, event = 508, why = 'Ailbeche 508: begins the quest'},
            {t = 'chat', re = "I%-I came here with my father, and now he's g%-gone!", why = 'Ailbeche 508 (say #11211)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to ailbeche s father exoroche'},
         done = {
            {t = 'event', zone = 230, event = 542, why = 'Exoroche 542: only while accepted'},
            {t = 'chat', re = "What's that%? My son%? At the Parade Grounds%?", why = 'Exoroche 542 (say #7846)'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to ailbeche and talk to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 231, event = 509, why = 'Ailbeche 509 (the fishing rod reward may not fit)'},
                  {t = 'chat', re = 'What%? Y%-you found my father%?', why = 'Ailbeche 509 (say #11217)'}}},
    },
}

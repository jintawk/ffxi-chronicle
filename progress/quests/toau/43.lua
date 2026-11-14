-- Step progress for Saga of the Skyserpent (Aht Urhgan quest 43). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Saga_of_the_Skyserpent.lua (Fari-Wari 823 begins the quest with no refusal; at
-- Prog 0 Fari-Wari plays 829 and the Halvung ??? (qm7) gives the Lilac ribbon (key item 855) and sets Prog 1; at Prog 1
-- Fari-Wari plays 953 and sends you to Wajaom Woodlands, whose zone-in plays cutscene 12 then 13, and 13 takes the ribbon back,
-- sets Prog 2 and stamps the Vana'diel day; at Prog 2 Fari-Wari plays 833 on the same day and 825 on a later one, and 825 runs
-- quest:complete). The Biyaada events (278, 279) are in no bullet. The reward items are not used. Not repeatable.
return {
    title = 'Saga of the Skyserpent',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to fari wari at the'},
         done = {
            {t = 'event', zone = 50, event = 823, why = 'Fari-Wari 823: the offer, begins the quest with no refusal'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 829, why = 'Fari-Wari 829: only at Prog 0 while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'go to wajaom woodlands c 8'},
         done = {
            {t = 'ki', id = 855, gained = true, why = 'lilac ribbon obtained (Halvung ???)'},
            {t = 'chat', re = 'obtained key item: lilac ribbon', why = 'chat: key item obtained'},
            {t = 'event', zone = 50, event = 953, why = 'Fari-Wari 953: only at Prog 1, after the ribbon'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to fari wari'},
         done = {
            {t = 'zonein', zone = 51, event = 12, after = 's2', why = 'Wajaom Woodlands zone-in cutscene 12: only at Prog 1'},
            {t = 'event', zone = 51, event = 13, why = 'Wajaom Woodlands 13: takes the ribbon, sets Prog 2'},
            {t = 'event', zone = 50, event = 833, why = 'Fari-Wari 833: only at Prog 2, the same Vana\'diel day'},
            {t = 'ki', id = 855, gained = false, conf = 'inferred', why = 'lilac ribbon handed back'},
         },
         reach = {{t = 'event', zone = 50, event = 953, why = 'Fari-Wari 953 offered (sends you to Wajaom Woodlands)'}}},
        {id = 's4', at = {n = 4, fp = 'wait a game day and speak'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 50, event = 825, why = 'Fari-Wari 825: a later day, runs quest:complete'},
         }},
    },
}

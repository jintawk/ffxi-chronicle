-- Step progress for Promotion: Sergeant Major (Aht Urhgan quest 95). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Promotion_Sergeant_Major.lua, client event script S4
-- 050_Naja_Salaheem_0103208C.txt (5048-5054 have no text). The page's three bullets are the three trials, each a Naja
-- cutscene with a minigame whose pass or fail is the option chosen at the end (so an event start proves nothing about the
-- result, and each trial can be redone on a later game day). The server stage names the proof: Naja 5048 / 5049 play trial 1
-- (Stage 0), 5050 / 5051 trial 2 (only once trial 1 is passed, Stage 1 or 2), 5052 / 5053 trial 3 (only once trial 2 is
-- passed, Stage 3 or 4), and 5054 (Stage 5, all three passed) runs quest:complete and prints "has been promoted to Sergeant
-- Major", line 6183 of Aht_Urhgan_Whitegate/IDs.lua. So the trial's own events are reaches and the next trial's events are
-- its proof; the last trial is proved by the final talk and the completed bit. The quest begins at 5048 (no bullet for that
-- talk, so the current bit is not used). Not repeatable.
return {
    title = 'Promotion: Sergeant Major',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'in this trial you must count'},
         done = {
            {t = 'event', zone = 50, event = 5050, why = 'Naja Salaheem 5050: trial 2 only plays once trial 1 is passed'},
            {t = 'event', zone = 50, event = 5051, why = 'Naja Salaheem 5051: the trial 2 redo, only once trial 1 is passed'},
         },
         reach = {
            {t = 'event', zone = 50, event = 5048, why = 'Naja Salaheem 5048: trial 1 (any result plays it)'},
            {t = 'event', zone = 50, event = 5049, why = 'Naja Salaheem 5049: the trial 1 redo'},
         }},
        {id = 's2', at = {n = 2, fp = 'in this trial you must give'},
         done = {
            {t = 'event', zone = 50, event = 5052, why = 'Naja Salaheem 5052: trial 3 only plays once trial 2 is passed'},
            {t = 'event', zone = 50, event = 5053, why = 'Naja Salaheem 5053: the trial 3 redo, only once trial 2 is passed'},
         },
         reach = {
            {t = 'event', zone = 50, event = 5050, why = 'Naja Salaheem 5050: trial 2 (any result plays it)'},
            {t = 'event', zone = 50, event = 5051, why = 'Naja Salaheem 5051: the trial 2 redo'},
         }},
        {id = 's3', at = {n = 3, fp = 'in this final trial you must'},
         done = {
            {t = 'event', zone = 50, event = 5054, why = 'Naja Salaheem 5054: only plays once all three trials are passed, runs quest:complete'},
            {t = 'chat', re = 'has been promoted to sergeant major', why = 'promotion message (IDs.lua 6183)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 50, event = 5052, why = 'Naja Salaheem 5052: trial 3 (any result plays it)'},
            {t = 'event', zone = 50, event = 5053, why = 'Naja Salaheem 5053: the trial 3 redo'},
         }},
    },
}

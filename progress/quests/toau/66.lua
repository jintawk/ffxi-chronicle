-- Step progress for Rat Race (Aht Urhgan quest 66). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Rat_Race.lua (a Prog state machine: Kakkaroon in Nashmau 308 begins the quest with
-- no refusal and sets Prog 1, and plays 313 on later talks until the end; Nadee Periyaha 849 at Prog 1 (sets 2), 851 at Prog 2,
-- 852 from Prog 3; Cacaroon 853 at Prog 2 on a plain talk, 850 when a Bronze piece is traded at Prog 2 (sets 3), 854 from Prog 3;
-- Ququroon 309 and 310 and 315 (Prog 3-5) and the shared 242 are in no bullet, the stew bullet being another quest; Kyokyoroon
-- 311 when exactly one Nashmau Stew is traded at Prog 5 (sets 6) and 316 at Prog 6; Kakkaroon 312 at Prog 6 runs quest:complete).
-- Client event scripts S4 050_Nadee_Periyaha_0103208A.txt (851: say #12639), 050_Cacaroon_010320EC.txt (853: say #12688, 854:
-- say #12684), 053_Kyokyoroon_01035036.txt (316: say #11615). Bullet 5 (Cook-a-roon?) is another quest: a note on the stew trade.
-- The reward is not used. Not repeatable.
return {
    title = 'Rat Race',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kakkaroon'},
         done = {
            {t = 'event', zone = 53, event = 308, why = 'Kakkaroon 308: the offer, begins the quest with no refusal'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 53, event = 313, why = 'Kakkaroon 313: his talk while accepted, before the end'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to nadee periyaha aht urhgan'},
         done = {
            {t = 'event', zone = 50, event = 849, why = 'Nadee Periyaha 849: only at Prog 1, sets Prog 2'},
            {t = 'event', zone = 50, event = 851, why = 'Nadee Periyaha 851: only at Prog 2'},
            {t = 'chat', re = 'I wonder what got into him%?', why = 'Nadee Periyaha 851 (say #12639)'},
            {t = 'event', zone = 50, event = 852, why = 'Nadee Periyaha 852: from Prog 3'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to cacaroon aht urhgan whitegate'},
         done = {
            {t = 'event', zone = 50, event = 853, why = 'Cacaroon 853: his plain talk at Prog 2'},
            {t = 'chat', re = 'Cacaroon got cheeep info, ya%?', why = 'Cacaroon 853 (say #12688)'},
         }},
        {id = 's4', at = {n = 4, fp = 'trade cacaroon one imperial bronze piece'},
         done = {
            {t = 'event', zone = 50, event = 850, why = 'Cacaroon 850: the Bronze piece trade, only at Prog 2, sets Prog 3'},
            {t = 'event', zone = 50, event = 854, why = 'Cacaroon 854: from Prog 3'},
            {t = 'chat', re = 'Cacaroon call friends now%.', why = 'Cacaroon 854 (say #12684)'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'now you must complete cook a'}},
        {id = 's6', at = {n = 6, fp = 'trade a nashmau stew to kyokyoroon'},
         done = {
            {t = 'event', zone = 53, event = 311, why = 'Kyokyoroon 311: the exact stew trade, only at Prog 5, sets Prog 6'},
            {t = 'event', zone = 53, event = 316, why = 'Kyokyoroon 316: only at Prog 6'},
            {t = 'chat', re = 'Kyokyoroon have must hurry to boat dock place!', why = 'Kyokyoroon 316 (say #11615)'},
         }},
        {id = 's7', at = {n = 7, fp = 'speak to kakkaroon to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 53, event = 312, why = 'Kakkaroon 312: only at Prog 6, runs quest:complete'},
         }},
    },
}

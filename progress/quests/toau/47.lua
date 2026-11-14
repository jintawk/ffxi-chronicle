-- Step progress for Soothing Waters (Aht Urhgan quest 47). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Soothing_Waters.lua (a Prog state machine: Fari-Wari 894 offers it and option 0
-- begins it, so 894 is only a reach; while accepted Fari-Wari plays 906 and Eunheem 907 at Prog 0-3; Eunheem 895 plays only at
-- Prog 0 and sets 1; Nadeey (Walahra Temple, Whitegate) 896 only at Prog 1 sets 2; Mihli Aliapoh 289 in Al Zahbi only at Prog 2
-- sets 3; the Aydeewa Subterrane ??? (qm10) plays cutscene 34 only when the Tuft of Colorful Hair is traded at Prog 3 and sets 4;
-- Fari-Wari 897 only at Prog 4 runs quest:complete). Prog 0 events are not shared: 906 and 907 also play at later Prog values,
-- so they prove the first steps (Fari-Wari 906 plays from Prog 0 on, Eunheem 907 from Prog 1). The Al Zahbi and Whitegate events
-- played once the quest is completed (284-288, 285) are in no bullet. Client event script S4 048_Mihli_Aliapoh_010301F7.txt (289:
-- say #8177). Bullet 5's hair drops are sub-bullets. Not repeatable.
return {
    title = 'Soothing Waters',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to fari wari in aht'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 906, why = 'Fari-Wari 906: his talk while accepted at Prog 0-3'},
         },
         reach = {{t = 'event', zone = 50, event = 894, why = 'Fari-Wari 894 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'go to g 9 and talk'},
         done = {
            {t = 'event', zone = 50, event = 895, why = 'Eunheem 895: only at Prog 0, sets Prog 1'},
            {t = 'event', zone = 50, event = 907, why = 'Eunheem 907: his talk from Prog 1 on'},
         }},
        {id = 's3', at = {n = 3, fp = 'talk to nadeey at k 7'},
         done = {
            {t = 'event', zone = 50, event = 896, why = 'Nadeey 896: only at Prog 1, sets Prog 2'},
         }},
        {id = 's4', at = {n = 4, fp = 'talk to mihli aliapoh in al'},
         done = {
            {t = 'event', zone = 48, event = 289, why = 'Mihli Aliapoh 289: only at Prog 2, sets Prog 3'},
            {t = 'chat', re = 'What do you want, mercenary%?', why = 'Mihli Aliapoh 289 (say #8177)'},
         }},
        {id = 's5', at = {n = 5, fp = 'use the i 7 bhaflau thickets'},
         done = {
            {t = 'event', zone = 68, event = 34, why = 'Aydeewa Subterrane ??? 34: only with the hair traded at Prog 3, sets Prog 4'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to fari wari to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 50, event = 897, why = 'Fari-Wari 897: only at Prog 4, runs quest:complete'},
         }},
    },
}

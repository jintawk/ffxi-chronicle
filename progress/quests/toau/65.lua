-- Step progress for Led Astray (Aht Urhgan quest 65). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Led_Astray.lua (Mhasbaf 808 begins the quest with no refusal; while accepted he
-- plays 834 on every talk; the Whitegate trigger area 7 plays 809 at Prog 0 (sets 1), Tohka Telposkha 810 at Prog 1 (sets 2),
-- Rubahah 811 and Cacaroon 812 at Prog 2, once each in either order, and the second one sets Prog 3, the trigger area 8 plays 813
-- at Prog 3, gives the Letter from Bernahn (key item 853) and sets 4; Tataroon in Nashmau plays 305 at Prog 4, takes the letter and
-- runs quest:complete). Rubahah and Cacaroon are one bullet but two events and either may come last, so neither proves it alone:
-- the step is shown done from the next event (813, which plays only at Prog 3, so both talks are done; the letter that 813
-- gives is what proves bullet 5), and 811 and 812 only mark it reached. Client event script S4
-- 050_Mhasbaf_0103212D.txt (834: say #5297). The reward is not used. Not repeatable.
return {
    title = 'Led Astray',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to mhasbaf in aht urhgan'},
         done = {
            {t = 'event', zone = 50, event = 808, why = 'Mhasbaf 808: the offer, begins the quest with no refusal'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 834, why = 'Mhasbaf 834: his talk while accepted'},
            {t = 'chat', re = "I'll keep a look out around here%.", why = 'Mhasbaf 834 (say #5297)'},
         }},
        {id = 's2', at = {n = 2, fp = 'walk downstairs to the pillar at'},
         done = {
            {t = 'event', zone = 50, event = 809, why = 'Whitegate trigger area 7: 809, only at Prog 0, sets Prog 1'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to tohka telposkha at i'},
         done = {
            {t = 'event', zone = 50, event = 810, why = 'Tohka Telposkha 810: only at Prog 1, sets Prog 2'},
         }},
        {id = 's4', at = {n = 4, fp = 'talk to rubahah at f 9'},
         done = {
            {t = 'event', zone = 50, event = 813, conf = 'inferred', why = 'Whitegate trigger area 8: 813, only at Prog 3, so both talks are done'},
         },
         reach = {{t = 'event', zone = 50, event = 811, why = 'Rubahah 811 (the second talk sets Prog 3)'},
                  {t = 'event', zone = 50, event = 812, why = 'Cacaroon 812 (the second talk sets Prog 3)'}}},
        {id = 's5', at = {n = 5, fp = 'walk to i 11 down the'},
         done = {
            {t = 'ki', id = 853, gained = true, why = 'letter from Bernahn obtained'},
            {t = 'chat', re = 'obtained key item: letter from bernahn', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to tataroon at g 8'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 53, event = 305, why = 'Tataroon 305: only at Prog 4, runs quest:complete'},
            {t = 'ki', id = 853, gained = false, conf = 'inferred', why = 'letter from Bernahn handed over'},
         }},
    },
}

-- Step progress for The All-New C-2000 (Windurst quest 24). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Kopuro-Popuro.lua (285 is the offer: the quest is added on any finish
-- except option 2, the decline, so it plays on a refusal and is a reach; 288 is his reminder and the wrong-trade reply, both only
-- while accepted; 292 takes the Two-Leaf Mandragora Bud, Insect Wing and Rabbit Hide and runs completeQuest with gil, fame and a
-- title but no item; 293 is his talk once completed). Client event script S4 241_Kopuro_Popuro_010F1016.txt (288 say #8087,
-- 292 say #8096). The quest log is set at s1, so it is not silent.
return {
    title = 'The All-New C-2000',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kopuro popuro to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 241, event = 288, why = 'Kopuro-Popuro 288: reminder, only while accepted'},
            {t = 'chat', re = 'Have you obtained the items I need to educate the All%-New C%-2000 yet%?', why = 'Kopuro-Popuro 288 (say #8087)'},
         },
         reach = {{t = 'event', zone = 241, event = 285, why = 'Kopuro-Popuro 285 offered (the second question can decline)'}}},
        {id = 's2', at = {n = 2, fp = 'trade kopuro popuro a two leaf'},
         done = {
            {t = 'event', zone = 241, event = 292, why = 'Kopuro-Popuro 292: the three items accepted, completes'},
            {t = 'chat', re = 'Mighty obliged to you there, friend', why = 'Kopuro-Popuro 292 (say #8096)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 241, event = 293, why = 'Kopuro-Popuro 293: his talk once completed'},
         }},
    },
}

-- Step progress for Keeping Notes (Assault/Aht Urhgan quest 0). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Keeping_Notes.lua (Ahkk Jharcham 9 is the offer and begins the quest on
-- finish with no refusal; 10 is her talk while accepted; trading exactly a Sheet of Parchment and a Jar of Black Ink plays 11,
-- which runs quest:complete; any other trade plays 14, so 11 is never a refusal; 12 plays once completed). Client event script
-- S4 050_Ahkk_Jharcham_01032115.txt (10 say #5566; events 9 and 11 have no text). One bullet: the log's accepted bit and
-- events 9 and 10 only reach it, the trade (11) and the completed bit prove it. The reward is a Mog House exit, no key item.
-- Not repeatable.
return {
    title = 'Keeping Notes',
    completes = 's1',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'trade a parchment and a black'},
         done = {
            {t = 'event', zone = 50, event = 11, why = 'Ahkk Jharcham 11: the exact trade accepted, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'quest', current = true, why = 'quest log: accepted (Ahkk Jharcham 9)'},
            {t = 'event', zone = 50, event = 9, why = 'Ahkk Jharcham 9 offered'},
            {t = 'event', zone = 50, event = 10, conf = 'inferred', why = 'Ahkk Jharcham 10: her talk while accepted'},
            {t = 'chat', re = 'Myehehe%.%.%.', conf = 'inferred', why = 'Ahkk Jharcham 10 (say #5566)'},
         }},
    },
}

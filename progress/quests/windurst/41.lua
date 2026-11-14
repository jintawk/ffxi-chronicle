-- Step progress for Inspector's Gadget! (Windurst quest 41). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/SOB3_Inspectors_Gadget.lua (Kohlo-Lakolo 413 is the offer and only option 0
-- begins the quest; 414 is his reminder; Pichichi 415 plays only while accepted and sets Prog 1; Chamama 551 plays from Prog 1
-- until she has made the moustache and sets Prog 2, and 553 only once the Fake moustache is held; 552 plays on the exact trade
-- of 4 Saruta Cotton and gives the Fake moustache; Kohlo-Lakolo 421 plays only with the moustache held and runs
-- quest:complete, whose Heko Obi reward needs a free slot while the event plays regardless, so 421 is `reach` and the quest log's
-- completed bit carries the last step). Bullets 2 and 4 each bundle two moments: bullet 2 is Kohlo (the accepted bit, only
-- `reach`) then Pichichi (415, which proves the whole bullet); bullet 4 is the Chamama trade (552 and the moustache, `reach`)
-- then Kohlo (the completion). The cotton count belongs to bullet 4, the trade it feeds. Client event scripts S4
-- 240_Kohlo_Lakolo_010F0052.txt (414 say #4324), 240_Pichichi_010F0055.txt (415 say #4327), 238_Chamama_010EE057.txt (551 say
-- #8781, 552 say #8784, 553 say #8785); key item and item ids from res (95 Fake moustache, 834 Saruta Cotton).
return {
    title = "Inspector's Gadget!",
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'zone after finishing the previous quest'}},
        {id = 's2', at = {n = 2, fp = 'speak to kohlo lakolo for a'},
         done = {
            {t = 'event', zone = 240, event = 415, why = 'Pichichi 415: only while accepted'},
            {t = 'chat', re = "If you athk my mommy nithely, she'll make you", why = 'Pichichi 415 (say #4327)'},
         },
         reach = {
            {t = 'quest', current = true, why = 'quest log: accepted (Kohlo-Lakolo 413, option 0)'},
            {t = 'event', zone = 240, event = 413, why = 'Kohlo-Lakolo 413 offered (its finish needs option 0)'},
            {t = 'event', zone = 240, event = 414, why = 'Kohlo-Lakolo 414: reminder, only while accepted'},
            {t = 'chat', re = "In order to catch the criminal, we'll need the seven gadgets", why = 'Kohlo-Lakolo 414 (say #4324)'},
         }},
        {id = 's3', at = {n = 3, fp = 'go to windurst waters and speak'},
         done = {
            {t = 'event', zone = 238, event = 551, why = 'Chamama 551: asks for the cotton (from Prog 1)'},
            {t = 'chat', re = 'to disguise yourself with, dearie%?', why = 'Chamama 551 (say #8781)'},
            {t = 'event', zone = 238, event = 553, conf = 'inferred', why = 'Chamama 553: only once the Fake moustache is held'},
            {t = 'chat', re = 'In the books, Detective Poiroto%-Boiroto could change his appearance', conf = 'inferred', why = 'Chamama 553 (say #8785)'},
         }},
        {id = 's4', at = {n = 4, fp = 'give chamama the four saruta cotton'}, count = {item = 834, need = 4},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 238, event = 552, why = 'Chamama 552: the cotton accepted'},
            {t = 'chat', re = 'This should be enough%.', why = 'Chamama 552 (say #8784)'},
            {t = 'ki', id = 95, gained = true, why = 'Fake moustache obtained'},
            {t = 'event', zone = 240, event = 421, why = 'Kohlo-Lakolo 421: the finish (also plays with a full bag, when the reward fails)'},
         }},
    },
}

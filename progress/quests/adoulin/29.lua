-- Step progress for F.A.I.L.ure Is Not an Option (Adoulin quest 29). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Western_Adoulin/npcs/Clautaire.lua (event 78 is the offer, available only at Adoulin fame 4
-- with the F.A.I.L. badge, and its finish runs quest:begin with no option; 77 is her talk while accepted and the Hunk of Bedrock is
-- not held; 76 plays only with the key item held, takes it and runs quest:complete, the reward being experience and bayld with
-- no item to refuse). Client event script S4 256_Clautaire_01100119.txt (78 say #8129, 76 say #8136; the 77 line carries the key
-- item name as a parameter, so no chat matcher). Key item 2384 from res/key_items.lua; the Mog Garden mineral vein raises no
-- event of its own, so the key item carries bullet 2. The Mog Garden tip (n=4) is a note on that bullet. The draft had no
-- begin or log signal on bullet 1 beyond the events; the log's accepted bit is added. Not repeatable.
return {
    title = 'F.A.I.L.ure Is Not an Option',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with clautaire i 12 western'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Clautaire 78)'},
            {t = 'event', zone = 256, event = 78, why = 'Clautaire 78: the offer, begins the quest with no option'},
            {t = 'chat', re = "I'm Clautaire! I just joined the Liberators a couple days ago!", why = 'Clautaire 78 (say #8129)'},
            {t = 'event', zone = 256, event = 77, why = 'Clautaire 77: her talk, plays only while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'harvest the mineral vein in your'},
         done = {
            {t = 'ki', id = 2384, gained = true, after = 's1', why = 'hunk of bedrock obtained'},
            {t = 'ki_have', id = 2384, have = true, why = 'hunk of bedrock held'},
            {t = 'chat', re = 'obtained key item: hunk of bedrock', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to clautaire for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 256, event = 76, why = 'Clautaire 76: needs the key item held, runs quest:complete'},
            {t = 'chat', re = "You pioneers are great! Now I'll ace my project for sure!", why = 'Clautaire 76 (say #8136)'},
            {t = 'ki', id = 2384, gained = false, after = 's2', why = 'hunk of bedrock taken by the completing event'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'note if this is your first'}},
    },
}

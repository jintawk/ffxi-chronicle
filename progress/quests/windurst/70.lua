-- Step progress for As Thick as Thieves (Windurst quest 70). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/THF_AF2_As_Thick_as_Thieves.lua (Nanaa Mihgo 504 offers the quest and begins
-- it, with the three forged-envelope key items, only for option 1; Bopa Greso 506 and Cha Lebagta 507 are the optional hints;
-- the Sauromugue ??? text "Something has come down from the tower!" is the Climbpix Highrise pop and event 2 takes the Grapnel
-- for the First signed forged envelope, only when naked; Sniggnix 10024 is the dice talk at Prog 0 and 10025 plays only once
-- Prog is 1 or more, so after he was beaten; North Gustaberg's ??? says "You sense an evil presence..." only at Prog 4, which
-- means the three Dangruf goblins are beaten; Sniggnix 10026 takes the Regal Die for the Second signed forged envelope; Nanaa 508
-- completes, but only if quest:complete can pay, so it is a reach). Client event scripts S4 241_Nanaa_Mihgo_010F1072.txt,
-- 241_Bopa_Greso_010F1073.txt, 245_Sniggnix_010F5047.txt; key items from res/key_items.lua (186 gang whereabouts note, 187/188
-- forged envelopes, 189/190 signed forged envelopes). Left as plain bullets: 10 to 14 (the Dangruf goblins: the win events 136
-- to 138 also play when the player gives up, and the generic "You beat the Goblin!" line does not say which goblin) and 16 (event
-- 200 plays with a full bag and the Regal Die is an item), plus the link bullet 19. The Sniggnix dice line "rolls the die" plays
-- on a lost roll too, so it is not used. Repeatable after a memory reset (page meta): the quest-start key items open the next
-- run. The quest log is set at s1, so it is not silent.
-- Chat 'You sense an evil presence' is also played by Chasing Quotas and other NMs: shared, gated after s9.
return {
    title = 'As Thick as Thieves',
    completes = 's18',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to nanaa mihgo in windurst'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'ki', id = 186, gained = true, why = 'gang whereabouts note obtained'},
            {t = 'ki_have', id = 186, have = true, why = 'gang whereabouts note held'},
            {t = 'chat', re = 'obtained key item: gang whereabouts note', why = 'chat: key item obtained'},
            {t = 'ki', id = 187, gained = true, why = 'first forged envelope obtained'},
            {t = 'chat', re = 'obtained key item: first forged envelope', why = 'chat: key item obtained'},
            {t = 'ki', id = 188, gained = true, why = 'second forged envelope obtained'},
            {t = 'chat', re = 'obtained key item: second forged envelope', why = 'chat: key item obtained'},
            {t = 'event', zone = 241, event = 505, conf = 'inferred', why = 'Nanaa Mihgo 505: reminder, only once accepted'},
         },
         reach = {{t = 'event', zone = 241, event = 504, why = 'Nanaa Mihgo 504 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'optional', at = {n = 2, fp = 'optional speak to cha lebagta and'},
         done = {
            {t = 'event', zone = 241, event = 506, why = 'Bopa Greso 506'},
            {t = 'chat', re = 'From what I saw, to meet with the member in the Goblin store in Jeuno, you have to try your hand at a game of chance%.', why = 'Bopa Greso 506 (say #8868)'},
            {t = 'event', zone = 241, event = 507, why = 'Cha Lebagta 507'},
            {t = 'chat', re = "But even if you have one, you won't be getting up that tower if you're a fat cat!", why = 'Cha Lebagta 507 (say #8871)'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to sauromugue champaign and check'},
         done = {
            {t = 'chat', re = 'Something has come down from the tower!', why = 'Sauromugue ???: Climbpix Highrise pops'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'there are 6 towers in all'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'climbpix highrise drops a grapnel this'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'next go to the tower at'}},
        {id = 's7', at = {n = 7, fp = 'trade your grapnel to the and'},
         done = {
            {t = 'event', zone = 120, event = 2, why = 'Sauromugue ??? 2: the Grapnel accepted'},
            {t = 'ki', id = 189, gained = true, why = 'first signed forged envelope obtained'},
            {t = 'ki_have', id = 189, have = true, why = 'first signed forged envelope held'},
            {t = 'chat', re = 'obtained key item: first signed forged envelope', why = 'chat: key item obtained'},
            {t = 'ki', id = 187, gained = false, conf = 'inferred', why = 'first forged envelope handed over'},
         }},
        {id = 's8', at = {n = 8, fp = 'go to lower jeuno h 10'},
         done = {
            {t = 'event', zone = 245, event = 10024, why = 'Sniggnix 10024: the dice talk'},
         }},
        {id = 's9', at = {n = 9, fp = 'keep rolling against him until you'},
         done = {
            {t = 'event', zone = 245, event = 10025, why = 'Sniggnix 10025: plays only once he was beaten'},
            {t = 'chat', re = "Here's your chance%. Go to Dangruf Wadi and find Dangruf brothers%.", why = 'Sniggnix 10025 (say #7976)'},
         }},
        {id = 's15', at = {n = 15, fp = 'you ll find a click on'},
         done = {
            {t = 'chat', re = 'You sense an evil presence', after = 's9', why = 'North Gustaberg ???: Gambilox Wanderling pops (Prog 4, all three goblins beaten)'},
         }},
        {id = 's17', at = {n = 17, fp = 'head back to lower jeuno and'},
         done = {
            {t = 'event', zone = 245, event = 10026, why = 'Sniggnix 10026: the Regal Die accepted'},
            {t = 'chat', re = 'yPauluart rolls the die and gets 789!', why = 'Sniggnix 10026 (print #7992)'},
            {t = 'ki', id = 190, gained = true, why = 'second signed forged envelope obtained'},
            {t = 'ki_have', id = 190, have = true, why = 'second signed forged envelope held'},
            {t = 'chat', re = 'obtained key item: second signed forged envelope', why = 'chat: key item obtained'},
            {t = 'ki', id = 188, gained = false, conf = 'inferred', why = 'second forged envelope handed over'},
         }},
        {id = 's18', at = {n = 18, fp = 'head back to windurst woods and'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 186, gained = false, conf = 'inferred', why = 'gang whereabouts note handed over'},
            {t = 'ki', id = 189, gained = false, conf = 'inferred', why = 'first signed forged envelope handed over'},
            {t = 'ki', id = 190, gained = false, conf = 'inferred', why = 'second signed forged envelope handed over'},
         },
         reach = {{t = 'event', zone = 241, event = 508, why = 'Nanaa Mihgo 508 (completion needs a free slot for the reward)'}}},
    },
}

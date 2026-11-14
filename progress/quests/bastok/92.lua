-- Step progress for Trust: Bastok (quest 92). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Trust_Bastok.lua (Clarion Star 434 and 438 begin the quest and give the Blue
-- institute card only on option 2, the accept; 435 plays while the card is held; Naji 980 only teaches the spell and sets a
-- variable, 981 is a reminder, 982 and 984 run quest:complete, take the card back and give the Bastok Trust permit); client
-- event scripts S4 236_Clarion_Star_010EC13D.txt and 237_Naji_010ED02D.txt (434 has two menus, so "That's the kind of spunk" can
-- precede a refusal and "Bwahaha! Perfect response!" is accept only; "let's get right to it" plays only on the accept, in both
-- 434 and 438; 981 say #10961, 982 say #10963; 980 and 984 are bare). The draft put the quest log completion on the first
-- Naji talk (980); it is the second (982) or the first when another nation's Trust quest is done (984), so 980 and 981 are only
-- reaches. Key item 2498 is temporary, so no chat line is used for it. The Ayame, Iron Eater, Lucius and Naji events after the
-- quest are on no bullet. Sub-bullets are not steps.
return {
    title = 'Trust: Bastok',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to clarion star in port'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 2498, gained = true, why = 'blue institute card obtained'},
            {t = 'ki_have', id = 2498, have = true, why = 'blue institute card held'},
            {t = 'chat', re = 'Bwahaha! Perfect response!', why = 'Clarion Star 434, accept branch (say #13472)'},
            {t = 'chat', re = "let's get right to it%. Before we go any further", why = 'Clarion Star 434 and 438, accept branch (say #13473)'},
            {t = 'event', zone = 236, event = 435, why = 'Clarion Star 435: plays only while the card is held'},
         },
         reach = {
            {t = 'event', zone = 236, event = 434, why = 'Clarion Star 434 offered (its finish needs option 2)'},
            {t = 'event', zone = 236, event = 438, why = 'Clarion Star 438 offered (its finish needs option 2)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to metalworks hp 1 j'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 237, event = 984, why = 'Naji 984: another nation\'s Trust quest is done, so this one completes'},
            {t = 'event', zone = 237, event = 982, why = 'Naji 982: the spell tried, the quest completes'},
            {t = 'chat', re = 'Tell me every last detail!', why = 'Naji 982 (say #10963)'},
            {t = 'ki', id = 2498, gained = false, after = 's1', why = 'blue institute card taken back (only when the quest completes)'},
            {t = 'ki', id = 2499, gained = true, conf = 'inferred', why = 'Bastok Trust permit obtained (reward)'},
            {t = 'ki_have', id = 2499, have = true, conf = 'inferred', why = 'Bastok Trust permit held'},
         },
         reach = {
            {t = 'event', zone = 237, event = 980, why = 'Naji 980: teaches the spell, the quest goes on'},
            {t = 'event', zone = 237, event = 981, why = 'Naji 981: the reminder to try the spell'},
            {t = 'chat', re = 'Give it a shake outside of town%.', why = 'Naji 981 (say #10961)'},
         }},
    },
}

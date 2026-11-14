-- Step progress for Unlisted Qualities (Jeuno quest 77). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Unlisted_Qualities.lua (Luto Mewrilah 10031 is a menu of race and name that
-- begins the quest only when one is chosen, so it is a reach; at Prog 0 he plays 10033 as his talk; Akta 10103, Kuah Dakonsa
-- 20000 and Red Ghost 320 each play only until their answer is stored and each can be cancelled, so they are reaches; Bheem
-- plays 10037 at Prog 0 and 10171 only at Prog 1, which needs all three answers; Luto 10032 plays only at Prog 2, which Bheem's
-- 10171 sets). LandSandBoat's completion is switched off (a TODO), the page and the log's completed bit carry s7. Client event
-- scripts S4 244_Luto_Mewrilah_010F408C.txt (10033 say #8854), 244_Bheem_010F402E.txt (10037 #8855, 10171 #8866), and the
-- NPC scripts of Akta (243), Kuah Dakonsa (245) and Red Ghost (246). Bullets 3 to 5 (height, face and hair, personality) have
-- no event that proves one of them alone, so they are optional: Bheem's 10171 or 10032 passing them folds them into done.
-- Bullet 2 is a note on bullet 3. Not repeatable. The quest log is set at s1, so it is not silent.
return {
    title = 'Unlisted Qualities',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to luto mewrilah to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (a race and name chosen)'},
            {t = 'event', zone = 244, event = 10033, why = 'Luto Mewrilah 10033: his talk at Prog 0, only while accepted'},
            {t = 'chat', re = "Better be on your way while the trail's still warm!", why = 'Luto Mewrilah 10033 (say #8854)'},
         },
         reach = {{t = 'event', zone = 244, event = 10031, why = 'Luto Mewrilah 10031 offered (the menu can be cancelled)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'once you have selected a race'}},
        {id = 's3', kind = 'optional', at = {n = 3, fp = 'speak to akta ru lude gardens'}, done = {}},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'speak to kuah dakonsa lower jeuno'}, done = {}},
        {id = 's5', kind = 'optional', at = {n = 5, fp = 'speak to red ghost port jeuno'}, done = {}},
        {id = 's6', at = {n = 6, fp = 'go to upper jeuno and speak'},
         done = {
            {t = 'event', zone = 244, event = 10032, why = 'Luto Mewrilah 10032: plays only at Prog 2, after Bheem'},
         },
         reach = {
            {t = 'event', zone = 244, event = 10171, why = 'Bheem 10171: plays only at Prog 1, after the three answers (can be cancelled)'},
            {t = 'chat', re = "So this person you're looking for is", why = 'Bheem 10171 (say #8866)'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to luto mewrilah to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 244, event = 10032, why = 'Luto Mewrilah 10032 offered'}}},
    },
}

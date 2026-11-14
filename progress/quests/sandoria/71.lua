-- Step progress for Blackmail (San d'Oria quest 71). Data only; see progress/quests/sandoria/27.lua for the format.
-- The bullets are three jobs, not accept/deliver/return: bullet 1 bundles the accept and the delivery, so it is done only at
-- Halver, and the accept (key item 161, the quest log, Dauperiat 643) is only `reach`. Bullet 2 is the talk with Dauperiat
-- that offers the second job: 646 and 650 play on a refusal too, so they are reach, and the step rests on the 647 reminder,
-- which plays only once the job is taken; bullet 3 is the floor plans trade, which is where the quest completes (the page's sub-bullet: "turn in the Castle Floor Plans to get this quest marked
-- as complete"). The draft completed at bullet 2 and placed the 648 trade on it.
-- Evidence: LandSandBoat scripts/quests/sandoria/Blackmail.lua (Dauperiat 643 gives key item 161 and begins the quest; Halver
-- 549 in Chateau d'Oraguille takes it; Dauperiat 646 offers the job, option 1 sets Prog 2; 647 is the reminder; 648 is the
-- exact trade of the plans and runs quest:complete; once complete, 650 offers the job again and 648 pays 900 gil each time);
-- client event scripts S4 231_Dauperiat_010E7085.txt (647 say #7240; 643, 646, 648 and 650 are cutscenes with no decoded line)
-- and 233_Halver_010E9007.txt (549 a cutscene); key item 161 from res/key_items.lua, item 530 Castle Floor Plans.
-- Repeatable (page meta): a second run starts at Dauperiat 650 (bullet 2, no new envelope; seen as 647 once the job is taken), so bullet 1 is skipped; the
-- quest-log matchers count for the first run only because retail leaves the bits set.
return {
    title = 'Blackmail',
    completes = 's3',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s2'}, skip = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with dauperiat to obtain a'},
         done = {
            {t = 'event', zone = 233, event = 549, why = 'Halver 549: the envelope delivered'},
            {t = 'ki', id = 161, gained = false, conf = 'inferred', why = 'suspicious envelope handed over'},
         },
         reach = {
            {t = 'event', zone = 231, event = 643, why = 'Dauperiat 643: the envelope given'},
            {t = 'ki', id = 161, gained = true, why = 'suspicious envelope obtained'},
            {t = 'ki_have', id = 161, have = true, why = 'suspicious envelope held'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'return to dauperiat he will now'},
         done = {
            {t = 'event', zone = 231, event = 647, conf = 'inferred', why = 'Dauperiat 647: reminder, only once the job is taken'},
            {t = 'chat', re = 'All right%. How about you go into Ghelsba, get the', conf = 'inferred', why = 'Dauperiat 647 (say #7240)'},
         },
         reach = {
            {t = 'event', zone = 231, event = 646, why = 'Dauperiat 646 offered (its finish needs option 1)'},
            {t = 'event', zone = 231, event = 650, why = 'Dauperiat 650 offered again (a repeat; its finish needs option 1)'},
         }},
        {id = 's3', at = {n = 3, fp = 'if you agree he requests that'},
         done = {
            {t = 'event', zone = 231, event = 648, why = 'Dauperiat 648: the Castle Floor Plans trade'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed'},
         }},
    },
}

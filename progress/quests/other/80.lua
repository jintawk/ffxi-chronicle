-- Step progress for In Search of the Truth (Other Areas quest 80). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/In_Search_of_the_Truth.lua. Tressia 544 is a plain cutscene that begins
-- the quest. Prog 0: Raminey 549, Zadant 551, Fouagine 553 and Noam 555 each play once (a bit each); Tressia plays 556 (the
-- "finished collecting information?" menu) until all four bits are set and 557 after that, so 557 proves bullet 4 as a whole
-- while one NPC event only marks it reached. Prog 1 (the chronological order solved): Mengrenaux 560 and Chemioue 561 play
-- only then, and Tressia 565 is the report-location quiz (menus; the client script says "Hmmm..." on a wrong answer, so 565
-- is only the `reach` of the answer step). Prog 2: Tressia 566 ("follow the criminal's trail") plays only once the answers
-- were accepted. The ??? trail: qm1 gives the Shaded Cruse (718, the `reach` of the trail bullet); qm5 plays 558 with the
-- cruse held after the other four, takes it and completes the quest log (player:completeQuest), so the log's completed bit
-- and 558 belong to the trail step, not to the last bullet; the return to Tressia (562) and Ondieulix's reward (559) come after
-- the log is completed and are `post` steps. Client event scripts S4 026_Tressia_0101A00B.txt (557 and 544 bare, 565 quiz,
-- 566 say #11765, 562 say #11796), 026_Ondieulix_0101A00F.txt (559 say #11802) and the four 026 patrol NPC files (bare).
-- The two optional early talks have no event of their own (LandSandBoat answers Mengrenaux and Chemioue only at Prog 1), so they
-- carry no signal; the report bullet is optional on the Prog 1 events. 559 gives the reward in the same event, so it is the only
-- proof of the last bullet and there is no log bit behind it. The quest log is set at s1, so it is not silent.
return {
    title = 'In Search of the Truth',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to tressia j 6 third'},
         done = {
            {t = 'event', zone = 26, event = 544, why = 'Tressia 544: the offer cutscene (no menu, begins the quest)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'optional', at = {n = 2, fp = 'optional speak to mengrenaux j 6'}, done = {}},
        {id = 's3', kind = 'optional', at = {n = 3, fp = 'optional speak to chemioue j 6'}, done = {}},
        {id = 's4', at = {n = 4, fp = 'speak to the following in any'},
         done = {
            {t = 'event', zone = 26, event = 557, why = 'Tressia 557: plays only once all four patrol members have been spoken to'},
         },
         reach = {
            {t = 'event', zone = 26, event = 549, why = 'Raminey 549'},
            {t = 'event', zone = 26, event = 551, why = 'Zadant 551'},
            {t = 'event', zone = 26, event = 553, why = 'Fouagine 553'},
            {t = 'event', zone = 26, event = 555, why = 'Noam 555'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to tressia j 6'},
         done = {
            {t = 'event', zone = 26, event = 565, why = 'Tressia 565: the report quiz, plays only once the order was solved (Prog 1)'},
            {t = 'event', zone = 26, event = 560, why = 'Mengrenaux 560: plays only at Prog 1'},
            {t = 'event', zone = 26, event = 561, why = 'Chemioue 561: plays only at Prog 1'},
         },
         reach = {{t = 'event', zone = 26, event = 557, why = 'Tressia 557: the order puzzle offered'}}},
        {id = 's6', kind = 'optional', at = {n = 6, fp = 'you will be asked to view'},
         done = {
            {t = 'event', zone = 26, event = 560, why = 'Mengrenaux 560: the reports'},
            {t = 'event', zone = 26, event = 561, why = 'Chemioue 561: the reports'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to tressia j 6 and'},
         done = {
            {t = 'event', zone = 26, event = 566, why = 'Tressia 566: plays only after the quiz was answered (Prog 2)'},
            {t = 'chat', re = "do you think you could go to the tributary and follow the criminal's trail%?", why = 'Tressia 566 (say #11765)'},
         },
         reach = {{t = 'event', zone = 26, event = 565, why = 'Tressia 565: the quiz (a wrong answer plays it too)'}}},
        {id = 's8', at = {n = 8, fp = 'follow the trail'},
         done = {
            {t = 'event', zone = 26, event = 558, why = 'qm5 in search of truth 558: the end of the trail, completes the log'},
            {t = 'quest', completed = true, why = 'quest log: completed (LandSandBoat completes it at 558)'},
            {t = 'ki', id = 718, gained = false, conf = 'inferred', why = 'Shaded Cruse taken'},
         },
         reach = {
            {t = 'ki', id = 718, gained = true, why = 'Shaded Cruse obtained at the first ???'},
            {t = 'ki_have', id = 718, have = true, why = 'Shaded Cruse held'},
         }},
        {id = 's9', kind = 'post', at = {n = 9, fp = 'return to tressia j 6 third'},
         done = {
            {t = 'event', zone = 26, event = 562, why = 'Tressia 562: plays only after the trail (Option 1)'},
            {t = 'chat', re = "Hey, thanks a lot for all you've done for us%.", why = 'Tressia 562 (say #11796)'},
         }},
        {id = 's10', kind = 'post', at = {n = 10, fp = 'go to ondieulix i 7 second'},
         done = {
            {t = 'event', zone = 26, event = 559, why = 'Ondieulix 559: the reward'},
            {t = 'chat', re = 'I heard of your deeds from Tressia%.', why = 'Ondieulix 559 (say #11802)'},
         }},
        {id = 's11', kind = 'note', with = 's10', at = {n = 11, fp = 'miledo shiraddo also appears in chameleon'}},
    },
}

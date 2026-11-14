-- Step progress for Food for Thought (Windurst quest 14). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Food_for_Thought.lua (Ohbiru-Dohbiru 308 is his hunger talk before the
-- quest, 309 the same again; Kerutoto 313, or 314 after a refusal, is the Do-a-food-run menu whose option 0 begins the quest,
-- so both are only reaches; the quest log's current bit proves bullet 2; Kerutoto 332 is the exact Grilled Hare trade at the
-- right progress; Kenapa-Keppa 327, 330 and 331 and Ohbiru-Dohbiru 322, 325 and 326 are the exact egg and the exact
-- tea, tortilla and kelp trades with or without the order, and each runs the same finish; a wrong trade plays Kenapa-Keppa
-- 329, a refusal; the last of the three deliveries completes the quest, which has gil, fame and a title as reward and
-- nothing to refuse). Bullet 3 (the two food orders) is optional: both trades are accepted without an order, so the orders
-- are left as an unproved optional step. The three deliveries can be made in any order but the page lists them in one, so
-- a delivery made out of order shows the ones before it as done; the quest log's completed bit completes bullet 6. Client
-- event scripts S4 238_Ohbiru_Dohbiru_010EE02D.txt (308 bare, 322 say #8070), 238_Kerutoto_010EE02F.txt (313 menu #8052, 332
-- say #8093) and 238_Kenapa_Keppa_010EE02E.txt (327 say #8082, 329 say #8086, 330 say #8088). Not repeatable (page meta). The
-- quest log is set at s2, so it is not silent.
return {
    title = 'Food for Thought',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ohbiru dohbiru in the'},
         done = {
            {t = 'event', zone = 238, event = 308, why = 'Ohbiru-Dohbiru 308: he mentions he is hungry'},
            {t = 'event', zone = 238, event = 309, conf = 'inferred', why = 'Ohbiru-Dohbiru 309: the same talk again, only after 308'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to the northern rhinostery building'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Kerutoto 313 or 314, option 0)'},
            {t = 'event', zone = 238, event = 315, conf = 'inferred', why = 'Kerutoto 315: his talk, only while accepted'},
         },
         reach = {
            {t = 'event', zone = 238, event = 313, why = 'Kerutoto 313 offered (its finish needs option 0)'},
            {t = 'event', zone = 238, event = 314, why = 'Kerutoto 314 offered (its finish needs option 0)'},
         }},
        {id = 's3', kind = 'optional', at = {n = 3, fp = 'speak to ohbiru dohbiru kenapa keppa'}, done = {}},
        {id = 's4', at = {n = 4, fp = 'trade kerutoto a grilled hare'},
         done = {
            {t = 'event', zone = 238, event = 332, why = 'Kerutoto 332: the Grilled Hare accepted'},
            {t = 'chat', re = 'I bet it was hard to come by!', why = 'Kerutoto 332 (say #8093)'},
            {t = 'event', zone = 238, event = 333, conf = 'inferred', why = 'Kerutoto 333: his talk once the hare is delivered'},
         }},
        {id = 's5', at = {n = 5, fp = 'trade kenapa keppa a hard boiled'},
         done = {
            {t = 'event', zone = 238, event = 327, why = 'Kenapa-Keppa 327: the Hard-boiled Egg accepted after the order'},
            {t = 'event', zone = 238, event = 330, why = 'Kenapa-Keppa 330: the Hard-boiled Egg accepted without the order'},
            {t = 'event', zone = 238, event = 331, why = 'Kenapa-Keppa 331: the Hard-boiled Egg accepted without the order'},
            {t = 'chat', re = 'You%.%.%.under%.%.%.stood%.%.%.me%.%.%.%?', why = 'Kenapa-Keppa 327 (say #8083)'},
         }},
        {id = 's6', at = {n = 6, fp = 'trade ohbiru dohbiru a pamtam kelp'},
         done = {
            {t = 'event', zone = 238, event = 322, why = 'Ohbiru-Dohbiru 322: the three foods accepted after the order'},
            {t = 'event', zone = 238, event = 325, why = 'Ohbiru-Dohbiru 325: the three foods accepted without the order'},
            {t = 'event', zone = 238, event = 326, why = 'Ohbiru-Dohbiru 326: the three foods accepted without the order'},
            {t = 'chat', re = 'Hey! These look good! I\'m glad I managed to keep waiting!', why = 'Ohbiru-Dohbiru 322 (say #8070)'},
            {t = 'quest', completed = true, why = 'quest log: completed (the last of the three deliveries)'},
            {t = 'event', zone = 238, event = 324, conf = 'inferred', why = 'Ohbiru-Dohbiru 324: his talk once his order is delivered'},
         }},
        {id = 's7', kind = 'note', with = 's6', at = {n = 7, fp = 'update no need to speak with'}},
    },
}

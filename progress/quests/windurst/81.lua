-- Step progress for The Puppet Master (Windurst quest 81). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/SMN_AF1_The_Puppet_Master.lua (the House of the Hero door 402 begins the quest with
-- no option test, 403 is its reminder; Juroro 256 hands out the Earth Pendulum and sets Prog 1 only if it can be given, so it is
-- a reach, while 253 (his reminder at Prog 1) and 257 (the pendulum re-issue) play only after it; 258 plays at Prog 2, after the
-- battlefield win, and sets Prog 3; Koru-Moru 404 runs quest:complete, which fails with a full bag after the cutscene played, so
-- it is a reach and the quest log carries the last bullet). Event 32001 in the Cloister of Tremors is any battlefield win there
-- (Trial by Earth uses it too), so the pendulum trade and the fight (bullet 4) have no signal of their own and stay a plain
-- bullet; the Quicksand Caves route (bullet 3) is a note on Juroro's second talk. Client event script S4 236_Juroro_010EC088.txt
-- (257 say #8599, #8600). Repeatable after a memory reset (page meta): the door 402 opens the next run. The quest log is set at
-- s1, so it is not silent.
-- Juroro 253 is also his default conversation (Port_Bastok DefaultActions): dropped.
-- Chat 'What a spacey-wacey individual' also plays at Gulmama 712 and Ripapa 10023 (Class Reunion, Carbuncle Debacle): dropped.
return {
    title = 'The Puppet Master',
    completes = 's6',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'while you are on summoner as'},
         done = {
            {t = 'event', zone = 239, event = 402, why = 'House of the Hero door 402: the quest begins'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 239, event = 403, conf = 'inferred', why = 'House of the Hero door 403: reminder, only once accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to juroro in port bastok'},
         done = {
            {t = 'event', zone = 236, event = 257, conf = 'inferred', why = 'Juroro 257: pendulum re-issue, only after it was given once'},
         },
         reach = {{t = 'event', zone = 236, event = 256, why = 'Juroro 256 (the pendulum needs a free slot)'}}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'make your way through the quicksand'}},
        {id = 's5', at = {n = 5, fp = 'speak to juroro again'},
         done = {
            {t = 'event', zone = 236, event = 258, why = 'Juroro 258: plays only at Prog 2, after the battlefield win'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to koru moru in windurst'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 239, event = 404, why = 'Koru-Moru 404 (completion needs a free slot for the reward)'}}},
    },
}

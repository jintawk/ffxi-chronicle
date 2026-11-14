-- Step progress for A Certain Substitute Patrolman (Adoulin quest 78). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/A_Certain_Substitute_Patrolman.lua (Rising Solstice 2550 begins the quest and
-- gives the Western Adoulin patrol route, no refusal; while accepted a plain talk is 2551; the seven patrol NPCs each play 2553 +
-- offset only when the quest's Prog equals their place in the order: Zaoso 2553, Clemmar 2554, Kongramm 2555, Virsaint 2556,
-- Shipilolo 2557, Dangueubert 2558, Nylene 2559 (the last, so only reached when the six before were done); Rising Solstice 2552
-- plays only at Prog 7, runs quest:complete and takes the route; the reward is bayld and experience, so no refusal). The wrong-
-- order talks play nothing. Client event scripts S4 256_Rising_Solstice_011000FB.txt (2550 say #7957, 2552 say #7996),
-- 256_Zaoso / Clemmar / Kongramm / Shipilolo / Dangueubert / Nylene (events 2553 to 2559 are only in their headers, no body;
-- LandSandBoat computes them as 2553 + offset, so check_steps cannot find a literal id). The bullet "speak to the following
-- NPCs in order" therefore stays a note on the return step: its seven sub-bullets are not steps, and the patrol talks are the
-- only signals of it. Key item 2274 from res/key_items.lua. Not repeatable.
return {
    title = 'A Certain Substitute Patrolman',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to rising solstice in western'},
         done = {
            {t = 'event', zone = 256, event = 2550, why = 'Rising Solstice 2550: the first talk, begins the quest'},
            {t = 'chat', re = "I don't have time for louses like y%.%.%.", why = 'Rising Solstice 2550 (say #7957)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 2274, gained = true, why = 'Western Adoulin patrol route obtained'},
            {t = 'ki_have', id = 2274, have = true, why = 'Western Adoulin patrol route held'},
            {t = 'chat', re = 'obtained key item: western adoulin patrol route', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak to the following npcs in'}},
        {id = 's3', at = {n = 3, fp = 'return to rising solstice for your'},
         done = {
            {t = 'event', zone = 256, event = 2552, why = 'Rising Solstice 2552: only at Prog 7, runs quest:complete'},
            {t = 'chat', re = "Speaking of trouble, everyone in the Peacekeepers' Coalition makes ridding our city of it their number one priority!", why = 'Rising Solstice 2552 (say #7996)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 2274, gained = false, why = 'Western Adoulin patrol route handed over'},
         }},
    },
}

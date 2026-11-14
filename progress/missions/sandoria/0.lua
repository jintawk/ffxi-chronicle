-- Step progress for Smash the Orcish Scouts (San d'Oria mission 1-1, mission id 0). Data only; see progress/quests/sandoria/27.lua
-- for the format. The first nation-mission mapping and the first user of the `mission` matcher.
-- Evidence: LandSandBoat scripts/missions/sandoria/1_1_Smash_the_Orcish_Scouts.lua. The three gate guards offer it (Ambrotien
-- 2000, Endracion 1000 in Southern San d'Oria 230, Grilau 1000 in Northern 231; the repeat offers are 2009/1009) and the accept is
-- option 0 of the final menu, so the offer event proves nothing alone (it plays on a decline too). What proves the accept is the
-- line the client says only on the accept branch (say #7250 in 230_Ambrotien_010E6062.txt, 230_Endracion_010E6061.txt and
-- 231_Grilau_010E7022.txt, same text in all three) and the nation line moving to the mission id (65535 = no mission before; the
-- line holds 0 while this mission is current; completing sets it back to 65535 and adds id 0 to the completed set). The trade is
-- Ambrotien 2020 / 2002, Endracion 1020 / 1002, Grilau 1020 / 1002 (first completion / repeat), played only when the Orcish Axe
-- (item 16656, res/items.lua) matched and the mission is current: refusals are 2008 and 2010 (wrong item, no mission), which are
-- not listed. Those events complete the mission in onEventFinish. Their bodies are not decoded in the pseudo-code, so there is no
-- client line for the completion; the event ids come from LandSandBoat and from each NPC's event list in the pseudo-code header.
-- The accept's mission matcher is completed = false: it matches the line moving to 0, not id 0 entering the completed set, so a
-- finished run's own log read cannot restart the run. It keeps run1 as well: after the Orcish Axe trade completes the run live,
-- the login snapshot still holds the stale current = 0 until the next 0x056 read, and an unconditioned matcher would restart the
-- run on it and wipe the last step. Restarts therefore ride on the accept dialogue alone; the line backfills run 1. The completes
-- step also carries mission completed = true, so a character that finished the mission before installing Chronicle shows both
-- steps done (the completed set read at login is history and never ticks a later run).
return {
    title = 'Smash the Orcish Scouts',
    completes = 's3',
    known = {{t = 'mission', line = 'sandoria', min = 0}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to any san d orian'},
         done = {
            {t = 'chat', re = 'Bring me one of those axes, and your mission will be a success%.', why = 'a gate guard, accepted (say #7250)'},
            {t = 'mission', line = 'sandoria', eq = 0, completed = false, run1 = true, why = 'mission line: current mission = Smash the Orcish Scouts'},
         },
         reach = {
            {t = 'event', zone = 230, event = 2000, why = 'Ambrotien 2000 offered (its finish needs option 0)'},
            {t = 'event', zone = 230, event = 1000, why = 'Endracion 1000 offered (its finish needs option 0)'},
            {t = 'event', zone = 231, event = 1000, why = 'Grilau 1000 offered (its finish needs option 0)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'go outside the city and kill'}},
        {id = 's3', at = {n = 3, fp = 'after you receive an orcish axe'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 0, completed = true, why = 'mission log: Smash the Orcish Scouts completed'},
            {t = 'event', zone = 230, event = 2020, why = 'Ambrotien 2020: the Orcish Axe accepted, first completion'},
            {t = 'event', zone = 230, event = 2002, why = 'Ambrotien 2002: the Orcish Axe accepted, repeat'},
            {t = 'event', zone = 230, event = 1020, why = 'Endracion 1020: the Orcish Axe accepted, first completion'},
            {t = 'event', zone = 230, event = 1002, why = 'Endracion 1002: the Orcish Axe accepted, repeat'},
            {t = 'event', zone = 231, event = 1020, why = 'Grilau 1020: the Orcish Axe accepted, first completion'},
            {t = 'event', zone = 231, event = 1002, why = 'Grilau 1002: the Orcish Axe accepted, repeat'},
         }},
    },
}

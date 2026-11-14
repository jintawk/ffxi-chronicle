-- Step progress for Wading Beasts (Bastok mission 2-2, mission id 4). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/bastok/2_2_Wading_Beasts.lua. The page has no accept bullet; the mission line moving to
-- id 4 (65535 = no mission before) only marks the mission as known. Obtaining the Lizard Egg has no signal of its own (a note).
-- Senator Alois (Metalworks, 237) takes the egg in a trade: 372 on the first completion, 373 on a repeat, played only when the
-- trade is exactly one Lizard Egg and the mission is current (a wrong trade plays nothing); onEventFinish completes the mission.
-- 372 has no body in 237_Alois_010ED01D.txt (it only ends), so there is no client line for the first completion; 373 says #7613.
return {
    title = 'Wading Beasts',
    completes = 's2',
    known = {{t = 'mission', line = 'bastok', eq = 4}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'obtain a lizard egg'}},
        {id = 's2', at = {n = 2, fp = 'once obtained trade the egg to'},
         done = {
            {t = 'mission', line = 'bastok', eq = 4, completed = true, why = 'mission log: Wading Beasts completed'},
            {t = 'event', zone = 237, event = 372, why = 'Alois 372: the Lizard Egg accepted, first completion'},
            {t = 'event', zone = 237, event = 373, why = 'Alois 373: the Lizard Egg accepted, repeat'},
            {t = 'chat', re = 'Uh%.%.%.I mean, this is very important to the safety of Bastok, yes!', why = 'Alois 373 (say #7613)'},
         }},
    },
}

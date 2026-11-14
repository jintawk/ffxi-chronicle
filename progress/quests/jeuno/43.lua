-- Step progress for Pretty Little Things (Jeuno quest 43). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Pretty_Little_Things.lua and scripts/zones/Port_Jeuno/npcs/Zona_Shodhun.lua
-- (Zona Shodhun plays event 10023 for every talk and trade and carries the case in P2: 10 a plain talk, 0 a bad trade, 1
-- a flower or another rock, 2 the Yellow Rock, 3/4/5 the same trades once completed; the first talk or trade of any kind
-- begins the quest, and the finish with option 4002 completes it and takes the rock; the reward has no item to refuse);
-- client event script S4 246_Zona_Shodhun_010F6040.txt (10023: L1 = P2, 10 is sub_0080 the talk, 2 is the Yellow Rock
-- branch, say #7188 in the Jeuno branch sub_05AB). LandSandBoat's P2 values are its own, so the quest log completion is
-- the proof that does not depend on them. Same shape as A Lady's Heart (Bastok quest 50). Not repeatable (page meta).
return {
    title = 'Pretty Little Things',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to zona shodhun to start'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (the first talk or trade)'},
            {t = 'event', zone = 246, event = 10023, p = {[2] = 10}, why = 'Zona Shodhun 10023, P2 = 10: a plain talk (LandSandBoat)'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'she won t come out and'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'yellow rock can be bought off'}},
        {id = 's4', at = {n = 4, fp = 'trade it to her to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 246, event = 10023, p = {[2] = 2}, why = 'Zona Shodhun 10023, P2 = 2: a Yellow Rock traded (LandSandBoat)'},
            {t = 'chat', re = 'Meooow! This is the one! This is the one!', why = 'Zona Shodhun 10023 (say #7188, Yellow Rock branch)'},
         }},
    },
}

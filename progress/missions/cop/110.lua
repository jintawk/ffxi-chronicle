-- Step progress for The Rites of Life (Chains of Promathia 1-1, mission id 110). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/1_1_The_Rites_of_Life.lua. Lower Delkfutt's Tower (184) event 39 is the last of the
-- chain 22 -> 36 -> 37 -> 38 -> 39 that only runs when the player starts the storyline, and its finish calls mission:begin, so it
-- (and the cop line moving to 110) proves bullet 1; the zone-in 22 plays on both start and postpone (option 1 starts, any other
-- postpones) and is not used. Upper Jeuno zone-in 2 plays only at status 1 (LandSandBoat). Monberaux 10 -> 206 -> 207 (Upper Jeuno
-- 244; 10 and 207 are listed in 244_Monberaux_010F4001.txt, bodies empty) complete the mission; the Mysterious amulet (a reward key
-- item) is not used. Bullet 4 is a note on the completing step; bullets 5 and 6 (postponed start) have no signal (the book's event 53
-- plays on a refusal too) and are left as plain bullets. The draft's zone-in 22 and the Rosaline / Auchefort reminder events are dropped.
return {
    title = 'The Rites of Life',
    completes = 's3',
    known = {{t = 'mission', line = 'cop', eq = 110}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to lower delkfutt s tower'},
         done = {
            {t = 'event', zone = 184, event = 39, why = 'Tales Beginning 39: the storyline started (chain 22 to 39, mission:begin)'},
            {t = 'mission', line = 'cop', eq = 110, completed = false, why = 'mission log: current mission = The Rites of Life'},
         }},
        {id = 's2', at = {n = 2, fp = 'zone into upper jeuno for another'},
         done = {
            {t = 'zonein', zone = 244, event = 2, why = 'Upper Jeuno zone-in cutscene 2 (status 1, LandSandBoat)'},
         }},
        {id = 's3', at = {n = 3, fp = 'go to the infirmary in upper'},
         done = {
            {t = 'mission', line = 'cop', eq = 110, completed = true, why = 'mission log: The Rites of Life completed'},
            {t = 'event', zone = 244, event = 10, why = 'Monberaux 10 (status 2)'},
            {t = 'event', zone = 244, event = 207, why = 'Monberaux 207: completes the mission'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'after the cutscene you will receive'}},
    },
}

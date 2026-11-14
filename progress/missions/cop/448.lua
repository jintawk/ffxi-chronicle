-- Step progress for The Enduring Tumult of War (Chains of Promathia 5-1, mission id 448). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/5_1_The_Enduring_Tumult_of_War.lua and zones/PsoXja/npcs/_i98.lua; client scripts
-- 232_Anoki_010E8018.txt (events 724 and 728, say #8449 and #8453), 231_Chasalvige_010E70F9.txt (761), 026_Despachiaire_0101A009.txt
-- (117), 237_Cid_010ED02B.txt (849); bodies empty except Anoki's. Optional talks (each plays once, status 0): Despachiaire 117,
-- Chasalvige 761, Anoki 724 and 728. Port Bastok zone-in 306 (status 0), Cid 849 (status 1), the Pso'Xja zone-in 1 (status 2, from
-- Beaucedine at x = -300; LandSandBoat's id), the Stone Gate _i98 events 69 / 70 (status 4, also replayed after the mission), and
-- the Promyvion - Vahzl zone-in 50 (status 4), which hands over the amulet and light of Vahzl and completes the mission. The Stone
-- Door's golem (bullet 9) and the elevator (11) have no event; the last Stone Door (_i99, event 2) needs option 1 to enter and plays
-- on a decline, so bullet 12 is a note with the zone-in on bullet 13. Bullet 2 has no event. Cid 863 (reminder) dropped.
return {
    title = 'The Enduring Tumult of War',
    completes = 's13',
    known = {{t = 'mission', line = 'cop', eq = 448}},
    steps = {
        {id = 's1', kind = 'optional', at = {n = 1, fp = 'optional speak to despachiaire through the'},
         done = {
            {t = 'event', zone = 26, event = 117, why = 'Despachiaire 117: the optional cutscene (status 0, first time only)'},
         }},
        {id = 's3', kind = 'optional', at = {n = 3, fp = 'optional speak to chasalvige in northern'},
         done = {
            {t = 'event', zone = 231, event = 761, why = 'Chasalvige 761: the optional cutscene (status 0, first time only)'},
         }},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'optional head to port san d'},
         done = {
            {t = 'event', zone = 232, event = 724, why = 'Anoki 724: the first optional cutscene (status 0, first time only)'},
            {t = 'chat', re = 'Wh%-when will the airship from Tavnazia arrive!%?', why = 'Anoki 724 (say #8449)'},
         }},
        {id = 's5', kind = 'optional', at = {n = 5, fp = 'optional speak to anoki a second'},
         done = {
            {t = 'event', zone = 232, event = 728, why = 'Anoki 728: the second optional cutscene (status 0, after 724)'},
            {t = 'chat', re = 'Are you still going on about that imaginary airship%?', why = 'Anoki 728 (say #8453)'},
         }},
        {id = 's6', at = {n = 6, fp = 'zone into port bastok for a'},
         done = {
            {t = 'zonein', zone = 236, event = 306, why = 'Port Bastok zone-in cutscene 306 (status 0 only, LandSandBoat)'},
         }},
        {id = 's7', at = {n = 7, fp = 'speak with cid in the metalworks'},
         done = {
            {t = 'event', zone = 237, event = 849, why = 'Cid 849 (status 1 only)'},
         }},
        {id = 's8', at = {n = 8, fp = 'travel to the nue tower at'},
         done = {
            {t = 'zonein', zone = 9, event = 1, why = "Pso'Xja zone-in cutscene 1 (status 2, from Beaucedine Glacier, LandSandBoat)"},
         }},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'move ahead until you reach the'}},
        {id = 's10', at = {n = 10, fp = 'check the stone door again once'},
         done = {
            {t = 'event', zone = 9, event = 69, why = "Stone Gate 69 in Pso'Xja (status 4, LandSandBoat)"},
            {t = 'event', zone = 9, event = 70, why = "Stone Gate 70 in Pso'Xja (status 4, the far side of the gate, LandSandBoat)"},
         }},
        {id = 's11', kind = 'note', with = 's13', at = {n = 11, fp = 'in the next room take the'}},
        {id = 's12', kind = 'note', with = 's13', at = {n = 12, fp = 'follow the path here until you'}},
        {id = 's13', at = {n = 13, fp = 'you will get another cutscene upon'},
         done = {
            {t = 'mission', line = 'cop', eq = 448, completed = true, why = 'mission log: The Enduring Tumult of War completed'},
            {t = 'zonein', zone = 22, event = 50, why = 'Promyvion - Vahzl zone-in cutscene 50: completes (status 4, LandSandBoat)'},
         }},
    },
}

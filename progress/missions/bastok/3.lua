-- Step progress for The Crystal Line (Bastok mission 2-1, mission id 3). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/bastok/2_1_The_Crystal_Line.lua. The four mission givers offer it through event 1001, a
-- menu whose description lines and accept menu play on a decline too, so only the nation line moving to id 3 proves the accept
-- (65535 = no mission before; completing sets it back to 65535 and adds id 3 to the completed set). Cid (237): event 505 is the first
-- talk (he explains and hands over a crystal), event 506 is the Faded Crystal trade (played only for that trade while the mission is
-- at status 1) and gives the C. L. report (key item 12, res/key_items.lua). Ayame's event 712 (played only with the report held)
-- completes the mission and takes the report. Naji's 711 only sends the player on to Ayame, so it proves nothing. Bodies of 506 are
-- not decoded in the pseudo-code (237_Cid_010ED02B.txt lists it); 712 is in 237_Ayame_010ED02F.txt.
return {
    title = 'The Crystal Line',
    completes = 's3',
    known = {{t = 'mission', line = 'bastok', eq = 3}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'trade enough crystals to the conquest'},
         done = {
            {t = 'mission', line = 'bastok', eq = 3, completed = false, why = 'mission line: current mission = The Crystal Line'},
         }},
        {id = 's2', at = {n = 2, fp = 'you will have to obtain a'},
         done = {
            {t = 'event', zone = 237, event = 506, why = 'Cid 506: the Faded Crystal accepted'},
            {t = 'ki', id = 12, gained = true, why = 'C. L. report obtained'},
            {t = 'ki_have', id = 12, have = true, why = 'C. L. report held'},
            {t = 'chat', re = 'obtained key item: c%. l%. report', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 237, event = 505, why = 'Cid 505: first talk, the crystal handed over'}}},
        {id = 's3', at = {n = 3, fp = 'speak to ayame in the cannonry'},
         done = {
            {t = 'mission', line = 'bastok', eq = 3, completed = true, why = 'mission log: The Crystal Line completed'},
            {t = 'event', zone = 237, event = 712, why = 'Ayame 712: the report handed over, mission completed'},
            {t = 'chat', re = 'You have a letter from the Chief Engineer%?', why = 'Ayame 712 (say #7603)'},
            {t = 'ki', id = 12, gained = false, why = 'C. L. report handed over'},
         }},
    },
}

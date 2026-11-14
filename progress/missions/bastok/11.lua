-- Step progress for To the Forsaken Mines (Bastok mission 3-2, mission id 11). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/bastok/3_2_To_the_Forsaken_Mines.lua. The page has no accept bullet; the nation line
-- moving to id 11 (65535 = no mission before; completing sets it back to 65535 and adds id 11 to the completed set) only marks
-- the mission as known. Davyad (Bastok Mines 234) plays event 54 as a plain talk once the mission is current (client text
-- 234_Davyad_010EA028.txt, say #10754). Trading the hare meat to the ??? in Gusgen Mines leaves only server messages, and the
-- glocolite drops from Blind Moby, so bullets 1, 3, 4 and 5 are notes. The Glocolite is traded to any of the four mission givers
-- (Rashid 234, Cleades 235, Argus 236, Malduc 237): event 1010 on the first completion, 1006 on a repeat, played only when the
-- trade is exactly one Glocolite while the mission is current (a wrong trade plays nothing); onEventFinish completes the mission.
-- Their bodies are not in the pseudo-code; both ids are in each NPC's event list.
return {
    title = 'To the Forsaken Mines',
    completes = 's6',
    known = {{t = 'mission', line = 'bastok', eq = 11}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'obtain a hare meat'}},
        {id = 's2', at = {n = 2, fp = 'speak to davyad k 6 in'},
         done = {
            {t = 'event', zone = 234, event = 54, why = 'Davyad 54: the Gusgen Mines briefing'},
            {t = 'chat', re = "I should warn you, it's not worth the risk%.", why = 'Davyad 54 (say #10754)'},
         }},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'head to gusgen mines or survival'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'once inside the mines follow these'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'trade the hare meat to the'}},
        {id = 's6', at = {n = 6, fp = 'trade the glocolite to any gate'},
         done = {
            {t = 'mission', line = 'bastok', eq = 11, completed = true, why = 'mission log: To the Forsaken Mines completed'},
            {t = 'event', zone = 234, event = 1010, why = 'Rashid 1010: the Glocolite accepted, first completion'},
            {t = 'event', zone = 234, event = 1006, why = 'Rashid 1006: the Glocolite accepted, repeat'},
            {t = 'event', zone = 235, event = 1010, why = 'Cleades 1010: the Glocolite accepted, first completion'},
            {t = 'event', zone = 235, event = 1006, why = 'Cleades 1006: the Glocolite accepted, repeat'},
            {t = 'event', zone = 236, event = 1010, why = 'Argus 1010: the Glocolite accepted, first completion'},
            {t = 'event', zone = 236, event = 1006, why = 'Argus 1006: the Glocolite accepted, repeat'},
            {t = 'event', zone = 237, event = 1010, why = 'Malduc 1010: the Glocolite accepted, first completion'},
            {t = 'event', zone = 237, event = 1006, why = 'Malduc 1006: the Glocolite accepted, repeat'},
         }},
    },
}

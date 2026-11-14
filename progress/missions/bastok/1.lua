-- Step progress for A Geological Survey (Bastok mission 1-2, mission id 1). Data only; see progress/missions/sandoria/0.lua for the
-- format and progress/quests/sandoria/27.lua for the quest model.
-- Evidence: LandSandBoat scripts/missions/bastok/1_2_A_Geological_Survey.lua. The four mission givers (Rashid 234, Cleades 235,
-- Argus 236, Malduc 237) offer it through event 1001, a menu of every mission whose description lines and "Will you accept this
-- mission?" menu (#7384) play on a decline too (236_Argus_010EC001.txt), so nothing about the offer proves the accept:
-- the nation line moving to id 1 does (65535 = no mission before; completing sets it back to 65535 and adds id 1 to the completed
-- set). Cid (237) event 503 hands over the Blue acidity tester (key item 3, res/key_items.lua; played only with neither tester held),
-- the geyser events in Dangruf Wadi (10, 11, 12) swap it for the Red acidity tester (key item 4) only when the Blue one is held, and
-- Cid event 504 (played only with the Red tester held) completes the mission and takes the Red tester. The bodies of 503 and 504 are
-- not decoded in the client pseudo-code; their ids come from LandSandBoat and Cid's event list in 237_Cid_010ED02B.txt.
return {
    title = 'A Geological Survey',
    completes = 's6',
    known = {{t = 'mission', line = 'bastok', eq = 1}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to any bastokan gate guard'},
         done = {
            {t = 'mission', line = 'bastok', eq = 1, completed = false, why = 'mission line: current mission = A Geological Survey'},
         }},
        {id = 's2', at = {n = 2, fp = 'go to cid s lab at'},
         done = {
            {t = 'event', zone = 237, event = 503, why = 'Cid 503: the Blue acidity tester handed over'},
            {t = 'ki', id = 3, gained = true, why = 'Blue acidity tester obtained'},
            {t = 'ki_have', id = 3, have = true, why = 'Blue acidity tester held'},
            {t = 'chat', re = 'obtained key item: blue acidity tester', why = 'chat: key item obtained'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'head to d 9 in south'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'once you enter the zone turn'}},
        {id = 's5', at = {n = 5, fp = 'in the south east corner of'},
         done = {
            {t = 'ki', id = 4, gained = true, why = 'Red acidity tester obtained (the geyser swapped it for the Blue one)'},
            {t = 'ki_have', id = 4, have = true, why = 'Red acidity tester held'},
            {t = 'chat', re = 'obtained key item: red acidity tester', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to cid for a cutscene'},
         done = {
            {t = 'mission', line = 'bastok', eq = 1, completed = true, why = 'mission log: A Geological Survey completed'},
            {t = 'event', zone = 237, event = 504, why = 'Cid 504: the mission completed, the Red acidity tester taken'},
            {t = 'ki', id = 4, gained = false, why = 'Red acidity tester handed over'},
         }},
    },
}

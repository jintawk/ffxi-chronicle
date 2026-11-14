-- Step progress for Darkness Rising (Bastok mission 5-1, mission id 14). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/bastok/5_1_Darkness_Rising.lua. Accepting is done at a gate guard (menu option 14) or by
-- Naji's event 720 (option 0); event 720 also plays on a decline (status 8), so only the nation line moving to id 14 proves the
-- accept (65535 = no mission before; completing sets it back to 65535 and adds id 14 to the completed set). Naji 721 (played
-- once the mission is at status 9, i.e. accepted at a guard) hands over the New Fei'Yin seal (key item 72, res/key_items.lua); the
-- Fei'Yin (204) zone-in cutscene 1 plays only at status 10; winning the Qu'Bia Arena battlefield gives the Burnt seal (73) and takes
-- the New Fei'Yin seal; Naji 722 (played only at status 12 with the Burnt seal) completes the mission and takes the seal. Bodies of
-- Naji 721 and 722 are not decoded in the client scripts; the ids come from LandSandBoat. Bullets 1 and 7 are notes.
return {
    title = 'Darkness Rising',
    completes = 's6',
    known = {{t = 'mission', line = 'bastok', eq = 14}},
    steps = {
        {id = 's1', kind = 'note', with = 's5', at = {n = 1, fp = 'players who are on the same'}},
        {id = 's2', at = {n = 2, fp = 'speak to a gate guard you'},
         done = {
            {t = 'mission', line = 'bastok', eq = 14, completed = false, why = 'mission line: current mission = Darkness Rising'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to naji for a cutscene'},
         done = {
            {t = 'event', zone = 237, event = 721, why = 'Naji 721: the New Fei Yin seal handed over'},
            {t = 'ki', id = 72, gained = true, why = 'New Fei Yin seal obtained'},
            {t = 'chat', re = "obtained key item: new fei'yin seal", why = 'chat: key item obtained'},
         },
         reach = {
            {t = 'event', zone = 237, event = 720, why = 'Naji 720 offered (its finish needs option 0)'},
         }},
        {id = 's4', at = {n = 4, fp = 'go to fei yin located in'},
         done = {
            {t = 'zonein', zone = 204, event = 1, why = 'Fei Yin zone-in cutscene 1 (played only at status 10)'},
         }},
        {id = 's5', at = {n = 5, fp = 'head to qu bia arena at'},
         done = {
            {t = 'ki', id = 73, gained = true, why = 'Burnt seal obtained at the Qu Bia Arena win'},
            {t = 'ki', id = 72, gained = false, why = 'New Fei Yin seal taken at the win'},
            {t = 'chat', re = 'obtained key item: burnt seal', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to naji to complete the'},
         done = {
            {t = 'mission', line = 'bastok', eq = 14, completed = true, why = 'mission log: Darkness Rising completed'},
            {t = 'event', zone = 237, event = 722, why = 'Naji 722: the Burnt seal handed over, the mission completed'},
            {t = 'ki', id = 73, gained = false, why = 'Burnt seal handed over'},
         }},
        {id = 's7', kind = 'note', with = 's6', at = {n = 7, fp = 'zoning to metalworks directly after finishing'}},
    },
}

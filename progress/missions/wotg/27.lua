-- Step progress for Another World (Wings of the Goddess mission id 27). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/28_Another_World.lua. Southern San d'Oria (230) zone-in cutscene 945 plays only while the
-- mission is current and you arrive from East Ronfaure (its finish sets Prog 1); Halver (Chateau d'Oraguille 233) event 566 plays at Prog 1
-- and its finish completes the mission (listed in the client's 233_Halver_010E9007.txt, body not decoded). The wotg line carries the
-- mission id while current and adds it to the completed set on completion.
return {
    title = 'Another World',
    completes = 's2',
    known = {{t = 'mission', line = 'wotg', eq = 27}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter southern san d oria from'},
         done = {
            {t = 'zonein', zone = 230, event = 945, why = "Southern San d'Oria zone-in cutscene 945 (from East Ronfaure, LandSandBoat)"},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to halver in chateau d'},
         done = {
            {t = 'mission', line = 'wotg', eq = 27, completed = true, why = 'mission log: Another World completed'},
            {t = 'event', zone = 233, event = 566, why = 'Halver 566 (Prog 1): completes the mission'},
         }},
    },
}

-- Step progress for Morimar (Seekers of Adoulin mission 4-3-1, mission id 278). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/soa/4_3_1_Morimar.lua and the client script S4 267_Alpine_Trail_0110B18E. The Alpine
-- Trail (Kamihr Drifts 267) plays event 46 while this mission is current, a "Proceed?" Yes/No menu, so it plays on a refusal too
-- and is only `reach`; its line ("This path seems to lead toward the summit of Mount Kamihr.") also plays on refusal and for the
-- earlier missions' events 44 and 45, so it is not used. On Yes the player is taken to Mount Kamihr (282) where zone-in 3 plays
-- (no client script decodes it); its finish completes the mission, and it plays only after the Yes. The adoulin line has no
-- completed set (`min = 279`). The Notes bullets about the crests are page notes, not steps.
return {
    title = 'Morimar',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 278}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to kamihr drifts and examine'},
         done = {
            {t = 'zonein', zone = 282, event = 3, why = 'Mount Kamihr zone-in 3 after the Yes, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 279, why = 'mission log: the line moved past Morimar'},
         },
         reach = {
            {t = 'event', zone = 267, event = 46, why = 'Alpine Trail 46: the Proceed? menu (also plays on a refusal)'},
         }},
    },
}

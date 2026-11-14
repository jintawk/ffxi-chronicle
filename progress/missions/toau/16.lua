-- Step progress for Guests of the Empire (Treasures of Aht Urhgan mission 17, mission id 16). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/17_Guests_of_the_Empire.lua, all in Aht Urhgan Whitegate (zone 50). Naja Salaheem 3076
-- is a progress event at status 0 (or 1 when properly dressed) and every finish advances the status (option 0 approves the gear, any other
-- option is the dress-up and sets status 1), so it proves the first talk; playing dress-up is inside the same cutscene and the
-- explanation bullet is dialogue, so both are notes. Naja 3077 plays only at status 2, after the gear was approved (bullet 4). The
-- Imperial Whitegate 3078 plays only at status 2 with both hands empty and the right armour, and its finish completes the mission; the
-- reminder 3081 is not used. The Imperial Mythril Piece (a reward item) is not used.
-- A full bag fails mission:complete (it gives the Imperial Mythril Piece first) and 3078 replays, so event 3078 is reach; the completed bit carries s5.
return {
    title = 'Guests of the Empire',
    completes = 's5',
    known = {{t = 'mission', line = 'toau', eq = 16}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to naja salaheem for a'},
         done = {
            {t = 'event', zone = 50, event = 3076, why = 'Naja Salaheem 3076: the cutscene (status 0, or 1 when properly dressed)'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'play dress up with naja salaheem'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'before you can continue naja salaheem'}},
        {id = 's4', at = {n = 4, fp = 'make sure to speak with her'},
         done = {
            {t = 'event', zone = 50, event = 3077, why = 'Naja Salaheem 3077: the approved-gear scene (status 2 only)'},
         }},
        {id = 's5', at = {n = 5, fp = 'check the imperial whitegate door at'},
         done = {
            {t = 'mission', line = 'toau', eq = 16, completed = true, why = 'mission log: Guests of the Empire completed'},
         },
         reach = {
            {t = 'event', zone = 50, event = 3078, why = 'Imperial Whitegate 3078: the palace cutscene (a full bag fails the completion and it replays)'},
         }},
    },
}

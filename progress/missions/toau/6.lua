-- Step progress for Westerly Winds (Treasures of Aht Urhgan mission 7, mission id 6). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/07_Westerly_Winds.lua, both in Aht Urhgan Whitegate (zone 50). The Teahouse trigger area
-- plays 3027 only at status 0; its finish gives Raillefal's note (key item 788) and the Imperial Silver Piece only with a free slot,
-- otherwise nothing changes, so the event is `reach` and the note (an intermediate key item that Naja takes again, not the mission's
-- reward) proves the step. Naja Salaheem 3028 (status 1 only) completes the mission. The silver piece is a reward item and is not used.
-- A full bag fails mission:complete (it gives the silver piece first) and 3028 replays, so event 3028 is reach; the completed bit carries s2.
return {
    title = 'Westerly Winds',
    completes = 's2',
    known = {{t = 'mission', line = 'toau', eq = 6}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to the shararat teahouse k'},
         done = {
            {t = 'ki', id = 788, gained = true, why = "Raillefal's note obtained"},
            {t = 'ki_have', id = 788, have = true, why = "Raillefal's note held"},
            {t = 'chat', re = "obtained key item: raillefal's note", why = 'chat: key item obtained'},
         },
         reach = {
            {t = 'event', zone = 50, event = 3027, why = 'Teahouse trigger area 3027 (no effect with a full inventory)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to naja salaheem i 10'},
         done = {
            {t = 'mission', line = 'toau', eq = 6, completed = true, why = 'mission log: Westerly Winds completed'},
         },
         reach = {
            {t = 'event', zone = 50, event = 3028, why = 'Naja Salaheem 3028 offered (a full bag fails the completion and it replays)'},
         }},
    },
}

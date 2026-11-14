-- Step progress for Leaute's Last Wishes (San d'Oria mission 6-1, mission id 16). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/6_1_Leautes_Last_Wishes.lua; client event script S4 233_Halver_010E9007.txt
-- (25: say #6733; 24: say #6747; 22: say #6748); key item 268 dreamrose (res/key_items.lua); zone text FEEL_SOMETHING_PRICKLY
-- (Western Altepa Desert IDs.lua, 7392) when the Dreamrose is checked and the Sabotender Enamorado spawns.
-- Halver 25 (status 0 -> 1), the Great Hall door 87 (status 1 -> 2, the king asks for the Dreamrose), Halver 24 (status 2, a reminder of
-- where to go: the server does not need it, so the step is optional), the Dreamrose (status 3 and the key item), Halver 22 (status 3 -> 4)
-- and the Chateau garden trigger area 111 (status 4 with the dreamrose; completes, takes it) are this mission's own events in zone 233.
-- Halver 23 and Arsha/Chupaile 85/86 only play on a repeat talk at status 1 and are not used. The door 87 and trigger area 111 have no
-- decoded body, so their ids come from LandSandBoat (87 is also a quest event, but at Deraquien in zone 230). The piece of paper is a reward
-- and is not used. Bullet 1 is the zoning note that follows the gate guard's offer.
return {
    title = "Leaute's Last Wishes",
    completes = 's9',
    known = {{t = 'mission', line = 'sandoria', min = 16}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you must zone after this cutscene'}},
        {id = 's2', at = {n = 2, fp = 'head to chateau d oraguille and'},
         done = {
            {t = 'event', zone = 233, event = 25, why = 'Halver 25 (status 0, plays once)'},
            {t = 'chat', re = 'your mission has been issued by the late Queen Leaute herself%.', why = 'Halver 25 (say #6733)'},
         }},
        {id = 's3', at = {n = 3, fp = 'select the great hall door for'},
         done = {
            {t = 'event', zone = 233, event = 87, why = 'Door: Great Hall 87 (status 1, LandSandBoat)'},
         }},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'speak with halver again'},
         done = {
            {t = 'event', zone = 233, event = 24, why = 'Halver 24 (status 2 only)'},
            {t = 'chat', re = 'You are to retrieve', why = 'Halver 24 (say #6747)'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'go to g 7 in western'}},
        {id = 's6', at = {n = 6, fp = 'check the dreamrose to spawn sabotender'},
         done = {
            {t = 'chat', re = 'You feel something prickly', why = 'the Dreamrose checked, Sabotender Enamorado spawns (Western Altepa Desert text 7392)'},
         }},
        {id = 's7', at = {n = 7, fp = 'check the dreamrose after defeating the'},
         done = {
            {t = 'ki', id = 268, gained = true, why = 'dreamrose obtained'},
            {t = 'ki_have', id = 268, have = true, why = 'dreamrose held'},
            {t = 'chat', re = 'obtained key item: dreamrose', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'return to halver'},
         done = {
            {t = 'event', zone = 233, event = 22, why = 'Halver 22 (status 3, needs the dreamrose done)'},
            {t = 'chat', re = 'The queen is sure to be pleased%.', why = 'Halver 22 (say #6748)'},
         }},
        {id = 's9', at = {n = 9, fp = 'go toward the garden at f'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 16, completed = true, why = "mission log: Leaute's Last Wishes completed"},
            {t = 'event', zone = 233, event = 111, why = 'Chateau garden trigger area 111 (status 4 with the dreamrose, completes)'},
         }},
    },
}

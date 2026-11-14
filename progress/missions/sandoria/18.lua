-- Step progress for Prestige of the Papsque (San d'Oria mission 7-1, mission id 18). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/7_1_Prestige_of_the_Papsque.lua; key item 283 ancient San d'Orian tablet
-- (res/key_items.lua); West Ronfaure zone text SOMETHING_IS_AMISS (IDs.lua, 7907). The Papal Chambers door (_6fc, Northern San d'Oria 231)
-- plays 7 at status 0 (-> 1) and 8 at the end (needs the tablet; completes, takes it); 9 is the reminder at status 1 and is not used.
-- The ??? (qm4, West Ronfaure) says "Something is amiss." when it spawns Marauder Dvogzog and gives the tablet on the second check.
-- The door events 7 and 8 have no decoded body, so their ids come from LandSandBoat.
return {
    title = 'Prestige of the Papsque',
    completes = 's6',
    known = {{t = 'mission', line = 'sandoria', min = 18}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to the cathedral in northern'},
         done = {
            {t = 'event', zone = 231, event = 7, why = 'Papal Chambers door 7 (status 0, LandSandBoat)'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'if you re low level form'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head to bostaunieux oubliette which can'}},
        {id = 's4', at = {n = 4, fp = 'when prepared check the to spawn'},
         done = {
            {t = 'chat', re = 'Something is amiss%.', why = 'the ??? checked, Marauder Dvogzog spawns (West Ronfaure text 7907)'},
         }},
        {id = 's5', at = {n = 5, fp = 'check the again to receive the'},
         done = {
            {t = 'ki', id = 283, gained = true, why = "ancient San d'Orian tablet obtained"},
            {t = 'ki_have', id = 283, have = true, why = "ancient San d'Orian tablet held"},
            {t = 'chat', re = "obtained key item: ancient san d.orian tablet", why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to the cathedral and visit'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 18, completed = true, why = 'mission log: Prestige of the Papsque completed'},
            {t = 'event', zone = 231, event = 8, why = 'Papal Chambers door 8 (needs the tablet, completes; LandSandBoat)'},
         }},
        {id = 's7', kind = 'note', with = 's6', at = {n = 7, fp = 'unity warp if you have dropped'}},
        {id = 's8', kind = 'note', with = 's6', at = {n = 8, fp = 'proto waypoint the west ronfaure proto'}},
    },
}

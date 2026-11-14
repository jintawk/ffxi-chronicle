-- Step progress for Meeting of the Minds (Seekers of Adoulin mission 1-7, mission id 126). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/1_7_Meeting_of_the_Minds.lua and the client script S4 257_Ploh_Trishbahk_0110108E.
-- Ploh Trishbahk plays 1500 only between 15:00 and 22:00; its finish takes the Dinner invitation (key item 2200, a temporary one
-- that nothing else removes) and completes the mission. Outside those hours he plays 1501 ("entrance is not permitted except
-- between the hours of 15:00 and 22:00") and keeps the key item, so 1501 proves nothing. The adoulin line has no completed set,
-- so the completion is `min = 127`. The draft's `completed = true` matcher is dropped.
return {
    title = 'Meeting of the Minds',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 126}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to ploh trishbahk at the'},
         done = {
            {t = 'event', zone = 257, event = 1500, why = 'Ploh Trishbahk 1500: the dinner scene, its finish completes the mission'},
            {t = 'ki', id = 2200, gained = false, why = 'Dinner invitation handed over'},
            {t = 'mission', line = 'adoulin', min = 127, why = 'mission log: the line moved past Meeting of the Minds'},
         }},
    },
}

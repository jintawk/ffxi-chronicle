-- Step progress for Cait Sith (Wings of the Goddess mission 3, mission id 2). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/03_Cait_Sith.lua. The mission is one zone-in: entering Southern San d'Oria [S]
-- (zone 80) from East Ronfaure [S] while it is current plays cutscene 67, and its finish calls mission:complete (the title Cait
-- Sith's Assistant is the reward). Bullet 2 is that step (it names both zones and says the walk-in is required); bullet 1 says how
-- the mission is triggered and what to finish first, a note on it. The cutscene is a zone-in event with a previous-zone and a
-- mission condition in LandSandBoat, and it is the event that completes the mission, so it is used. The draft left the zone-in
-- unplaced and made bullet 1 a step with the log's "current mission = 2" as its only proof; fixed.
return {
    title = 'Cait Sith',
    completes = 's2',
    known = {{t = 'mission', line = 'wotg', eq = 2}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'this mission is triggered by clicking'}},
        {id = 's2', at = {n = 2, fp = 'after finishing any pair of national'},
         done = {
            {t = 'zonein', zone = 80, event = 67, why = 'Southern San d\'Oria [S] zone-in cutscene 67 from East Ronfaure [S]: completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 2, completed = true, why = 'mission log: Cait Sith completed'},
         }},
    },
}

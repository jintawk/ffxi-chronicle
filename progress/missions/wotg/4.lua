-- Step progress for While the Cat is Away (Wings of the Goddess mission 5, mission id 4). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/05_While_the_Cat_is_Away.lua. The mission is one zone-in: entering East Ronfaure [S]
-- (zone 81) from Southern San d'Oria [S] while it is current plays cutscene 7, and its finish calls mission:complete. Bullet 2
-- is that step; bullets 1 and 3 say how the mission begins and what follows, notes on it. The cutscene has a previous-zone and a
-- mission condition in LandSandBoat and is the event that completes the mission. The draft made bullet 1 a step proven by the log's
-- "current mission = 4" and left the zone-in unplaced; fixed.
return {
    title = 'While the Cat is Away',
    completes = 's2',
    known = {{t = 'mission', line = 'wotg', eq = 4}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'begins automatically at the last cutscene'}},
        {id = 's2', at = {n = 2, fp = 'zone into east ronfaure s from'},
         done = {
            {t = 'zonein', zone = 81, event = 7, why = 'East Ronfaure [S] zone-in cutscene 7 from Southern San d\'Oria [S]: completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 4, completed = true, why = 'mission log: While the Cat is Away completed'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'the next mission will be triggered'}},
    },
}

-- Step progress for A Timeswept Butterfly (Wings of the Goddess mission 6, mission id 5). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/06_A_Timeswept_Butterfly.lua. The mission is one zone-in: entering La Vaule [S]
-- (zone 85) from Jugner Forest [S] while it is current plays cutscene 1, and its finish calls mission:complete. Bullet 1 is that
-- step; bullets 2 and 3 are the two ways there (Survival Guide to Jugner Forest [S], or Vunkerl Inlet [S]), notes on it. The
-- cutscene has a previous-zone and a mission condition in LandSandBoat and is the event that completes the mission. The draft made
-- every bullet a note on itself and left the zone-in unplaced; fixed.
return {
    title = 'A Timeswept Butterfly',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 5}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into la vaule s'},
         done = {
            {t = 'zonein', zone = 85, event = 1, why = 'La Vaule [S] zone-in cutscene 1 from Jugner Forest [S]: completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 5, completed = true, why = 'mission log: A Timeswept Butterfly completed'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'the fastest way is to take'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'otherwise you ll have to zone'}},
    },
}

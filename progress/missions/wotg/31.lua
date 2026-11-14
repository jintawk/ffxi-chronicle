-- Step progress for Storm's Crescendo (Wings of the Goddess mission id 31). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/32_Storms_Crescendo.lua. Rally Point: Blue (Xarcabard [S] 137) plays event 19 at Status 0
-- (gives the Alchemical signal flare, key item 1238) and event 26 re-gives a lost flare at Status 1. The Excavated Snow starts the
-- battlefield (LandSandBoat notes "Event 28" without a handler, so it is not used: an entry event may play on a decline). After the
-- fight the zone-in cutscene 20 plays at Status 2, Rally Point: Red plays event 23 at Status 3, and zone-in cutscene 39 at Status 4
-- completes the mission. The page has no bullet for those last two, so every one of them proves bullet 3 (the fight). Bullets 1, 4, 5,
-- 6 and 7 are tips about the fight. No client script exists for these ids.
return {
    title = "Storm's Crescendo",
    completes = 's3',
    known = {{t = 'mission', line = 'wotg', eq = 31}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'having 1 player from your party'}},
        {id = 's2', at = {n = 2, fp = 'examine the rally point blue at'},
         done = {
            {t = 'event', zone = 137, event = 19, why = 'Rally Point: Blue 19 (Status 0)'},
            {t = 'event', zone = 137, event = 26, why = 'Rally Point: Blue 26 (Status 1, flare lost): the flare again'},
            {t = 'ki', id = 1238, gained = true, why = 'Alchemical signal flare obtained'},
            {t = 'ki_have', id = 1238, have = true, why = 'Alchemical signal flare held'},
            {t = 'chat', re = 'obtained key item: alchemical signal flare', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'examine the excavated snow to your'},
         done = {
            {t = 'mission', line = 'wotg', eq = 31, completed = true, why = "mission log: Storm's Crescendo completed"},
            {t = 'zonein', zone = 137, event = 20, why = 'Xarcabard [S] zone-in cutscene 20 after the fight (Status 2)'},
            {t = 'event', zone = 137, event = 23, why = 'Rally Point: Red 23 (Status 3)'},
            {t = 'zonein', zone = 137, event = 39, why = 'Xarcabard [S] zone-in cutscene 39 (Status 4): completes the mission'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'your flee effect will refresh upon'}},
        {id = 's5', kind = 'note', with = 's3', at = {n = 5, fp = 'upon speaking to an operative they'}},
        {id = 's6', kind = 'note', with = 's3', at = {n = 6, fp = 'when you first start the blast'}},
        {id = 's7', kind = 'note', with = 's3', at = {n = 7, fp = 'various tiger mobs are present in'}},
    },
}

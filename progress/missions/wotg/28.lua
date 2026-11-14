-- Step progress for A Hawk in Repose (Wings of the Goddess mission id 28). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/29_A_Hawk_in_Repose.lua. The Weathered Gravestone (Batallia Downs 105) plays event 502 at
-- Status 0 (sets Status 1) and, on a Lilac trade at Status 1, event 503, whose finish takes the Lilac and completes the mission. The
-- client has no script for this gravestone; the ids are LandSandBoat's.
return {
    title = 'A Hawk in Repose',
    completes = 's2',
    known = {{t = 'mission', line = 'wotg', eq = 28}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the weathered gravestone in batallia'},
         done = {
            {t = 'event', zone = 105, event = 502, why = 'Weathered Gravestone 502 (Status 0 only)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade a lilac to the weathered'},
         done = {
            {t = 'mission', line = 'wotg', eq = 28, completed = true, why = 'mission log: A Hawk in Repose completed'},
            {t = 'event', zone = 105, event = 503, why = 'Weathered Gravestone 503 (the Lilac accepted): completes the mission'},
         }},
    },
}

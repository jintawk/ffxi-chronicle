-- Step progress for Sheltering Doubt (Chains of Promathia 4-1, mission id 368). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/4_1_Sheltering_Doubt.lua; client script 026_Despachiaire_0101A009.txt lists event 108
-- (body empty); the Safehold zone-in cutscene 107 and the Dilapidated Gate (_0p0, Misareaux Coast 25) cutscene 7 are LandSandBoat's
-- (no client script). Zone-in 107 plays only at status 0, Despachiaire 108 only at status 1 and the gate at status 2 or more; the
-- gate cutscene completes the mission. A "current mission = 368" matcher is not used on bullet 3: the log moves to 368 when Darkness
-- Named completes, before the zone-in. Dropped from the draft: the Tavnazia warp rune key item on bullet 5 (sold in Western
-- Adoulin, nothing to do with this mission), the Justinius reminders (109, 266) and Spatial Displacement 551 (opens only after the
-- mission). Bullet 1 (indented) and the Optional bullets 5 and 6 keep their plain bullets.
return {
    title = 'Sheltering Doubt',
    completes = 's4',
    known = {{t = 'mission', line = 'cop', eq = 368}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'zone into tavnazian safehold home point'},
         done = {
            {t = 'zonein', zone = 26, event = 107, why = 'Tavnazian Safehold zone-in cutscene 107 (status 0 only, LandSandBoat)'},
         }},
        {id = 's3', at = {n = 3, fp = 'go south and speak with despachiaire'},
         done = {
            {t = 'event', zone = 26, event = 108, why = 'Despachiaire 108 (status 1 only)'},
         }},
        {id = 's4', at = {n = 4, fp = 'check the dilapidated gate at the'},
         done = {
            {t = 'mission', line = 'cop', eq = 368, completed = true, why = 'mission log: Sheltering Doubt completed'},
            {t = 'event', zone = 25, event = 7, why = 'Dilapidated Gate 7: completes (status 2 or more, LandSandBoat)'},
         }},
    },
}

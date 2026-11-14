-- Step progress for An Eternal Melody (Chains of Promathia 2-4, mission id 238). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/2_4_An_Eternal_Melody.lua and zones/Misareaux_Coast/npcs/_0p2.lua; no client scripts
-- for the three events, so the ids are LandSandBoat's. The north Walnut door (_0qa, Tavnazian Safehold 26, event 104) plays only at
-- status 0 and gives the Mysterious amulet (key item 579); the Dilapidated Gate to Snowmint Point (_0p0, Misareaux Coast 25, cutscene 5)
-- plays at status 1; the trigger area on the Safehold bridge plays event 105 at status 2 and completes the mission. The amulet is
-- also given and taken by missions 110 and 138, so neither its key item nor its chat line is used here. Dropped from the draft:
-- Dilapidated Gate 552 (the Riverne gate, which opens only after this mission), Morangeart 521 / the Monarch beard (an ENM that
-- needs this mission completed) and the Justinius and Parelbriaux reminders (127, 126).
return {
    title = 'An Eternal Melody',
    completes = 's3',
    known = {{t = 'mission', line = 'cop', eq = 238}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to the north walnut door'},
         done = {
            {t = 'event', zone = 26, event = 104, why = 'Walnut door 104: the amulet cutscene (status 0 only)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to the dilapidated gate to'},
         done = {
            {t = 'event', zone = 25, event = 5, why = 'Dilapidated Gate (Snowmint Point) cutscene 5 (status 1 only, LandSandBoat)'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to tavnazian safehold and approach'},
         done = {
            {t = 'mission', line = 'cop', eq = 238, completed = true, why = 'mission log: An Eternal Melody completed'},
            {t = 'event', zone = 26, event = 105, why = 'Safehold bridge trigger area 105: completes (status 2)'},
         }},
    },
}

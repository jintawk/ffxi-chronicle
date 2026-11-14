-- Step progress for Edge of Existence (Wings of the Goddess mission id 39). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/40_Edge_of_Existence.lua. Each Cavernous Maw plays its own mission event with no menu
-- while the mission is current, and its finish completes the mission: Batallia Downs 105 event 3, Rolanberry Fields 110 and Sauromugue
-- Champaign 120 event 502 (the three the page lists), and the past-side maws Batallia Downs [S] 84 event 7, Rolanberry Fields [S] 91
-- and Sauromugue Champaign [S] 98 event 702. All six ids are in the client's Cavernous Maw scripts (bodies not decoded).
return {
    title = 'Edge of Existence',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 39}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine one of the cavernous maws'},
         done = {
            {t = 'mission', line = 'wotg', eq = 39, completed = true, why = 'mission log: Edge of Existence completed'},
            {t = 'event', zone = 105, event = 3, why = 'Batallia Downs Cavernous Maw 3'},
            {t = 'event', zone = 110, event = 502, why = 'Rolanberry Fields Cavernous Maw 502'},
            {t = 'event', zone = 120, event = 502, why = 'Sauromugue Champaign Cavernous Maw 502'},
            {t = 'event', zone = 84, event = 7, why = 'Batallia Downs [S] Cavernous Maw 7'},
            {t = 'event', zone = 91, event = 702, why = 'Rolanberry Fields [S] Cavernous Maw 702'},
            {t = 'event', zone = 98, event = 702, why = 'Sauromugue Champaign [S] Cavernous Maw 702'},
         }},
    },
}

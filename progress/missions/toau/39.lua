-- Step progress for Unraveling Reason (Treasures of Aht Urhgan mission 40, mission id 39). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/toau/40_Unraveling_Reason.lua; S4 pseudo-code 243_Pherimociel_010F300F.txt lists 10098 and 10099.
-- Zones: 243 = Ru'Lude Gardens, 51 = Wajaom Woodlands. Bullet 1 (optional) is Pherimociel's "ship isn't ready" cutscene 10099 (status 0,
-- one per zone). The draft used 10098 as a sign of it; 10098 is the ship-is-ready offer and plays on a refusal too (only option 1 starts the
-- trip), so it proves nothing and is not used. Bullet 2 (wait a day, zone, speak to him again) is a note on bullet 3: the accept is seen
-- only through its result. Bullet 3 is the arrival: Wajaom zone-in cutscene 11 (status 1), then 21 (status 2) and 22 (status 3, completes
-- the mission); any of them proves the arrival, and the mission completing does too.
return {
    title = 'Unraveling Reason',
    completes = 's3',
    known = {{t = 'mission', line = 'toau', eq = 39}},
    steps = {
        {id = 's1', kind = 'optional', at = {n = 1, fp = 'optional speak to pherimociel in ru'},
         done = {
            {t = 'event', zone = 243, event = 10099, why = "Pherimociel 10099: the optional \"ship isn't ready\" cutscene (status 0)"},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'wait until next game day and'}},
        {id = 's3', at = {n = 3, fp = 'when the cutscene is over you'},
         done = {
            {t = 'zonein', zone = 51, event = 11, why = 'Wajaom Woodlands zone-in cutscene 11 (status 1, after the accepted offer)'},
            {t = 'zonein', zone = 51, event = 21, why = 'Wajaom Woodlands zone-in cutscene 21 (status 2)'},
            {t = 'zonein', zone = 51, event = 22, why = 'Wajaom Woodlands zone-in cutscene 22 (status 3): completes the mission'},
            {t = 'mission', line = 'toau', eq = 39, completed = true, why = 'mission log: Unraveling Reason completed'},
         }},
    },
}

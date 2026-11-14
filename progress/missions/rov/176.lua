-- Step progress for Prime Number (Rhapsodies of Vana'diel mission, page id 176 = LandSandBoat's PRIME_NUMBER 68 + 108). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_12_Prime_Number.lua: the zone-in cutscene 124 in the Alzadaal Undersea Ruins
-- (zone 72) plays only while this mission is current, and its finish completes it into From the Ruins. The Shrouded Maw zone-in
-- 12 plays after the completion (Option 1), so it is not used. The rov line holds the page id and has no completed set, so the
-- completion is `min = 178` (From the Ruins, 70 + 108, the next value in the enum). The indented bullets about the Nyzul Isle
-- staging point are travel help and are not steps.
return {
    title = 'Prime Number',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 176}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into the alzadaal undersea ruins'},
         done = {
            {t = 'zonein', zone = 72, event = 124, why = 'Alzadaal Undersea Ruins zone-in 124 (plays only while this mission is current)'},
            {t = 'mission', line = 'rov', min = 178, why = 'mission log: the line moved past Prime Number'},
         }},
    },
}

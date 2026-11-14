-- Step progress for Burgeoning Dread (ASA mission 2, mission id 1). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/asa/02_Burgeoning_Dread.lua. The one bullet is a zone-in cutscene with no choice in it, and
-- its finish completes the mission: West Sarutabaruta (115) 62 from Windurst Waters and 63 from Port Windurst, East Sarutabaruta
-- (116) 71 from Windurst Woods (not mounted; the client has three ??? actors with event 71 there, S4 116___010742DC and its two
-- neighbours, bodies empty). The kit it asks for is picked in the update half of the event (LandSandBoat's Option var), so the
-- cutscene is the only thing the page can show. The asa line moves to 2 on completion (no completed set, so `min = 2`). The draft
-- had East Sarutabaruta 71 as `reach`; it is `done`, because LandSandBoat completes the mission in its finish like 62 and 63.
return {
    title = 'Burgeoning Dread',
    completes = 's1',
    known = {{t = 'mission', line = 'asa', eq = 1}},
    groups = {main = {start = {{t = 'mission', line = 'asa', eq = 1, completed = false, why = 'mission line: current mission = Burgeoning Dread'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into either east sarutabaruta or'},
         done = {
            {t = 'zonein', zone = 115, event = 62, why = 'West Sarutabaruta zone-in 62 from Windurst Waters (finish completes)'},
            {t = 'zonein', zone = 115, event = 63, why = 'West Sarutabaruta zone-in 63 from Port Windurst (finish completes)'},
            {t = 'zonein', zone = 116, event = 71, why = 'East Sarutabaruta zone-in 71 from Windurst Woods (finish completes)'},
            {t = 'mission', line = 'asa', min = 2, why = 'mission line: past Burgeoning Dread (That Which Curdles Blood is 2)'},
         }},
    },
}

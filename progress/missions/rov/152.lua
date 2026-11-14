-- Step progress for Spirits Awoken (Rhapsodies of Vana'diel mission 2-1, page id 152; LandSandBoat enum 44, page id = enum + 108).
-- Data only; see progress/missions/adoulin/140.lua for the format. Evidence: LandSandBoat scripts/missions/rov/2_01_Spirits_Awoken.lua.
-- Zoning into Lower Delkfutt's Tower (zone 184) from Qufim Island plays zone-in scene 51 while this mission is current (no refusal
-- path), and its finish completes it. No other LandSandBoat script plays event 51 in that zone (the zone's other scenes are 14, 15,
-- 22, 25, 36, 37 and 53, for rotz 8, cop 1-1 and cop 5-3). The page notes that warping to the Survival Guide triggers it too: the
-- scene is the same, so the event id is the proof, not the route. No client script is decoded for the zone-in. The rov line has no
-- completed set: the completion is `min = 154` (Crashing Waves, enum 46 + 108). Bullet 2 (where the Qufim Island Survival Guide and
-- Home Point are) is a direction into the zone-in; bullet 3 (get the Survival Guide afterwards) is a plain bullet.
return {
    title = 'Spirits Awoken',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 152}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into lower delkfutt s tower'},
         done = {
            {t = 'zonein', zone = 184, event = 51, why = "Lower Delkfutt's Tower zone-in scene 51: completes the mission"},
            {t = 'mission', line = 'rov', min = 154, why = 'mission log: the line moved past Spirits Awoken'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'the qufim island survival guide and'}},
    },
}

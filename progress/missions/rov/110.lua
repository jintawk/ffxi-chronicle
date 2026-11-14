-- Step progress for Resonance (Rhapsodies of Vana'diel mission 1-2, page id 110). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/1_02_Resonance.lua. The rov line holds the page id (LandSandBoat's enum + 108, so
-- RESONANCE = 2 is 110) and has no completed set, so the completion is `min = 111` (Emissary from the Seas, the next value on both paths).
-- Bullet 1: while this mission is current and its status is 0, the first zone-in at Selbina plays event 176 and the first at Mhaura
-- event 368 (onZoneIn returns it; the finish completes the mission). No other mission plays those two ids on a zone-in there, so each
-- is a zone-in signal for bullet 1. The client has no script for either, LandSandBoat only. Bullet 2 is the line moving on.
return {
    title = 'Resonance',
    completes = 's2',
    known = {{t = 'mission', line = 'rov', eq = 110}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into either selbina or mhaura'},
         done = {
            {t = 'zonein', zone = 248, event = 176, why = 'Selbina zone-in cutscene 176 (Resonance, the Selbina path)'},
            {t = 'zonein', zone = 249, event = 368, why = 'Mhaura zone-in cutscene 368 (Resonance, the Mhaura path)'},
         }},
        {id = 's2', at = {n = 2, fp = 'after the cutscene you will now'},
         done = {
            {t = 'mission', line = 'rov', min = 111, why = 'mission log: the line moved past Resonance'},
         }},
    },
}

-- Step progress for Undying Light (Seekers of Adoulin mission, page id 360). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_5_0_Undying_Light.lua. Western Adoulin (256) plays 182 on a zone-in from Ceizak
-- Battlegrounds while this mission is current at status 0 (the choices inside it only change the scene, and the finish always sets
-- status 1), so it proves bullet 1; LandSandBoat notes that retail plays it only when you come through the gate, which at worst
-- leaves the bullet to the later proofs. Ploh Trishbahk (Eastern Adoulin 257) plays 1547 only at status 1, a plain progress event
-- whose finish sets status 2 and puts you at the gates, where onZoneIn plays 1549 at status 2 and its finish completes the mission,
-- so 1547, 1549 and the line prove bullet 2. The adoulin line has no completed set (packet value = page id), so the completion is
-- `min = 361`, not the draft's `completed = true`. The client script for Ploh has only empty stubs for 1547 and 1555 (no say lines).
return {
    title = 'Undying Light',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 360}},
    groups = {main = {start = {{t = 'mission', line = 'adoulin', eq = 360, why = 'mission line: current mission = Undying Light'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone in to western adoulin from'},
         done = {
            {t = 'zonein', zone = 256, event = 182, why = 'Western Adoulin zone-in 182 from Ceizak: plays only in this mission at status 0'},
         }},
        {id = 's2', at = {n = 2, fp = 'proceed to the castle gates in'},
         done = {
            {t = 'event', zone = 257, event = 1547, why = 'Ploh Trishbahk 1547: plays only at status 1, no refusal path'},
            {t = 'zonein', zone = 257, event = 1549, why = 'Eastern Adoulin zone-in 1549, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 361, why = 'mission line: the line moved past Undying Light'},
         }},
    },
}

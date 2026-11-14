-- Step progress for Heroes, Unite! (Seekers of Adoulin mission, page id 330). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_1_2_Heroes_Unite.lua. The Alpine Trail (Kamihr Drifts 267) plays 60 whenever the mission
-- is current and only option 1 goes on, so 60 is `reach`. Option 1 sets status 1 and sends you to Mount Kamihr (282), whose onZoneIn
-- plays cutscene 6 only at status 1, so that zone-in proves the bullet; its finish returns you to Kamihr Drifts, where a zone-in with
-- no cutscene completes the mission. The adoulin line has no completed set (packet value = page id), so the completion is `min = 331`.
-- Rejected: Levil's 40 (a reminder while the mission is current).
return {
    title = 'Heroes, Unite!',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 330}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to kamihr drifts bivouac 3'},
         done = {
            {t = 'zonein', zone = 282, event = 6, why = 'Mount Kamihr zone-in 6: only plays after the Alpine Trail was accepted'},
            {t = 'mission', line = 'adoulin', min = 331, why = 'mission log: the line moved past Heroes, Unite!'},
         },
         reach = {
            {t = 'event', zone = 267, event = 60, why = 'Alpine Trail 60: the cutscene offer (only option 1 goes on)'},
         }},
    },
}

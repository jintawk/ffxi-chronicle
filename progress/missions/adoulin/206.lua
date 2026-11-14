-- Step progress for The Disappearance of Nyline (Seekers of Adoulin mission, page id 206). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_3_3_The_Disappearance_of_Nyline.lua and zones/Foret_de_Hennetiel/Zone.lua. The
-- Ergon Locus trigger area (Foret de Hennetiel 262, a cylinder in the zone script) plays event 517 while the mission is current
-- and its finish always completes the mission. The Door: Boarding House 1512 (Eastern Adoulin) is a one-off side scene that is
-- not on the page. The adoulin line (packet value = page id, no completed set) moves past 206: `min = 207`.
return {
    title = 'The Disappearance of Nyline',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 206}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach the ergon locus torchbloom in'},
         done = {
            {t = 'event', zone = 262, event = 517, why = 'Foret de Hennetiel Ergon Locus area 517: the cutscene with Nyline, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 207, why = 'mission log: the line moved past The Disappearance of Nyline'},
         }},
    },
}

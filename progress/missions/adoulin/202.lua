-- Step progress for Evil Entities (Seekers of Adoulin mission, page id 202). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_3_1_Evil_Entities.lua and the client script S4 261_Elmric. Elmric (Ceizak
-- Battlegrounds 261) plays 23 on every talk while the mission is current and its finish always completes the mission (the client
-- event has no text). Elmric 24 belongs to the next mission. The adoulin line (packet value = page id, no completed set) moves
-- past 202: `min = 203`.
return {
    title = 'Evil Entities',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 202}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to ceizak battlegrounds and speak'},
         done = {
            {t = 'event', zone = 261, event = 23, why = 'Elmric 23: its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 203, why = 'mission log: the line moved past Evil Entities'},
         }},
    },
}

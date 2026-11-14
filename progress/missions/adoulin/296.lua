-- Step progress for Cries from the Deep (Seekers of Adoulin mission 4-4, mission id 296). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/soa/4_4_0_Cries_from_the_Deep.lua. Trigger area 1 at the castle gates in Eastern Adoulin
-- (zone 257) plays 1532 while the mission is current; its finish moves the player and the zone-in cutscene 1550 follows, whose
-- finish completes the mission. 1532 is `reach` (the cutscene has played, the mission is not yet complete), 1550 and the line
-- prove the completion. Neither has client dialogue decoded. Levil's 180 is a reminder. The adoulin line has no completed set
-- (`min = 297`).
return {
    title = 'Cries from the Deep',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 296}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach the adoulin castle gates at'},
         done = {
            {t = 'zonein', zone = 257, event = 1550, why = 'Eastern Adoulin zone-in 1550, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 297, why = 'mission log: the line moved past Cries from the Deep'},
         },
         reach = {
            {t = 'event', zone = 257, event = 1532, why = 'castle gates trigger area 1532: the first cutscene'},
         }},
    },
}

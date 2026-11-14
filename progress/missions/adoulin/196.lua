-- Step progress for Dark Clouds Ahead (Seekers of Adoulin mission, page id 196). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_2_1_Dark_Clouds_Ahead.lua. Levil (Western Adoulin 256) plays 132 on every talk
-- while the mission is current and its finish always completes the mission. The client script has no text for 132. The adoulin
-- line (packet value = page id, no completed set) moves past 196: `min = 197`.
return {
    title = 'Dark Clouds Ahead',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 196}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head back to the pioneers coalition'},
         done = {
            {t = 'event', zone = 256, event = 132, why = 'Levil 132: its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 197, why = 'mission log: the line moved past Dark Clouds Ahead'},
         }},
    },
}

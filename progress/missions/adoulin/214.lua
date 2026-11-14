-- Step progress for To the Victor... (Seekers of Adoulin, mission page id 214). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_4_1_To_the_Victor.lua. Masad (Western Adoulin 256) plays 153 only with the Card
-- Jailer Teodor key item or after winning the minigame (a loss plays 134 and sets a variable, nothing else), and the finish of 153
-- completes the mission. 134 (the minigame) and Levil's 142 (a reminder) prove nothing. The adoulin line has no completed set:
-- `min = 215`.
return {
    title = 'To the Victor...',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 214}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'note if you purchase the card'}},
        {id = 's2', at = {n = 2, fp = 'this mission is completed after beating'},
         done = {
            {t = 'event', zone = 256, event = 153, why = 'Masad 153: the minigame won (or skipped with the key item), finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 215, why = 'mission log: the line moved past To the Victor...'},
         }},
    },
}

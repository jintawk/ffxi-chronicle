-- Step progress for The Man in Black (Seekers of Adoulin, mission page id 212). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_4_0_The_Man_in_Black.lua. Masad (Western Adoulin 256) plays 153, the Teodor
-- cutscene, only with the Card Jailer Teodor key item or after the minigame; its finish completes the mission, so 153 and the line
-- moving on prove the Masad step. 134 is the minigame itself and plays on every talk (also a retry after a loss), so it is only
-- `reach`. Nothing separates beating the minigame, or the retry after a loss, from the Teodor scene: bullets 3 and 4 are notes on
-- the Masad step. Levil's 142 is a reminder. The draft's empty branch step and its `completed = true` matcher are dropped (the
-- adoulin line has no completed set: `min = 213`).
return {
    title = 'The Man in Black',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 212}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'note if you possess the rhapsody'}},
        {id = 's2', at = {n = 2, fp = 'go to the mummers coalition in'},
         done = {
            {t = 'event', zone = 256, event = 153, why = 'Masad 153: the Teodor cutscene, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 213, why = 'mission log: the line moved past The Man in Black'},
         },
         reach = {
            {t = 'event', zone = 256, event = 134, why = 'Masad 134: the minigame while the mission is current (also a retry)'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'beat him at the minigame boom'}},
        {id = 's4', kind = 'note', with = 's2', at = {n = 4, fp = 'if you lose talk to masad'}},
    },
}

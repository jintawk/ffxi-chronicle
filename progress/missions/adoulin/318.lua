-- Step progress for Balamor's Ruse (Seekers of Adoulin mission 4-6, mission page id 318). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_6_0_Balamors_Ruse.lua. The Consummate simulacrum (key item 2600, temporary) is
-- dropped by Rala Waterways mobs only while this mission is current, so its gain proves bullet 1. The battle (Rala Waterways [U],
-- zone 259) is not implemented in LandSandBoat: its win event 1000 is an assumption in the script ("needs to be verified"), so it
-- is not used, nor is the key item leaving on entry. After the win the zone-in 369 in Rala Waterways (258) plays and its finish
-- completes the mission, so 369 and the line moving on prove bullet 4. Bullets 2, 3, 5 and 6 (the Augural Conveyor, the fight,
-- where you are put back, the exit) are notes on bullet 4. Levil's 40 is a reminder. The adoulin line has no completed set:
-- `min = 319`. No client script is decoded for these events.
return {
    title = "Balamor's Ruse",
    completes = 's4',
    known = {{t = 'mission', line = 'adoulin', eq = 318}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'kill enemies in rala waterways until'},
         done = {
            {t = 'ki', id = 2600, gained = true, why = 'Consummate simulacrum obtained'},
            {t = 'ki_have', id = 2600, have = true, why = 'Consummate simulacrum held'},
            {t = 'chat', re = 'obtained key item: consummate simulacrum', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'after acquiring the consummate simulacrum head'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'this battle is against balamor and'}},
        {id = 's4', at = {n = 4, fp = 'upon successfully completing this mission you'},
         done = {
            {t = 'zonein', zone = 258, event = 369, why = 'Rala Waterways zone-in 369 after the won battle, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 319, why = "mission log: the line moved past Balamor's Ruse"},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'you ll be put back at'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'the nearby exit to eastern adoulin'}},
    },
}

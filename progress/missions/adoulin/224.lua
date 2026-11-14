-- Step progress for Beauty and the Beast (Seekers of Adoulin, mission page id 224). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_5_0_Beauty_and_the_Beast.lua. The Signs of a Struggle target in Ceizak
-- Battlegrounds (zone 261) plays 21 only while this mission is current, and its finish completes the mission. Ploh Trishbahk's
-- 5063, Levil's 143 and the Rising Solstice and Volgoi lines are reminders or side speech and prove nothing. The adoulin line has
-- no completed set: `min = 225`. No client script is decoded for the target.
return {
    title = 'Beauty and the Beast',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 224}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to ceizak battlegrounds to the'},
         done = {
            {t = 'event', zone = 261, event = 21, why = 'Ceizak Battlegrounds Signs of a Struggle 21, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 225, why = 'mission log: the line moved past Beauty and the Beast'},
         }},
    },
}

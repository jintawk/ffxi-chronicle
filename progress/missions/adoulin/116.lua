-- Step progress for Onward to Adoulin (Seekers of Adoulin mission 1-3, mission id 116). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/1_3_Onward_to_Adoulin.lua and the client script S4 245_Waypoint_010F50E0.
-- The Waypoint's 10120 is a Yes / No menu ("Activate this waypoint?"), so it is only `reach` (it plays in this mission's first
-- phase only). Saying Yes sends the player to Ceizak Battlegrounds, where zone-in scene 3 plays only in the second phase and its
-- finish completes the mission. The adoulin line has no completed set, so the completion is `min = 117`.
return {
    title = 'Onward to Adoulin',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 116}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'activate the waypoint located at h'},
         done = {
            {t = 'zonein', zone = 261, event = 3, why = 'Ceizak Battlegrounds zone-in scene 3 (after Yes at the Waypoint), its finish completes'},
            {t = 'mission', line = 'adoulin', min = 117, why = 'mission log: the line moved past Onward to Adoulin'},
         },
         reach = {
            {t = 'event', zone = 245, event = 10120, why = 'Waypoint 10120: the menu offered (it also plays on No)'},
         }},
    },
}

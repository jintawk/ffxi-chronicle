-- Step progress for Teahouse Tumult (Treasures of Aht Urhgan, mission id 19). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/20_Teahouse_Tumult.lua: Aydeewa Subterrane (68) zone-in cutscene 10 plays only at status 0
-- and sets status 1 (no other cutscene in that zone's Zone.lua); the blank target (blank_toau20) plays event 11 only at status 1
-- and completes the mission. Bullet 2 (walk west on Map 5) is a direction note with s3.
return {
    title = 'Teahouse Tumult',
    completes = 's3',
    known = {{t = 'mission', line = 'toau', eq = 19}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to aydeewa subterrane via one'},
         done = {
            {t = 'zonein', zone = 68, event = 10, why = "Aydeewa Subterrane zone-in cutscene 10 (status 0 only, LandSandBoat)"},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'make your way to the western'}},
        {id = 's3', at = {n = 3, fp = 'at f 8 g 8 there'},
         done = {
            {t = 'event', zone = 68, event = 11, why = "blank target 11: completes the mission (status 1 only)"},
            {t = 'mission', line = 'toau', eq = 19, completed = true, why = "mission log: Teahouse Tumult completed"},
         }},
    },
}

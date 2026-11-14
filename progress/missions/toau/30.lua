-- Step progress for Shades of Vengeance (Treasures of Aht Urhgan, mission id 30). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/31_Shades_of_Vengeance.lua: Caedarva Mire (79) zone-in cutscene 21 plays only at status 1
-- (after the Periqia assault is won) and completes the mission. The assault has no event of its own, so bullets 1 to 3 (travel,
-- enter Periqia, the fight) and the bullet 5 tip are notes with s4. Nahshib's 22 (a fresh permit after a failed run) is not used.
return {
    title = 'Shades of Vengeance',
    completes = 's4',
    known = {{t = 'mission', line = 'toau', eq = 30}},
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'head to dvucca isle staging point'}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'enter periqia via the runic seal'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'this fight is against up to'}},
        {id = 's4', at = {n = 4, fp = 'upon winning this battle you ll'},
         done = {
            {t = 'zonein', zone = 79, event = 21, why = "Caedarva Mire zone-in cutscene 21: completes the mission (status 1 only)"},
            {t = 'mission', line = 'toau', eq = 30, completed = true, why = "mission log: Shades of Vengeance completed"},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'if you have already finished this'}},
    },
}

-- Step progress for Path of Darkness (Treasures of Aht Urhgan mission 42, mission id 41). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/toau/42_Path_of_Darkness.lua and zones/Nyzul_Isle/instances/path_of_darkness.lua; zone 72 =
-- Alzadaal Undersea Ruins, key item 898 = Nyzul Isle route (res/key_items.lua). The blank lamp (bullet 1) plays event 6 on a refusal too,
-- so it is a note on the Runic Seal step. Entering the instance takes the Nyzul Isle route key item (given by the previous mission), so its
-- loss proves bullet 2. The win sets status 2 with no event of its own; the zone-in cutscene 7 back in Alzadaal (status 2) runs
-- mission:complete and is the last bullet's "one last cutscene"; "Defeat Amnaf" (bullet 12) and the fight descriptions are notes on it.
-- The draft took the retry hand-out (Rodin-Comidin 3142 / the key item gain, the sub-bullet of bullet 4) and the mission line moving to 41
-- as proof of bullets 4 and 1, put the completion on bullet 12 and marked bullet 13 post: all dropped or moved. Naja's 3148 is shared.
return {
    title = 'Path of Darkness',
    completes = 's13',
    known = {{t = 'mission', line = 'toau', eq = 41}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'activate the blank target j 9'}},
        {id = 's2', at = {n = 2, fp = 'check the runic seal i 9'},
         done = {
            {t = 'ki', id = 898, gained = false, why = 'Nyzul Isle route taken on entering the instance (LandSandBoat)'},
         }},
        {id = 's3', kind = 'note', with = 's13', at = {n = 3, fp = 'naja salaheem will fight with you'}},
        {id = 's4', kind = 'note', with = 's13', at = {n = 4, fp = 'the bc consists of three fights'}},
        {id = 's5', kind = 'note', with = 's13', at = {n = 5, fp = 'the first fight is against amnaf'}},
        {id = 's6', kind = 'note', with = 's13', at = {n = 6, fp = 'once defeated amnaf will warp one'}},
        {id = 's7', kind = 'note', with = 's13', at = {n = 7, fp = 'naja will wait for a bit'}},
        {id = 's8', kind = 'note', with = 's13', at = {n = 8, fp = 'the second fight is once again'}},
        {id = 's9', kind = 'note', with = 's13', at = {n = 9, fp = 'naja will pick one of the'}},
        {id = 's10', kind = 'note', with = 's13', at = {n = 10, fp = 'amnaf gives up and warps away'}},
        {id = 's11', kind = 'note', with = 's13', at = {n = 11, fp = 'this fight is against only amnaf'}},
        {id = 's12', kind = 'note', with = 's13', at = {n = 12, fp = 'defeat amnaf to finish the bc'}},
        {id = 's13', at = {n = 13, fp = 'upon winning this battlefield you ll'},
         done = {
            {t = 'zonein', zone = 72, event = 7, why = 'Alzadaal Undersea Ruins zone-in cutscene 7 (status 2): completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'toau', eq = 41, completed = true, why = 'mission log: Path of Darkness completed'},
         }},
    },
}

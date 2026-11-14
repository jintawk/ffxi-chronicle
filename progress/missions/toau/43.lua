-- Step progress for Nashmeira's Plea (Treasures of Aht Urhgan mission 44, mission id 43). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/toau/44_Nashmeiras_Plea.lua and zones/Nyzul_Isle/instances/nashmeiras_plea.lua; zone 72 = Alzadaal
-- Undersea Ruins, key item 899 = mythril mirror (res/key_items.lua). The blank lamp (bullet 1) plays event 8 on a refusal too, so it is a
-- note on the Runic Seal step. Entering the instance takes the Mythril mirror key item (given by the previous mission), so its loss proves
-- bullet 2. The win sets status 2 with no event of its own; the zone-in cutscene 10 back in Alzadaal (status 2) runs mission:complete and is
-- bullet 21's "one last cutscene"; the fight descriptions (bullets 3 to 19) are notes on it. Bullet 20 (lost the fight, Naja gives the key
-- item again) is a branch proved by Naja's 3156, which plays only when the key item is not held (the gain alone is not used: the previous
-- mission hands it out too). The draft put the completion on bullet 15, a fight description, and used the key item gain for the branch: fixed.
return {
    title = "Nashmeira's Plea",
    completes = 's21',
    known = {{t = 'mission', line = 'toau', eq = 43}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'check the blank target at the'}},
        {id = 's2', at = {n = 2, fp = 'head to the runic seal i'},
         done = {
            {t = 'ki', id = 899, gained = false, why = 'Mythril mirror taken on entering the instance (LandSandBoat)'},
         }},
        {id = 's3', kind = 'note', with = 's21', at = {n = 3, fp = 'the time limit for this fight'}},
        {id = 's4', kind = 'note', with = 's21', at = {n = 4, fp = 'this fight is broken into three'}},
        {id = 's5', kind = 'note', with = 's21', at = {n = 5, fp = 'raubahn re raises twice during this'}},
        {id = 's6', kind = 'note', with = 's21', at = {n = 6, fp = 'he has access to all blue'}},
        {id = 's7', kind = 'note', with = 's21', at = {n = 7, fp = 'each time he re raises his'}},
        {id = 's8', kind = 'note', with = 's21', at = {n = 8, fp = 'he seems to favor the spell'}},
        {id = 's9', kind = 'note', with = 's21', at = {n = 9, fp = 'every time he uses azure lore'}},
        {id = 's10', kind = 'note', with = 's21', at = {n = 10, fp = 'he has access to sword weapon'}},
        {id = 's11', kind = 'note', with = 's21', at = {n = 11, fp = 'the final time he re raises'}},
        {id = 's12', kind = 'note', with = 's21', at = {n = 12, fp = 'he is unable to move at'}},
        {id = 's13', kind = 'note', with = 's21', at = {n = 13, fp = 'he is a paladin type monster'}},
        {id = 's14', kind = 'note', with = 's21', at = {n = 14, fp = 'at 50 hp he uses perfect'}},
        {id = 's15', kind = 'note', with = 's21', at = {n = 15, fp = 'this part of the battle is'}},
        {id = 's16', kind = 'note', with = 's21', at = {n = 16, fp = 'like razfahd he cannot move at'}},
        {id = 's17', kind = 'note', with = 's21', at = {n = 17, fp = 'he is a paladin type monster'}},
        {id = 's18', kind = 'note', with = 's21', at = {n = 18, fp = 'he has access to the following'}},
        {id = 's19', kind = 'note', with = 's21', at = {n = 19, fp = 'the battle is over once alexander'}},
        {id = 's20', kind = 'branch', at = {n = 20, fp = 'if you fail this fight return'},
         done = {
            {t = 'event', zone = 50, event = 3156, why = 'Naja Salaheem 3156: the key item handed out again (only without the Mythril mirror)'},
         }},
        {id = 's21', at = {n = 21, fp = 'if you win this fight you'},
         done = {
            {t = 'zonein', zone = 72, event = 10, why = 'Alzadaal Undersea Ruins zone-in cutscene 10 (status 2): completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'toau', eq = 43, completed = true, why = "mission log: Nashmeira's Plea completed"},
         }},
    },
}

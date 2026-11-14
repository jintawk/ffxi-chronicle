-- Step progress for Legacy of the Lost (Treasures of Aht Urhgan mission 35, mission id 34). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/toau/34_Testing_the_Waters.lua (the cutscene) and 35_Legacy_of_the_Lost.lua. Bullet 1 is Talacca
-- Cove zone-in event 106 (57 = Talacca Cove, res/zones.lua): it plays only at the previous mission's status 1 and its finish runs
-- mission:complete for Testing the Waters, which is what makes this mission current, so the mission line moving to 34 proves the bullet (and
-- survives a login). Event 106 is not used: it belongs to the previous mission's script, so check_steps cannot tie it to this entry. The Rock Slab entry and the Gessho fight leave no event of their own (32000 / 32001 are any battlefield in the zone, never
-- proof), so bullets 2 and 3 are notes on the last bullet; the win is proved by the mission completing (LandSandBoat: the 32001 finish calls
-- mission:complete), which is the final cutscene of bullet 4. The draft had only notes (no `completes`): the mission-line proof for bullet 1 and the completion are added.
return {
    title = 'Legacy of the Lost',
    completes = 's4',
    known = {{t = 'mission', line = 'toau', eq = 34}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after the last mission you will'},
         done = {
            {t = 'mission', line = 'toau', eq = 34, completed = false, why = 'mission log: current mission = Legacy of the Lost'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'examine the rock slab directly in'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'this is a 30 minute fight'}},
        {id = 's4', at = {n = 4, fp = 'upon winning this battle you ll'},
         done = {
            {t = 'mission', line = 'toau', eq = 34, completed = true, why = 'mission log: Legacy of the Lost completed'},
         }},
    },
}

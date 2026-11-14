-- Step progress for Puppet in Peril (Treasures of Aht Urhgan, mission id 28). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/29_Puppet_in_Peril.lua: the Ornamental Door (_1v0) in Jade Sepulcher (67) plays event 4 only
-- at status 0 and sets status 1; the battlefield win (exit 32001, any win in that zone, not used) completes the mission, so the
-- win bullet is proved by the mission line. Bullet 1 (travel) is a note with s2; bullets 3 (enter the battlefield, no event of its
-- own) and 4 (the fight) are notes with s5.
return {
    title = 'Puppet in Peril',
    completes = 's5',
    known = {{t = 'mission', line = 'toau', eq = 28}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'after the last mission s cutscene'}},
        {id = 's2', at = {n = 2, fp = 'examine the ornamental door for a'},
         done = {
            {t = 'event', zone = 67, event = 4, why = "Ornamental Door 4 (status 0 only)"},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'check the door again and select'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'the fight is against lancelord gaheel'}},
        {id = 's5', at = {n = 5, fp = 'upon winning the battle you will'},
         done = {
            {t = 'mission', line = 'toau', eq = 28, completed = true, why = "mission log: Puppet in Peril completed (the battlefield win)"},
         }},
    },
}

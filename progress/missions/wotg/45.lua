-- Step progress for When Wills Collide (Wings of the Goddess, mission id 45). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/46_When_Wills_Collide.lua. Bullet 1 (the warp from the Veridical Conflux, 29) is a
-- menu with a "Not yet" choice and the arrival in Walk of Echoes has no cutscene, so it has no signal: a note on bullet 2. The Ornate
-- Door ('_521', Walk of Echoes 182) plays 1 at status 0 (reach); the Bottled punch bug is "lost on entry" to the battlefield
-- (LandSandBoat comment from retail), which is the bullet's second half. After the win the zone-in cutscene 2 (status 2) is what
-- runs mission:complete, so it sits on the same step (the fight itself is bullets 3 and 4, notes). The Punch Bug trade at the
-- Conflux (42) only hands the key item and is left out; 32000/32001 are battlefield events shared by every Walk of Echoes fight.
return {
    title = 'When Wills Collide',
    completes = 's2',
    known = {{t = 'mission', line = 'wotg', eq = 45}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'enter walk of echoes from the'}},
        {id = 's2', at = {n = 2, fp = 'examine the ornate door north of'},
         done = {
            {t = 'ki', id = 1730, gained = false, why = 'Bottled punch bug used up on entering the battlefield'},
            {t = 'zonein', zone = 182, event = 2, why = 'Walk of Echoes zone-in 2 (status 2, after the win): completes the mission'},
            {t = 'mission', line = 'wotg', eq = 45, completed = true, why = 'mission log: When Wills Collide completed'},
         },
         reach = {{t = 'event', zone = 182, event = 1, why = 'Ornate Door 1: the first cutscene (status 0)'}}},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'your opponents in this bc are'}},
        {id = 's4', kind = 'note', with = 's2', at = {n = 4, fp = 'this fight is easily won at'}},
    },
}

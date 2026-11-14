-- Step progress for Ancient Vows (Chains of Promathia 2-5, mission id 248). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/2_5_Ancient_Vows.lua; no client scripts exist for the two ids, so they are LandSandBoat's.
-- The Dilapidated Gate (_0p2, Misareaux Coast 25) plays event 6 only at status 0 (the gate then also plays 552 after the mission, not
-- used); the Riverne - Site #A01 (30) zone-in cutscene 100 plays at status 1 and sets status 2. The Giant Scale trades at the Unstable
-- Displacements are generic zone scripts with no signal of their own, and the Monarch Linn win is event 32001, which every battlefield
-- there shares (never proof), so the instanced-fight bullet 7 is marked by the mission log completing. Bullets 3 to 6 are travel and
-- trades (notes on bullet 7); 8 to 10 describe other content and stay plain bullets. The draft's bullet 4 step (no signal) is a note.
return {
    title = 'Ancient Vows',
    completes = 's7',
    known = {{t = 'mission', line = 'cop', eq = 248}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after your group is prepared and'},
         done = {
            {t = 'event', zone = 25, event = 6, why = 'Dilapidated Gate 6 (status 0 only, LandSandBoat)'},
         }},
        {id = 's2', at = {n = 2, fp = 'check the spatial displacement ahead for'},
         done = {
            {t = 'zonein', zone = 30, event = 100, why = 'Riverne - Site #A01 zone-in cutscene 100 (status 1, LandSandBoat)'},
         }},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'head west to the spatial displacement'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'after you have your scales make'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'head west again to the unstable'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'head straight north and pass through'}},
        {id = 's7', at = {n = 7, fp = 'you will now prepare for an'},
         done = {
            {t = 'mission', line = 'cop', eq = 248, completed = true, why = 'mission log: Ancient Vows completed (Monarch Linn won)'},
         }},
    },
}

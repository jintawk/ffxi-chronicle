-- Step progress for Ark Angels (Zilart mission 14, mission id 26). Data only; see progress/missions/sandoria/12.lua.
-- The zilart line carries completed ids only, so the mission matcher is a completion.
-- Evidence: LandSandBoat scripts/missions/rotz/14_Ark_Angels.lua (the client has no script for the blank target in The Shrine of
-- Ru'Avitau, zone 178). Examining the blank target (event 53, only at status 0, a cutscene with no menu) is bullet 3, not bullet 2:
-- the draft put it on the travel bullet that names the zone. It sets status 1. The five Ark Angel fights (La'Loff Amphitheater;
-- the battlefield exit event 32001 is never proof) each give a shard (KIs 455 to 459, res/key_items.lua) and the fifth
-- completes the mission, so the completed id ticks the fight bullet; the shards could already be held from Divine Might and are
-- not used. The page says Repeatable: Yes, but the zilart line has no current value to tell a new run, so no `repeatable` block
-- (the draft's restart guess is dropped). Bullets 1, 2, 4 and 5 are the zone-in note, the travel, the return and the portal
-- guide: notes on the step they lead into. `known` is the previous mission (id 24) or anything after it completed.
return {
    title = 'Ark Angels',
    completes = 's6',
    known = {{t = 'mission', line = 'zilart', min = 24, completed = true}},
    groups = {main = {start = {{t = 'mission', line = 'zilart', min = 24, completed = true}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'zone into ru aun gardens for'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'proceed straight forward into the teleporter'}},
        {id = 's3', at = {n = 3, fp = 'head north a short distance and'},
         done = {
            {t = 'event', zone = 178, event = 53, why = 'blank target (blank_divine_might) 53: the cutscene, status 0 only (LandSandBoat)'},
         }},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'after the cutscene return to ru'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'there are 5 bc fights to'}},
        {id = 's6', at = {n = 6, fp = 'visit each of the towers and'},
         done = {
            {t = 'mission', line = 'zilart', eq = 26, completed = true, why = 'mission log: Ark Angels completed (the fifth shard)'},
         }},
    },
}

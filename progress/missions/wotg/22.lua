-- Step progress for Dungeons and Dancers (Wings of the Goddess mission 22, mission id 22). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/23_Dungeons_and_Dancers.lua (Beaucedine Glacier [S] 136, Everbloom Hollow 86; none of it
-- in the client pseudo-code). Regal Pawprints 8 (G-9) plays event 20 at status 0 (no menu; finish sets status 1). The battlefield entry
-- has no scripted event, and Everbloom Hollow 10000 (the "cleared" event that sets status 2) is marked in LandSandBoat as an assumption
-- to verify, so neither is used: bullet 2 is a note on the step that follows the fight. After the fight the zone-in cutscene 18
-- (status 2) completes the mission and hands out the Umbra bug. The long Battlefield Navigation bullets are notes on the same step.
-- The draft's Aroma bug / event 25 (a Naoi replacement, a different branch) on bullet 1, its event 10000 on bullet 2 and its
-- empty post step are dropped.
return {
    title = 'Dungeons and Dancers',
    completes = 's3',
    known = {{t = 'mission', line = 'wotg', eq = 22}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the regal pawprints beaucedine glacier'},
         done = {
            {t = 'event', zone = 136, event = 20, why = 'Regal Pawprints 20: the cutscene (status 0, LandSandBoat)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'examine the regal pawprints again to'}},
        {id = 's3', at = {n = 3, fp = 'you have 30 minutes to complete'},
         done = {
            {t = 'zonein', zone = 136, event = 18, why = 'Beaucedine Glacier [S] zone-in cutscene 18 (status 2, after the battle): completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 22, completed = true, why = 'mission log: Dungeons and Dancers completed'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'everyone in your party will receive'}},
        {id = 's5', kind = 'note', with = 's3', at = {n = 5, fp = 'everyone in your party will also'}},
        {id = 's6', kind = 'note', with = 's3', at = {n = 6, fp = 'there is a giddy bomb enemy'}},
        {id = 's7', kind = 'note', with = 's3', at = {n = 7, fp = 'go northwest to start and hug'}},
        {id = 's8', kind = 'note', with = 's3', at = {n = 8, fp = 'blow up the wall to the'}},
        {id = 's9', kind = 'note', with = 's3', at = {n = 9, fp = 'circle back to the wall you'}},
        {id = 's10', kind = 'note', with = 's3', at = {n = 10, fp = 'go back to the dead end'}},
        {id = 's11', kind = 'note', with = 's3', at = {n = 11, fp = 'blow up the wall to the'}},
        {id = 's12', kind = 'note', with = 's3', at = {n = 12, fp = 'travel east and blow up the'}},
        {id = 's13', kind = 'note', with = 's3', at = {n = 13, fp = 'continue southeast and examine the blue'}},
    },
}

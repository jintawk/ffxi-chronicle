-- Step progress for Distorter of Time (Wings of the Goddess mission 23, mission id 23). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/24_Distorter_of_Time.lua (Beaucedine Glacier [S] 136, Ruhotz Silvermines; none of it in
-- the client pseudo-code). The battle's entry has no scripted event and Ruhotz Silvermines 10000 (the "cleared" event) is marked in
-- LandSandBoat as an assumption to verify, so it is not used. After the win the zone-in cutscene 19 (status 1) completes the mission,
-- and bullet 1 is that step. Bullet 2 is the retry branch: Regal Pawprints 1 (Naoi) plays event 26 and hands out a new Umbra bug only
-- when you hold none (key item 1161); that bug is also the previous mission's reward, so the key item is not used. The fight bullets
-- are notes on the completing step. The draft put them on the branch; fixed.
return {
    title = 'Distorter of Time',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 23}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'you have 30 minutes to complete'},
         done = {
            {t = 'zonein', zone = 136, event = 19, why = 'Beaucedine Glacier [S] zone-in cutscene 19 (status 1, after the battle): completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 23, completed = true, why = 'mission log: Distorter of Time completed'},
         }},
        {id = 's2', kind = 'branch', at = {n = 2, fp = 'if you fail this mission you'},
         done = {
            {t = 'event', zone = 136, event = 26, why = 'Regal Pawprints (Naoi) 26: a new Umbra bug handed out (LandSandBoat)'},
         }},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'uses the following tp moves'}},
        {id = 's4', kind = 'note', with = 's1', at = {n = 4, fp = 'will summon atomos from time to'}},
        {id = 's5', kind = 'note', with = 's1', at = {n = 5, fp = 'has access to the following moves'}},
        {id = 's6', kind = 'note', with = 's1', at = {n = 6, fp = 'if lilisette dies the mission ends'}},
        {id = 's7', kind = 'note', with = 's1', at = {n = 7, fp = 'if you re a solo player'}},
    },
}

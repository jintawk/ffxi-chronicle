-- Step progress for Impurity (Rhapsodies of Vana'diel mission 1-15, page id 142; LandSandBoat enum 34, page id = enum + 108).
-- Data only; see progress/missions/adoulin/140.lua for the format. Evidence: LandSandBoat scripts/missions/rov/1_15_Impurity.lua.
-- The whole mission is one scene: the ??? at (H-7) in Yuhtunga Jungle (qm11, zone 123) plays event 212 while this mission is current
-- (no refusal path) and its finish completes it. No client script is decoded for the ???; the other 212s in LandSandBoat (cop 1-2 and
-- 1-3 in La Theine Plateau, cop 5-2 in Beaucedine Glacier, sandoria 2-3 in Metalworks) are in other zones, and 213 (the next mission's
-- scene) is in this zone but belongs to The Lost Avatar. The three bullets are three ways to reach the ??? (from Sea Serpent Grotto by
-- Escape, from Norg by chocobo "and ride to the ???", from anywhere by the Unity Wanted teleport); only bullet 2 names the ??? as the
-- destination, so the scene is its step and bullets 1 and 3 are notes on it. The rov line has no completed set, so the completion is
-- `min = 144` (The Lost Avatar, enum 36 + 108). The draft's events are kept.
return {
    title = 'Impurity',
    completes = 's2',
    known = {{t = 'mission', line = 'rov', eq = 142}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'if you are still in sea'}},
        {id = 's2', at = {n = 2, fp = 'if you are starting from norg'},
         done = {
            {t = 'event', zone = 123, event = 212, why = '??? (qm11) in Yuhtunga Jungle, event 212: the scene that completes the mission'},
            {t = 'mission', line = 'rov', min = 144, why = 'mission log: the line moved past Impurity'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'if you are starting from any'}},
    },
}

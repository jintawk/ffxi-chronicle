-- Step progress for Drenched! It Began with a Raindrop (A Moogle Kupo d'Etat mission 2, mission id 1). Data only; see
-- progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/amk/02_Drenched_It_Began_with_a_Raindrop.lua. The Moogle in the player's home nation Mog House
-- (Southern, Northern, Port San d'Oria 230 to 232; Bastok Mines, Markets, Port 234 to 236; Windurst Waters, Walls, Port, Woods 238 to
-- 241: xi.moghouse.inMogHouseInHomeNation) plays event 30024 only when the trade matched the three items (Orcish plate armor 2757,
-- Quadav backscale 2758, Yagudo caulk 2759), and its finish completes the mission, so there is no refusal path to separate. The mkd
-- line has no completed set in Chronicle (core/data.lua get_mission_read reads it as a current value only), so the completion is the
-- line moving to the next mission id, 2 (completeMission sets the line to 0 for a moment, addMission then sets 2). Bullets 2 to 4 are
-- the "A Moogle Kupo d'Etat" Key section: Squintrox Dryeyes hands the White coral key out only to a player whose line is already at
-- the Fin mission (id 14, Squintrox_Dryeyes.lua hasCompletedExpansion), so they are a repeat that cannot happen during this mission
-- and stay plain bullets. The draft's zone 'None' was the mog house zone list it could not resolve.
return {
    title = 'Drenched! It Began with a Raindrop',
    completes = 's1',
    known = {{t = 'mission', line = 'mkd', eq = 1}},
    groups = {main = {start = {{t = 'mission', line = 'mkd', eq = 1, why = 'mission line: current mission = Drenched! It Began with a Raindrop'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'trade the following three items to'},
         done = {
            {t = 'event', zone = 230, event = 30024, why = "Moogle 30024 in Southern San d'Oria: the three items accepted, completes the mission"},
            {t = 'event', zone = 231, event = 30024, why = "Moogle 30024 in Northern San d'Oria"},
            {t = 'event', zone = 232, event = 30024, why = "Moogle 30024 in Port San d'Oria"},
            {t = 'event', zone = 234, event = 30024, why = 'Moogle 30024 in Bastok Mines'},
            {t = 'event', zone = 235, event = 30024, why = 'Moogle 30024 in Bastok Markets'},
            {t = 'event', zone = 236, event = 30024, why = 'Moogle 30024 in Port Bastok'},
            {t = 'event', zone = 238, event = 30024, why = 'Moogle 30024 in Windurst Waters'},
            {t = 'event', zone = 239, event = 30024, why = 'Moogle 30024 in Windurst Walls'},
            {t = 'event', zone = 240, event = 30024, why = 'Moogle 30024 in Port Windurst'},
            {t = 'event', zone = 241, event = 30024, why = 'Moogle 30024 in Windurst Woods'},
            {t = 'mission', line = 'mkd', min = 2, why = 'mission line: moved on to Hasten! In a Jam in Jeuno? (this one completed)'},
         }},
    },
}

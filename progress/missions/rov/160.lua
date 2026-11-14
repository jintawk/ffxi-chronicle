-- Step progress for Inescapable Binds (Rhapsodies of Vana'diel mission 2-5, page id 160; LandSandBoat enum 52, page id = enum + 108).
-- Data only; see progress/missions/adoulin/140.lua for the format. Evidence: LandSandBoat scripts/missions/rov/2_05_Inescapable_Binds.lua
-- and 2_06_Desert_Winds.lua. Zoning into Aht Urhgan Whitegate (zone 50) with a Boarding Permit plays zone-in scene 165 while this mission
-- is current and the characters are available; its finish completes the mission and starts Ever Forward (enum 56 + 108 = 164). The draft
-- had it as a talk event; the script returns it from onZoneIn, so it is a zone-in. The other way to finish the mission is to obtain the
-- Boarding Permit (the quest The Road to Aht Urhgan completes it from its own script), which starts Desert Winds (enum 54 + 108 = 162)
-- and plays the same scene 165 on the next zone-in; scene 165 is therefore also the scene of the next mission, which is harmless here
-- (a player at 162 has already finished 160). No client script is decoded for the zone-in (the other 165 in LandSandBoat, in cop 8-3, is
-- in Al'Taieu). The rov line has no completed set and the next value is 162 or 164, so the completion is `min = 162`, which both reach.
return {
    title = 'Inescapable Binds',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 160}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into aht urhgan whitegate for'},
         done = {
            {t = 'zonein', zone = 50, event = 165, why = 'Aht Urhgan Whitegate zone-in scene 165: the cutscene that completes the mission'},
            {t = 'mission', line = 'rov', min = 162, why = 'mission log: the line moved past Inescapable Binds (Desert Winds or Ever Forward)'},
         }},
    },
}

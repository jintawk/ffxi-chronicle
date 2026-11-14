-- Step progress for Numbering Days (Rhapsodies of Vana'diel mission 2-4, page id 158; LandSandBoat enum 50, page id = enum + 108).
-- Data only; see progress/missions/adoulin/140.lua for the format. Evidence: LandSandBoat scripts/missions/rov/2_04_Numbering_Days.lua.
-- The door "Marble Bridge" (_6s1) at (F-7) in Upper Jeuno (zone 244) plays event 10221 (progressEvent) while this mission is current,
-- whether or not the player may enter the eatery (the page says so), and its finish completes the mission. There is no refusal path. No
-- client script is decoded for the door (10221 is only listed among the events of several Upper Jeuno NPCs, with no body), and no other
-- script plays 10221 in zone 244. The rov line has no completed set: the completion is `min = 160` (Inescapable Binds, enum 52 + 108).
return {
    title = 'Numbering Days',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 158}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to upper jeuno and examine'},
         done = {
            {t = 'event', zone = 244, event = 10221, why = 'Door: "Marble Bridge" in Upper Jeuno, event 10221: the cutscene that completes the mission'},
            {t = 'mission', line = 'rov', min = 160, why = 'mission log: the line moved past Numbering Days'},
         }},
    },
}

-- Step progress for Ring My Bell (Rhapsodies of Vana'diel mission 1-18, page id 150; LandSandBoat enum 42, page id = enum + 108).
-- Data only; see progress/missions/adoulin/140.lua for the format. Evidence: LandSandBoat scripts/missions/rov/1_18_Ring_My_Bell.lua.
-- The Oaken Door (_700) in Norg (zone 252) plays event 284, the cutscene with Gilgamesh, Aldo, Tenzen, Zeid, Kagero and Prishe, only
-- when the required characters are available (not on one of the CoP missions the page's Notes list); its finish completes the mission.
-- When they are not available the same door plays event 283 instead, which only tells the player so: that is the refusal and is not
-- used. The draft called 284 "a reminder" because the script uses mission:event, but it is the mission's one scene. No client script is
-- decoded for the door. The rov line has no completed set: the completion is `min = 152` (Spirits Awoken, enum 44 + 108). The two Notes
-- bullets (which missions block the scene, the Warrior's Path warning) are conditions, not steps, and stay plain bullets.
return {
    title = 'Ring My Bell',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 150}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'to start the next chapter examine'},
         done = {
            {t = 'event', zone = 252, event = 284, why = "Gilgamesh's Oaken Door in Norg, event 284: the characters' cutscene that completes the mission"},
            {t = 'mission', line = 'rov', min = 152, why = 'mission log: the line moved past Ring My Bell'},
         }},
    },
}

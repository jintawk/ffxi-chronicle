-- Step progress for Return to Delkfutt's Tower (Rise of the Zilart mission 8, mission id 16). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/rotz/08_Return_to_Delkfutts_Tower.lua; client event script S4 245_Aldo_010F5007.txt (events
-- 104 and 68 listed; the body of 104 is empty); zones 184 Lower Delkfutt's Tower, 179 Stellar Fulcrum, 245 Lower Jeuno (res/zones.lua).
-- Aldo 104 (Lower Jeuno) plays only while the mission is current and his bit is unset (later talks play the reminder 68): an optional
-- cutscene. The Lower Delkfutt's Tower zone-in 15 plays on any arrival until its bit is set ("Optional. Yes. Really."; 14 is the
-- arrival from Middle Delkfutt's Tower and is not this bullet). The Stellar Fulcrum zone-in 0 plays at status 0 and sets status 1;
-- winning the battlefield (exit 32001, any win in that zone, so not used) sets status 2, and the zone-in 17 then completes the
-- mission, which is bullet 13. Zone-in events 0, 15 and 17 have no client script (LandSandBoat's ids). Gilgamesh 13 is a reminder.
-- Dropped from the draft: the Delkfutt key bullet (an optional key item that can be owned already) and the route bullets, which prove
-- nothing; bullet 12 (the fight) is a note on the completing step. `known` is the previous mission (id 14) or anything after it
-- completed.
return {
    title = "Return to Delkfutt's Tower",
    completes = 's13',
    known = {{t = 'mission', line = 'zilart', min = 14, completed = true}},
    steps = {
        {id = 's1', kind = 'optional', at = {n = 1, fp = 'optional aldo s decision at the'},
         done = {
            {t = 'event', zone = 245, event = 104, why = 'Aldo 104: the optional cutscene (bit 0, LandSandBoat)'},
         }},
        {id = 's2', kind = 'optional', at = {n = 2, fp = 'zone into lower delkfutt s tower'},
         done = {
            {t = 'zonein', zone = 184, event = 15, why = "Lower Delkfutt's Tower zone-in 15: the optional cutscene (bit 1, LandSandBoat)"},
         }},
        {id = 's3', at = {n = 3, fp = 'zone into stellar fulcrum for a'},
         done = {
            {t = 'zonein', zone = 179, event = 0, why = 'Stellar Fulcrum zone-in 0: the pre-battle cutscene (status 0, LandSandBoat)'},
         }},
        {id = 's12', kind = 'note', with = 's13', at = {n = 12, fp = 'you will enter a bcnm fight against'}},
        {id = 's13', at = {n = 13, fp = 'clearing this bc ends the mission'},
         done = {
            {t = 'mission', line = 'zilart', eq = 16, completed = true, why = "mission log: Return to Delkfutt's Tower completed"},
            {t = 'zonein', zone = 179, event = 17, why = 'Stellar Fulcrum zone-in 17: completes (status 2, LandSandBoat)'},
         }},
    },
}

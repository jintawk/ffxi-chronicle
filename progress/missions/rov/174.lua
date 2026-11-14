-- Step progress for Take Wing (Rhapsodies of Vana'diel mission, page id 174 = LandSandBoat's TAKE_WING 66 + 108). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_11_Take_Wing.lua: trigger area 5 (Shararat Teahouse, Aht Urhgan Whitegate)
-- starts event 168 by itself (no branch, no refusal) and its finish completes the mission into Prime Number. 168 is not used by
-- any other mission script. The rov line holds the page id and has no completed set, so the completion is `min = 176` (Prime
-- Number, 68 + 108, the next value in the enum).
return {
    title = 'Take Wing',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 174}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to shararat teahouse at k'},
         done = {
            {t = 'event', zone = 50, event = 168, why = 'Shararat Teahouse area 168: the cutscene that completes the mission'},
            {t = 'mission', line = 'rov', min = 176, why = 'mission log: the line moved past Take Wing'},
         }},
    },
}

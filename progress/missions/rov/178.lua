-- Step progress for From the Ruins (Rhapsodies of Vana'diel mission, page id 178 = LandSandBoat's FROM_THE_RUINS 70 + 108). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_13_From_the_Ruins.lua: the Imperial Whitegate in Aht Urhgan Whitegate plays event
-- 169 (no refusal branch) and its finish completes the mission into Cauterize. 169 is not used by any other mission script. The
-- reward key item (Rhapsody in Crimson) is not used because it can already be owned. The rov line holds the page id and has no
-- completed set, so the completion is `min = 180` (Cauterize, 72 + 108, the next value in the enum). Bullets 2 to 5 are optional
-- side scenes available during chapter 2 and share no event with this mission, so they are notes.
return {
    title = 'From the Ruins',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 178}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to aht urhgan whitegate and'},
         done = {
            {t = 'event', zone = 50, event = 169, why = 'Imperial Whitegate 169: the cutscene that completes the mission'},
            {t = 'mission', line = 'rov', min = 180, why = 'mission log: the line moved past From the Ruins'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'you can do the following at'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'requires all aht urhgan missions completed'}},
        {id = 's4', kind = 'note', with = 's1', at = {n = 4, fp = 'requires promathia mission 3 5 darkness'}},
        {id = 's5', kind = 'note', with = 's1', at = {n = 5, fp = 'requires all promathia missions completed'}},
    },
}

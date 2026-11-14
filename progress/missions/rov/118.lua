-- Step progress for Flames of Prayer (Rhapsodies of Vana'diel mission 1-6, page id 118). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/1_06_Flames_of_Prayer.lua. The rov line holds the page id (enum + 108) and has no
-- completed set; the next value is 120 (The Path Untraveled). Bullet 1 is the Oaken Door in Norg: its event 277 (zone 252) plays on
-- every touch while this mission is current, has no options, and its finish completes the mission. No other mission plays 277 there.
-- The Rhapsody in White key item is the reward and is not used. Bullets 2 to 5 are notes about the unlocked bonuses.
return {
    title = 'Flames of Prayer',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 118}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'this is a second time after'},
         done = {
            {t = 'event', zone = 252, event = 277, why = 'Norg Oaken Door 277: its finish completes the mission'},
            {t = 'mission', line = 'rov', min = 120, why = 'mission log: the line moved past Flames of Prayer'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'experience and skill gains'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'fields of valor'}},
        {id = 's4', kind = 'note', with = 's1', at = {n = 4, fp = 'alter egos'}},
        {id = 's5', kind = 'note', with = 's1', at = {n = 5, fp = 'other'}},
    },
}

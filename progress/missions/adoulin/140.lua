-- Step progress for Ortharsyne (Seekers of Adoulin mission 2-2-2, mission id 140). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_2_1_Ortharsyne.lua. Zoning into Yorcia Weald (zone 263; the script's "!zone 264"
-- comment is the [U] copy) plays scene 1 whenever this mission is current, and its finish completes it. The adoulin line has no
-- completed set, so the completion is `min = 141`. Bullets 1 and 3 are notes on the way in. The draft's `completed = true`
-- matcher is dropped.
return {
    title = 'Ortharsyne',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 140}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'see survival skills'}},
        {id = 's2', at = {n = 2, fp = 'zone into yorcia weald for a'},
         done = {
            {t = 'zonein', zone = 263, event = 1, why = 'Yorcia Weald zone-in scene 1, its finish completes'},
            {t = 'mission', line = 'adoulin', min = 141, why = 'mission log: the line moved past Ortharsyne'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'this route should not be done'}},
    },
}

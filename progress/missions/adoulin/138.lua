-- Step progress for An Aimless Journey (Seekers of Adoulin mission 2-2-1, mission id 138). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_2_0_An_Aimless_Journey.lua. Trigger area 1 at the Ergon Locus in Cirdas Caverns
-- plays 12 only while this mission is current, and its finish completes it. The adoulin line has no completed set, so the
-- completion is `min = 139`. Bullets 2 and 3 (what to do next, the routes in) are notes; the Notes-section bullets are Arciela
-- dialogue choices and stay plain bullets. The draft's `completed = true` matcher is dropped.
return {
    title = 'An Aimless Journey',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 138}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'travel to cirdas caverns and head'},
         done = {
            {t = 'event', zone = 270, event = 12, why = 'Cirdas Caverns Ergon Locus trigger area: scene 12, its finish completes'},
            {t = 'mission', line = 'adoulin', min = 139, why = 'mission log: the line moved past An Aimless Journey'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'after viewing the cutscene you can'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'some suggested route options on making'}},
    },
}

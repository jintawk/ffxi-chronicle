-- Step progress for The Light Within (Seekers of Adoulin mission, page id 368). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_5_1_The_Light_Within.lua. This mission never completes in the log (core/data.lua: the
-- line stays at 368 forever), so no matcher can use the line moving past it, and there is no `completes`. Ceizak Battlegrounds (261)
-- plays 30 on a zone-in only at status 1 (its choices change the scene, the finish always runs), then sends you to Leafallia (281),
-- where the zone-in 13 plays only at status 2; both prove bullet 3, as does Arciela's skirt (permanent key item 2630, given by the
-- finish of 30; held counts, nothing else gives it). Bullet 4 (the ring talk) is left as a plain bullet: Ploh's 1555 plays at status 3
-- or 4 and can be left without choosing a ring (the reward and the status reset happen only for a chosen option), so it is not
-- proof, and the Councilor's Garb and Cuffs and the ring are items that can come back from elsewhere (Ploh returns them), which
-- can only support. Rejected from the draft: zone-in 13 on bullet 4 (it continues the cutscene of bullet 3), the Pristine hair
-- ribbon's loss (a temporary key item), the item gains. Bullets 1 and 2 (cutscene freeze tips) are notes on bullet 3; the Trust,
-- side-quest and next-mission bullets stay plain.
return {
    title = 'The Light Within',
    known = {{t = 'mission', line = 'adoulin', eq = 368}},
    groups = {main = {start = {{t = 'mission', line = 'adoulin', eq = 368, why = 'mission line: current mission = The Light Within'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'if you re already in the'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you may also try to press'}},
        {id = 's3', at = {n = 3, fp = 'zone into ceizak battlegrounds for a'},
         done = {
            {t = 'zonein', zone = 261, event = 30, why = 'Ceizak Battlegrounds zone-in 30: plays only in this mission at status 1'},
            {t = 'zonein', zone = 281, event = 13, why = 'Leafallia zone-in 13: plays only at status 2, after the Ceizak cutscene'},
            {t = 'ki', id = 2630, gained = true, why = "Arciela's skirt obtained (finish of 30)"},
            {t = 'ki_have', id = 2630, have = true, why = "Arciela's skirt held (permanent key item)"},
            {t = 'chat', re = 'obtained key item: arciela.s skirt', why = 'chat: key item obtained'},
         }},
    },
}

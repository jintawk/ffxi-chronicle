-- Step progress for The Gates (Seekers of Adoulin mission 4-3, mission id 274). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/soa/4_3_0_The_Gates.lua. After the Umbril battlefield is won the player is returned to
-- Woh Gates (zone 273) and the zone-in cutscene 9 plays (no client script decodes it); its finish completes the mission. The
-- Tuft of golden fur (key item 2552) is a battlefield entry item, taken on entry (the page says so), so its loss shows the fight
-- began and is `reach`. Rejected: the draft's "? 1000" in Cirdas Caverns [U] (271), which LandSandBoat itself marks as an unverified
-- guess for the battlefield clear event, and Levil's 165 reminder. The adoulin line has no completed set (`min = 275`). Bullets 2
-- to 5 describe the fight and are notes; the Notes bullet on re-obtaining the Tuft stays a plain bullet.
return {
    title = 'The Gates',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 274}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the darkened crevice at g'},
         done = {
            {t = 'zonein', zone = 273, event = 9, why = 'Woh Gates zone-in 9 after the battlefield win, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 275, why = 'mission log: the line moved past The Gates'},
         },
         reach = {
            {t = 'ki', id = 2552, gained = false, why = 'Tuft of golden fur taken at the battlefield entry'},
            {t = 'chat', re = 'lost key item: tuft of golden fur', why = 'Lost key item line at the entry'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'you are assisted by arciela darrcuiln'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'the fight is lost if any'}},
        {id = 's4', kind = 'note', with = 's1', at = {n = 4, fp = 'the fight is still won if'}},
        {id = 's5', kind = 'note', with = 's1', at = {n = 5, fp = 'see the discussion page page for'}},
    },
}

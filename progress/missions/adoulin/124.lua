-- Step progress for Life on the Frontier (Seekers of Adoulin mission 1-6, mission id 124). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/1_6_Life_on_the_Frontier.lua. Brenton's event 4 plays only while this mission is
-- current and the imprimatur gate is met; its finish completes the mission and gives the Dinner invitation (a reward, so not
-- used). The adoulin line has no completed set, so the completion is `min = 125`. Bullets 1 and 2 are notes on the fame gate and
-- the Wildskeeper key items. Not used: the Kipligg, Ruth and Zaoso events (no effect on the mission) and the unplaced NPC events.
return {
    title = 'Life on the Frontier',
    completes = 's3',
    known = {{t = 'mission', line = 'adoulin', eq = 124}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'depending on fame you will get'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'upon completing that you also gain'}},
        {id = 's3', at = {n = 3, fp = 'talk to brenton for a cutscene'},
         done = {
            {t = 'event', zone = 256, event = 4, why = 'Brenton 4: the cutscene, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 125, why = 'mission log: the line moved past Life on the Frontier'},
         }},
    },
}

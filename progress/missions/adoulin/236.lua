-- Step progress for Kumhau, the Flashfrost Naakual (Seekers of Adoulin, mission page id 236). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_6_1_Kumhau_the_Flashfrost_Naakual.lua. The bullet is one long cutscene chain: the
-- Crawling Cave in Kamihr Drifts (zone 267) plays 30, which sends you to Ceizak Battlegrounds (261) where the zone-in 27 plays,
-- which sends you back to Kamihr Drifts where the zone-in 31 plays; only the finish of 31 completes the mission. So 31 and the
-- line moving on prove the step, while 30 and 27 only show it has begun and are `reach`. Levil's 145 only records that he was
-- spoken to and proves nothing. The Aureate ball of fur is a reward key item (bullet 2, a note). The adoulin line has no
-- completed set: `min = 237`. No client script text exists for these events.
return {
    title = 'Kumhau, the Flashfrost Naakual',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 236}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the crawling cave at f'},
         done = {
            {t = 'zonein', zone = 267, event = 31, why = 'Kamihr Drifts zone-in 31, the end of the chain, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 237, why = 'mission log: the line moved past Kumhau, the Flashfrost Naakual'},
         },
         reach = {
            {t = 'event', zone = 267, event = 30, why = 'Crawling Cave 30: the chain starts'},
            {t = 'zonein', zone = 261, event = 27, why = 'Ceizak Battlegrounds zone-in 27: the middle of the chain'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'you will receive aureate ball of'}},
    },
}

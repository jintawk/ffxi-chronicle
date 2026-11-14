-- Step progress for Prelude of Black and White (San d'Oria quest 88). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Prelude_of_Black_and_White.lua (the Door: Prince Regent's Rm, event 551 in
-- Chateau d'Oraguille, begins the quest on finish, with no option to refuse; trading exactly the Yagudo Holy Water and the
-- Moccasins to Narcheral is event 691 and completes it); client event scripts S4 231_Narcheral_010E70C1.txt (691 say
-- #12504; 551 has no client script, it is in LandSandBoat's quest script). The draft made bullet 1 a note: it is the
-- start. Bullets 2 to 4 gather the two items (drops and a find, items that can come from elsewhere) and are notes on the
-- trade. The page's repeat ("after a Memory reset") is not modelled.
-- Completion events that giveItem/complete in onEventFinish play whether or not the reward fits (no separate refusal event), so they are reach only and the completed bit / key item loss proves the step.
return {
    title = 'Prelude of Black and White',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'as a white mage examine the'},
         done = {
            {t = 'event', zone = 233, event = 551, why = "Door: Prince Regent's Rm 551: begins the quest"},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'go to castle oztroja or castle'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'yagudo abbots spawn behind the brass'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'find a pair of moccasins'}},
        {id = 's5', at = {n = 5, fp = 'take the pair of moccasins and'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 231, event = 691, why = 'Narcheral 691: plays even if the reward does not fit'},
            {t = 'chat', re = 'Excellent work, my friend%.', why = 'Narcheral 691 (say #12504), same'},
         }},
    },
}

-- Step progress for The Crimson Trial (San d'Oria quest 84). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/RDM_AF1_The_Crimson_Trial.lua (Sharzalion 70 or 71 option 1 begins the
-- quest, a refused 70 only sets Prog; 74 is his reminder, only while accepted; trading the Davoi Storage Key to the Davoi
-- Storage Hole gives key item 196, Orcish dried food; 75 completes it, takes the food and gives the Fencing Degen); client
-- event scripts S4 230_Sharzalion_010E60CC.txt (71 accept branch say #9070, 74 say #9073; 70 and 75 have no text); key item
-- id from res/key_items.lua. Bullet n=2 (kill Purpleflash Brukdok for the key) has no strong signal: the Davoi Storage Key
-- is an item that can come from elsewhere, so it is a note on the trade it feeds. Event 70 and 71 play on a refusal too, so they are
-- reach only. The page's repeat ("after a Memory reset") is not modelled.
-- Completion events that giveItem/complete in onEventFinish play whether or not the reward fits (no separate refusal event), so they are reach only and the completed bit / key item loss proves the step.
return {
    title = 'The Crimson Trial',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to sharzalion in the lion'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'chat', re = "That's the spirit, my friend%.", why = 'Sharzalion 71, accepted (say #9070)'},
            {t = 'event', zone = 230, event = 74, conf = 'inferred', why = 'Sharzalion 74: reminder, only while accepted'},
            {t = 'chat', re = "Head to Davoi and search the Orcs' storage holes!", conf = 'inferred', why = 'Sharzalion 74 (say #9073)'},
         },
         reach = {{t = 'event', zone = 230, event = 70, why = 'Sharzalion 70 offered (its finish needs option 1)'},
                  {t = 'event', zone = 230, event = 71, why = 'Sharzalion 71 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'go to davoi and fight purpleflash'}},
        {id = 's3', at = {n = 3, fp = 'trade the davoi storage key to'},
         done = {
            {t = 'ki', id = 196, gained = true, why = 'Orcish dried food obtained'},
            {t = 'ki_have', id = 196, have = true, why = 'Orcish dried food held'},
            {t = 'chat', re = 'obtained key item: orcish dried food', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'you will obtain the key item'}},
        {id = 's5', at = {n = 5, fp = 'return to sharzalion after obtaining the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 196, gained = false, after = 's3', why = 'Orcish dried food handed over (deleted only when the quest completes)'},
         },
         reach = {{t = 'event', zone = 230, event = 75, why = 'Sharzalion 75: plays even if the reward does not fit'}}},
    },
}

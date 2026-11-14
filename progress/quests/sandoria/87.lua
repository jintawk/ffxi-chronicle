-- Step progress for Messenger from Beyond (San d'Oria quest 87). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Messenger_From_Beyond.lua (Narcheral 689 begins the quest on finish, with no
-- option to refuse; trading exactly one Tavnazia Pass is event 690 and completes it); client event scripts S4
-- 231_Narcheral_010E70C1.txt (690 say #12502 / #12503; 689 has no text). The Valkurm Dunes ??? click and Marchelute's
-- drop are an item and a zone message shared with other ???s there, so bullets 2 to 4 are notes on the trade. The page's
-- repeat ("after a Memory reset") is not modelled.
-- Completion events that giveItem/complete in onEventFinish play whether or not the reward fits (no separate refusal event), so they are reach only and the completed bit / key item loss proves the step.
return {
    title = 'Messenger from Beyond',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'as a white mage talk to'},
         done = {
            {t = 'event', zone = 231, event = 689, why = 'Narcheral 689: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'head to b 8 secret beach'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'between 18 00 and 5 00'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'marchelute drops a tavnazia pass'}},
        {id = 's5', at = {n = 5, fp = 'take the tavnazia pass back to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 231, event = 690, why = 'Narcheral 690: plays even if the reward does not fit'},
            {t = 'chat', re = 'This is for you%. I foresee I will need your help yet again', why = 'Narcheral 690 (say #12503), same'},
         }},
    },
}

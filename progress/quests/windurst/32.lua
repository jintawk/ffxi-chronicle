-- Step progress for Curses, Foiled Again! (Windurst quest 32). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Curses_Foiled_Again_1.lua (Shantotto 171 is the offer and only option 3 begins
-- the quest; 172 is her reminder and plays only once accepted; 173 plays on the exact trade of 1 Bomb Ash + 2 Bone Chips and
-- runs quest:complete in onEventFinish, but the Brass Rod reward needs a free slot and 173 plays without that check, so 173 and
-- its lines are `reach` and the quest log's completed bit carries the last step); client event script S4
-- 239_Shantotto_010EF01A.txt (171 say #7482 on the Yes branch only, 172 say #7485, 173 say #7486/#7487). The bullet about
-- where the items are sold is a note on the trade. The indented Blood and Glory hint is not a step.
return {
    title = 'Curses, Foiled Again!',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to shantotto k 7 windurst'},
         done = {
            {t = 'chat', re = 'Jolly well! Now grab a quill and jot these down%.', why = 'Shantotto 171, accepted (say #7482, option 3 branch)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 239, event = 172, conf = 'inferred', why = 'Shantotto 172: reminder, only once accepted'},
            {t = 'chat', re = "Ohoho%.%.%. Still haven't found me my", conf = 'inferred', why = 'Shantotto 172 (say #7485)'},
         },
         reach = {{t = 'event', zone = 239, event = 171, why = 'Shantotto 171 offered (its finish needs option 3)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you will have to obtain 2'}},
        {id = 's3', at = {n = 3, fp = 'trade her the items to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 239, event = 173, why = 'Shantotto 173: the trade accepted (also plays with a full bag, when the reward fails)'},
            {t = 'chat', re = 'Here, dear, take this as your reward%.', why = 'Shantotto 173 (say #7487)'},
         }},
    },
}

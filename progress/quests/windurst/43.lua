-- Step progress for A Greeting Cardian (Windurst quest 43). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/A_Greeting_Cardian.lua. The log stays empty until Kororo's offer is accepted: his
-- first talk 296 is only a nudge toward Spare One (bullet 2); Spare One 295 is a menu where options 1 to 3 teach a greeting
-- (leaving the menu teaches nothing, so only the greeting lines said after a choice prove it, and 495 repeats it later; bullet
-- 3); after a zone change and a minute Kororo offers 298 (a menu, only option 1 begins the quest; bullet 4); while accepted 299
-- is his reminder; Five of Spades in Buburimu (event 1, only before it is done) sets Prog 1 (bullet 6); Kororo 303 runs
-- quest:complete, whose Tourmaline Earring reward needs a free slot while the event plays regardless, so 303 is `reach` and the
-- quest log's completed bit carries the last step. Bullets 5, 8 and 9 are the hint and the flagging conditions, notes. Client
-- event scripts S4 241_Kororo_010F1017.txt (296 say #8114, 299 say #8127, 303 say #8135), 241_Spare_One_010F101C.txt (295 say
-- #8110 to #8112 after a choice, 495), 118_Five_of_Spades_01076253.txt (event 1 say #7267 to #7269).
return {
    title = 'A Greeting Cardian',
    completes = 's7',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's4'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you will have to zone after'}},
        {id = 's2', at = {n = 2, fp = 'talk to kororo in the manustery'},
         done = {
            {t = 'event', zone = 241, event = 296, why = 'Kororo 296: the nudge toward Spare One'},
            {t = 'chat', re = 'That Spare Oney there is but a newborny Cardian!', why = 'Kororo 296 (say #8114)'},
         }},
        {id = 's3', at = {n = 3, fp = 'talk to the cardian that kororo'},
         done = {
            {t = 'chat', re = 'GIMMEFIVE!', why = 'Spare One 295 / 495: the greeting taught (say #8110, after a choice)'},
            {t = 'chat', re = 'HANGTENDOOD!', why = 'Spare One 295 / 495: the greeting taught (say #8111)'},
            {t = 'chat', re = 'WASSUUUUUUUUP%?', why = 'Spare One 295 / 495: the greeting taught (say #8112)'},
            {t = 'event', zone = 241, event = 495, why = 'Spare One 495: repeats the greeting, only once taught'},
         },
         reach = {{t = 'event', zone = 241, event = 295, why = 'Spare One 295: the greeting menu (leaving it teaches nothing)'}}},
        {id = 's4', at = {n = 4, fp = 'leave windurst woods then return after'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Kororo 298, option 1)'},
            {t = 'event', zone = 241, event = 299, conf = 'inferred', why = 'Kororo 299: reminder, only while accepted'},
            {t = 'chat', re = 'The Cardian whose lifey you ruined by teaching him a silly greeting', conf = 'inferred', why = 'Kororo 299 (say #8127)'},
         },
         reach = {{t = 'event', zone = 241, event = 298, why = 'Kororo 298 offered (its finish needs option 1)'}}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'the cardian you are looking for'}},
        {id = 's6', at = {n = 6, fp = 'go to buburimu peninsula and speak'},
         done = {
            {t = 'event', zone = 118, event = 1, why = 'Five of Spades 1: his greeting, sets Prog 1'},
            {t = 'chat', re = 'FiVe isA cArdIanOF WiN%-DuRst!', why = 'Five of Spades 1 (say #7267 to #7269)'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to kororo to receive your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 241, event = 303, why = 'Kororo 303: the finish (also plays with a full bag, when the reward fails)'},
            {t = 'chat', re = 'So, did you findy him', why = 'Kororo 303 (say #8135)'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'this quest cannot be flagged if'}},
        {id = 's9', kind = 'note', with = 's7', at = {n = 9, fp = 'this quest cannot be flagged if'}},
    },
}

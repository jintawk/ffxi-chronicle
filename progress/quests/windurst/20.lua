-- Step progress for Early Bird Catches the Bookworm (Windurst quest 20). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Early_Bird_Catches_the_Bookworm.lua (Tosuka-Porika 387 is the offer and only
-- option 0 begins the quest, so it is a reach; while accepted Tosuka-Porika plays 388, Furakku-Norakku 389/390/397/400 and
-- Orn 395/396/398/399, all accepted-only; Quu Bokye 58 takes the Silver Beastcoin and gives key item 27 in its finish, 57 is
-- his talk before the trade, 59 after it; Orn 398 and 399 play only at Prog 2 and 3, after the trade; Furakku-Norakku 400
-- plays at Prog 2 or more and runs quest:complete, which has gil, fame and a title but no item reward). Client event script
-- S4 238_Orn_010EE058.txt (396 say #8254, 399 #8261), 238_Furakku_Norakku_010EE011.txt (397 #8258), 145_Quu_Bokye_010911CA.txt
-- (57 #7349); key item 27 from res/key_items.lua (the Overdue book notification key item has no id in this LandSandBoat
-- checkout, so it is not used). Bullet 1 is the accepting step: the quest log is set there, so it is not silent. The
-- optional Orn and Furakku revisits are indented, so they are not steps.
-- Shared-signal audit: chat 'Hurry up and get' also plays in Naiko-Paneiko 671, Serukoko 419 and Koru-Moru 215: tightened to the unique tail of Furakku-Norakku 397.
return {
    title = 'Early Bird Catches the Bookworm',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to tosuka porika to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 238, event = 388, why = 'Tosuka-Porika 388: only while accepted'},
            {t = 'event', zone = 238, event = 389, why = 'Furakku-Norakku 389: gives the notification, only while accepted'},
            {t = 'event', zone = 238, event = 397, why = 'Furakku-Norakku 397: only while accepted'},
            {t = 'chat', re = 'back off of him%. i sure hope', why = 'Furakku-Norakku 397 (say #8258)'},
            {t = 'event', zone = 238, event = 395, why = 'Orn 395: takes the notification, only while accepted'},
            {t = 'event', zone = 238, event = 396, why = 'Orn 396: only while accepted'},
            {t = 'chat', re = 'Some guy told me that the stuff the Yagudo steal is massed in the treasure chamber', why = 'Orn 396 (say #8254)'},
         },
         reach = {{t = 'event', zone = 238, event = 387, why = 'Tosuka-Porika 387 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'you will have to go to'},
         reach = {
            {t = 'event', zone = 145, event = 57, why = 'Quu Bokye 57: his talk before the trade'},
            {t = 'chat', re = 'Squawk%? You are wanting this book%?', why = 'Quu Bokye 57 (say #7349)'},
         },
         done = {
            {t = 'event', zone = 145, event = 58, why = 'Quu Bokye 58: the Silver Beastcoin accepted, gives the key item'},
            {t = 'ki', id = 27, gained = true, why = '"Art For Everyone" obtained'},
            {t = 'ki_have', id = 27, have = true, why = '"Art For Everyone" held'},
            {t = 'chat', re = 'obtained key item: "art for everyone"', why = 'chat: key item obtained'},
            {t = 'event', zone = 145, event = 59, why = 'Quu Bokye 59: his talk after the trade'},
            {t = 'event', zone = 238, event = 398, why = 'Orn 398: only at Prog 2, after the trade'},
            {t = 'event', zone = 238, event = 399, why = 'Orn 399: only at Prog 3, after the trade'},
            {t = 'chat', re = 'Sorry to ask, seeing as you went out of your way and all', why = 'Orn 399 (say #8261)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to furakku norakku with the'},
         done = {
            {t = 'event', zone = 238, event = 400, why = 'Furakku-Norakku 400: the book handed over, completes'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 27, gained = false, after = 's2', conf = 'inferred', why = '"Art For Everyone" handed over'},
         }},
    },
}

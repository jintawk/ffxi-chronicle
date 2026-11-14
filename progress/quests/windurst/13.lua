-- Step progress for Chasing Tales (Windurst quest 13). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Chasing_Tales.lua (Tosuka-Porika 403 is a Listen/Don't menu, option 0 begins
-- the quest, so it is only a reach, and 406/412 are his talk while accepted; Furakku-Norakku 404 hands over the overdue book
-- notification, which is the first talk of the accepted quest; Hae Jakkya in Windurst Woods 402 plays only with the
-- notification held and before the delivery is recorded; Furakku-Norakku 409 plays only once it is recorded and the book is
-- not held yet, so it is the return visit; Hae Jakhya in San d'Oria 611 plays only after that and gives the book "A Song of
-- Love"; Furakku-Norakku 410 plays only with the book held and completes the quest, which has gil, fame and a title as reward
-- and nothing to refuse). Disagreement with the draft: it had no signal for the Windurst Woods delivery, the return visit and
-- the San d'Oria talk. Client event scripts S4 238_Tosuka_Porika_010EE010.txt (403 menu #8269), 238_Furakku_Norakku_010EE011.txt
-- (409 say #8280, 410), 241_Hae_Jakkya_010F105D.txt (402 say #8489) and 230_Hae_Jakhya_010E608C.txt (611 say #6617); key item
-- id from res/key_items.lua (126 "A Song of Love"; the notification's id is not used, two key items share its name). Not
-- repeatable (page meta). The quest log is set at s1, so it is not silent.
return {
    title = 'Chasing Tales',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to tosuka porika'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Tosuka-Porika 403, option 0)'},
            {t = 'event', zone = 238, event = 406, conf = 'inferred', why = 'Tosuka-Porika 406: his talk, only while accepted'},
         },
         reach = {{t = 'event', zone = 238, event = 403, why = 'Tosuka-Porika 403 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'talk to furakku norakku behind the'},
         done = {
            {t = 'event', zone = 238, event = 404, why = 'Furakku-Norakku 404: the overdue book notification handed over'},
         }},
        {id = 's3', at = {n = 3, fp = 'talk to hae jakkya at i'},
         done = {
            {t = 'event', zone = 241, event = 402, why = 'Hae Jakkya 402: the notification delivered'},
            {t = 'chat', re = 'Give you back the book I borrrrowed from the library%?', why = 'Hae Jakkya 402 (say #8489)'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to furakku norakku'},
         done = {
            {t = 'event', zone = 238, event = 409, why = 'Furakku-Norakku 409: plays only after the delivery'},
            {t = 'chat', re = "She doesn't seem the type to borrow such a tacky book%.", why = 'Furakku-Norakku 409 (say #8281)'},
         }},
        {id = 's5', at = {n = 5, fp = 'travel to southern san d oria'},
         done = {
            {t = 'event', zone = 230, event = 611, why = 'Hae Jakhya 611: the book handed over'},
            {t = 'ki', id = 126, gained = true, why = '"A Song of Love" obtained'},
            {t = 'chat', re = 'Ah! That\'s rrright! That book I borrowed in Windurst%.', why = 'Hae Jakhya 611 (say #6618)'},
         }},
        {id = 's6', at = {n = 6, fp = 'return the book to furakku norakku'},
         done = {
            {t = 'event', zone = 238, event = 410, why = 'Furakku-Norakku 410: the book returned'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 126, gained = false, conf = 'inferred', why = '"A Song of Love" handed over'},
            {t = 'event', zone = 238, event = 411, conf = 'inferred', why = 'Furakku-Norakku 411: plays only once completed'},
         }},
    },
}

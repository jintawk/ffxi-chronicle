-- Step progress for Vanishing Act (Aht Urhgan quest 62). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Vanishing_Act.lua (after Delivering the Goods, Qutiba or Ulamaal plays 42, the
-- offer, and option 0 begins the quest; while it is available they play 52/53 instead when you have not zoned, which the client
-- shares with Delivering the Goods, and Fochacha plays 47: none of these is used; while accepted Fochacha plays 43 at Prog 0
-- (sets 1) and 48 at Prog 1, the Whitegate trigger area (G-5) plays 44 at Prog 1 (sets 2), Fochacha then plays 49, and Ulamaal
-- or Qutiba play 54 without the Rainbow berry and 45 with it; the Wajaom Woodlands Harvesting Point plays 507 only when a sickle
-- is traded at Prog 2 without the berry and gives key item 776; 45 runs quest:complete and takes the berry). Client event
-- scripts S4 050_Fochacha_010320FE.txt (48: say #9152, 49: say #9175). The reward is not used. Bullet 1 (zone first) is a note
-- on the offer. Not repeatable.
return {
    title = 'Vanishing Act',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'note you must zone after completing'}},
        {id = 's2', at = {n = 2, fp = 'speak to ulamaal to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 54, why = 'Ulamaal or Qutiba 54: his talk while accepted, no berry yet'},
         },
         reach = {{t = 'event', zone = 50, event = 42, why = 'Qutiba or Ulamaal 42 offered (its finish needs option 0)'}}},
        {id = 's3', at = {n = 3, fp = 'speak to fochacha at i 9'},
         done = {
            {t = 'event', zone = 50, event = 43, why = 'Fochacha 43: only at Prog 0, sets Prog 1'},
            {t = 'event', zone = 50, event = 48, why = 'Fochacha 48: only at Prog 1'},
            {t = 'chat', re = 'Maybe I was a little too harsh%.', why = 'Fochacha 48 (say #9152)'},
         }},
        {id = 's4', at = {n = 4, fp = 'head to the alchemy guild at'},
         done = {
            {t = 'event', zone = 50, event = 44, why = 'Whitegate trigger area 44: only at Prog 1, sets Prog 2'},
            {t = 'event', zone = 50, event = 49, why = 'Fochacha 49: from Prog 2 on'},
            {t = 'chat', re = 'I wonder what that little rascally%-wascal is up to now%.%.%.', why = 'Fochacha 49 (say #9175)'},
         }},
        {id = 's5', at = {n = 5, fp = 'begin harvesting wajaom woodlands to obtain'},
         done = {
            {t = 'ki', id = 776, gained = true, why = 'rainbow berry obtained'},
            {t = 'chat', re = 'obtained key item: rainbow berry', why = 'chat: key item obtained'},
            {t = 'event', zone = 51, event = 507, why = 'Harvesting Point 507: only a sickle trade at Prog 2 without the berry'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to ulamaal for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 50, event = 45, why = 'Ulamaal or Qutiba 45: with the berry, runs quest:complete'},
            {t = 'ki', id = 776, gained = false, conf = 'inferred', why = 'rainbow berry handed over'},
         }},
    },
}

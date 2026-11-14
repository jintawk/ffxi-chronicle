-- Step progress for The Rescue (other areas quest 23). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/The_Rescue.lua (Thunder Hawk 80 is the offer and begins the quest only on
-- option 70; 83 is his reminder while accepted without the sack; the Quadav Charm traded to the Beadeaux jail door _43b plays
-- event 1000 only for an exact charm trade without the sack and gives the Trader's Sack (key item 94); Thunder Hawk 81 with
-- the sack runs quest:complete and takes the sack; 82 plays after completion and is not used). Client event script S4
-- 248_Thunder_Hawk_010F8002.txt (80 accept branch say #6835, 81 say #6849); zone 147 has no client script for the door, so its
-- event 1000 is read from LandSandBoat. The Quadav Charm hunt is a note (the charm can come from elsewhere). Not repeatable.
return {
    title = 'The Rescue',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to thunder hawk to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Thunder Hawk 80, option 70)'},
            {t = 'chat', re = 'Thanks%. The turtlebacks often strike merchants headed to our village%.', why = 'Thunder Hawk 80, accept branch (say #6835)'},
            {t = 'event', zone = 248, event = 83, conf = 'inferred', why = 'Thunder Hawk 83: reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 248, event = 80, why = 'Thunder Hawk 80 offered (its finish needs option 70)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to beadeaux and kill de'}},
        {id = 's3', at = {n = 3, fp = 'head to i 8 and trade'},
         done = {
            {t = 'ki', id = 94, gained = true, why = "trader's sack obtained (jail door event 1000)"},
            {t = 'event', zone = 147, event = 1000, why = 'Beadeaux jail door 1000: the Quadav Charm accepted'},
            {t = 'chat', re = "obtained key item: trader's sack", why = 'chat: key item obtained'},
            {t = 'ki_have', id = 94, have = true, conf = 'inferred', why = "trader's sack held"},
         }},
        {id = 's4', at = {n = 4, fp = 'return to thunder hawk for a'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 248, event = 81, why = 'Thunder Hawk 81: runs quest:complete'},
            {t = 'chat', re = "We're thankful enough you're safe%.", why = 'Thunder Hawk 81 (say #6849)'},
            {t = 'ki', id = 94, gained = false, conf = 'inferred', why = "trader's sack handed over"},
         }},
    },
}

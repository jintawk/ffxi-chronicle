-- Step progress for The Secrets of Worship (Chains of Promathia 4-3, mission id 428). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/4_3_The_Secrets_of_Worship.lua; no client script for the door events, so the ids are
-- LandSandBoat's. The Walnut Door (_0qa, Tavnazian Safehold 26, event 111) plays only at status 0; the Wooden Gate (_0s8, Sacrarium
-- 28) plays event 6 at status 2 and event 5 at status 3 with the Reliquiarium key (key item 582, res/key_items.lua), and event 5
-- completes the mission. The key is given by the ??? after Old Professor Mariselle (live gain only, so it proves bullet 15). The
-- Iron Gate cutscene (Misareaux Coast 25, event 9) and its repeat (502) need option 1 to enter and play on a decline, so bullet 5
-- is left plain, as are the travel and key-farming bullets (6 to 12, 14, 16); the Temple Knight key (quest A Hard Day's Knight)
-- and Justinius 131 (an optional briefing, the draft's Monarch Linn permit) prove nothing here. Dropped from the draft: its
-- completion on bullet 9 (that bullet is the key-farming advice; event 5 is bullet 17) and the Parelbriaux 137 reminder.
return {
    title = 'The Secrets of Worship',
    completes = 's17',
    known = {{t = 'mission', line = 'cop', eq = 428}},
    steps = {
        {id = 's4', at = {n = 4, fp = 'examine the walnut door at k'},
         done = {
            {t = 'event', zone = 26, event = 111, why = 'Walnut Door 111: the cutscene (status 0 only, LandSandBoat)'},
         }},
        {id = 's13', at = {n = 13, fp = 'after entering take a right at'},
         done = {
            {t = 'event', zone = 28, event = 6, why = 'Wooden Gate 6: the first cutscene (status 2 only, LandSandBoat)'},
         }},
        {id = 's15', at = {n = 15, fp = 'after it is defeated everyone on'},
         done = {
            {t = 'ki', id = 582, gained = true, why = 'Reliquiarium key obtained from the ???'},
            {t = 'chat', re = 'obtained key item: reliquiarium key', why = 'chat: key item obtained'},
         }},
        {id = 's17', at = {n = 17, fp = 'once past the doors return to'},
         done = {
            {t = 'mission', line = 'cop', eq = 428, completed = true, why = 'mission log: The Secrets of Worship completed'},
            {t = 'event', zone = 28, event = 5, why = 'Wooden Gate 5: completes (status 3 with the Reliquiarium key, LandSandBoat)'},
         }},
    },
}

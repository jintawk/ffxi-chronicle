-- Step progress for What Price Loyalty (Crystal War quest 50, Wings of the Goddess). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/crystalWar/WOTG_BAS_10_What_Price_Loyalty.lua; client event scripts S4
-- 087_Gentle_Tiger_0105722B.txt (348, 349 and 350 are bare cutscenes), 087_Gentle_Tiger_010571D7.txt (354 to 357, the reminders),
-- 088_Roderich_0105832A.txt (10 and 11). Gentle Tiger 348 begins the quest and hands over the Sack of victuals (1171); Roderich 10
-- (North Gustaberg [S], zone 88) takes it and sets Prog 1; Gentle Tiger 349 sets Prog 2. Entering Xarcabard [S] (zone 137) plays the
-- zone-in cutscene 8 and gives the Commander's endorsement (1172), which is bullet 4 (the draft had it on bullet 5); the Forbidding
-- Portal 9 is the first cutscene of bullet 5 (reach); the battle is not implemented in LandSandBoat, but leaving it sets Prog 5 and
-- the Xarcabard [S] zone-in from Everbloom Hollow plays 10, which proves bullet 5. Gentle Tiger 357 plays only at Prog 4 without the
-- endorsement, i.e. after the endorsement was used up in a lost fight, so it and the endorsement's loss after bullet 4 are inferred
-- for bullet 5. Gentle Tiger 350 runs quest:complete. The reminders 354, 355 and Roderich 11 play only after the step they follow,
-- so they are inferred. Chat patterns stop before the player's name, which the lines contain. Not repeatable.
-- Shared-signal audit: events 348 to 350, 354 to 357 of zone 87, 10 and 11 of zone 88 and 8 to 10 of zone 137 are used by no other
-- script naming those zones (the other Xarcabard [S] quests and missions use 1 to 7, 13, 17 to 26, 30 to 34, 39 to 42); key items
-- 1171 and 1172 are named by this quest alone (the 1171 and 1172 under progress/quests/windurst/ are item ids, not key items).
return {
    title = 'What Price Loyalty',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to gentle tiger in bastok'},
         done = {
            {t = 'event', zone = 87, event = 348, why = 'Gentle Tiger 348: begins the quest and gives the Sack of victuals (no menu)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 1171, gained = true, why = 'Sack of victuals obtained'},
            {t = 'ki_have', id = 1171, have = true, why = 'Sack of victuals held'},
            {t = 'chat', re = 'obtained key item: sack of victuals', why = 'chat: key item obtained'},
            {t = 'event', zone = 87, event = 354, conf = 'inferred', why = 'Gentle Tiger 354: his reminder while the sack is held'},
            {t = 'chat', re = 'How can you just stroll around here while Zeid rots away in Benedikt Watchtower%?', conf = 'inferred', why = 'Gentle Tiger 354 (say #13513)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to the benedikt watchtower in'},
         done = {
            {t = 'event', zone = 88, event = 10, why = 'Roderich 10: plays at Prog 0 with the sack, sets Prog 1'},
            {t = 'ki', id = 1171, gained = false, after = 's1', why = 'Sack of victuals taken by Roderich'},
            {t = 'event', zone = 88, event = 11, conf = 'inferred', why = 'Roderich 11: his reminder, plays only after 10'},
            {t = 'chat', re = 'Curses! I must organize a search party immediately%.%.%.', conf = 'inferred', why = 'Roderich 11 (say #8100)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to gentle tiger'},
         done = {
            {t = 'event', zone = 87, event = 349, why = 'Gentle Tiger 349: plays only at Prog 1, sets Prog 2'},
            {t = 'event', zone = 87, event = 355, conf = 'inferred', why = 'Gentle Tiger 355: his reminder, plays only from Prog 2'},
            {t = 'chat', re = 'The President%-%-no, the whole Republic%-%-is counting on you', conf = 'inferred', why = 'Gentle Tiger 355 (say #13514)'},
         }},
        {id = 's4', at = {n = 4, fp = 'travel to xarcabard s for a'},
         done = {
            {t = 'zonein', zone = 137, event = 8, why = 'Xarcabard [S] zone-in cutscene 8: plays only at Prog 2, gives the endorsement'},
            {t = 'ki', id = 1172, gained = true, why = "Commander's endorsement obtained"},
            {t = 'ki_have', id = 1172, have = true, why = "Commander's endorsement held"},
            {t = 'chat', re = "obtained key item: commander's endorsement", why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'examine the forbidding portal at the'},
         done = {
            {t = 'zonein', zone = 137, event = 10, why = 'Xarcabard [S] zone-in cutscene 10: back from Everbloom Hollow after the battle (Prog 5)'},
            {t = 'ki', id = 1172, gained = false, after = 's4', conf = 'inferred', why = "Commander's endorsement used up when the battle is entered"},
            {t = 'event', zone = 87, event = 357, conf = 'inferred', why = 'Gentle Tiger 357: plays only at Prog 4 without the endorsement (a lost fight)'},
            {t = 'chat', re = "If it were me, sure, I'm dropping and fumbling things all the time", conf = 'inferred', why = 'Gentle Tiger 357 (say #13516)'},
         },
         reach = {{t = 'event', zone = 137, event = 9, why = 'Forbidding Portal 9: the first cutscene, plays at Prog 3 with the endorsement, sets Prog 4'}}},
        {id = 's6', at = {n = 6, fp = 'speak to gentle tiger for a'},
         done = {
            {t = 'event', zone = 87, event = 350, why = 'Gentle Tiger 350: the final cutscene, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

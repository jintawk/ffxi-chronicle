-- Step progress for Even More Gullible's Travels (Outlands quest 9). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Kazham/npcs/Magriffon.lua (148 is the offer, a menu: the log's current bit proves the
-- accept; 149 is the reminder before the 35,000 gil trade; 150 is the trade, it only plays with enough gil, and gives the
-- Treasure map KI 256; 151 is his reminder once the map is held; 152 is the finish, played only after the third flower) and
-- scripts/zones/Yuhtunga_Jungle/npcs/Blue_Rafflesia.lua (events 21 to 23 are a menu "Look inside the flower?" whose "No" plays
-- the same event, so they only reach; the third flower shows the dizzy message, "You feel slightly dizzy...", which also plays on
-- the post-quest daily repeat, so it is gated after s2; the nectar is handed out by every flower, so it proves nothing).
-- The first bullet and the map hunt (bullet 3) are notes; the bundled accept-and-trade bullet 2 is done by the trade, the
-- accept only reaches it. Events 148 and 152 have no client script in the S4 dump (LandSandBoat only). Client event scripts S4
-- 250_Magriffon_010FA02E.txt (149 say #10315, 150 say #10317, 151 say #10322) and 123_Blue_Rafflesia_0107B232.txt (21). Not repeatable.
return {
    title = "Even More Gullible's Travels",
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'zone after finishing the previous quest'}},
        {id = 's2', at = {n = 2, fp = 'return to magriffon i 7 who'},
         done = {
            {t = 'event', zone = 250, event = 150, why = 'Magriffon 150: the 35,000 gil accepted, gives the map'},
            {t = 'chat', re = 'Oh! You have made a noble decision%.', why = 'Magriffon 150 (say #10317)'},
            {t = 'ki', id = 256, gained = true, why = 'treasure map obtained'},
            {t = 'ki_have', id = 256, have = true, why = 'treasure map held'},
            {t = 'chat', re = 'obtained key item: treasure map', why = 'chat: key item obtained'},
            {t = 'event', zone = 250, event = 151, conf = 'inferred', why = 'Magriffon 151: his reminder, only once the map is given'},
            {t = 'chat', re = 'You have made a noble decision%.', conf = 'inferred', why = 'Magriffon 151 (say #10322)'},
         },
         reach = {
            {t = 'quest', current = true, why = 'quest log: accepted (Magriffon 148, option 1)'},
            {t = 'event', zone = 250, event = 148, why = 'Magriffon 148 offered (its finish needs option 1)'},
            {t = 'event', zone = 250, event = 149, why = 'Magriffon 149: reminder, only while accepted before the trade'},
            {t = 'chat', re = 'I will exchange with you the', why = 'Magriffon 149 (say #10315)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'go to the three places in'}},
        {id = 's4', at = {n = 4, fp = 'at each spot on the map'},
         done = {
            {t = 'chat', re = 'You feel slightly dizzy%. You must have breathed in too much of the pollen%.', after = 's2', why = 'Blue Rafflesia: the third flower (FEEL_DIZZY)'},
         },
         reach = {
            {t = 'event', zone = 123, event = 21, after = 's2', why = 'Blue Rafflesia 21 offered (its finish needs option 1)'},
            {t = 'event', zone = 123, event = 22, after = 's2', why = 'Blue Rafflesia 22 offered (its finish needs option 1)'},
            {t = 'event', zone = 123, event = 23, after = 's2', why = 'Blue Rafflesia 23 offered (its finish needs option 1)'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to magriffon to finish the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 250, event = 152, why = 'Magriffon 152: runs completeQuest'},
         }},
    },
}

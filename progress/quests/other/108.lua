-- Step progress for A Moral Manifest? (other quest 108). Data only: which observation proves which step bullet of
-- pages/quests/other/108.lua.
-- Evidence: LandSandBoat scripts/zones/Altar_Room/Zone.lua (zone-in events 46 offer, 47 Vault quipus, 51 completes with
-- Tsoo's Headgear), scripts/zones/Altar_Room/npcs/Stone_Lid.lua (48 spawns the Yagudo NMs, 49 after Yagudo Avatar is dead, 50 the
-- Yagudo Headgear trade), scripts/zones/Windurst_Woods/npcs/Ponono.lua (700 first talk, 703 the 10,000 gil trade, 704 talk
-- after the cutting, 705 hands out the cutting). Zone-in 46 plays on accept and decline (decline = option 1, no quest), so the
-- accept rests on the quest log's current bit. 705 plays whenever the wait is over; a full bag would still show it (the
-- cutting is then not given), the item gain below only supports it. Client event script S4 241_Ponono_010F1029.txt
-- (700: say #7347; 703: say #7359; 705: say #7361).
return {
    title = 'A Moral Manifest?',
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter altar room for a cutscene'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (zone-in 46 option 0)'},
         },
         reach = {{t = 'zonein', zone = 152, event = 46, why = 'Altar Room zone-in 46 offered (a decline plays it too)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to ponono windurst woods g'},
         done = {
            {t = 'event', zone = 241, event = 700, why = 'Ponono 700'},
            {t = 'chat', re = "I see that your situation is a little more severe than a supper party at the consulate's mansion%.", why = 'Ponono 700 (say #7347)'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade ponono a velvet cloth rainbow'},
         done = {
            {t = 'event', zone = 241, event = 703, why = 'Ponono 703 (Velvet Cloth, Rainbow Cloth and 10,000 gil trade)'},
            {t = 'chat', re = 'You cannot rush a great artist!', why = 'Ponono 703 (say #7359)'},
         }},
        {id = 's4', at = {n = 4, fp = 'wait until the next game day'},
         done = {
            {t = 'event', zone = 241, event = 705, why = 'Ponono 705 (the cutting)'},
            {t = 'chat', re = 'The cutting is complete!', why = 'Ponono 705 (say #7360)'},
            {t = 'event', zone = 241, event = 704, conf = 'inferred', why = 'Ponono 704 (talk after the cutting was given)'},
            {t = 'item', id = 1867, gained = true, conf = 'inferred', why = 'Yagudo Cutting gained (items can come from elsewhere)'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'synthesize a yagudo headgear'}},
        {id = 's6', at = {n = 6, fp = 'return altar room while wearing your'},
         done = {
            {t = 'zonein', zone = 152, event = 47, why = 'Altar Room zone-in 47 (Vault quipus)'},
            {t = 'ki', id = 725, gained = true, why = 'vault quipus obtained'},
            {t = 'ki_have', id = 725, have = true, why = 'vault quipus held'},
            {t = 'chat', re = 'obtained key item: vault quipus', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'check the stone lid while wearing'},
         done = {
            {t = 'event', zone = 152, event = 48, why = 'Stone Lid 48 (spawns the Yagudo NMs)'},
         }},
        {id = 's8', at = {n = 8, fp = 'once yagudo avatar is defeated check'},
         done = {
            {t = 'event', zone = 152, event = 49, why = 'Stone Lid 49 (after the Yagudo Avatar)'},
            {t = 'ki', id = 725, gained = false, conf = 'inferred', why = 'Vault quipus taken when the Yagudo Avatar dies'},
         }},
        {id = 's9', at = {n = 9, fp = 'trade your yagudo headgear to the'},
         done = {
            {t = 'event', zone = 152, event = 50, why = 'Stone Lid 50 (Yagudo Headgear trade)'},
            {t = 'item', id = 15216, gained = true, conf = 'inferred', why = "Tsoo's Headgear gained (items can come from elsewhere)"},
         }},
        {id = 's10', at = {n = 10, fp = 'equip tsoo s headgear zone out'},
         done = {
            {t = 'zonein', zone = 152, event = 51, why = 'Altar Room zone-in 51 (completes, Gold Beastcoin)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

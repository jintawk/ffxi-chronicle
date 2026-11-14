-- Step progress for Wonder Wands (Windurst quest 48). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Port_Windurst/npcs/Hakkuru-Rinkuru.lua (259 offers the quest and addQuest needs
-- option 1; 260 is the reminder while accepted, and also the wrong-trade refusal; 265 plays on any trade of exactly the three
-- items but its finish completes the quest only with a free slot, so it is a refusal-played event: `reach`, and the quest
-- log's completed bit carries the last step; 267 is the second reward after completion), Goltata.lua (257), Ohruru.lua (258)
-- and Yaman-Hachuman.lua (256), each only while the quest is accepted; client event scripts S4 240_Goltata_010F0017.txt
-- (257 say #3691) and 240_Ohruru_010F0018.txt (258 say #3693); item id from res/items.lua (12750 New Moon Armlets).
-- Nothing in LandSandBoat requires the captains' talks (the trade works without them) and one captain's event cannot prove
-- all three, so that bullet is optional. The quest log is set at s1, so it is not silent. The wand-buying bullet is a note.
return {
    title = 'Wonder Wands',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to hakkuru rinkuru port windurst'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 240, event = 260, conf = 'inferred', why = 'Hakkuru-Rinkuru 260: reminder, only once accepted'},
         },
         reach = {{t = 'event', zone = 240, event = 259, why = 'Hakkuru-Rinkuru 259 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'optional', at = {n = 2, fp = 'speak to the war warlock captains'},
         done = {
            {t = 'event', zone = 240, event = 257, why = 'Goltata 257'},
            {t = 'chat', re = 'The bigger the war, the more influence the number of troops has on the final victory%.', why = 'Goltata 257 (say #3691)'},
            {t = 'event', zone = 240, event = 258, why = 'Ohruru 258'},
            {t = 'chat', re = 'Enhancement magic is like an invisible reinforcement%-ment%-ment%.', why = 'Ohruru 258 (say #3693)'},
            {t = 'event', zone = 240, event = 256, why = 'Yaman-Hachuman 256'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'obtain a rose wand oak staff'}},
        {id = 's4', at = {n = 4, fp = 'trade the rose wand oak staff'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 12750, gained = true, conf = 'inferred', why = 'New Moon Armlets gained (reward) (items can come from elsewhere)'},
            {t = 'event', zone = 240, event = 267, conf = 'inferred', why = 'Hakkuru-Rinkuru 267: second reward, only once completed'},
         },
         reach = {{t = 'event', zone = 240, event = 265, why = 'Hakkuru-Rinkuru 265: the three items traded (also plays with a full bag)'}}},
    },
}

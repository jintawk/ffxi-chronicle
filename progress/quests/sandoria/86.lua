-- Step progress for Peace for the Spirit (San d'Oria quest 86). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no quest script, only NPC scripts: zones/Chateau_dOraguille/npcs/Curilla.lua (109 option 1 adds
-- the quest; 108 is her reminder while accepted), zones/Southern_San_dOria/npcs/Sharzalion.lua (69 is the pre-quest line
-- and proves nothing; 64 is the first talk once accepted, 65 and 66 follow the steps below), zones/FeiYin/npcs/Dry_Fountain.lua
-- (event 17 only on a trade of exactly the Antique Coin), zones/Garlaige_Citadel/npcs/Oaken_Box.lua (event 14 only on a
-- trade of the Nail Puller) and zones/Northern_San_dOria/Zone.lua (the zone-in event 49 completes the quest and gives the
-- Warlock's Chapeau); client event scripts S4 230_Sharzalion_010E60CC.txt (65 say #9126, 66 say #9127; 64 has no text, the
-- Curilla, Dry Fountain, Oaken Box and zone events have none). The two kill bullets (n=3 Miser Murphy, n=7 Guardian Statue)
-- only hand out items that can come from elsewhere, so they are notes on the trades they feed; the Curilla optional line (113) belongs to
-- no bullet. The page's repeat ("after a Memory reset") is not modelled.
return {
    title = 'Peace for the Spirit',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'as a red mage talk to'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 233, event = 108, conf = 'inferred', why = 'Curilla 108: reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 233, event = 109, why = 'Curilla 109 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'head to southern san d oria'},
         done = {
            {t = 'event', zone = 230, event = 64, why = 'Sharzalion 64: first talk once accepted'},
            {t = 'event', zone = 230, event = 65, conf = 'inferred', why = 'Sharzalion 65: only after 64'},
            {t = 'chat', re = "Fei'Yin is no place for you%.", conf = 'inferred', why = 'Sharzalion 65 (say #9126)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'kill miser murphy in fei yin'}},
        {id = 's4', at = {n = 4, fp = 'trade the coin to the dry'},
         done = {
            {t = 'event', zone = 204, event = 17, why = 'Dry Fountain 17: the Antique Coin accepted'},
         }},
        {id = 's5', at = {n = 5, fp = 'head to southern san d oria'},
         done = {
            {t = 'event', zone = 230, event = 66, why = 'Sharzalion 66: only once the coin is traded'},
            {t = 'chat', re = "What, you traveled to Fei'Yin%?", why = 'Sharzalion 66 (say #9127)'},
         }},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'go to garlaige citadel g 8'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'kill him for a nail puller'}},
        {id = 's8', at = {n = 8, fp = 'trade the nail puller to the'},
         done = {
            {t = 'event', zone = 200, event = 14, why = 'Oaken Box 14: the Nail Puller accepted'},
         }},
        {id = 's9', at = {n = 9, fp = 'zone into northern san d oria'},
         done = {
            {t = 'zonein', zone = 231, event = 49, why = 'Northern San d\'Oria zone-in event 49: completes'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 12513, gained = true, conf = 'inferred', why = "Warlock's Chapeau gained (reward)"},
         }},
    },
}

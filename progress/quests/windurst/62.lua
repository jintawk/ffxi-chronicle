-- Step progress for Twinstone Bonding (Windurst quest 62). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Gioh_Ajihri.lua (487 is the offer, played only while the quest is
-- available, and its finish adds the quest with no choice; 488 is her talk while accepted, and also after completion once no
-- zoning is owed, so it only infers; 491 is her talk after completion while a zoning is owed; the earring trade is event 490,
-- which plays whenever she was spoken to and no zoning is owed, but its finish completes the quest through npcUtil.completeQuest
-- with an item reward, so it fails with a full bag after the trade was taken: a refusal-played event, only `reach`, and the
-- quest log's completed bit carries the last step); client event script S4 241_Gioh_Ajihri_010F10B5.txt (488 say #8733,
-- 491 say #8737); item id from res/items.lua (17154, the reward). The draft folded both bullets into one step; they are two.
-- Repeatable on retail, but the repeat's trade (490, gil only) is the same event as the first, so no event opens a second run
-- and there is no `repeatable` entry. The quest log is set at s1, so it is not silent.
-- Chat 'If you happen to come upon' also plays at Baldric (Metalworks): tightened to the unique tail of Gioh Ajihri's line.
-- Item 17154 (Wrapped Bow) is sold by shops (Thadiene, Mono Nchaa, Wata Khamazom): shared, gated after s1.
return {
    title = 'Twinstone Bonding',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with gioh ajihri in windurst'},
         done = {
            {t = 'event', zone = 241, event = 487, why = 'Gioh Ajihri 487: the offer, adds the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 241, event = 488, conf = 'inferred', why = 'Gioh Ajihri 488: her talk once the quest is accepted'},
            {t = 'chat', re = "just do it as a favor for us%.", conf = 'inferred', why = 'Gioh Ajihri 488 (say #8733)'},
         }},
        {id = 's2', at = {n = 2, fp = 'bring the twinstone earring back to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 17154, gained = true, after = 's1', conf = 'inferred', why = 'reward item gained (items can come from elsewhere)'},
            {t = 'event', zone = 241, event = 491, conf = 'inferred', why = 'Gioh Ajihri 491: her talk after completion while a zoning is owed'},
            {t = 'chat', re = 'Deep in the Meriphataud Mountains, there is a bastion of the Yagudo', conf = 'inferred', why = 'Gioh Ajihri 491 (say #8737)'},
         },
         reach = {{t = 'event', zone = 241, event = 490, why = 'Gioh Ajihri 490: the earring traded (also plays when the reward cannot be given)'}}},
    },
}

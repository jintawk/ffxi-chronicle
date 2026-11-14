-- Step progress for A New Dawn (Jeuno quest 62). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no quest script; the quest lives in NPC scripts. zones/Lower_Jeuno/npcs/_6t2.lua (the Door:
-- Merchant's House, 245: 5 and 4 are the offers and only option 1 adds the quest, so they are only a reach);
-- zones/Upper_Jeuno/npcs/Osker.lua (244: 146 is his talk before the Mahogany Lumber trade, 148 plays only on the exact trade
-- and gives key item 217, 147 is his talk afterwards; 145 also plays in Scattered Into Shadow, so it is not used);
-- zones/The_Eldieme_Necropolis/npcs/Sarcophagus.lua (195: 45 plays once Sturm is down and runs completeQuest with the Paragon
-- title and item 14222, but the item cannot be given on a full bag while 45 still plays, so it is only a reach and the quest
-- log's completed bit carries the last step; the key item is taken only on success); client event script S4
-- 244_Osker_010F400D.txt (146 say #7751, 147 say #7754); key item 217 (tamer's whistle) from res/key_items.lua, used by no other
-- quest. The three notes are the trip and the NM spawn, which leave no trace. Not repeatable (page meta).
return {
    title = 'A New Dawn',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the door merchant s house'},
         done = {
            {t = 'quest', current = true, why = "quest log: accepted (the Door: Merchant's House 5 or 4, option 1)"},
         },
         reach = {{t = 'event', zone = 245, event = 5, why = "the Door: Merchant's House 5 offered (its finish needs option 1)"},
                  {t = 'event', zone = 245, event = 4, why = "the Door: Merchant's House 4 offered (its finish needs option 1)"}}},
        {id = 's2', at = {n = 2, fp = 'trade a piece of mahogany lumber'},
         done = {
            {t = 'event', zone = 244, event = 148, why = 'Osker 148: the Mahogany Lumber accepted'},
            {t = 'ki', id = 217, gained = true, why = "tamer's whistle obtained"},
            {t = 'ki_have', id = 217, have = true, why = "tamer's whistle held"},
            {t = 'chat', re = "obtained key item: tamer's whistle", why = 'chat: key item obtained'},
            {t = 'event', zone = 244, event = 147, conf = 'inferred', why = 'Osker 147: his talk after the trade'},
            {t = 'chat', re = 'Not bad if I say so myself%.', conf = 'inferred', why = 'Osker 147 (say #7754)'},
         },
         reach = {{t = 'event', zone = 244, event = 146, why = 'Osker 146: his talk before the trade'}}},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'zone into batallia downs from beaucedine'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'once inside head to d 4'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'examining the sarcophagus will spawn three'}},
        {id = 's6', at = {n = 6, fp = 'once defeated examine the sarcophagus for'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 217, gained = false, after = 's2', conf = 'inferred', why = "tamer's whistle handed over (taken only when the quest completes)"},
         },
         reach = {{t = 'event', zone = 195, event = 45, why = "Sarcophagus 45 (also plays when the reward cannot be given)"}}},
    },
}

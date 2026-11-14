-- Step progress for Distant Loyalties (San d'Oria quest 74). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Distant_Loyalties.lua (Femitte 663 option 0 begins the quest and gives key
-- item 167; Rouva 664 repeats while it is open; Michea 315 first talk takes the order, 316 is her reminder until the Mythril
-- Ingot is traded, 317 is the exact trade, 320 plays until the player zones, 318 hands over key item 168; Femitte 665
-- completes and takes it; once complete Michea 319 is the last bit of lore); client event scripts S4 230_Femitte_010E60C3.txt
-- (663 and 665 are cutscenes), 230_Rouva_010E60C4.txt (664 say #8891) and 235_Michea_010EB02C.txt (315 say #7710, 316 say
-- #7713, 317 and 320 say #7714, 318 say #7715, 319 say #7716/#7717). The draft put Michea's 316 and 320 reminders on the
-- last Michea bullet (they play before it) and the key item 167 loss on the optional lore bullet (the order is taken at 315).
-- Femitte 665 plays whether or not the White Cape fits (quest:complete fails in the finish), so it is reach and the
-- completed bit proves bullet 5.
-- Bullet 2 is travel, a note on the trade bullet; bullet 3 also holds the zone-out, but the trade is its action.
return {
    title = 'Distant Loyalties',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to femitte who needs a'},
         done = {
            {t = 'ki', id = 167, gained = true, why = 'goldsmithing order obtained'},
            {t = 'ki_have', id = 167, have = true, why = 'goldsmithing order held'},
            {t = 'chat', re = 'obtained key item: goldsmithing order', why = 'chat: key item obtained'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 230, event = 664, conf = 'inferred', why = 'Rouva 664: only while the quest is open'},
            {t = 'chat', re = 'You should be able to find an Elvaan goldsmith in Bastok, named%-%-', conf = 'inferred', why = 'Rouva 664 (say #8891)'},
         },
         reach = {{t = 'event', zone = 230, event = 663, why = 'Femitte 663 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to bastok markets hp 1'}},
        {id = 's3', at = {n = 3, fp = 'michea requests a mythril ingot after'},
         done = {
            {t = 'event', zone = 235, event = 317, why = 'Michea 317: the Mythril Ingot trade'},
            {t = 'chat', re = "I'll start working right away%.", why = 'Michea 317 / 320 (say #7714)'},
            {t = 'event', zone = 235, event = 320, conf = 'inferred', why = 'Michea 320: reminder, only after the trade'},
         },
         reach = {{t = 'event', zone = 235, event = 315, why = 'Michea 315: the request for a Mythril Ingot'},
                  {t = 'event', zone = 235, event = 316, why = 'Michea 316: reminder until the trade'}}},
        {id = 's4', at = {n = 4, fp = 'zone back into bastok markets and'},
         done = {
            {t = 'event', zone = 235, event = 318, why = 'Michea 318: the Mythril hearts'},
            {t = 'chat', re = "I've finished the item aunt Femitte ordered%.", why = 'Michea 318 (say #7715)'},
            {t = 'ki', id = 168, gained = true, why = 'mythril hearts obtained'},
            {t = 'ki_have', id = 168, have = true, why = 'mythril hearts held'},
            {t = 'chat', re = 'obtained key item: mythril hearts', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'travel back to southern san d'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 168, gained = false, conf = 'inferred', why = 'mythril hearts handed over'},
         },
         reach = {{t = 'event', zone = 230, event = 665, why = 'Femitte 665: plays even when the White Cape does not fit'}}},
        {id = 's6', kind = 'optional', at = {n = 6, fp = 'optional talk to michea again for'},
         done = {
            {t = 'event', zone = 235, event = 319, why = 'Michea 319: the lore, only once the quest is done'},
            {t = 'chat', re = "But Aunt Femitte told me then that even if everyone else didn't want me back", why = 'Michea 319 (say #7717)'},
         }},
    },
}

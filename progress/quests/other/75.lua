-- Step progress for Elderly Pursuits (Other Areas quest 75). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Elderly_Pursuits.lua (Despachiaire 517 in Tavnazian Safehold is a plain
-- cutscene that begins the quest and gives the Antique amulet; Rouva 747 plays only with the amulet held; the ??? in
-- Carpenters' Landing, after Para dies, swaps the amulet for the Cathedral medallion; Rouva 748 plays only with the medallion;
-- Despachiaire 518 runs quest:complete and takes the medallion). Client event scripts S4 026_Despachiaire_0101A009.txt and
-- 230_Rouva_010E60C4.txt: 517, 518, 747 and 748 are bare cutscenes with no say lines, so events and key items carry the
-- steps. The travel and spawn bullets are notes on the ??? exchange. The quest log is set at s1, so it is not silent.
return {
    title = 'Elderly Pursuits',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to despachiaire for a cutscene'},
         done = {
            {t = 'event', zone = 26, event = 517, why = 'Despachiaire 517: the offer cutscene (no menu, begins the quest)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 680, gained = true, why = 'antique amulet obtained'},
            {t = 'ki_have', id = 680, have = true, why = 'antique amulet held'},
            {t = 'chat', re = 'obtained key item: antique amulet', why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to southern san d oria'},
         done = {
            {t = 'event', zone = 230, event = 747, why = 'Rouva 747: plays only with the Antique amulet held'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'travel to carpenters landing via the'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'check the at f 9 to'}},
        {id = 's5', at = {n = 5, fp = 'once the nm is defeated check'},
         done = {
            {t = 'ki', id = 681, gained = true, why = 'cathedral medallion obtained'},
            {t = 'ki_have', id = 681, have = true, why = 'cathedral medallion held'},
            {t = 'chat', re = 'obtained key item: cathedral medallion', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to rouva'},
         done = {
            {t = 'event', zone = 230, event = 748, why = 'Rouva 748: plays only with the Cathedral medallion held'},
         }},
        {id = 's7', at = {n = 7, fp = 'head back to despachiaire for your'},
         done = {
            {t = 'event', zone = 26, event = 518, why = 'Despachiaire 518: runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 681, gained = false, conf = 'inferred', why = 'cathedral medallion handed over'},
         }},
    },
}

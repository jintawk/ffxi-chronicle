-- Step progress for A Boy's Dream (San d'Oria quest 91). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Northern_San_dOria/npcs/Ailbeche.lua (41/40 option 1 begins the quest, aBoysDreamCS 2;
-- 46 is his talk at 2; Exoroche 50 sets 3; Ailbeche 39 at 3; trading the Giant Shell Bug is 15 (3 to 4); 60 at 4; trading the
-- Odontotyrannus is 47 (4 to 5, and his talk at 5); Zaldon 85 takes the Odontotyrannus and gives key item 218 (5 to 6);
-- Ailbeche 25 at 6 or more; Exoroche 32 at 7 or more (7 to 8)), zones/Chateau_dOraguille/npcs/_6h0.lua (88 at 8: Gallant
-- Leggings, takes key item 218, completes; with no free slot the event still plays and nothing completes, so it is only a
-- reach marker). Client event scripts S4 231_Ailbeche_010E7009.txt (46 say #12464, 39 say #12465; 41, 40, 15, 60, 47, 25
-- have no decoded body, so those rest on the event id) ; key item 218 from res/key_items.lua. The quest is repeatable (page
-- meta): the log bits count for the first run only and a new Ailbeche accept opens the next. Bullets 5-7 (fishing, the
-- Oztroja route, the fish drop) have no signal of their own and are notes on the Odontotyrannus trade (n=8).
return {
    title = "A Boy's Dream",
    completes = 's12',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with ailbeche'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 231, event = 46, conf = 'inferred', why = 'Ailbeche 46: only once accepted, before Exoroche'},
            {t = 'chat', re = 'Oh, how I wish that Father was more like Vilbert%.', conf = 'inferred', why = 'Ailbeche 46 (say #12464)'},
         },
         reach = {{t = 'event', zone = 231, event = 41, why = 'Ailbeche 41 offered (its finish needs option 1)'},
                  {t = 'event', zone = 231, event = 40, why = 'Ailbeche 40 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'talk to exoroche at helbort s'},
         done = {
            {t = 'event', zone = 230, event = 50, why = 'Exoroche 50: only at aBoysDreamCS 2, sets 3'},
            {t = 'event', zone = 231, event = 39, conf = 'inferred', why = 'Ailbeche 39: only after Exoroche'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to and speak with ailbeche'},
         done = {
            {t = 'event', zone = 231, event = 39, why = 'Ailbeche 39: only after Exoroche'},
            {t = 'chat', re = 'Oh, I knew he would say no%.', why = 'Ailbeche 39 (say #12465)'},
         }},
        {id = 's4', at = {n = 4, fp = 'trade ailbeche a giant shell bug'},
         done = {
            {t = 'event', zone = 231, event = 15, why = 'Ailbeche 15: the Giant Shell Bug accepted'},
            {t = 'event', zone = 231, event = 60, conf = 'inferred', why = 'Ailbeche 60: only once the bug is traded'},
         }},
        {id = 's5', kind = 'note', with = 's8', at = {n = 5, fp = 'fish with a rod used for'}},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'from the entrance go through the'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'odontotyrannus monster will be fished up'}},
        {id = 's8', at = {n = 8, fp = 'return ailbeche and trade them the'},
         done = {
            {t = 'event', zone = 231, event = 47, why = 'Ailbeche 47: the Odontotyrannus accepted (also his talk once it is traded)'},
         }},
        {id = 's9', at = {n = 9, fp = 'head to selbina and trade trade'},
         done = {
            {t = 'event', zone = 248, event = 85, why = 'Zaldon 85: the Odontotyrannus accepted'},
            {t = 'ki', id = 218, gained = true, why = "knight's boots obtained"},
            {t = 'ki_have', id = 218, have = true, why = "knight's boots held"},
            {t = 'chat', re = "obtained key item: knight's boots", why = 'chat: key item obtained'},
         }},
        {id = 's10', at = {n = 10, fp = 'return to and speak with ailbeche'},
         done = {
            {t = 'event', zone = 231, event = 25, why = 'Ailbeche 25: only after the Zaldon scene'},
         }},
        {id = 's11', at = {n = 11, fp = 'speak with exoroche at helbort s'},
         done = {
            {t = 'event', zone = 230, event = 32, why = 'Exoroche 32: only after the Zaldon scene'},
         }},
        {id = 's12', at = {n = 12, fp = 'finally head to chateau d oraguille'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 218, gained = false, conf = 'inferred', why = "knight's boots handed over"},
            {t = 'item', id = 14095, gained = true, conf = 'inferred', why = 'Gallant Leggings gained (items can come from elsewhere)'},
         },
         reach = {{t = 'event', zone = 233, event = 88, why = "Trion's door 88 (also plays with a full bag, so it proves nothing)"}}},
    },
}

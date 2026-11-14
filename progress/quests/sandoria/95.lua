-- Step progress for Chasing Quotas (San d'Oria quest 95). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Chasing_Quotas.lua (Ceraulian 18 or 14 begins it; 17 takes the Gold Hairpin
-- at Prog 0 and starts a one minute wait; 7 at Prog 1 after the wait; Miaux 67 at Prog 2 gives key item 449; Ardea 264 at Prog 3;
-- Esca 137 at Prog 4 takes the earring; the Batallia ??? gives key item 299 after Sturmtiger dies; Ceraulian 15 at Prog 6
-- completes and takes key item 299, but with a full bag the event still plays and nothing completes, so it only reaches the
-- step); client event scripts S4 232_Ceraulian_010E8048.txt (13 say #8365, 8 say #8394), 231_Miaux_010E7032.txt (68 say #12787),
-- 235_Ardea_010EB012.txt (264 say #8210, 265 say #8213), 100_Esca_010642A5.txt (138 say #7919); 17, 7, 15, 67 and 137 are
-- not in the decoded scripts and rest on the event id and zone. Key items 449 and 299, items 12494 and 14227 from
-- res/key_items.lua and res/items.lua. Repeatable after a memory reset (page meta): the log bits count for the first run only.
-- Bullets 6-7 are indented (never steps). Bullets 9-10 (the island, the ??? that spawns Sturmtiger) lead into the second
-- examine (n=11), the only moment with a strong signal: "You sense an evil presence." is Batallia's text but Valkurm Dunes has
-- a line of its own for another ???, so it is not used. The draft put the completed bit on the Ceraulian trade and the
-- Ranchuriome's legacy on nothing. The quest log is set at s1, so it is not silent.
return {
    title = 'Chasing Quotas',
    completes = 's12',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ceraulian inside cargo room'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 232, event = 13, conf = 'inferred', why = 'Ceraulian 13: reminder, only while accepted at Prog 0'},
            {t = 'chat', re = "I'm not gonna hold my breath waiting for that", conf = 'inferred', why = 'Ceraulian 13 (say #8365)'},
         },
         reach = {{t = 'event', zone = 232, event = 18, why = 'Ceraulian 18 offered (its finish needs option 1 or more)'},
                  {t = 'event', zone = 232, event = 14, why = 'Ceraulian 14 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade him a gold hairpin for'},
         done = {
            {t = 'event', zone = 232, event = 17, why = 'Ceraulian 17: the Gold Hairpin accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'wait one minute then speak to'},
         done = {
            {t = 'event', zone = 232, event = 7, why = 'Ceraulian 7: after the one minute wait, sets Prog 2'},
            {t = 'event', zone = 232, event = 8, conf = 'inferred', why = 'Ceraulian 8: reminder, only once he has spoken'},
            {t = 'chat', re = 'The cad that mugged our boss must have been following him', conf = 'inferred', why = 'Ceraulian 8 (say #8394)'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to miaux northern san d'},
         done = {
            {t = 'event', zone = 231, event = 67, why = 'Miaux 67: gives the Shiny earring'},
            {t = 'ki', id = 449, gained = true, why = 'shiny earring obtained'},
            {t = 'ki_have', id = 449, have = true, why = 'shiny earring held'},
            {t = 'chat', re = 'obtained key item: shiny earring', why = 'chat: key item obtained'},
            {t = 'event', zone = 231, event = 68, conf = 'inferred', why = 'Miaux 68: only once he has given the earring'},
         }},
        {id = 's5', at = {n = 5, fp = 'speak to ardea bastok markets h'},
         done = {
            {t = 'event', zone = 235, event = 264, why = 'Ardea 264: only at Prog 3 with the earring'},
            {t = 'chat', re = 'You want me to take a look at this earring%?', why = 'Ardea 264 (say #8210)'},
            {t = 'event', zone = 235, event = 265, conf = 'inferred', why = 'Ardea 265: reminder, only once she has spoken'},
            {t = 'chat', re = 'Could you please take that earring to Esca%?', conf = 'inferred', why = 'Ardea 265 (say #8213)'},
         }},
        {id = 's8', at = {n = 8, fp = 'next speak to esca west ronfaure'},
         done = {
            {t = 'event', zone = 100, event = 137, why = 'Esca 137: takes the earring'},
            {t = 'ki', id = 449, gained = false, conf = 'inferred', why = 'shiny earring handed over'},
            {t = 'event', zone = 100, event = 138, conf = 'inferred', why = 'Esca 138: reminder, only once the earring is returned'},
            {t = 'chat', re = 'The armor is buried on a small island', conf = 'inferred', why = 'Esca 138 (say #7919)'},
         }},
        {id = 's9', kind = 'note', with = 's11', at = {n = 9, fp = 'head to the island in batallia'}},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'examine the at i 11 to'}},
        {id = 's11', at = {n = 11, fp = 'examine the again after sturmtiger is'},
         done = {
            {t = 'ki', id = 299, gained = true, why = "Ranchuriome's legacy obtained"},
            {t = 'ki_have', id = 299, have = true, why = "Ranchuriome's legacy held"},
            {t = 'chat', re = "obtained key item: ranchuriome's legacy", why = 'chat: key item obtained'},
         }},
        {id = 's12', at = {n = 12, fp = 'return to ceraulian for your reward'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 299, gained = false, conf = 'inferred', why = "Ranchuriome's legacy handed over"},
            {t = 'item', id = 14227, gained = true, conf = 'inferred', why = 'Drachen Brais gained (reward; items can come from elsewhere)'},
         },
         reach = {{t = 'event', zone = 232, event = 15, why = 'Ceraulian 15 (also plays with a full bag, so it proves nothing)'}}},
    },
}

-- Step progress for In Defiant Challenge (Jeuno quest 128). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/LB01_In_Defiant_Challenge.lua (Maat 79 is an Accept/Decline menu, option 1
-- begins the quest, so it is only a reach; 80 is his talk while accepted; trading exactly the three items plays 81, which
-- completes the quest, pays no item and so cannot be refused; Bomb Coal, Exoray Mold and Ancient Papyrus are either a monster
-- drop or three ??? key items that fuse in the bag: the fused set is removed and the item given with "Obtained: <item>.");
-- client event script S4 243_Maat_010F3031.txt (80 say #10401, P0-P2 = items 1088, 1089, 1090). Item ids 1088 Ancient
-- Papyrus, 1089 Exoray Mold, 1090 Bomb Coal (res/items.lua; Rare/Ex, no auction, quest-only) and key item ids 2134-2142
-- (shreds, crumbs, fragments) from res/key_items.lua. The pouch of weighted stones and the Magicked astrolabe are travel aids
-- and prove nothing. One fragment is only a reach of its step; the loss of one is the fusion. Maat's ids are unique to this
-- quest. Not repeatable (page meta). The quest log is set at s1, so it is not silent.
return {
    title = 'In Defiant Challenge',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to maat on a level'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 243, event = 80, conf = 'inferred', why = 'Maat 80: his talk, only while accepted'},
            {t = 'chat', re = "Well, did you find them%? Here's what I need:", conf = 'inferred', why = 'Maat 80 (say #10401)'},
         },
         reach = {{t = 'event', zone = 243, event = 79, why = 'Maat 79 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'you may either defeat monsters in'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'if you wish to fight the'}},
        {id = 's4', at = {n = 4, fp = 'bomb coal which drops from explosures'},
         reach = {
            {t = 'ki', id = 2140, gained = true, why = 'bomb coal fragment obtained'},
            {t = 'ki', id = 2141, gained = true, why = 'bomb coal fragment obtained'},
            {t = 'ki', id = 2142, gained = true, why = 'bomb coal fragment obtained'},
         },
         done = {
            {t = 'chat', re = 'obtained: .-bomb coal', why = 'ITEM_OBTAINED: the fused fragments given as the item'},
            {t = 'item', id = 1090, gained = true, why = 'Bomb Coal gained (drop or fusion)'},
            {t = 'ki', id = 2140, gained = false, conf = 'inferred', why = 'bomb coal fragment used up in the fusion'},
         }},
        {id = 's5', at = {n = 5, fp = 'exoray mold which drops from exorays'},
         reach = {
            {t = 'ki', id = 2137, gained = true, why = 'exoray mold crumb obtained'},
            {t = 'ki', id = 2138, gained = true, why = 'exoray mold crumb obtained'},
            {t = 'ki', id = 2139, gained = true, why = 'exoray mold crumb obtained'},
         },
         done = {
            {t = 'chat', re = 'obtained: .-exoray mold', why = 'ITEM_OBTAINED: the fused crumbs given as the item'},
            {t = 'item', id = 1089, gained = true, why = 'Exoray Mold gained (drop or fusion)'},
            {t = 'ki', id = 2137, gained = false, conf = 'inferred', why = 'exoray mold crumb used up in the fusion'},
         }},
        {id = 's6', at = {n = 6, fp = 'ancient papyrus which drops from liches'},
         reach = {
            {t = 'ki', id = 2134, gained = true, why = 'ancient papyrus shred obtained'},
            {t = 'ki', id = 2135, gained = true, why = 'ancient papyrus shred obtained'},
            {t = 'ki', id = 2136, gained = true, why = 'ancient papyrus shred obtained'},
         },
         done = {
            {t = 'chat', re = 'obtained: .-ancient papyrus', why = 'ITEM_OBTAINED: the fused shreds given as the item'},
            {t = 'item', id = 1088, gained = true, why = 'Ancient Papyrus gained (drop or fusion)'},
            {t = 'ki', id = 2134, gained = false, conf = 'inferred', why = 'ancient papyrus shred used up in the fusion'},
         }},
        {id = 's7', at = {n = 7, fp = 'trade the items to maat to'},
         done = {
            {t = 'event', zone = 243, event = 81, why = 'Maat 81: the three items accepted, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

-- Step progress for Do Not Go Into the Light (Adoulin quest 122). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Western_Adoulin/npcs/Chanteillie.lua (only her part is scripted: the exact trade of
-- Urunday Lumber, Damascus Ingot and Fire Crystal plays 5076 and gives the Inventors' Coalition pickaxe, and there is no other
-- branch for a wrong trade; while accepted and holding the pickaxe her talk is 5077). The rest of the quest (the doors, Borghest)
-- has no LandSandBoat script, so the steps before the trade have no signal of their own and are notes on the trade. Client
-- event script S4 256_Chanteillie_0110010D.txt (5077 say #9517). Key item 2459 from res/key_items.lua. The last bullet ends the
-- quest, so the log's completed bit belongs to it. Not repeatable.
return {
    title = 'Do Not Go Into the Light',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's6', at = {n = 1, fp = 'you must wait a game day'}},
        {id = 's2', kind = 'note', with = 's6', at = {n = 2, fp = 'check the door to svenja s'}},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'next check the door to the'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'speak to borghest at the morimar'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'obtain a piece of urunday lumber'}},
        {id = 's6', at = {n = 6, fp = 'trade the items to chanteillie at'},
         done = {
            {t = 'event', zone = 256, event = 5076, why = 'Chanteillie 5076: the exact trade, gives the pickaxe'},
            {t = 'ki', id = 2459, gained = true, why = "Inventors' Coalition pickaxe obtained"},
            {t = 'ki_have', id = 2459, have = true, why = "Inventors' Coalition pickaxe held"},
            {t = 'chat', re = "obtained key item: inventors' coalition pickaxe", why = 'chat: key item obtained'},
            {t = 'event', zone = 256, event = 5077, conf = 'inferred', why = 'Chanteillie 5077: her talk while holding the pickaxe'},
            {t = 'chat', re = 'There is one undeniable truth about construction: that which is made can always be broken%.', conf = 'inferred', why = 'Chanteillie 5077 (say #9517)'},
         }},
        {id = 's7', at = {n = 7, fp = 'head back to the hospital to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

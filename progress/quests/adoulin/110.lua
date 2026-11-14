-- Step progress for Vegetable Vegetable Crisis (Adoulin quest 110). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Western_Adoulin/npcs/Chanteillie.lua is the only part of the quest it implements (no
-- script for Amchuchu's door, Cid or the quest itself): Chanteillie 5088 is her talk while the quest is accepted and before
-- the trade (it names Midrium Ingot, Urunday Lumber and Raaz Leather), and 5089 plays only on the exact trade of those three
-- items (a wrong trade plays nothing); the client event script S4 256_Chanteillie_0110010D.txt shows 5089 branching on its
-- params: P1 == 0 says #10945 (the trade itself), then #10947 (wait) or #10948 (Amchuchu has finished), so the event also
-- plays on the return talk and is proof the trade is done either way. 5088 is a reach on the trade bullet (the lab visit
-- before it has no signal of its own: notes). Amchuchu's Missive (2505, res/key_items.lua) is the objective of n=4, handed
-- over before Cid and the final reward, not a reward itself. The page ends the quest at the laboratory ("check Amchuchu's
-- Laboratory for reward", n=6), so the log's completed bit belongs to n=6; the Cid talk (n=5) has no signal: a note.
-- Not repeatable.
return {
    title = 'Vegetable Vegetable Crisis',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'wait one in game day after'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'check amchuchu s laboratory at the'}},
        {id = 's3', at = {n = 3, fp = 'trade midrium ingot urunday lumber and'},
         done = {
            {t = 'event', zone = 256, event = 5089, why = 'Chanteillie 5089: the exact trade accepted (also her return talk after it)'},
            {t = 'chat', re = 'Ah, most excellent%. This should suffice%.', why = 'Chanteillie 5089, P1 = 0 (say #10945)'},
            {t = 'chat', re = 'I know our maester asserted that she would have the letter done', conf = 'inferred', why = 'Chanteillie 5089 (say #10947): after the trade, before the day passes'},
            {t = 'chat', re = 'Amchuchu has likely finished composing her missive%.', conf = 'inferred', why = 'Chanteillie 5089 (say #10948): after the trade, the day passed'},
         },
         reach = {
            {t = 'event', zone = 256, event = 5088, why = 'Chanteillie 5088: her talk while accepted, before the trade'},
            {t = 'chat', re = 'Amchuchu informed me that you would be assisting in her repair efforts%.', why = 'Chanteillie 5088 (say #10942)'},
         }},
        {id = 's4', at = {n = 4, fp = 'check amchuchu s laboratory to receive'},
         done = {
            {t = 'ki', id = 2505, gained = true, why = "Amchuchu's Missive obtained"},
            {t = 'ki_have', id = 2505, have = true, why = "Amchuchu's Missive held"},
            {t = 'chat', re = "obtained key item: amchuchu's missive", why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'talk to cid in metalworks'}},
        {id = 's6', at = {n = 6, fp = 'check amchuchu s laboratory for reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed at the laboratory'},
         }},
    },
}

-- Step progress for Black Tiger Skins (San d'Oria quest 31). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Black_Tiger_Skins.lua (Hanaa Punaa 576/579 begin the quest on option 0;
-- 577 is the exact trade of 3 Tiger Hide, but the reward is an item (Tiger Stole): with no free slot 577 plays and the
-- quest is NOT completed, so 577 and its line are never proof, only the quest log is); client event script S4
-- 230_Hanaa_Punaa_010E6059.txt (576/579 say #8071 is the option 0 branch; 578 is the accepted-state talk).
-- The second bullet bundles the accept and the trade; it is done only by the completion. The accepted quest is `reach`.
return {
    title = 'Black Tiger Skins',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'obtain 3 black tiger hides'}},
        {id = 's2', at = {n = 2, fp = 'speak with hanaa punaa to begin'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 13119, gained = true, conf = 'inferred', why = 'Tiger Stole gained (reward)'},
         },
         reach = {{t = 'quest', current = true, why = 'quest log: accepted'},
                  {t = 'chat', re = "That's great! I'll get right to work as soon as you bring the thrrree", why = 'Hanaa Punaa 576/579 (say #8071, option 0 branch)'},
                  {t = 'event', zone = 230, event = 578, why = 'Hanaa Punaa 578: plays only once accepted'},
                  {t = 'event', zone = 230, event = 577, why = 'Hanaa Punaa 577: the trade (a full bag plays it too, no completion)'},
                  {t = 'event', zone = 230, event = 576, why = 'Hanaa Punaa 576 offered (accepting needs option 0)'},
                  {t = 'event', zone = 230, event = 579, why = 'Hanaa Punaa 579 offered (accepting needs option 0)'}}},
    },
}

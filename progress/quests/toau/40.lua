-- Step progress for The Beast Within (Aht Urhgan quest 40, the Blue Mage level cap 75 flag). Data only; see progress/quests/sandoria/27.lua
-- for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/BLU_LB_The_Beast_Within.lua (Waoud 760 offers the quest, option 0 begins it;
-- while it is accepted Waoud 761 is the paid divination menu and plays on every talk; trading the Blue Mage's Testimony to the
-- Imperial Whitegate plays 762 (Prog 0 -> 1, option 0 teleports to Jade Sepulcher; a Prog 2 trade plays 763 instead), the zone-in
-- at Prog 1 plays cutscene 2 and sets Prog 2; the battlefield win plays event 6 in Jade Sepulcher, which gives the Instant Warp
-- scroll and runs quest:complete, so event 6 and the completed bit prove the last bullet. 762 is only a reach (a menu option can
-- refuse). Waoud 761 proves the quest was begun. The Instant Warp reward is not used. Client event script S4
-- 050_Waoud_01032119.txt (761: say #9034 on the paid divination, the item being the testimony). Bullet 2 is the drop, bullet 4
-- (the Ornamental Door trade) has no event of its own, so both are notes on the step they lead into. Not repeatable.
return {
    title = 'The Beast Within',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to waoud j 10 aht'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 761, why = 'Waoud 761: his talk menu, only while accepted'},
            {t = 'chat', re = 'The symbol of ambition%.%.%.', why = 'Waoud 761 (say #9034)'},
         },
         reach = {{t = 'event', zone = 50, event = 760, why = 'Waoud 760 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'obtain a blue mage s testimony'}},
        {id = 's3', at = {n = 3, fp = 'trade the testimony to the imperial'},
         done = {
            {t = 'zonein', zone = 67, event = 2, why = 'Jade Sepulcher zone-in cutscene 2: only at Prog 1, after the trade'},
            {t = 'event', zone = 50, event = 763, why = 'Imperial Whitegate 763: the trade replayed, only at Prog 2'},
         },
         reach = {{t = 'event', zone = 50, event = 762, why = 'Imperial Whitegate 762 (its finish needs option 0)'}}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'trade the testimony to the ornamental'}},
        {id = 's5', at = {n = 5, fp = 'defeat raubahn to complete the quest'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 67, event = 6, why = 'Jade Sepulcher 6: the victory cutscene, runs quest:complete'},
         }},
    },
}

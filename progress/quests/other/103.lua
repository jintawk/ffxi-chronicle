-- Step progress for Missionary Moblin (other quest 103). Data only: which observation proves which step bullet of
-- pages/quests/other/103.lua.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Missionary_Moblin.lua (Koblakiq, Oldton Movalpolos 11: event 7 offers and
-- begins the quest only on option 1; 9 plays only for a Soiled Letter trade and completes; 8 is the active-quest talk and
-- 12 the post-completion talk, neither proves a step); client event script S4 011_Koblakiq_0100B0EC.txt (7: say #7834 only on
-- the "terrified / do as she asks" branch; 9: say #7837-7838).
return {
    title = 'Missionary Moblin',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to koblakiq to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'chat', re = "That's the way it should be%.", why = 'Koblakiq 7, accepted (say #7834, choice 0 branch)'},
         },
         reach = {{t = 'event', zone = 11, event = 7, why = 'Koblakiq 7 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade koblakiq a soiled letter to'},
         done = {
            {t = 'event', zone = 11, event = 9, why = 'Koblakiq 9 (Soiled Letter trade, completes)'},
            {t = 'chat', re = 'This is a letter from my brother!', why = 'Koblakiq 9 (say #7837)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

-- Step progress for The Rumor (San d'Oria quest 61). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Rumor.lua (Novalmauge 13 begins the quest on option 1; 11 is the
-- accepted-state talk; 12 is the exact trade of a vial of Beastman Blood, but the reward is an item (Scroll of Drain): with
-- no free slot 12 plays and the quest is NOT completed, so 12 and its line are only `reach`); client event script S4
-- 167_Novalmauge_010A7107.txt (13 say #7354 first offer / #7356 second offer are the accept branches; 12 say #7357).
-- Shared-signal audit (2026-10-28): dropped item 4853 (Scroll of Drain is sold by an NPC and dropped by mobs); the completed bit and the 12 reach stay.
return {
    title = 'The Rumor',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to novalmauge in bostaunieux oubliette'},
         done = {
            {t = 'chat', re = 'That is good news, indeed%.', why = 'Novalmauge 13 (say #7354 / #7356, accept branch)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 167, event = 11, conf = 'inferred', why = 'Novalmauge 11: plays only once accepted'},
         },
         reach = {{t = 'event', zone = 167, event = 13, why = 'Novalmauge 13 offered (accepting needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade novalmauge a vial of beastman'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 167, event = 12, why = 'Novalmauge 12: the trade (a full bag plays it too, no completion)'}}},
    },
}

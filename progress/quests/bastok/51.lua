-- Step progress for Ghosts of the Past (Bastok quest 51). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/MNK_AF1_Ghosts_of_the_Past.lua (Oggbi 231 begins the quest on finish, no
-- refusal branch, Monk at the AF1 level; the Gusgen Mines ??? only spawns the Wandering Ghost with a message, no event;
-- trading the Miner's Pendant to Oggbi is event 232, which runs quest:complete). Oggbi's event script (S4
-- 236_Oggbi_010EC07D.txt) has no distinctive line for 231 or 232, so events and the quest log carry both steps. The pickaxe,
-- travel, Wandering Ghost and drop bullets leave no event or key item the client sees (the Miner's Pendant is an item, which
-- alone never proves a step) and are notes on the final trade. Event 232 also plays when the reward item (Beat Cesti) cannot be given, so it is
-- `reach` and the completed bit proves the last step. The quest is repeatable after a Memory reset, which opens a
-- fresh accept (231 again), so the quest log's bits count for the first run only.
return {
    title = 'Ghosts of the Past',
    completes = 's6',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to oggbi inside the steaming'},
         done = {
            {t = 'event', zone = 236, event = 231, why = 'Oggbi 231: the quest begun'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's6', at = {n = 2, fp = 'get a pickaxe from the auction'}},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'travel to gusgen mines go to'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'get to the 3rd map by'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'wandering ghost drops a miner s'}},
        {id = 's6', at = {n = 6, fp = 'trade the miner s pendant to'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 236, event = 232, why = "Oggbi 232: plays even when the Beat Cesti does not fit, so it is not proof"}}},
    },
}

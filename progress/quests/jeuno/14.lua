-- Step progress for Never to Return (Jeuno quest 14). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Never_to_Return.lua (Kurou-Morou 202 is the offer, offered only after three
-- fortune readings on three Vana'diel days (Prog >= 3) and begun on option 0 only, so the quest log's current bit proves
-- bullet 1 and 202 is a reach; 204 is the plain reading and plays before and after, 203 the reminder; Kurou-Morou 201 is
-- the exact Horn Hairpin trade and runs quest:complete, but the reward is a Garnet Ring, so 201 also plays when the bag is
-- full and is only a reach: the log's completed bit proves bullet 3); client event script S4 245_Kurou_Morou_010F5022.txt
-- (202 say #7556 "A thousand thanks" on the Yes branch only, 203 say #7558, 201 say #7559); item id from res/items.lua
-- (12507 Horn Hairpin). Bullet 2 explains how the quest is triggered, so it is a note on bullet 1. Not repeatable (page meta).
-- The quest log is set at the end of bullet 1, so it is not silent for the later steps.
return {
    title = 'Never to Return',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after completing your crystal ball have'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Kurou-Morou 202, option 0, after three readings)'},
            {t = 'chat', re = 'A thousand thanks, my dear clientaru!', why = 'Kurou-Morou 202, Yes branch only (say #7556)'},
            {t = 'event', zone = 245, event = 203, conf = 'inferred', why = 'Kurou-Morou 203: the reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 245, event = 202, why = 'Kurou-Morou 202 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'asking for your fourth reading will'}},
        {id = 's3', at = {n = 3, fp = 'trade a horn hairpin to kurou'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (201 also plays when the Garnet Ring cannot be given)'},
            {t = 'item', id = 12507, lost = true, after = 's1', conf = 'inferred', why = 'Horn Hairpin gone (traded, or sold)'},
         },
         reach = {{t = 'event', zone = 245, event = 201, why = 'Kurou-Morou 201: the Horn Hairpin trade (the Garnet Ring needs a free slot)'}}},
    },
}

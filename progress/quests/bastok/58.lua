-- Step progress for Dark Puppet (Bastok quest 58). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/DRK_AF2_Dark_Puppet.lua (Cid 760 begins the quest at its finish; the Ordelle's
-- Caves zone-in cutscene 10 plays once at Prog 0; the three ??? trades (ingot, axe, sword) each answer with the same
-- SENSE_A_FOUL_PRESENCE line and the kills set no signal the client sees until the La Theine Plateau zone-in cutscene 122, which
-- completes the quest); client event script S4 237_Cid_010ED02B.txt (760 is bare). The three identical trade lines cannot be told
-- apart (the engine marks every step a line matches, in one pass) and the item drops alone are not strong signals, so bullets 4
-- to 10 are notes on the closing zone-in. The draft mapped only Cid and made the quest log completion prove bullet 1. Repeatable:
-- the restart is the next 760.
return {
    title = 'Dark Puppet',
    completes = 's11',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with cid as a dark'},
         done = {
            {t = 'event', zone = 237, event = 760, why = 'Cid 760: the quest offered and begun at its finish'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'obtain a darksteel ingot from the'}},
        {id = 's3', at = {n = 3, fp = 'zone into ordelle s caves for'},
         done = {
            {t = 'zonein', zone = 193, event = 10, why = 'Ordelle\'s Caves zone-in cutscene 10: plays once at Prog 0'},
         }},
        {id = 's4', kind = 'note', with = 's11', at = {n = 4, fp = 'trade the darksteel ingot to the'}},
        {id = 's5', kind = 'note', with = 's11', at = {n = 5, fp = 'defeat gerwitz s axe and it'}},
        {id = 's6', kind = 'note', with = 's11', at = {n = 6, fp = 'head south up the ramp d'}},
        {id = 's7', kind = 'note', with = 's11', at = {n = 7, fp = 'trade gerwitz s axe to the'}},
        {id = 's8', kind = 'note', with = 's11', at = {n = 8, fp = 'defeat gerwitz s sword and it'}},
        {id = 's9', kind = 'note', with = 's11', at = {n = 9, fp = 'head south to enter a large'}},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'trade gerwitz s sword to the'}},
        {id = 's11', at = {n = 11, fp = 'defeat gerwitz s soul then head'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'zonein', zone = 102, event = 122, after = 's1', why = 'La Theine Plateau zone-in cutscene 122: plays after the Soul is dead (a full bag plays it too, no completion)'}}},
    },
}

-- Step progress for True Strength (Bastok quest 53). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/MNK_AF3_True_Strength.lua (Ayame 748 begins the quest at its finish; trading a
-- Yagudo Drink to the Castle Oztroja ??? plays YOU_HOLD only when the NM pops; Ayame 749 on the Xalmo Feather completes it);
-- zones/Castle_Oztroja/IDs.lua (YOU_HOLD); client event script S4 237_Ayame_010ED02F.txt (748 and 749 are bare). Repeatable
-- after a Memory reset: the restart is the next 748. The Xalmo Feather drop (n=5) is only an item gain, which can come from
-- elsewhere, so it is a note on the trade. Travel and direction bullets (n=2, n=3) are notes.
return {
    title = 'True Strength',
    completes = 's6',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to ayame in the metalworks'},
         done = {
            {t = 'event', zone = 237, event = 748, why = 'Ayame 748: the quest offered and begun at its finish'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'travel to castle oztroja'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head to the top floor where'}},
        {id = 's4', at = {n = 4, fp = 'look for a torch with a'},
         done = {
            {t = 'chat', re = 'over the flame%.%.%. a peculiar scent covers the area%.', why = 'Castle Oztroja YOU_HOLD: the NM popped'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'he drops xalmo feather'}},
        {id = 's6', at = {n = 6, fp = 'trade the feather to ayame for'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 237, event = 749, why = 'Ayame 749: the feather accepted (a full bag plays it too, no completion)'}}},
    },
}

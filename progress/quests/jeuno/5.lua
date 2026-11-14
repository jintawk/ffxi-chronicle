-- Step progress for Save My Son (Jeuno quest 5). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Save_My_Son.lua (Door: Merchant's House _6t2 in Lower Jeuno plays 164, a menu
-- whose option 0 begins the quest, so 164 is a reach and the log's current bit proves the step; while accepted the door
-- plays 229, or 163 once the Night Flowers cutscene is seen; Shalott plays 101 before the flowers and 44 after; the Night
-- Flowers in Qufim Island play event 0 only at night and at Prog 0; 163 runs quest:complete but the reward includes the Beast
-- Whistle, so it also plays when the bag is full and is only a reach: the log's completed bit proves the last step; 132 is
-- the door once completed). Client event script S4 244_Shalott_010F400E.txt (101 has no text, 44 say #7213); the door and the
-- Night Flowers have no client script (in LandSandBoat's lists for zones 245 and 126 only). Not repeatable.
return {
    title = 'Save My Son',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the door merchant s house'},
         done = {
            {t = 'quest', current = true, why = "quest log: accepted (Door: Merchant's House 164, option 0)"},
            {t = 'event', zone = 245, event = 229, conf = 'inferred', why = "Door: Merchant's House 229: plays only while accepted, before the flowers"},
         },
         reach = {{t = 'event', zone = 245, event = 164, why = "Door: Merchant's House 164 offered (its finish needs option 0)"}}},
        {id = 's2', kind = 'optional', at = {n = 2, fp = 'optional speak to shalott upper jeuno'},
         done = {
            {t = 'event', zone = 244, event = 101, why = 'Shalott 101: only while accepted, before the flowers'},
            {t = 'event', zone = 244, event = 44, why = 'Shalott 44: after the flowers, or once completed'},
            {t = 'chat', re = "What%? Oh, that guy's kid got better%?", why = 'Shalott 44 (say #7213)'},
         }},
        {id = 's3', at = {n = 3, fp = 'examine the night flowers down the'},
         done = {
            {t = 'event', zone = 126, event = 0, why = 'Night Flowers 0: the cutscene, only at night and at Prog 0'},
            {t = 'event', zone = 245, event = 163, conf = 'inferred', why = "Door: Merchant's House 163: plays only after the flowers"},
         }},
        {id = 's4', at = {n = 4, fp = 'examine the door merchant s house'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 245, event = 132, conf = 'inferred', why = "Door: Merchant's House 132: plays only once completed"},
         },
         reach = {{t = 'event', zone = 245, event = 163, why = "Door: Merchant's House 163 (also plays when the Beast Whistle cannot be given)"}}},
    },
}

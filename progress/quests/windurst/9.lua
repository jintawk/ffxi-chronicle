-- Step progress for The Moonlit Path (Windurst quest 9). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/The_Moonlit_Path.lua (Leepe-Hoppe 842 is the offer menu, begun only on
-- option 2; 843 is the reminder while a whisper is missing; 844 plays only when ALL SIX whispers are held and there is no
-- Moon bauble yet, and its option 0 hands over the bauble; 845 the reminder with the bauble held; winning the Full Moon
-- Fountain battlefield gives the Whisper of the moon; 846 (and 850 on a repeat) is the reward menu, which plays whatever the
-- player picks and only completes the quest and takes the whisper once the choice could be given, so both are only reaches
-- and the whisper's loss and the quest log's completed bit carry the last step; 847 and 851 play once completed; 848 offers
-- a repeat, which deletes and begins the quest again and gives a new Moon bauble). The six whispers have no single signal
-- (each key item alone is one fight), so event 844 proves bullet 2 and the six key items are only its reach. Event 32001 at
-- the fountain is any win in that zone, so the Whisper of the moon key item proves the fight; the travel and entry bullets
-- (4, 5) are notes on it. A repeat needs no whispers: the new bauble opens the next run (restart s3, skip s1 and s2) and the
-- quest-log matchers count for the first run only (run1). Client event script S4 238_Leepe_Hoppe_010EE030.txt (842 menu
-- #10105, 844 say #10123, 845 say #10138, 846 menu #10152); key item ids from res/key_items.lua (320 to 325 the six whispers,
-- 326 whisper of the moon, 334 moon bauble). Bullets 8 to 14 are tips. The quest log is set at s1, so it is not silent.
-- Shared-signal audit: key items 320 to 325 (the six whispers) are also given by the Trial by Fire/Earth/Water/Wind/Ice/Lightning quests (bastok/61, sandoria/59 and unmapped ones): shared, gated after s1.
-- The restart on s3 rests on the moon bauble and event 845 only, which are unique to this quest.
return {
    title = 'The Moonlit Path',
    completes = 's7',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s3'}, skip = {'s1', 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to leepe hoppe to begin'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 238, event = 843, conf = 'inferred', why = 'Leepe-Hoppe 843: reminder, only once accepted'},
         },
         reach = {{t = 'event', zone = 238, event = 842, why = 'Leepe-Hoppe 842 offered (its finish needs option 2)'}}},
        {id = 's2', at = {n = 2, fp = 'next you must battle the six'},
         done = {
            {t = 'event', zone = 238, event = 844, why = 'Leepe-Hoppe 844: plays only with all six whispers held'},
         },
         reach = {
            {t = 'ki', id = 320, gained = true, after = 's1', why = 'whisper of flames obtained'},
            {t = 'ki', id = 321, gained = true, after = 's1', why = 'whisper of tremors obtained'},
            {t = 'ki', id = 322, gained = true, after = 's1', why = 'whisper of tides obtained'},
            {t = 'ki', id = 323, gained = true, after = 's1', why = 'whisper of gales obtained'},
            {t = 'ki', id = 324, gained = true, after = 's1', why = 'whisper of frost obtained'},
            {t = 'ki', id = 325, gained = true, after = 's1', why = 'whisper of storms obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'turn the whispers into leepe hoppe'},
         done = {
            {t = 'ki', id = 334, gained = true, why = 'moon bauble obtained'},
            {t = 'ki_have', id = 334, have = true, why = 'moon bauble held'},
            {t = 'chat', re = 'obtained key item: moon bauble', why = 'chat: key item obtained'},
            {t = 'event', zone = 238, event = 845, conf = 'inferred', why = 'Leepe-Hoppe 845: reminder, only with the bauble held'},
         },
         reach = {{t = 'event', zone = 238, event = 844, why = 'Leepe-Hoppe 844 (its finish needs option 0)'}}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'head to full moon fountain'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'with the moon bauble key item'}},
        {id = 's6', at = {n = 6, fp = 'defeat fenrir prime and you will'},
         done = {
            {t = 'ki', id = 326, gained = true, why = 'whisper of the moon obtained'},
            {t = 'ki_have', id = 326, have = true, why = 'whisper of the moon held'},
            {t = 'chat', re = 'obtained key item: whisper of the moon', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to leepe hoppe to turn'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 326, gained = false, why = 'whisper of the moon handed over (only after the reward could be given)'},
            {t = 'event', zone = 238, event = 847, conf = 'inferred', why = 'Leepe-Hoppe 847: plays only once completed'},
            {t = 'event', zone = 238, event = 851, conf = 'inferred', why = 'Leepe-Hoppe 851: the same, after a repeat'},
         },
         reach = {
            {t = 'event', zone = 238, event = 846, why = 'Leepe-Hoppe 846: the reward menu (the quest completes only if the choice can be given)'},
            {t = 'event', zone = 238, event = 850, why = 'Leepe-Hoppe 850: the same on a repeat'},
         }},
    },
}

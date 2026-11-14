-- Step progress for Star Struck (Windurst quest 10). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Star_Struck.lua (Koru-Moru 197 is a Yes/No menu that plays only while the
-- Torn Epistle is held, and option 0 begins the quest, so it is only a reach; 198 is his talk while accepted; trading the
-- epistle again plays 199, a 50 gil swap that does not advance the quest; the Meteorite trade plays 211, which completes the
-- quest, but the Compound Eye Circlet reward cannot be given on a full bag while 211 still plays and the trade is only taken
-- on success, so 211 is only a reach and the quest log's completed bit carries the last step; 213 plays once completed).
-- Client event script S4 239_Koru_Moru_010EF021.txt (197 menu #7547, 198 say #7550, 199 say #7551, 213 say #7575). Bullets 1
-- and 3 (kill Savanna Rarabs for the Torn Epistle, kill crawlers for the Meteorite) are drops that only an item gain could
-- show, and an item alone proves nothing, so they stay plain bullets. Not repeatable (page meta). The quest log is set at s2,
-- so it is not silent.
return {
    title = 'Star Struck',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'speak to koru moru while the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Koru-Moru 197, option 0)'},
            {t = 'event', zone = 239, event = 198, conf = 'inferred', why = 'Koru-Moru 198: his talk, only while accepted'},
            {t = 'event', zone = 239, event = 199, conf = 'inferred', why = 'Koru-Moru 199: the epistle swapped for 50 gil, only while accepted'},
         },
         reach = {{t = 'event', zone = 239, event = 197, why = 'Koru-Moru 197 offered (its finish needs option 0)'}}},
        {id = 's4', at = {n = 4, fp = 'trade the meteorite to koru moru'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 239, event = 213, conf = 'inferred', why = 'Koru-Moru 213: plays only once completed'},
         },
         reach = {{t = 'event', zone = 239, event = 211, why = 'Koru-Moru 211 (also plays when the Compound Eye Circlet cannot be given)'}}},
    },
}

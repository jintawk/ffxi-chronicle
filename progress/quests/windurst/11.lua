-- Step progress for Blast from the Past (Windurst quest 11). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Blast_from_the_Past.lua (Koru-Moru 214 is a Yes/No menu, option 0 begins the
-- quest, so it is only a reach; 215 and 216 are his talk while accepted; the Burnite Shell trade plays 224, which completes
-- the quest, but the Great Club reward cannot be given on a full bag while 224 still plays, so it is only a reach and the
-- quest log's completed bit carries the last step; any other trade plays 225, a refusal; 223 is Yoran-Oran's line once
-- completed). Client event script S4 239_Koru_Moru_010EF021.txt (214 menu #7582, 215 say #7586, 216 say #7588). Bullet 1
-- (zone first) is a note on the offer and bullet 3 (the way to the Maze of Shakhrami) a note on the trade; bullet 4 (the
-- Fossil Rock NM drops the Burnite Shell) is a fight and a drop with no strong signal and stays a plain bullet. The optional
-- hints under bullet 2 are indented. Not repeatable (page meta). The quest log is set at s2, so it is not silent.
return {
    title = 'Blast from the Past',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'zone in and out if you'}},
        {id = 's2', at = {n = 2, fp = 'speak to koru moru to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Koru-Moru 214, option 0)'},
            {t = 'event', zone = 239, event = 216, conf = 'inferred', why = 'Koru-Moru 216: his talk, only while accepted'},
            {t = 'event', zone = 239, event = 215, conf = 'inferred', why = 'Koru-Moru 215: his talk after the hints, only while accepted'},
         },
         reach = {{t = 'event', zone = 239, event = 214, why = 'Koru-Moru 214 offered (its finish needs option 0)'}}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'head to the maze of shakhrami'}},
        {id = 's5', at = {n = 5, fp = 'trade the burnite shell to koru'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 239, event = 223, conf = 'inferred', why = 'Yoran-Oran 223: plays only once completed'},
         },
         reach = {{t = 'event', zone = 239, event = 224, why = 'Koru-Moru 224 (also plays when the Great Club cannot be given)'}}},
    },
}

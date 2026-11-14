-- Step progress for Welcome! To My Decrepit Domicile (A Moogle Kupo d'Etat mission 4, mission id 3). Data only; see
-- progress/missions/sandoria/0.lua for the format and progress/missions/zilart/10.lua for the any-order groups.
-- Evidence: LandSandBoat scripts/missions/amk/04_Welcome_To_My_Decrepit_Domicile.lua and missions/amk/helpers.lua (helmTrade). The
-- three materials are key items a mining, logging or harvesting point gives at 5% once the line is at this mission or later: Sturdy
-- metal strip 1136, Piece of rugged tree bark 1137, Savory lamb roast 1138 (res/key_items.lua). The page says they can be gathered in
-- any order, so each is a group opened by the line reaching this mission (a single group would infer the ones not seen as done); the
-- strip joins the three one-step groups into one row. A gather is a drop, so the key item gained or still held is only `reach`; what proves
-- the bullet is the door taking the key item (event 10179 / 10180 / 10181 play only while the key item is held, and their finishes
-- delete it, so the loss is a hand-in). The Inconspicuous Door in Upper Jeuno (244) is one bullet with three cutscenes, one per material, in the order strip,
-- bark, roast (mission status 0, 1, 2). The first two are partial progress of that bullet (reach); the third, 10181, runs
-- mission:complete and proves it, and it implies the three gathers. The reminders 10186 to 10188 (the door without the key item) prove
-- nothing. The mkd line has no completed set in Chronicle (core/data.lua get_mission_read), so the completion is also the line moving
-- past it (min = 4). Bullets 5 and 6 are gathering tips (notes on the door step). Bullets 7 to 9 belong to the "A Moogle Kupo d'Etat" Key section
-- (Squintrox Dryeyes needs the line at the Fin mission before he hands out the Blue coral key) and stay plain bullets. The draft's
-- repeatable restart was a guess: LandSandBoat never reruns the mission, only the key exchange repeats, so it is dropped.
return {
    title = 'Welcome! To My Decrepit Domicile',
    completes = 's4',
    known = {{t = 'mission', line = 'mkd', eq = 3}},
    groups = {
        strip = {start = {{t = 'mission', line = 'mkd', eq = 3}}},
        bark = {start = {{t = 'mission', line = 'mkd', eq = 3}}},
        roast = {start = {{t = 'mission', line = 'mkd', eq = 3}}},
    },
    steps = {
        {id = 's1', group = 'strip', at = {n = 1, fp = 'go to gusgen mines or palborough'},
         done = {
            {t = 'ki', id = 1136, gained = false, why = 'Sturdy metal strip handed over at the door (10179)'},
            {t = 'event', zone = 244, event = 10179, why = 'Inconspicuous Door 10179: plays only with the strip in hand'},
         },
         reach = {
            {t = 'ki', id = 1136, gained = true, why = 'Sturdy metal strip obtained (mining point, helpers.helmTrade)'},
            {t = 'ki_have', id = 1136, have = true, why = 'Sturdy metal strip held'},
            {t = 'chat', re = 'obtained key item: sturdy metal strip', why = 'chat: key item obtained'},
         }},
        {id = 's2', group = 'bark', at = {n = 2, fp = 'go to east ronfaure or jugner'},
         done = {
            {t = 'ki', id = 1137, gained = false, why = 'Piece of rugged tree bark handed over at the door (10180)'},
            {t = 'event', zone = 244, event = 10180, why = 'Inconspicuous Door 10180: plays only with the bark in hand'},
         },
         reach = {
            {t = 'ki', id = 1137, gained = true, why = 'Piece of rugged tree bark obtained (logging point, helpers.helmTrade)'},
            {t = 'ki_have', id = 1137, have = true, why = 'Piece of rugged tree bark held'},
            {t = 'chat', re = 'obtained key item: piece of rugged tree bark', why = 'chat: key item obtained'},
         }},
        {id = 's3', group = 'roast', at = {n = 3, fp = 'go to giddeus or west sarutabaruta'},
         done = {
            {t = 'ki', id = 1138, gained = false, why = 'Savory lamb roast handed over at the door (10181)'},
            {t = 'event', zone = 244, event = 10181, why = 'Inconspicuous Door 10181: plays only with the roast in hand'},
         },
         reach = {
            {t = 'ki', id = 1138, gained = true, why = 'Savory lamb roast obtained (harvesting point, helpers.helmTrade)'},
            {t = 'ki_have', id = 1138, have = true, why = 'Savory lamb roast held'},
            {t = 'chat', re = 'obtained key item: savory lamb roast', why = 'chat: key item obtained'},
         }},
        {id = 's4', implies = {'s1', 's2', 's3'}, at = {n = 4, fp = 'after you have all three key'},
         done = {
            {t = 'event', zone = 244, event = 10181, why = 'Inconspicuous Door 10181: the third cutscene, completes the mission'},
            {t = 'mission', line = 'mkd', min = 4, why = 'mission line: moved on to Curses! A Horrifically Harrowing Hex (this one completed)'},
         },
         reach = {
            {t = 'event', zone = 244, event = 10179, why = 'Inconspicuous Door 10179: first cutscene'},
            {t = 'event', zone = 244, event = 10180, why = 'Inconspicuous Door 10180: second cutscene'},
            {t = 'ki', id = 1136, gained = false, why = 'Sturdy metal strip taken by the door'},
            {t = 'ki', id = 1137, gained = false, why = 'Piece of rugged tree bark taken by the door'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'these key items can be obtained'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'for maximum efficiency be sure that'}},
    },
}

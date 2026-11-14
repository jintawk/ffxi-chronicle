-- Step progress for The Signpost Marks the Spot (Bastok quest 22). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Signpost_Marks_the_Spot.lua (Nbu Latteh 235 begins it only on option 0, a
-- refusal plays the same event; the Konschtat signpost gives key item 108; Roh Latteh 96 runs quest:complete, which also gives
-- the Linen Robe, and only then takes the painting); client event scripts S4 235_Nbu_Latteh_010EB032.txt (235) and
-- 234_Roh_Latteh_010EA014.txt (96, no decoded line); key item 108 from res/key_items.lua. Full-inventory rule: 96 plays the
-- same with a full bag, so it is `reach` only; the quest log and the loss of the painting prove s5. Bullet 2 (the hints from
-- Nbu and the guard) is optional and has no signal here: Parnika's event 232 belongs to Mom, the Adventurer? and plays for
-- anyone who has done it. Bullet 3 (travel and examine) is a note on the painting, which is bullet 4. The quest log is set
-- at s1, so it is not silent.
return {
    title = 'The Signpost Marks the Spot',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to nbu latteh at j'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         },
         reach = {{t = 'event', zone = 235, event = 235, why = 'Nbu Latteh 235 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'optional', at = {n = 2, fp = 'optional speak to nbu latteh again'}, done = {}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'travel to konschtat highlands and inspect'}},
        {id = 's4', at = {n = 4, fp = 'you will receive a painting of'},
         done = {
            {t = 'ki', id = 108, gained = true, why = 'painting of a windmill obtained'},
            {t = 'ki_have', id = 108, have = true, why = 'painting of a windmill held'},
            {t = 'chat', re = 'obtained key item: painting of a windmill', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to bastok mines and speak'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 108, gained = false, why = 'painting of a windmill handed over (taken only after the completion succeeded)'},
         },
         reach = {{t = 'event', zone = 234, event = 96, why = 'Roh Latteh 96 (also plays with a full bag, the Linen Robe may not fit)'}}},
    },
}

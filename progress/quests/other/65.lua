-- Step progress for X Marks the Spot (Other Areas quest 65). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/X_Marks_The_Spot.lua (Despachiaire 144 begins the quest; Parelbriaux 145 sets
-- Prog 1; Odeya 141 at Prog 1 sets Prog 2 and plays 146 as a reminder after that; the Tavnazian Liver traded at Prog 2 plays 142
-- and sets Prog 3; Odeya plays 147 as a reminder at Prog 3; the Phomiuna Aqueducts 2nd Ornate Gate plays 37 at Prog 3 and sets
-- Prog 4; Odeya 143 at Prog 4 completes the quest); client event scripts S4 026_Despachiaire_0101A009.txt (144 say #10459),
-- 026_Parelbriaux_0101A00E.txt (145 say #10468), 026_Odeya_0101A036.txt (146 say #10473, 147 say #10481; 141, 142, 143 are
-- bare). Bullets 7-10 (the aqueduct maps and the gate) are indented, so they are not steps: the gate's event 37 is a reach
-- of the closing bullet. The draft read Odeya 147 as the trade; it is her reminder after the trade, so it only infers it.
return {
    title = 'X Marks the Spot',
    completes = 's11',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to despachiaire k 10 upper'},
         done = {
            {t = 'event', zone = 26, event = 144, why = 'Despachiaire 144: begins the quest'},
            {t = 'chat', re = "Whatever could she have been searching for in Prishe's quarters%?", why = 'Despachiaire 144 (say #10459)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to parelbriaux k 7 upper'},
         done = {
            {t = 'event', zone = 26, event = 145, why = 'Parelbriaux 145 (Prog 1)'},
            {t = 'chat', re = 'That Mithra is some kind of tracker called a sin hunter%.', why = 'Parelbriaux 145 (say #10468)'},
         }},
        {id = 's3', at = {n = 3, fp = 'talk to odeya j 10 upper'},
         done = {
            {t = 'event', zone = 26, event = 141, why = 'Odeya 141 (Prog 1 to 2)'},
            {t = 'event', zone = 26, event = 146, conf = 'inferred', why = 'Odeya 146: her reminder at Prog 2'},
            {t = 'chat', re = "Speaking of eating, it's the season for", conf = 'inferred', why = 'Odeya 146 (say #10473)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'obtain a tavnazian liver from the'}},
        {id = 's5', at = {n = 5, fp = 'return to tavnazian safehold and trade'},
         done = {
            {t = 'event', zone = 26, event = 142, why = 'Odeya 142: exactly one Tavnazian Liver traded at Prog 2'},
            {t = 'event', zone = 26, event = 147, conf = 'inferred', why = 'Odeya 147: her reminder at Prog 3, after the trade'},
            {t = 'chat', re = "My eyes aren't as sharp as they used to be, but it looked like she found a key to some part of the cathedral in Prishe's room%.", conf = 'inferred', why = 'Odeya 147 (say #10481)'},
         }},
        {id = 's6', kind = 'note', with = 's11', at = {n = 6, fp = 'proceed to phomiuna aqueducts'}},
        {id = 's11', at = {n = 11, fp = 'return to odeya for the next'},
         done = {
            {t = 'event', zone = 26, event = 143, after = 's5', why = 'Odeya 143: completes the quest (Prog 4)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 27, event = 37, after = 's5', why = 'Phomiuna Aqueducts 2nd Ornate Gate 37 (Prog 3 to 4)'},
         }},
    },
}

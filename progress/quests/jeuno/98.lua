-- Step progress for Comeback Queen (Jeuno quest 98). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/DNC_AF3_Comeback_Queen.lua (Laila 10143 begins the quest with no refusal and
-- gives Wyatt's proposal; Harmodios in Bastok Markets plays 490 at Prog 0, takes the proposal and sets Prog 1, 491 is his
-- talk afterwards; Laila 10147 at Prog 1 starts the one day wait; Rhea Myuliah plays 10149 at Prog 2 or 3; Laila plays 10151
-- once the wait is over, as a menu whose option 0 sends the player back to practise, so it is only a reach; choosing to
-- perform runs the Upper Jeuno zone-in cutscenes 10208, 10209, 10210 and 10211 in a row at Prog 4 to 7, and 10211 completes
-- the quest only if the Dancer's Casaque could be given, so it is a reach and the completed bit carries the last bullet;
-- 10154 is the reminder at Prog 8). Client event scripts S4 235_Harmodios_010EB020.txt (491 say #12442), 244_Laila_010F40BD.txt
-- (10144 say #12004 is the Prog 0 talk), 244_Rhea_Myuliah_010F40BB.txt and 244_Rhea_Myuliah_010F40BE.txt (bare). Key item 973
-- (Wyatt's proposal) and the zone ids (244 Upper Jeuno, 235 Bastok Markets) from res/. The performance cutscenes begin only
-- after the player chose to perform, so 10208 proves bullet 5 and 10209 to 10211 are reaches of the last bullet. The tips on
-- the audience (n=6) are a note. The quest log is set at s1, so it is not silent. Not repeatable (page meta).
return {
    title = 'Comeback Queen',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to laila in upper jeuno'},
         done = {
            {t = 'event', zone = 244, event = 10143, why = 'Laila 10143: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 973, gained = true, why = 'Wyatt\'s proposal obtained'},
            {t = 'ki_have', id = 973, have = true, why = 'Wyatt\'s proposal held'},
            {t = 'chat', re = 'obtained key item: wyatt\'s proposal', why = 'chat: key item obtained'},
            {t = 'event', zone = 244, event = 10144, conf = 'inferred', why = 'Laila 10144: her talk at Prog 0, only while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to harmodios in bastok markets'},
         done = {
            {t = 'event', zone = 235, event = 490, why = 'Harmodios 490 (Prog 0): takes the proposal'},
            {t = 'ki', id = 973, gained = false, after = 's1', why = 'Wyatt\'s proposal handed over'},
            {t = 'event', zone = 235, event = 491, conf = 'inferred', why = 'Harmodios 491: his talk after Prog 1'},
            {t = 'chat', re = 'A collaboration of circus and dance, huh%?', conf = 'inferred', why = 'Harmodios 491 (say #12442)'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to upper jeuno and speak'},
         done = {
            {t = 'event', zone = 244, event = 10147, why = 'Laila 10147 (Prog 1): starts the one day wait'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to rhea myuliah in upper'},
         done = {
            {t = 'event', zone = 244, event = 10149, why = 'Rhea Myuliah 10149 (Prog 2 or 3)'},
         }},
        {id = 's5', at = {n = 5, fp = 'after you feel comfortable with performing'},
         done = {
            {t = 'zonein', zone = 244, event = 10208, why = 'Upper Jeuno zone-in cutscene 10208: the performance begins (Prog 4)'},
         },
         reach = {{t = 'event', zone = 244, event = 10151, why = 'Laila 10151: the menu once the wait is over (option 0 sends you back to practise)'}}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'the audience is composed of 3'}},
        {id = 's7', at = {n = 7, fp = 'perform the best to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'zonein', zone = 244, event = 10209, why = 'Upper Jeuno zone-in cutscene 10209 (Prog 5)'},
            {t = 'zonein', zone = 244, event = 10210, why = 'Upper Jeuno zone-in cutscene 10210 (Prog 6)'},
            {t = 'zonein', zone = 244, event = 10211, why = 'Upper Jeuno zone-in cutscene 10211 (Prog 7; completes only if the casaque could be given)'},
            {t = 'event', zone = 244, event = 10154, why = 'Laila 10154: reminder at Prog 8, the casaque not yet given'},
         }},
    },
}

-- Step progress for A Knight's Test (San d'Oria quest 29). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/A_Knights_Test.lua (Balasiel 627/635 give Book of Tasks 143 and begin the
-- quest on option 0; Cahaurme 633 gives Book of the East 144; Baunise 634 gives Book of the West 145; the Disused Well in
-- Davoi gives Knight's soul 146 once both books are held; Balasiel 628 needs the soul, completes the quest and takes the
-- four key items); client event scripts S4 230_Balasiel_010E603F.txt (627 say #8041 is the option 0 branch, 669 say #8042,
-- 628 say #8050; the reward is an item (Kite Shield), so with no free slot 628 plays and the quest is NOT completed: 628 is
-- only `reach`, the quest log is the proof), 230_Cahaurme_010E6004.txt, 230_Baunise_010E6005.txt. The books can be fetched in either order. The
-- bullets n=5 to n=7 are indented hints, not steps.
return {
    title = "A Knight's Test",
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to balasiel who will give'},
         done = {
            {t = 'chat', re = 'Excellent%. This will be your last task, then%.', why = 'Balasiel 627/635 (say #8041, option 0 branch)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 143, gained = true, why = 'Book of Tasks obtained'},
            {t = 'ki_have', id = 143, have = true, why = 'Book of Tasks held'},
            {t = 'chat', re = 'obtained key item: book of tasks', why = 'chat: key item obtained'},
            {t = 'event', zone = 230, event = 669, conf = 'inferred', why = 'Balasiel 669: plays only once accepted'},
            {t = 'chat', re = 'The way of the sword is the way of action!', conf = 'inferred', why = 'Balasiel 669 (say #8042)'},
         },
         reach = {{t = 'event', zone = 230, event = 627, why = 'Balasiel 627 offered (accepting needs option 0)'},
                  {t = 'event', zone = 230, event = 635, why = 'Balasiel 635 offered (accepting needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to cahaurme j 9 from'},
         done = {
            {t = 'event', zone = 230, event = 633, why = 'Cahaurme 633'},
            {t = 'ki', id = 144, gained = true, why = 'Book of the East obtained'},
            {t = 'ki_have', id = 144, have = true, why = 'Book of the East held'},
            {t = 'chat', re = 'obtained key item: book of the east', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to baunise h 9 from'},
         done = {
            {t = 'event', zone = 230, event = 634, why = 'Baunise 634'},
            {t = 'ki', id = 145, gained = true, why = 'Book of the West obtained'},
            {t = 'ki_have', id = 145, have = true, why = 'Book of the West held'},
            {t = 'chat', re = 'obtained key item: book of the west', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'go to the dead end on'},
         done = {
            {t = 'ki', id = 146, gained = true, why = "Knight's soul obtained"},
            {t = 'ki_have', id = 146, have = true, why = "Knight's soul held"},
            {t = 'chat', re = "obtained key item: knight's soul", why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'return to balasiel to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 146, gained = false, conf = 'inferred', why = "Knight's soul handed over"},
            {t = 'ki', id = 143, gained = false, conf = 'inferred', why = 'Book of Tasks handed over'},
            {t = 'ki', id = 145, gained = false, conf = 'inferred', why = 'Book of the West handed over'},
            {t = 'ki', id = 144, gained = false, conf = 'inferred', why = 'Book of the East handed over'},
         },
         reach = {{t = 'event', zone = 230, event = 628, why = 'Balasiel 628: the hand-in (a full bag plays it too, no completion)'}}},
    },
}

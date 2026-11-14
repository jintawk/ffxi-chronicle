-- Step progress for Go! Go! Gobmuffin! (Other Areas quest 69). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Go_Go_Gobmuffin.lua (Epinolle 232 begins the quest, 233 is her reminder at
-- Prog 0; killing all three Riverne - Site B01 NMs sets Prog 1, with no event of its own; Epinolle 234 at Prog 1 completes the
-- quest; 235 is her after-quest line); client event script S4 026_Epinolle_0101A046.txt (232 say #10781, 233 say #10786, 235
-- say #10807; 234 is bare). The draft completed the quest at the begin step; 234 completes it on the last bullet, and 235
-- plays only after completion, so it proves nothing. The quest log is set at the begin step, so it is not silent. Bullet 1 is
-- the prerequisite and bullets 3-5 are the trip to Riverne.
return {
    title = 'Go! Go! Gobmuffin!',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'to activate this quest you must'}},
        {id = 's2', at = {n = 2, fp = 'speak to epinolle to begin this'},
         done = {
            {t = 'event', zone = 26, event = 232, why = 'Epinolle 232: begins the quest'},
            {t = 'chat', re = 'You know about what happened to Cape Riverne, right%?', why = 'Epinolle 232 (say #10781)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 26, event = 233, conf = 'inferred', why = 'Epinolle 233: her reminder at Prog 0'},
            {t = 'chat', re = "Would you go to Cape Riverne and see if you can find that sweet Gobmuffin", conf = 'inferred', why = 'Epinolle 233 (say #10786)'},
         }},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'enter riverne site b01'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'once inside head to the island'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'as soon as you exit the'}},
        {id = 's6', at = {n = 6, fp = 'return to epinolle after you ve'},
         done = {
            {t = 'event', zone = 26, event = 234, after = 's2', why = 'Epinolle 234: all three NMs dead, completes the quest'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

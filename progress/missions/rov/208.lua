-- Step progress for Past Imperfect (Rhapsodies of Vana'diel mission, page id 208). Data only; see progress/missions/adoulin/134.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_23_Past_Imperfect.lua: the Oaken Door `_700` in Norg plays event 286 while this mission is
-- current and the party members are available (otherwise only a message, no event); its finish is `mission:complete`, nothing is asked. The
-- first param (0/1/2) only reflects Rise of the Zilart progress. No client event script for it. Another mission's door scene can take priority
-- on the first talk (see the page's Notes bullet), which is not this mission's event.
-- The rov line has no completed set, so the completion is `min = 209`. The next mission, The Cursed Temple, is page 209 in the client's table
-- but LandSandBoat's enum puts it at 210 (102 + 108), and which one the line holds is unproven; 209 is true for both.
return {
    title = 'Past Imperfect',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', eq = 208}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'return to norg for a cutscene'},
         done = {
            {t = 'event', zone = 252, event = 286, why = 'Norg Oaken Door 286: the mission scene, its finish completes'},
            {t = 'mission', line = 'rov', min = 209, why = 'mission log: the line moved past Past Imperfect (209 or 210)'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'this mission can be blocked or'}},
    },
}

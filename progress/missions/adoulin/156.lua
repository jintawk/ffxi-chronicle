-- Step progress for For Whom Do We Toil? (Seekers of Adoulin mission, page id 156). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_5_2_For_Whom_Do_We_Toil.lua. Rala Waterways (258) returns cutscene 356 from onZoneIn
-- only at mission status 0 (its finish sets status 1), so the zone-in proves bullet 1. The Sluice Gate (258) plays event 343 as the
-- password prompt: the finish option separates the right password (completes), a wrong one (counts a failure) and a failed answer
-- (status 2, completed on the next click), and a matcher cannot see the option, so 343 is only `reach` (it plays only at status 1
-- with fewer than 3 failures, in this mission). The line moving past the mission is the only proof of bullet 2, and it covers the
-- status 2 path that completes with no event. Rejected from the draft: History 1003 and its "This shelf is packed" line (a menu
-- that plays on every visit and is not required), Wegellion 1504 (sets an Option nothing tests), Levil 126 and Yefafa 1 (reminders).
-- The adoulin line has no completed set (packet value = page id), so the completion is `min = 157`, not `completed = true`.
-- Note detailing seditious plans (bullet 3) is the reward key item, so that bullet is a note.
return {
    title = 'For Whom Do We Toil?',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 156}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter rala waterways for a cutscene'},
         done = {
            {t = 'zonein', zone = 258, event = 356, why = 'Rala Waterways zone-in 356 (status 0 only)'},
         }},
        {id = 's2', at = {n = 2, fp = 'proceed south to the dead end'},
         done = {
            {t = 'mission', line = 'adoulin', min = 157, why = 'mission log: the line moved past For Whom Do We Toil?'},
         },
         reach = {
            {t = 'event', zone = 258, event = 343, why = 'Sluice Gate 343: the password prompt (plays on right and wrong answers)'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'once the cutscene is completed you'}},
    },
}

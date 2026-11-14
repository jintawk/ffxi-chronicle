-- Step progress for Slanderous Utterings (Chains of Promathia 4-4, mission id 438). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/4_4_Slanderous_Utterings.lua; client script 026_Despachiaire_0101A009.txt lists event
-- 112 (body empty); the Iron Gate (_0w0, Sealion's Den 32) event 13 is LandSandBoat's (no client script). The trigger area behind the
-- Walnut Door plays event 112 only at status 0; the Iron Gate event 13 plays only at status 1 and completes the mission. Bullet 2
-- is travel (a note). Dropped from the draft: Despachiaire 132 and 317 (briefings that play while the mission is current and
-- after it, the chat lines with them) and Arquil 293 (after the mission).
return {
    title = 'Slanderous Utterings',
    completes = 's3',
    known = {{t = 'mission', line = 'cop', eq = 438}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach despachiaire through the walnut door'},
         done = {
            {t = 'event', zone = 26, event = 112, why = 'Walnut Door trigger area 112: the cutscene (status 0 only)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to the bottom floor home'}},
        {id = 's3', at = {n = 3, fp = 'check the iron gate in sealion'},
         done = {
            {t = 'mission', line = 'cop', eq = 438, completed = true, why = 'mission log: Slanderous Utterings completed'},
            {t = 'event', zone = 32, event = 13, why = "Iron Gate 13 in Sealion's Den: completes (status 1 only, LandSandBoat)"},
         }},
    },
}

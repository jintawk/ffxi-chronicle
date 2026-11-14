-- Step progress for Something Fishy (Windurst quest 52). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Port_Windurst/npcs/Tokaka.lua (208 is the offer, played only while the quest is
-- available, and its finish adds the quest with no choice; 209 is her talk once the quest is accepted or done and no zoning
-- is owed; 211 is the same talk while a zoning is owed; trading one Bastore Sardine is event 210, which needs her earlier
-- talk and no owed zoning, so it has no refusal path, and completes the quest on the first run). Repeatable: after zoning,
-- Tokaka's 209 is the first talk of the next run, so it is s1's restart signal; 211 is not used on s1 because it also plays
-- right after the trade and would open a run too early. The quest log's accepted and completed bits count for the first run
-- only. The two notes under the page's Notes heading are not steps. The quest log is set at s1, so it is not silent.
-- Client script S4 240_Tokaka_010F0034.txt has no distinctive line for 208 or 210 and 209's lines carry item placeholders,
-- so there are no chat patterns.
-- Tokaka 209 plays on every talk after acceptance or completion, so as a restart proof it would reopen a finished page: moved from done to reach (208 stays the restart proof).
return {
    title = 'Something Fishy',
    completes = 's2',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to tokaka to begin this'},
         done = {
            {t = 'event', zone = 240, event = 208, why = 'Tokaka 208: the offer, adds the quest'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
         },
         reach = {{t = 'event', zone = 240, event = 209, why = 'Tokaka 209: her talk once the quest is accepted or done (also after completion)'}}},
        {id = 's2', at = {n = 2, fp = 'trade tokaka a bastore sardine to'},
         done = {
            {t = 'event', zone = 240, event = 210, why = 'Tokaka 210: the Bastore Sardine accepted'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
    },
}

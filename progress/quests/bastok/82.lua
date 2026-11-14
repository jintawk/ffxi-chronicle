-- Step progress for Chips (Bastok quest 82). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Chips.lua (Ghebi Damomohe 169 begins the quest only on option 0, option 1 only
-- sets must-zone; Cid 883 plays only for a trade of the three chips with a free slot and no CCB Polymer held, both checked
-- before the event, and completes the quest; once completed, the same trade plays 884 and completes again); client event
-- scripts S4 245_Ghebi_Damomohe_010F5006.txt (169: "Welcome to Neptune's Spire!" plays on accept and refuse, so it is not
-- proof; "Well, it looks like those jewels" plays after the accept menu choice only) and 237_Cid_010ED02B.txt (884 say #10088;
-- 883 is bare). The quest is repeatable: a repeat needs only the trade (884), the log keeps its current bit on retail, so the
-- log matchers are first-run only and event 884 opens the next run.
return {
    title = 'Chips',
    completes = 's3',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s3'}, skip = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ghebi damomohe in lower'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (Ghebi Damomohe 169, option 0)'},
            {t = 'chat', re = "Well, it looks like those jewels aren't just any rocks", why = 'Ghebi Damomohe 169, accept branch only (say #8778)'},
         },
         reach = {{t = 'event', zone = 245, event = 169, why = 'Ghebi Damomohe 169 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'in pso xja fight the following'}},
        {id = 's3', at = {n = 3, fp = 'trade all three chips to cid'},
         done = {
            {t = 'event', zone = 237, event = 883, why = 'Cid 883: the three chips accepted, reward checked first'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'event', zone = 237, event = 884, why = 'Cid 884: a repeat trade'},
            {t = 'chat', re = 'Ah, another set of chips%.', why = 'Cid 884 (say #10088)'},
         }},
    },
}

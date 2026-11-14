-- Step progress for A Squire's Test (San d'Oria quest 10). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/A_Squires_Test.lua (Balasiel 616 or 631 begin the quest only on the accept
-- answer, a refusal plays the same event; trading exactly one Revival Tree Root is event 617, which runs quest:complete);
-- client event script S4 230_Balasiel_010E603F.txt (616/631 accept branch say #7895, 617 say #7897). Bullets 2 and 3 are
-- tips: where Balasiel stands (a note on bullet 1) and where to get the root (a note on the trade). The quest log is set at s1.
-- Full-inventory rule (coordinator, 2026-10-28): an event whose finish can fail on a full bag (giveItem or a reward item)
-- plays the same either way, so it and its lines are `reach` only; the quest log or a success-only signal proves the step.
return {
    title = "A Squire's Test",
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to balasiel who asks of'},
         done = {
            {t = 'chat', re = 'Ah, I see you have a stout heart%.', why = 'Balasiel 616/631, accepted (say #7895)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         },
         reach = {{t = 'event', zone = 230, event = 616, why = 'Balasiel 616 offered (its finish needs option 0)'},
                  {t = 'event', zone = 230, event = 631, why = 'Balasiel 631 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'he is located on the upper'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'revival tree root can be bought'}},
        {id = 's4', at = {n = 4, fp = 'trade the root to him to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 230, event = 617, why = 'Balasiel 617: the root (the Spatha reward may not fit)'},
                  {t = 'chat', re = 'Ah, I see I was right about you%.', why = 'Balasiel 617 (say #7897)'}}},
    },
}

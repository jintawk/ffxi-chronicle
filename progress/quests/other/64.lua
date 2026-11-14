-- Step progress for A Hard Day's Knight (Other Areas quest 64). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/A_Hard_Days_Knight.lua (Quelveuiat 119 offers the quest and begins it only on
-- option 3, so 119 is a reach; 120 is his reminder; the Lufaise Meadows ??? pops Splinterspine Grukjuk with MURDEROUS_PRESENCE
-- ("Wait, you sense a murderous presence...!", a line only this quest uses); Quelveuiat 121 after the kill completes the quest.
-- Once completed he plays 631 on every talk, trade or not, and 632 only after both crest keys were traded, which gives the
-- Temple Knight key (permanent KI 2506)); client event script S4 026_Quelveuiat_0101A035.txt (120 say #10443, 631 say #13214,
-- 632 say #13217; 119 and 121 are bare). The draft counted 631 and its line as proof of the optional trade; 631 plays on a plain
-- talk, so only 632 and the key item prove it.
return {
    title = "A Hard Day's Knight",
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to quelveuiat i 10 middle'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 26, event = 120, conf = 'inferred', why = 'Quelveuiat 120: his reminder while accepted'},
            {t = 'chat', re = 'Go to the lookout platform in the south of Lufaise Meadows and assess the situation out there%.', conf = 'inferred', why = 'Quelveuiat 120 (say #10443)'},
         },
         reach = {{t = 'event', zone = 26, event = 119, why = 'Quelveuiat 119 offered (accepted only on option 3)'}}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'zone into lufaise meadows by taking'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head to h 10 afterwards'}},
        {id = 's4', at = {n = 4, fp = 'click the at the top of'},
         done = {
            {t = 'chat', re = 'wait, you sense a murderous presence', after = 's1', why = 'Lufaise Meadows MURDEROUS_PRESENCE: Splinterspine Grukjuk popped'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to tavnazian safehold and speak'},
         done = {
            {t = 'event', zone = 26, event = 121, after = 's1', why = 'Quelveuiat 121: completes the quest (Prog 1)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's6', kind = 'post', at = {n = 6, fp = 'after completing the quest you may'},
         done = {
            {t = 'event', zone = 26, event = 632, after = 's5', why = 'Quelveuiat 632: both crest keys traded'},
            {t = 'chat', re = 'To think that someone of your generation would dredge up both sorts of these past relics%.%.%.', after = 's5', why = 'Quelveuiat 632 (say #13217)'},
            {t = 'ki', id = 2506, gained = true, after = 's5', why = 'Temple Knight key obtained'},
            {t = 'ki_have', id = 2506, have = true, after = 's5', why = 'Temple Knight key held'},
            {t = 'chat', re = 'obtained key item: temple knight key', after = 's5', why = 'chat: key item obtained'},
         }},
    },
}

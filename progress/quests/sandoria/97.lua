-- Step progress for Eco-Warrior (San d'Oria quest 97). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Eco_Warrior.lua (Norejaie 677 offers it and begins it only on option 1; 679 is
-- her reminder; Rojaireaut 51 applies the ointment only on option 0, 53 is his menu while the level restriction is on, 54 plays
-- once the Indigested Stalagmite is held; the ??? in Ordelle's Caves pops Necroplasm, then after the kill gives key item 472;
-- Norejaie 681 takes it and completes the quest, but quest:complete fails on a full bag while the event still plays, so it only
-- reaches the step); client event scripts S4 230_Norejaie_010E60EC.txt (677 accept line say #9293, 679 say #9296, 681 say
-- #9297) and 193_Rojaireaut_010C11B5.txt (51 slap-it-on line say #7451, 53 say #7454, 54 say #7453). Key item 472 and item
-- 4198 (Dragon Chronicles) from res/key_items.lua and res/items.lua. The title is the quest's own name (the three nations
-- share one LandSandBoat script name); the page title adds "(San d'Oria)". Repeatable after the next conquest tally (page
-- meta): the log bits count for the first run only. Both "Rojaireaut" offer events (677, 51) play whether or not the player
-- accepts, so they are `reach`; only the lines after the accept choice prove the step. Bullets 2 and 4-10 are travel,
-- maze directions, the ??? that pops Necroplasm (its pop line is not unique to this nation's quest) and a Trust tip, and lead
-- into the second examine (n=11). Bullet 13 (one Eco-Warrior a week) is not a step. The quest log is set at s1, so it is
-- not silent.
-- Shared-signal audit: item 4198 (Dragon Chronicles) is shared with the Bastok/Windurst Eco-Warrior, the chocobo race game and Garrison, gated after s1 (restart step s1 uses unique proofs only).
return {
    title = 'Eco-Warrior',
    completes = 's12',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to norejaie to begin this'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'chat', re = "I knew you'd come through for us!", why = 'Norejaie 677, accepted (say #9293)'},
            {t = 'event', zone = 230, event = 679, conf = 'inferred', why = 'Norejaie 679: reminder, only while accepted'},
            {t = 'chat', re = 'will be waiting with further instructions in the caves%.', conf = 'inferred', why = 'Norejaie 679 (say #9296)'},
         },
         reach = {{t = 'event', zone = 230, event = 677, why = 'Norejaie 677 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'enter ordelle s caves from the'}},
        {id = 's3', at = {n = 3, fp = 'speak to rojaireaut g 3 to'},
         done = {
            {t = 'chat', re = 'Now, close your eyes for a moment%.', why = 'Rojaireaut 51, ointment applied (say #7451)'},
            {t = 'event', zone = 193, event = 53, conf = 'inferred', why = 'Rojaireaut 53: his menu while the level restriction is on'},
         },
         reach = {{t = 'event', zone = 193, event = 51, why = 'Rojaireaut 51 offered (the ointment only on option 0)'}}},
        {id = 's4', kind = 'note', with = 's11', at = {n = 4, fp = 'head east through the puddle and'}},
        {id = 's5', kind = 'note', with = 's11', at = {n = 5, fp = 'continue to follow the path eventually'}},
        {id = 's6', kind = 'note', with = 's11', at = {n = 6, fp = 'stick to the wall on the'}},
        {id = 's7', kind = 'note', with = 's11', at = {n = 7, fp = 'before reaching the next tunnel turn'}},
        {id = 's8', kind = 'note', with = 's11', at = {n = 8, fp = 'at the north east corner of'}},
        {id = 's9', kind = 'note', with = 's11', at = {n = 9, fp = 'when you examine the an nm'}},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'trusts may be used in this'}},
        {id = 's11', at = {n = 11, fp = 'defeat the necroplasm and check the'},
         done = {
            {t = 'ki', id = 472, gained = true, why = 'indigested stalagmite obtained'},
            {t = 'ki_have', id = 472, have = true, why = 'indigested stalagmite held'},
            {t = 'chat', re = 'obtained key item: indigested stalagmite', why = 'chat: key item obtained'},
            {t = 'event', zone = 193, event = 54, conf = 'inferred', why = 'Rojaireaut 54: only while the stalagmite is held'},
            {t = 'chat', re = 'That should be proof enough for Norejaie', conf = 'inferred', why = 'Rojaireaut 54 (say #7453)'},
         }},
        {id = 's12', at = {n = 12, fp = 'return to norejaie to complete this'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 472, gained = false, conf = 'inferred', why = 'indigested stalagmite handed over'},
            {t = 'item', id = 4198, gained = true, after = 's1', conf = 'inferred', why = 'Dragon Chronicles gained (reward; items can come from elsewhere)'},
         },
         reach = {{t = 'event', zone = 230, event = 681, why = 'Norejaie 681 (also plays with a full bag, so it proves nothing)'}}},
    },
}

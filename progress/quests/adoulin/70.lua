-- Step progress for Don't Ever Leaf Me (Adoulin quest 70). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no quest script, only zones/Western_Adoulin/npcs/Barenngo.lua and Dewalt.lua, which play events
-- 5015 / 5016 and 5013 / 5014 while the quest is accepted (first talk, then the reminder). Audibert and Corpo-Vorpo have no
-- script and no client event script, so bullets 1 and 2 rest on the log: the quest begins at Audibert's first talk (the only
-- way in), and his last talk, once all three tasks are done, completes it (the bullet says "complete the following 3 tasks to
-- complete the quest", so `completes` is bullet 2, not the last task bullet as the draft had it). The three tasks are done in
-- any order, so they are optional bullets that are never inferred from each other. Barenngo's and Dewalt's talks are only the
-- first part of a bundled bullet (talk, examine, report back), so they are reaches. The one clean end is the Rusted pickaxe
-- (key item 2261, temporary), fished up as the last act of bullet 5. Bullet 3 (Corpo-Vorpo, the Daunting Emanation) has no
-- signal and is left unmapped, as are the fishing tips. The draft's chat lines for events 5013 to 5016 are kept as reaches.
-- Client event scripts S4 256_Barenngo_011000BF.txt (5015 say #9213, 5016 say #9218) and 256_Dewalt_011000BE.txt (5013 say
-- #9207, 5014 say #9212).
return {
    title = "Don't Ever Leaf Me",
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with audibert in the scouts'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Audibert is the only way in)'},
         }},
        {id = 's2', at = {n = 2, fp = 'complete the following 3 tasks to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (all three tasks reported to Audibert)'},
         }},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'speak to barenngo in the pioneers'},
         done = {},
         reach = {
            {t = 'event', zone = 256, event = 5015, why = 'Barenngo 5015: his first talk while accepted'},
            {t = 'chat', re = 'Not another person coming to ask me about leafkin!', why = 'Barenngo 5015 (say #9213)'},
            {t = 'event', zone = 256, event = 5016, why = 'Barenngo 5016: his reminder talk'},
            {t = 'chat', re = 'If you really want to see a leafkin, try heading to the Yahse Hunting Grounds, near coordinates J%-6%.', why = 'Barenngo 5016 (say #9218)'},
         }},
        {id = 's5', kind = 'optional', at = {n = 5, fp = 'speak to dewalt in the couriers'},
         done = {
            {t = 'ki', id = 2261, gained = true, why = 'Rusted pickaxe obtained by fishing'},
            {t = 'ki_have', id = 2261, have = true, why = 'Rusted pickaxe held'},
            {t = 'chat', re = 'obtained key item: rusted pickaxe', why = 'chat: key item obtained'},
         },
         reach = {
            {t = 'event', zone = 256, event = 5013, why = 'Dewalt 5013: his first talk while accepted'},
            {t = 'chat', re = "Huh%? You got somethin' to ask me%?", why = 'Dewalt 5013 (say #9207)'},
            {t = 'event', zone = 256, event = 5014, why = 'Dewalt 5014: his reminder talk'},
            {t = 'chat', re = "'Member what I told you%-%-down in Foret de Hennetiel was the place I saw 'em%.", why = 'Dewalt 5014 (say #9212)'},
         }},
    },
}

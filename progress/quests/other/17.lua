-- Step progress for Under the Sea (quest other 17). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Under_the_Sea.lua (Yaya 31 has no menu and runs quest:begin; then a Prog
-- chain owned by this quest alone: Oswald 32 at Prog 0, Jimaida 33 at Prog 1, Zaldon 34 at Prog 2, each setting the next
-- Prog; trading exactly one Fat Greedie to Zaldon is event 35 with a 20% chance, which gives the etched ring (key item 93),
-- and 36 on a miss, which proves nothing; Oswald 37 plays while the ring is held, takes it and runs quest:complete, but
-- the Amber Earring reward needs a free slot and the same event plays without one, so 37 is only a reach and the log bit
-- and the ring's loss prove the step). The page puts "The quest is now active in your log" under Jimaida's bullet while
-- LandSandBoat flags it at Yaya; the log flag stays on the first step, which is right under either (a flag seen at
-- Jimaida still means Yaya was spoken to). Client event scripts S4 248_Yaya_010F8016.txt (31 say #6727),
-- 248_Oswald_010F8013.txt (32 say #6731, 37 say #6747), 248_Jimaida_010F8015.txt (33 say #6734), 248_Zaldon_010F8017.txt
-- (34 say #6737, 35 say #6745). Etched ring id 93. Not repeatable.
return {
    title = 'Under the Sea',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to yaya h 9'},
         done = {
            {t = 'event', zone = 248, event = 31, why = 'Yaya 31: no menu, runs quest:begin'},
            {t = 'chat', re = "As you've no doubt discovered, this here village owes its life to the fish%.", why = 'Yaya 31 (say #6727)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to oswald i 9 inside'},
         done = {
            {t = 'event', zone = 248, event = 32, why = 'Oswald 32: only at Prog 0, sets Prog 1'},
            {t = 'chat', re = "Don't mind me%. I have a lot to think about and", why = 'Oswald 32 (say #6731)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to jimaida h 9'},
         done = {
            {t = 'event', zone = 248, event = 33, why = 'Jimaida 33: only at Prog 1, sets Prog 2'},
            {t = 'chat', re = 'What!%? You want me to look for a ring%?', why = 'Jimaida 33 (say #6734)'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to zaldon h 9'},
         done = {
            {t = 'event', zone = 248, event = 34, why = 'Zaldon 34: only at Prog 2, sets Prog 3'},
            {t = 'chat', re = "What%? You're out to find that ring%?", why = 'Zaldon 34 (say #6737)'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'fish up a fat greedie in'}},
        {id = 's6', at = {n = 6, fp = 'trade zaldon the fat greedie'},
         done = {
            {t = 'ki', id = 93, gained = true, why = 'etched ring obtained'},
            {t = 'ki_have', id = 93, have = true, why = 'etched ring held'},
            {t = 'event', zone = 248, event = 35, why = 'Zaldon 35: the ring found'},
            {t = 'chat', re = "Well, tug my tail! I never thought you'd find it, but here it is!", why = 'Zaldon 35 (say #6745)'},
            {t = 'chat', re = 'obtained key item: etched ring', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to oswald for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 93, gained = false, why = 'etched ring taken (only inside quest:complete)'},
         },
         reach = {
            {t = 'event', zone = 248, event = 37, why = 'Oswald 37: the ring handed over (also plays with no room for the Amber Earring)'},
            {t = 'chat', re = 'Yes, what is this%? Goodness gracious!', why = 'Oswald 37 (say #6747)'},
         }},
    },
}

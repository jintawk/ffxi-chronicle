-- Step progress for The Rescue Drill (San d'Oria mission 2-1, mission id 3). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/2_1_The_Rescue_Drill.lua; client event scripts S4 230_Ambrotien_010E6062.txt,
-- 230_Endracion_010E6061.txt, 231_Grilau_010E7022.txt (accept: say #7286, #52 in Grilau; turn-in 1005/2005: say #7287),
-- 102_Galaihaurat_0106625F.txt, 102_Deaufrain_01066259.txt, 102_Equesobillot_01066258.txt, 102_Vicorpasse_01066260.txt,
-- 193_Ruillont_010C11AB.txt; key item 65 from res/key_items.lua.
-- The menu is 1009/2009 (option 3 accepts), so what proves the accept is the line only the accept branch says and the nation line
-- moving to id 3 (completed = false, run1 as in the pilot). Galaihaurat 110 plays at status 0 only (the mission's first talk), and
-- Ruillont 1 at status 2 to 7, so neither needs the optional talks of the sub-bullet (Equesobillot 101, Deaufrain 102, Vicorpasse 108,
-- Laurisse 106, Narvecaint 107, Augevinne, Yaucevouchat): those are not mapped. Only one of Equesobillot 112 / Deaufrain 113 /
-- Galaihaurat 114 gives the Bronze Sword (random per player, the event plays only for the chosen NPC and then adds the sword).
-- Ruillont 2 plays only on the Bronze Sword trade at status 9 (a wrong trade plays nothing). Vicorpasse 115 (status 10) gives the
-- Rescue training certificate; the gate guard turn-in is Ambrotien 2005, Endracion 1005, Grilau 1005 (status 11) and completes the
-- mission. The Bronze Sword item gain is not used (items support a step, never prove it). The draft made bullet 4 and the sword
-- trade notes, used the optional talks as proof of the Ruillont bullet and the 'min = 4' mission guess; fixed.
return {
    title = 'The Rescue Drill',
    completes = 's9',
    known = {{t = 'mission', line = 'sandoria', min = 0}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to any gate guard and'},
         done = {
            {t = 'chat', re = "It's all just a drill, so this should be easy compared to your usual fare%.", why = 'a gate guard, accepted (say #7286)'},
            {t = 'mission', line = 'sandoria', eq = 3, completed = false, run1 = true, why = 'mission line: current mission = The Rescue Drill'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to la theine plateau and'},
         done = {
            {t = 'event', zone = 102, event = 110, why = 'Galaihaurat 110: the first talk, status 0 only'},
            {t = 'chat', re = 'Are you in the rescue drill%?', why = 'Galaihaurat 110 (say #7424)'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'at the east side of f'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'continue into ordelle s caves at'}},
        {id = 's5', at = {n = 5, fp = 'once inside ordelle s caves follow'},
         done = {
            {t = 'event', zone = 193, event = 1, why = 'Ruillont 1: status 2 to 7'},
            {t = 'chat', re = 'An adventurer, are you%? I am Ruillont of the Temple Knights%.', why = 'Ruillont 1 (say #7364)'},
         }},
        {id = 's6', at = {n = 6, fp = 'go back to la theine plateau'},
         done = {
            {t = 'event', zone = 102, event = 112, why = 'Equesobillot 112: the Bronze Sword'},
            {t = 'event', zone = 102, event = 113, why = 'Deaufrain 113: the Bronze Sword'},
            {t = 'event', zone = 102, event = 114, why = 'Galaihaurat 114: the Bronze Sword'},
            {t = 'chat', re = "Ruillont's sword%? Yes, I was keeping it for him during training%.", why = 'Equesobillot 112 / Deaufrain 113 / Galaihaurat 114 (say #7431)'},
         }},
        {id = 's7', at = {n = 7, fp = 'head back to ruillont in ordelle'},
         done = {
            {t = 'event', zone = 193, event = 2, why = 'Ruillont 2: the Bronze Sword accepted (only on the matching trade)'},
            {t = 'chat', re = "My sword! You've brought me my sword!", why = 'Ruillont 2 (say #7374)'},
         }},
        {id = 's8', at = {n = 8, fp = 'go back to la theine plateau'},
         done = {
            {t = 'event', zone = 102, event = 115, why = 'Vicorpasse 115: the certificate'},
            {t = 'chat', re = "What%? Ruillont's in that cave%? And he doesn't want us to send help, eh%?", why = 'Vicorpasse 115 (say #7435)'},
            {t = 'ki', id = 65, gained = true, why = 'Rescue training certificate obtained'},
            {t = 'chat', re = 'obtained key item: rescue training certificate', why = 'chat: key item obtained'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to a gate guard to'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 3, completed = true, why = 'mission log: The Rescue Drill completed'},
            {t = 'event', zone = 230, event = 2005, why = 'Ambrotien 2005: the certificate handed in'},
            {t = 'event', zone = 230, event = 1005, why = 'Endracion 1005: the certificate handed in'},
            {t = 'event', zone = 231, event = 1005, why = 'Grilau 1005: the certificate handed in'},
            {t = 'chat', re = "You've returned! I hear the drill turned into something far more perilous%.", why = 'gate guard 1005 / 2005 (say #7287)'},
         }},
    },
}

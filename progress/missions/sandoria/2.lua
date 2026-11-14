-- Step progress for Save the Children (San d'Oria mission 1-3, mission id 2). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/1_3_Save_the_Children.lua. The menu is event 2009/1009 (option 102 accepts and
-- sets status 1), so what proves the accept is the line the client says only on the accept branch (say #7274 in
-- 230_Ambrotien_010E6062.txt, 230_Endracion_010E6061.txt and, as say #40, 231_Grilau_010E7022.txt) and the nation line moving to
-- id 2 (completed = false, run1 as in the pilot). Arnau 693 (231) is a cutscene that plays only while the mission is current with
-- status below 2 and its finish sets status 2; it has no refusal branch (its body is not decoded, the id is in LandSandBoat and in
-- Arnau's event list). The Orcish hut key (item 157, res/key_items.lua) is handed out only by the battlefield win
-- (Ghelsba 32001 -> npcUtil.giveKeyItem) and taken again by the Hut Door cutscene, so its gain proves bullet 5; the cutscene is
-- Hut Door 3 (client, say #7758 "But, I wonder what that Orc meant...") and 55 (LandSandBoat's first-completion id, not in the
-- client's event list for the door), and proves bullet 6. The gate guard turn-in plays 2004 / 1004 for the first completion and
-- 2024 / 1024 for a repeat and its finish completes the mission (Ambrotien 2004/2024, Endracion 1004/1024, Grilau 1004/1024).
-- The optional Arnau cutscene (694) is an indented bullet and not mapped. The draft guessed "completes", put the hut key LOSS and a
-- 'min = 3' mission guess on bullet 5 (both belong to bullet 6 or prove nothing: the line holds 65535 after a completion) and
-- left the accept and the turn-in as notes.
return {
    title = 'Save the Children',
    completes = 's7',
    known = {{t = 'mission', line = 'sandoria', min = 0}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to any gate guard and'},
         done = {
            {t = 'chat', re = "Orcs tend to keep their hostages in tents or small huts%. Once you're inside the compound, check them first%.", why = 'a gate guard, accepted (say #7274)'},
            {t = 'mission', line = 'sandoria', eq = 2, completed = false, run1 = true, why = 'mission line: current mission = Save the Children'},
         }},
        {id = 's2', at = {n = 2, fp = 'next speak to arnau in the'},
         done = {
            {t = 'event', zone = 231, event = 693, why = 'Arnau 693: the cutscene, only while this mission is current and status < 2'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'after the cutscene head to ghelsba'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'make your way to the hut'}},
        {id = 's5', at = {n = 5, fp = 'interact with the hut door and'},
         done = {
            {t = 'ki', id = 157, gained = true, why = 'Orcish hut key obtained (the battlefield win)'},
            {t = 'chat', re = 'obtained key item: orcish hut key', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'interact with the hut door after'},
         done = {
            {t = 'event', zone = 140, event = 3, why = 'Hut Door 3: the children freed'},
            {t = 'chat', re = 'But, I wonder what that Orc meant%.%.%.', why = 'Hut Door 3 (say_as #7758)'},
            {t = 'event', zone = 140, event = 55, why = 'Hut Door 55: LandSandBoat id for the first completion'},
            {t = 'ki', id = 157, gained = false, conf = 'inferred', why = 'Orcish hut key taken by the door'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to a gate guard to'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 2, completed = true, why = 'mission log: Save the Children completed'},
            {t = 'event', zone = 230, event = 2004, why = 'Ambrotien 2004: turn-in, first completion'},
            {t = 'event', zone = 230, event = 2024, why = 'Ambrotien 2024: turn-in, repeat'},
            {t = 'event', zone = 230, event = 1004, why = 'Endracion 1004: turn-in, first completion'},
            {t = 'event', zone = 230, event = 1024, why = 'Endracion 1024: turn-in, repeat'},
            {t = 'event', zone = 231, event = 1004, why = 'Grilau 1004: turn-in, first completion'},
            {t = 'event', zone = 231, event = 1024, why = 'Grilau 1024: turn-in, repeat'},
         }},
    },
}

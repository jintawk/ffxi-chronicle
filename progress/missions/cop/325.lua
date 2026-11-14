-- Step progress for The Road Forks (Chains of Promathia 3-3, mission id 325). Data only; see progress/missions/sandoria/0.lua and
-- the research pilot's three-paths word matcher.
-- Evidence: LandSandBoat scripts/missions/cop/3_3_The_Road_Forks.lua; client scripts S4 231_Arnau (51), 231_Chasalvige (38), 002_Guilloud (0),
-- 230_Hinaree (23), 238_Ohbiru_Dohbiru (872), 238_Kyume_Romeh (873), 238_Honoi_Gomoi (874), 239_Yoran_Oran (469, 470, 471, 472, 478),
-- 240_Yujuju (592), 238_Tosuka_Porika (875), 237_Cid (847): the bodies are cutscenes (empty), the ids and statuses are LandSandBoat's,
-- the zone-ins 14 (Northern San d'Oria) and 871 (Windurst Waters) and Cradle of Rebirth 2 have no client script. Key items 581 (cracked
-- Mimeo Mirror), 586 (Mimeo Jewel), 587 to 589 (the Mimeo feathers) from res/key_items.lua.
-- Two paths in any order, each its own group like Three Paths: the San d'Oria path is nibble 0 of the CoP progress word (0xFFFF +0x14),
-- the Windurst path nibble 1 (the client counts them from sub-missions 330 and 340 while CoP is 325); LandSandBoat sets the San d'Oria
-- status 1 (zone-in 14), 2 (Arnau 51), 5 (Chasalvige 38), 9 (Guilloud 0), 14 (Hinaree 23) and the Windurst status 1 (zone-in 871),
-- 2 (Ohbiru-Dohbiru 872), 3 (Yoran-Oran 469), 5 (Kyume-Romeh 873), 6 (Honoi-Gomoi 874), 8 (Yoran-Oran 470), 9 (471), 11 (Yujuju 592),
-- 12 (Tosuka-Porika 875), 14 (Yoran-Oran 472). Statuses 3 and 4 (San d'Oria) and 10 and 13 (Windurst) have no step of their own, so a
-- step's range runs to the next status. Cid 847 plays only when both paths stand at 14 and completes the mission, so it implies the last step of each path.
-- Placement fixes against the draft: Guilloud 0 plays only after the Overgrown Ivy is dead, so it is bullet 6 (bullet 5, the spawn, has
-- no event: zone text only); Yoran-Oran 469 is bullet 10, 470 (the mirror handed back) is bullet 13 and 472 is bullet 32 (the draft
-- put all three on bullet 10); the Mimeo Jewel (the Loose Sand click, bullet 23) is a step of its own. The Lioumere fight, the travel,
-- the Geomagnetic Fount, the optional Kyume-Romeh report (no event at that status) and the quest-guide bullets 35 to 41 leave no
-- signal and stay notes or plain bullets. The optional Yoran-Oran lore talk (bullet 33, event 478) cannot be a step: an optional step is never inferred and the completed-log snapshot has to show every step done.
return {
    title = 'The Road Forks',
    completes = 's34',
    known = {{t = 'mission', line = 'cop', eq = 325}},
    groups = {
        sandoria = {start = {{t = 'mission', line = 'cop', eq = 325, completed = false, why = 'mission line: current mission = The Road Forks'}}},
        windurst = {start = {{t = 'mission', line = 'cop', eq = 325, completed = false, why = 'mission line: current mission = The Road Forks'}}},
    },
    steps = {
        -- San d'Oria path (word nibble 0)
        {id = 's1', group = 'sandoria', at = {n = 1, fp = 'zone into northern san d oria'},
         done = {
            {t = 'zonein', zone = 231, event = 14, why = "Northern San d'Oria zone-in cutscene 14 (status 0, LandSandBoat)"},
            {t = 'word', nib = 0, min = 1, max = 1, why = "San d'Oria path status 1 (zone-in 14)"},
         }},
        {id = 's2', group = 'sandoria', at = {n = 2, fp = 'head to the cathedral and speak'},
         done = {
            {t = 'event', zone = 231, event = 51, why = 'Arnau 51 (status 1 only)'},
            {t = 'word', nib = 0, min = 2, max = 4, why = "San d'Oria path status 2 (Arnau 51)"},
         }},
        {id = 's3', group = 'sandoria', at = {n = 3, fp = 'speak with chasalvige who is in'},
         done = {
            {t = 'event', zone = 231, event = 38, why = 'Chasalvige 38 (status 2 only)'},
            {t = 'word', nib = 0, min = 5, max = 8, why = "San d'Oria path status 5 (Chasalvige 38)"},
         }},
        {id = 's4', group = 'sandoria', kind = 'note', with = 's6', at = {n = 4, fp = 'head to carpenters landing via the'}},
        {id = 's5', group = 'sandoria', kind = 'note', with = 's6', at = {n = 5, fp = 'speak with guilloud at h 10'}},
        {id = 's6', group = 'sandoria', at = {n = 6, fp = 'speak with guilloud again after defeating'},
         done = {
            {t = 'event', zone = 2, event = 0, why = 'Guilloud 0: the cutscene after the Overgrown Ivy is dead (status 5)'},
            {t = 'word', nib = 0, min = 9, max = 13, why = "San d'Oria path status 9 (Guilloud 0)"},
         }},
        {id = 's7', group = 'sandoria', at = {n = 7, fp = 'speak with hinaree at b 6'},
         done = {
            {t = 'event', zone = 230, event = 23, why = "Hinaree 23: ends the San d'Oria path (status 9)"},
            {t = 'word', nib = 0, min = 14, why = "San d'Oria path status 14 (Hinaree 23)"},
         }},
        -- Windurst path (word nibble 1)
        {id = 's8', group = 'windurst', at = {n = 8, fp = 'zone into windurst waters for a'},
         done = {
            {t = 'zonein', zone = 238, event = 871, why = 'Windurst Waters zone-in cutscene 871 (status 0, LandSandBoat)'},
            {t = 'word', nib = 1, min = 1, max = 1, why = 'Windurst path status 1 (zone-in 871)'},
         }},
        {id = 's9', group = 'windurst', at = {n = 9, fp = 'speak to ohbiru dohbiru at j'},
         done = {
            {t = 'event', zone = 238, event = 872, why = 'Ohbiru-Dohbiru 872 (status 1 only)'},
            {t = 'word', nib = 1, min = 2, max = 2, why = 'Windurst path status 2 (Ohbiru-Dohbiru 872)'},
         }},
        {id = 's10', group = 'windurst', at = {n = 10, fp = 'speak with yoran oran at e'},
         done = {
            {t = 'event', zone = 239, event = 469, why = 'Yoran-Oran 469 (status 2 only)'},
            {t = 'word', nib = 1, min = 3, max = 4, why = 'Windurst path status 3 (Yoran-Oran 469)'},
         }},
        {id = 's11', group = 'windurst', at = {n = 11, fp = 'speak with kyume romeh at f'},
         done = {
            {t = 'event', zone = 238, event = 873, why = 'Kyume-Romeh 873 (status 3 only)'},
            {t = 'word', nib = 1, min = 5, max = 5, why = 'Windurst path status 5 (Kyume-Romeh 873)'},
         }},
        {id = 's12', group = 'windurst', at = {n = 12, fp = 'head to windurst waters south map'},
         done = {
            {t = 'event', zone = 238, event = 874, why = 'Honoi-Gomoi 874: the cracked Mimeo Mirror (status 5 only)'},
            {t = 'word', nib = 1, min = 6, max = 7, why = 'Windurst path status 6 (Honoi-Gomoi 874)'},
            {t = 'ki', id = 581, gained = true, why = 'cracked Mimeo Mirror obtained'},
            {t = 'chat', re = 'obtained key item: cracked mimeo mirror', why = 'chat: key item obtained'},
         }},
        {id = 's13', group = 'windurst', at = {n = 13, fp = 'head back to windurst walls home'},
         done = {
            {t = 'event', zone = 239, event = 470, why = 'Yoran-Oran 470: the mirror handed over (status 6)'},
            {t = 'word', nib = 1, min = 8, max = 8, why = 'Windurst path status 8 (Yoran-Oran 470)'},
            {t = 'ki', id = 581, gained = false, why = 'cracked Mimeo Mirror taken'},
         }},
        {id = 's14', group = 'windurst', kind = 'note', with = 's23', at = {n = 14, fp = 'travel to k 8 in attohwa'}},
        {id = 's15', group = 'windurst', kind = 'note', with = 's23', at = {n = 15, fp = 'to reach the loose sand you'}},
        {id = 's16', group = 'windurst', kind = 'note', with = 's23', at = {n = 16, fp = 'clicking the loose sand spawns a'}},
        {id = 's17', group = 'windurst', kind = 'note', with = 's23', at = {n = 17, fp = 'read the following four points after'}},
        {id = 's18', group = 'windurst', kind = 'note', with = 's23', at = {n = 18, fp = 'you will receive a mimeo jewel'}},
        {id = 's19', group = 'windurst', kind = 'note', with = 's23', at = {n = 19, fp = 'you will have exactly 30 earth'}},
        {id = 's20', group = 'windurst', kind = 'note', with = 's23', at = {n = 20, fp = 'the jewel will also immediately break'}},
        {id = 's21', group = 'windurst', kind = 'note', with = 's23', at = {n = 21, fp = 'if the jewel breaks you will'}},
        {id = 's23', group = 'windurst', at = {n = 23, fp = 'after reading the points above stand'},
         done = {
            {t = 'ki', id = 586, gained = true, why = 'Mimeo Jewel obtained at the Loose Sand (after Lioumere)'},
            {t = 'chat', re = 'obtained key item: mimeo jewel', why = 'chat: key item obtained'},
         }},
        {id = 's24', group = 'windurst', kind = 'note', with = 's26', at = {n = 24, fp = 'make your way up parradamo tor'}},
        {id = 's25', group = 'windurst', kind = 'note', with = 's26', at = {n = 25, fp = 'to reach the base of the'}},
        {id = 's26', group = 'windurst', at = {n = 26, fp = 'once you reach the top with'},
         done = {
            {t = 'event', zone = 7, event = 2, why = 'Cradle of Rebirth 2: needs the Mimeo Jewel (status 8, LandSandBoat)'},
            {t = 'ki', id = 587, gained = true, why = 'Mimeo Feather obtained'},
            {t = 'chat', re = 'obtained key item: mimeo feather', why = 'chat: key item obtained'},
         }},
        {id = 's27', group = 'windurst', kind = 'note', with = 's29', at = {n = 27, fp = 'before leaving if you have started'}},
        {id = 's29', group = 'windurst', at = {n = 29, fp = 'return to yoran oran at e'},
         done = {
            {t = 'event', zone = 239, event = 471, why = 'Yoran-Oran 471: the feathers handed over (status 8, needs the feather)'},
            {t = 'word', nib = 1, min = 9, max = 10, why = 'Windurst path status 9 (Yoran-Oran 471)'},
            {t = 'ki', id = 587, gained = false, why = 'Mimeo Feather taken'},
         }},
        {id = 's30', group = 'windurst', at = {n = 30, fp = 'speak with yujuju at m 6'},
         done = {
            {t = 'event', zone = 240, event = 592, why = 'Yujuju 592 (status 9 only)'},
            {t = 'word', nib = 1, min = 11, max = 11, why = 'Windurst path status 11 (Yujuju 592)'},
         }},
        {id = 's31', group = 'windurst', at = {n = 31, fp = 'head inside the eastern half of'},
         done = {
            {t = 'event', zone = 238, event = 875, why = 'Tosuka-Porika 875 (status 11 only)'},
            {t = 'word', nib = 1, min = 12, max = 13, why = 'Windurst path status 12 (Tosuka-Porika 875)'},
         }},
        {id = 's32', group = 'windurst', at = {n = 32, fp = 'head back and talk to yoran'},
         done = {
            {t = 'event', zone = 239, event = 472, why = 'Yoran-Oran 472: ends the Windurst path (status 12)'},
            {t = 'word', nib = 1, min = 14, why = 'Windurst path status 14 (Yoran-Oran 472)'},
         }},
        -- both paths done
        {id = 's34', implies = {'s7', 's32'}, at = {n = 34, fp = 'head to the metalworks home point'},
         done = {
            {t = 'mission', line = 'cop', eq = 325, completed = true, why = 'mission log: The Road Forks completed'},
            {t = 'event', zone = 237, event = 847, why = 'Cid 847: completes (both paths at status 14)'},
         }},
    },
}

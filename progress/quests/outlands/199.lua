-- Step progress for Chasing Dreams (Outlands quest 199). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Chasing_Dreams.lua (Rudolfo 117 begins the quest on finish, no choice; Prog 1
-- by Zoriboh 119, 2 by Sohyon 209, 3 by Washu 221 which gives Washu's flask; the four clams in Korroloka Tunnel fill it into the
-- Flask of clam water (Prog 4); Sohyon 210 swaps it for the Storeroom key; Gimb 211 takes the key (Prog 5); Kagetora 322 (Prog
-- 6); Patient Wheel 323 takes five Eastern Gems (Prog 7); Abelard 1108 (Prog 8); the Lufaise Meadows zone-in plays 4 (Prog 9);
-- Zoriboh 121 completes); client event scripts S4 247_Zoriboh, 252_Washu_010FC017.txt (221 say #11132), 236_Kagetora and
-- 236_Patient_Wheel_010EC0A1.txt (326 say #9188 at Prog 6, 327 say #9200 at Prog above 6). Most of these events carry no text in
-- the client. The draft put 326 on the trade: it plays at Prog 6, after Kagetora and before the trade, so it marks the Kagetora
-- bullet (inferred), and 327 marks the trade. It also put the zone-in cutscene on the Abelard bullet; it is the Lufaise bullet.
-- Event 213 (Sohyon) and 324 (Kagetora) are "additional dialogue" that plays at other progress values too, so they prove nothing.
-- The vortex bullet has no signal of its own (the cave is a plain zone line) and is a note on the cutscene. Not repeatable.
return {
    title = 'Chasing Dreams',
    completes = 's13',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'first head to rabao and talk'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Rudolfo 117)'},
            {t = 'event', zone = 247, event = 117, why = 'Rudolfo 117: begins the quest'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to zoriboh f 6'},
         done = {
            {t = 'event', zone = 247, event = 119, why = 'Zoriboh 119 (Prog 0)'},
            {t = 'event', zone = 247, event = 120, conf = 'inferred', why = 'Zoriboh 120: his later talk, Prog 1 to 3'},
            {t = 'chat', re = "You've gotta get there before anything happens to her%.", conf = 'inferred', why = 'Zoriboh 120 (say #10510)'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to norg and talk to'},
         done = {
            {t = 'event', zone = 252, event = 209, why = 'Sohyon 209 (Prog 1)'},
         }},
        {id = 's4', at = {n = 4, fp = 'then talk to washu to receive'},
         done = {
            {t = 'event', zone = 252, event = 221, why = 'Washu 221: gives the flask'},
            {t = 'chat', re = 'Fill it from the four big clams in the Korroloka Tunnel%.', why = 'Washu 221 (say #11132)'},
            {t = 'ki', id = 623, gained = true, why = "Washu's flask obtained"},
            {t = 'ki_have', id = 623, have = true, why = "Washu's flask held"},
            {t = 'chat', re = "obtained key item: washu's flask", why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'head to korroloka tunnel you will'},
         done = {
            {t = 'ki', id = 624, gained = true, why = 'Flask of clam water obtained (the fourth clam)'},
            {t = 'ki_have', id = 624, have = true, why = 'Flask of clam water held'},
            {t = 'chat', re = 'obtained key item: flask of clam water', why = 'chat: key item obtained'},
            {t = 'ki', id = 623, gained = false, conf = 'inferred', why = "Washu's flask used up"},
         }},
        {id = 's6', at = {n = 6, fp = 'head to norg and talk to'},
         done = {
            {t = 'event', zone = 252, event = 210, why = 'Sohyon 210: flask taken, key given'},
            {t = 'ki', id = 633, gained = true, why = 'Storeroom key obtained'},
            {t = 'ki_have', id = 633, have = true, why = 'Storeroom key held'},
            {t = 'chat', re = 'obtained key item: storeroom key', why = 'chat: key item obtained'},
            {t = 'ki', id = 624, gained = false, conf = 'inferred', why = 'Flask of clam water handed over'},
         }},
        {id = 's7', at = {n = 7, fp = 'talk to gimb h 9'},
         done = {
            {t = 'event', zone = 252, event = 211, why = 'Gimb 211: key taken (Prog 5)'},
            {t = 'ki', id = 633, gained = false, conf = 'inferred', why = 'Storeroom key handed over'},
         }},
        {id = 's8', at = {n = 8, fp = 'head to port bastok and talk'},
         done = {
            {t = 'event', zone = 236, event = 322, why = 'Kagetora 322 (Prog 5)'},
            {t = 'event', zone = 236, event = 326, conf = 'inferred', why = 'Patient Wheel 326: asks for the gems, only at Prog 6, after Kagetora'},
            {t = 'chat', re = 'Where am I gonna get my hands on goods like that%?', conf = 'inferred', why = 'Patient Wheel 326 (say #9188)'},
         }},
        {id = 's9', at = {n = 9, fp = 'trade 5x eastern gems to patient'}, count = {item = 1664, need = 5},
         done = {
            {t = 'event', zone = 236, event = 323, why = 'Patient Wheel 323: the five Eastern Gems taken (Prog 7)'},
            {t = 'event', zone = 236, event = 327, conf = 'inferred', why = 'Patient Wheel 327: his talk at Prog above 6, after the trade'},
            {t = 'chat', re = 'There have been rumors of some weird eddy of darkness', conf = 'inferred', why = 'Patient Wheel 327 (say #9200)'},
         }},
        {id = 's10', at = {n = 10, fp = 'head to selbina and talk to'},
         done = {
            {t = 'event', zone = 248, event = 1108, why = 'Abelard 1108 (Prog 7)'},
         }},
        {id = 's11', kind = 'note', with = 's12', at = {n = 11, fp = 'use the swirling vortex in valkurm'}},
        {id = 's12', at = {n = 12, fp = 'you will get a cut scene'},
         done = {
            {t = 'zonein', zone = 24, event = 4, after = 's10', why = 'Lufaise Meadows zone-in 4 (Prog 8)'},
         }},
        {id = 's13', at = {n = 13, fp = 'head to rabao talk to zoriboh'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 247, event = 121, why = 'Zoriboh 121 (Prog 9): runs quest:complete'},
         }},
    },
}

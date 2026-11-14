-- Step progress for Hitting the Marquisate (Windurst quest 71). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/THF_AF3_Hitting_the_Marquisate.lua (Nanaa Mihgo 512 begins the quest with no
-- option test and gives the Cat Burglar's note; Yatniel 10029 sets his talk, 10031 is the accepted 4 Quake Grenades trade
-- (needed later: Nanaa 516 tests it) and 10030/10032 are his later talks; Hagain 10003 gives the Bomb incense, 10005 is the
-- accepted Chandelier Coal trade and 10006 his talk after it; Garlaige Citadel ??? 50 to 55 each ask whether to use the incense
-- and play whichever answer is given, while event 56 at the last ??? plays only once all six were answered yes (hagainProg 7), so
-- it proves bullet 6 and none of 50 to 55 is used; Nanaa 516 asks for the letter and sets the final stage, 517 is her talk
-- after it; La Theine ??? 119 takes the Pickaxe but the quest only completes if quest:complete can pay, so it is a reach and the
-- quest log carries the last step). Client event scripts S4 245_Yatniel_010F5042.txt, 249_Hagain_010F904C.txt,
-- 241_Nanaa_Mihgo_010F1072.txt; key items from res/key_items.lua (202 Cat Burglar's note, 193 Bomb incense). Bullet 7 (the
-- Chandelier pop) is a note: its "Something flies out from the ceiling!" line is in no decoded text. Repeatable after a memory
-- reset (page meta): Nanaa 512 opens the next run. The quest log is set at s1, so it is not silent.
return {
    title = 'Hitting the Marquisate',
    completes = 's14',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to nanaa mihgo in windurst'},
         done = {
            {t = 'event', zone = 241, event = 512, why = 'Nanaa Mihgo 512: the quest begins'},
            {t = 'chat', re = "Don't rrrush into anything just yet%.", why = 'Nanaa Mihgo 512 (say #8888)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'ki', id = 202, gained = true, why = "Cat Burglar's note obtained"},
            {t = 'ki_have', id = 202, have = true, why = "Cat Burglar's note held"},
            {t = 'chat', re = "obtained key item: cat burglar's note", why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'go to lower jeuno g 10'},
         done = {
            {t = 'event', zone = 245, event = 10029, why = 'Yatniel 10029'},
            {t = 'event', zone = 245, event = 10030, conf = 'inferred', why = 'Yatniel 10030: only once 10029 is done'},
            {t = 'chat', re = "Don't make me repeat myself, dammit!", conf = 'inferred', why = 'Yatniel 10030 (say #8007)'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade the quake grenades to him'},
         done = {
            {t = 'event', zone = 245, event = 10031, why = 'Yatniel 10031: the 4 Quake Grenades accepted'},
            {t = 'event', zone = 245, event = 10032, conf = 'inferred', why = 'Yatniel 10032: only once the grenades are traded'},
            {t = 'chat', re = "If I didn't have this damn assignment, I would have joined in on the treasure hunt%.", conf = 'inferred', why = 'Yatniel 10032 (say #8013)'},
         }},
        {id = 's4', at = {n = 4, fp = 'go to mhaura h 8 and'},
         done = {
            {t = 'event', zone = 249, event = 10003, why = 'Hagain 10003'},
            {t = 'ki', id = 193, gained = true, why = 'bomb incense obtained'},
            {t = 'ki_have', id = 193, have = true, why = 'bomb incense held'},
            {t = 'chat', re = 'obtained key item: bomb incense', why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'head to garlaige citadel via the'}},
        {id = 's6', at = {n = 6, fp = 'you will now need to examine'},
         done = {
            {t = 'event', zone = 200, event = 56, why = 'Garlaige Citadel ??? 56: plays only after the six ??? were used'},
         }},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'the last will spawn a bomb'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'using hide or spectral jig immediately'}},
        {id = 's9', at = {n = 9, fp = 'go back to mhaura and trade'},
         done = {
            {t = 'event', zone = 249, event = 10005, why = 'Hagain 10005: the Chandelier Coal accepted'},
            {t = 'ki', id = 193, gained = false, conf = 'inferred', why = 'bomb incense handed over'},
            {t = 'event', zone = 249, event = 10006, conf = 'inferred', why = 'Hagain 10006: only once the coal is traded'},
            {t = 'chat', re = 'The Tenshodo is treating this talk of the Atarefaunet treasure as just another rumor%.', conf = 'inferred', why = 'Hagain 10006 (say #7271)'},
         }},
        {id = 's10', at = {n = 10, fp = 'head to windurst woods and talk'},
         done = {
            {t = 'event', zone = 241, event = 516, why = 'Nanaa Mihgo 516'},
            {t = 'chat', re = '%.%.%.What was the letter you had for the papers you delivered originally%?', why = 'Nanaa Mihgo 516 (say #8907)'},
            {t = 'event', zone = 241, event = 517, conf = 'inferred', why = 'Nanaa Mihgo 517: only once 516 is done'},
            {t = 'chat', re = "We must hurry to Ordelle's Caves!", conf = 'inferred', why = 'Nanaa Mihgo 517 (say #8914)'},
         }},
        {id = 's11', kind = 'note', with = 's14', at = {n = 11, fp = 'you ll need a pickaxe for'}},
        {id = 's12', kind = 'note', with = 's14', at = {n = 12, fp = 'go to ordelle s caves enter'}},
        {id = 's13', kind = 'note', with = 's14', at = {n = 13, fp = 'note if you have the proto'}},
        {id = 's14', at = {n = 14, fp = 'head to the middle of the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 202, gained = false, conf = 'inferred', why = "Cat Burglar's note handed over"},
         },
         reach = {{t = 'event', zone = 102, event = 119, why = 'La Theine Plateau ??? 119 (completion needs a free slot for the reward)'}}},
    },
}

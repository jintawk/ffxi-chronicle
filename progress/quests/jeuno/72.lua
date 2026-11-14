-- Step progress for A Chocobo's Tale (Jeuno quest 72). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/A_Chocobos_Tale.lua (Nevela 10015 is a plain cutscene whose finish begins the
-- quest; the quest variable Prog then runs 0 to 5: Wobke 245 at Prog 0 (246 is his talk at Prog 1 and 2), the Pashhow
-- Marshlands Outpost Gate 21 at Prog 1, the exact three Bottles of Warding Oil traded to the Gate is 22 at Prog 2, Wobke 247
-- at Prog 3, the Batallia Downs ??? gives key item 611 at Prog 4, and Nevela 10017 at Prog 5 runs quest:complete, pays 5200
-- gil and takes the key item; no event here has a refusal path). Client event scripts S4 244_Nevela_010F4031.txt (10015 say
-- #7634, 10017 #8717), 234_Wobke_010EA085.txt (245 #12189, 246 #12202, 247 #12227), 109_Outpost_Gate_0106D29E.txt (21 #8395 to
-- #8397, 22 #8403); key item id from res/key_items.lua (611 Silver Comet's collar). Bullets 4 (the oil drops) and 7 (spawning
-- the Badshah NMs) are notes on the step they lead into. Not repeatable. The quest log is set at s1, so it is not silent.
return {
    title = "A Chocobo's Tale",
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to nevela to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 244, event = 10015, why = 'Nevela 10015: the cutscene that begins the quest'},
            {t = 'chat', re = 'You see, chocobos have wings, do they not%?', why = 'Nevela 10015 (say #7634)'},
         }},
        {id = 's2', at = {n = 2, fp = 'go to bastok mines and talk'},
         done = {
            {t = 'event', zone = 234, event = 245, why = 'Wobke 245: Prog 0, sets Prog 1'},
            {t = 'chat', re = 'A chocobo with silver%-colored feathers%.%.%.%?', why = 'Wobke 245 (say #12189)'},
            {t = 'event', zone = 234, event = 246, why = 'Wobke 246: his talk at Prog 1 and 2'},
         }},
        {id = 's3', at = {n = 3, fp = 'go to pashhow marshlands outpost and'},
         done = {
            {t = 'event', zone = 109, event = 21, why = 'Outpost Gate 21: Prog 1, sets Prog 2'},
            {t = 'chat', re = 'You say you got business with me%?', why = 'Outpost Gate 21 (say #8397)'},
            {t = 'chat', re = "Huh%? Where'd you hear", why = 'Outpost Gate 21 (say #8396)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'obtain three warding oils from emerald'}},
        {id = 's5', at = {n = 5, fp = 'trade the oils to the outpost'},
         done = {
            {t = 'event', zone = 109, event = 22, why = 'Outpost Gate 22: the exact three oils traded, Prog 2, sets Prog 3'},
            {t = 'chat', re = 'You brought what I asked for%?', why = 'Outpost Gate 22 (say #8403)'},
         }},
        {id = 's6', at = {n = 6, fp = 'go to bastok mines and speak'},
         done = {
            {t = 'event', zone = 234, event = 247, why = 'Wobke 247: Prog 3, sets Prog 4'},
            {t = 'chat', re = 'Were you able to meet with that adventurer%?', why = 'Wobke 247 (say #12227)'},
         }},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'head to batallia downs and examine'}},
        {id = 's8', at = {n = 8, fp = 'kill badshah and re examine the'},
         done = {
            {t = 'ki', id = 611, gained = true, why = "Silver Comet's collar obtained from the ???"},
            {t = 'ki_have', id = 611, have = true, why = "Silver Comet's collar held"},
            {t = 'chat', re = "obtained key item: silver comet's collar", why = 'chat: key item obtained'},
         }},
        {id = 's9', at = {n = 9, fp = 'speak to nevela to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 244, event = 10017, why = 'Nevela 10017: Prog 5, runs quest:complete'},
            {t = 'chat', re = 'I would place this on the grave of her mate, Shooting Star, if I only knew where it was%.', why = 'Nevela 10017 (say #8717)'},
            {t = 'ki', id = 611, gained = false, after = 's8', conf = 'inferred', why = "Silver Comet's collar handed over"},
         }},
    },
}

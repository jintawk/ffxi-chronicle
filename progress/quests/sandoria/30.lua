-- Step progress for The Medicine Woman (San d'Oria quest 30). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Medicine_Woman.lua (Abeaule 613/615 begin the quest on option 0;
-- Amaura 636 gives Amaura's formula 148 on option 0; Amaura 637 is the exact trade of malboro vine, zinc ore and insect
-- wing: it takes the formula and gives cold medicine 147; Abeaule 614 needs the medicine, completes and takes it; the
-- reward is gil, so 614 cannot be refused); client event scripts S4 231_Abeaule_010E7048.txt (613/615 say #11368 is the
-- option 0 branch; 614 say #11370) and 230_Amaura_010E601F.txt (636 say #8058 option 0 branch; 637 say #8060).
-- The first bullet bundles the accept and the walk to Amaura: it rests on the acceptance.
return {
    title = 'The Medicine Woman',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after speaking with abeaule head over'},
         done = {
            {t = 'chat', re = 'I knew you were the one to ask, as always!', why = 'Abeaule 613/615 (say #11368, option 0 branch)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         },
         reach = {{t = 'event', zone = 231, event = 613, why = 'Abeaule 613 offered (accepting needs option 0)'},
                  {t = 'event', zone = 231, event = 615, why = 'Abeaule 615 offered (accepting needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'amaura requires certain ingredients to brew'},
         done = {
            {t = 'chat', re = "Very well, very well%. I've written a list of what I'll be needing, so take it with ye%.", why = 'Amaura 636 (say #8058, option 0 branch)'},
            {t = 'ki', id = 148, gained = true, why = "Amaura's formula obtained"},
            {t = 'ki_have', id = 148, have = true, why = "Amaura's formula held"},
            {t = 'chat', re = "obtained key item: amaura's formula", why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 230, event = 636, why = 'Amaura 636 offered (the formula needs option 0)'}}},
        {id = 's3', at = {n = 3, fp = 'gather and trade the listed items'},
         done = {
            {t = 'event', zone = 230, event = 637, why = 'Amaura 637: the exact trade'},
            {t = 'chat', re = "Ye've brought what I asked for%?", why = 'Amaura 637 (say #8060)'},
            {t = 'ki', id = 147, gained = true, why = 'cold medicine obtained'},
            {t = 'ki_have', id = 147, have = true, why = 'cold medicine held'},
            {t = 'chat', re = 'obtained key item: cold medicine', why = 'chat: key item obtained'},
            {t = 'ki', id = 148, gained = false, conf = 'inferred', why = "Amaura's formula handed over"},
         }},
        {id = 's4', at = {n = 4, fp = 'deliver the medicine to abeaule for'},
         done = {
            {t = 'event', zone = 231, event = 614, why = 'Abeaule 614: completes the quest'},
            {t = 'chat', re = "Ah, just the stuff! I'll buy it from you and give it to the guest right away!", why = 'Abeaule 614 (say #11370)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 147, gained = false, conf = 'inferred', why = 'cold medicine handed over'},
         }},
    },
}

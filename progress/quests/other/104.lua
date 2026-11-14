-- Step progress for For the Birds (other quest 104). Data only: which observation proves which step bullet of
-- pages/quests/other/104.lua. Bullets 1-3 are preparation and carry no step.
-- Evidence: LandSandBoat scripts/quests/otherAreas/For_The_Birds.lua. Koblakiq (Oldton Movalpolos 11): 14 offers and begins
-- on option 1 only; 15 is the accepted-quest reminder at Prog 0; 16 plays at Prog 1, gives the Glittering fragment (key item
-- 632); 17 reminder at Prog 2; 18 plays at Prog 4 and completes. Daa Bola the Seer (Castle Oztroja 151): 86 is the
-- Prog 0 talk (not required: the trade works without it); 87 plays only for an Arnica Root trade. Ge'Fhu Yagudoeye
-- (Beadeaux 147): 124 plays once the four Quadav are dead (Prog 3, Option 4); the quest still ends at Koblakiq 18, so 124 only
-- shows the last bullet is under way. Client event scripts S4 011_Koblakiq_0100B0EC.txt (16: say #7856; 18: say #7872),
-- 151_Daa_Bola_the_Seer_010971F7.txt (87: say #8025). The Glittering fragment is taken by Ge'Fhu at Prog 2 (the
-- fight starts), so it is not used as proof of the fight.
return {
    title = 'For the Birds',
    completes = 's12',
    known = {{t = 'quest'}},
    steps = {
        {id = 's4', at = {n = 4, fp = 'after completing missionary moblin talk to'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 11, event = 15, conf = 'inferred', why = 'Koblakiq 15 (reminder, only while the quest is accepted)'},
         },
         reach = {{t = 'event', zone = 11, event = 14, why = 'Koblakiq 14 offered (its finish needs option 1)'}}},
        {id = 's5', kind = 'note', with = 's8', at = {n = 5, fp = 'obtain an arnica root if you'}},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'head to castle oztroja and go'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'on the next map head to'}},
        {id = 's8', at = {n = 8, fp = 'trade the arnica root to daa'},
         done = {
            {t = 'event', zone = 151, event = 87, why = 'Daa Bola the Seer 87 (Arnica Root trade)'},
            {t = 'chat', re = 'This time I be letting you go%.', why = 'Daa Bola the Seer 87 (say #8025)'},
         }},
        {id = 's9', at = {n = 9, fp = 'after speaking to the yagudo head'},
         done = {
            {t = 'event', zone = 11, event = 16, why = 'Koblakiq 16 (gives the Glittering fragment)'},
            {t = 'chat', re = 'You took your time getting back%.', why = 'Koblakiq 16 (say #7856)'},
            {t = 'ki', id = 632, gained = true, why = 'glittering fragment obtained'},
            {t = 'ki_have', id = 632, have = true, why = 'glittering fragment held'},
            {t = 'event', zone = 11, event = 17, conf = 'inferred', why = 'Koblakiq 17 (reminder, only after 16)'},
         }},
        {id = 's10', kind = 'note', with = 's12', at = {n = 10, fp = 'after receiving glittering fragment head to'}},
        {id = 's11', kind = 'note', with = 's12', at = {n = 11, fp = 'after going through the exit at'}},
        {id = 's12', at = {n = 12, fp = 'after the fight talk to ge'},
         done = {
            {t = 'event', zone = 11, event = 18, why = 'Koblakiq 18 (completes)'},
            {t = 'chat', re = 'They gave proof of the big sparkly crystal straight to the Kindred%.', why = 'Koblakiq 18 (say #7872)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 147, event = 124, why = "Ge'Fhu Yagudoeye 124 (after the Quadav fight)"}}},
    },
}

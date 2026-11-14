-- Step progress for Ghatsad's Quandary (The Voracious Resurgence, page id 310). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr scripts are all stubs, so no scene is proof here; the page's two temporary key items carry the mapping.
-- Key item 3263 "gift for Megomak" is gained on bullet 1 and lost on bullet 5 (the Acid-eaten Door); 3264 "pure white ampoule" is gained
-- on bullet 8 (after the Vexing Sniffles fight) and lost on bullet 10 (the Acid-eaten Door again). Neither is the reward, and no LandSandBoat
-- script uses either. Cast metal plate (774) is a permanent item from elsewhere, so it proves nothing. Bullet 11 is the line moving to 326.
-- Bullets 6, 7 and 9 are cutscenes with no signal; 6 and 7 are travel and stay notes, 9 is left a plain bullet.
return {
    title = "Ghatsad's Quandary",
    completes = 's11',
    known = {{t = 'mission', line = 'tvr', min = 310, max = 325}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with ghatsad in the automaton'},
         done = {
            {t = 'ki', id = 3263, gained = true, why = 'gift for Megomak obtained from Ghatsad'},
            {t = 'ki_have', id = 3263, have = true, why = 'gift for Megomak held'},
            {t = 'chat', re = 'obtained key item: gift for megomak', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'head to mount zhayolm i 9'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'for the next step you will'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'head to the gates of halvung'}},
        {id = 's5', at = {n = 5, fp = 'go through the gate you just'},
         done = {
            {t = 'ki', id = 3263, gained = false, why = 'gift for Megomak taken at the Acid-eaten Door'},
         }},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'proceed to hazhalm testing grounds in'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'head back outside to caedarva mire'}},
        {id = 's8', at = {n = 8, fp = 'examine the vexing sniffles once more'},
         done = {
            {t = 'ki', id = 3264, gained = true, why = 'pure white ampoule obtained after the fight'},
            {t = 'ki_have', id = 3264, have = true, why = 'pure white ampoule held'},
            {t = 'chat', re = 'obtained key item: pure white ampoule', why = 'chat: key item obtained'},
         }},
        {id = 's10', at = {n = 10, fp = 'return to the acid eaten door'},
         done = {
            {t = 'ki', id = 3264, gained = false, why = 'pure white ampoule taken at the Acid-eaten Door'},
         }},
        {id = 's11', at = {n = 11, fp = 'return to ghatsad i 7 in'},
         done = {
            {t = 'mission', line = 'tvr', min = 326, why = "mission log: the line moved past Ghatsad's Quandary"},
         }},
    },
}

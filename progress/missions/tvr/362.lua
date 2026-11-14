-- Step progress for The Sea Sage (The Voracious Resurgence, page id 362). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr scripts are all stubs, so no scene is proof here; three temporary key items carry the mapping and none is
-- the reward nor used by any LandSandBoat script: 3265 "aeropearl" (bullet 10, after the Marolith cutscene), 3266 "man-made solution"
-- (bullet 15, after Panaiveriyamman falls) and 3267 "repaired aeropearl" (bullet 16, Ghatsad's cutscene). Bullet 18 is the line moving to 380.
-- Bullets 6 and 12 (the begin cutscene, Ghatsad's first talk) have no signal and stay plain bullets. The page does not say when the
-- aeropearl is taken away, so no loss is mapped.
return {
    title = 'The Sea Sage',
    completes = 's18',
    known = {{t = 'mission', line = 'tvr', min = 362, max = 379}},
    steps = {
        {id = 's5', kind = 'note', with = 's10', at = {n = 5, fp = 'note you need the thunder hammer'}},
        {id = 's7', kind = 'note', with = 's10', at = {n = 7, fp = 'proceed to g 8 in wajaom'}},
        {id = 's8', kind = 'note', with = 's10', at = {n = 8, fp = 'travel to g 9 in aydeewa'}},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'once outside keep going and after'}},
        {id = 's10', at = {n = 10, fp = 'equip the thunder hammer in your'},
         done = {
            {t = 'ki', id = 3265, gained = true, why = 'aeropearl obtained after the Marolith cutscene'},
            {t = 'ki_have', id = 3265, have = true, why = 'aeropearl held'},
            {t = 'chat', re = 'obtained key item: aeropearl', why = 'chat: key item obtained'},
         }},
        {id = 's11', kind = 'note', with = 's15', at = {n = 11, fp = 'return to the apkallu guide in'}},
        {id = 's13', kind = 'note', with = 's15', at = {n = 13, fp = 'head to alzadaal undersea ruins and'}},
        {id = 's14', kind = 'note', with = 's15', at = {n = 14, fp = 'panaiveriyamman war'}},
        {id = 's15', at = {n = 15, fp = 'you will receive the man made'},
         done = {
            {t = 'ki', id = 3266, gained = true, why = 'man-made solution obtained after the Acrolith fight'},
            {t = 'ki_have', id = 3266, have = true, why = 'man-made solution held'},
            {t = 'chat', re = 'obtained key item: man%-made solution', why = 'chat: key item obtained'},
         }},
        {id = 's16', at = {n = 16, fp = 'return to ghatsad for a cutscene'},
         done = {
            {t = 'ki', id = 3267, gained = true, why = 'repaired aeropearl obtained from Ghatsad'},
            {t = 'ki_have', id = 3267, have = true, why = 'repaired aeropearl held'},
            {t = 'chat', re = 'obtained key item: repaired aeropearl', why = 'chat: key item obtained'},
         }},
        {id = 's17', kind = 'note', with = 's18', at = {n = 17, fp = 'acquire a lamian fang key once'}},
        {id = 's18', at = {n = 18, fp = 'return to the apkallu guide via'},
         done = {
            {t = 'mission', line = 'tvr', min = 380, why = 'mission log: the line moved past The Sea Sage'},
         }},
    },
}

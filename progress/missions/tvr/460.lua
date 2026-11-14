-- Step progress for Altennia Burns Bright (The Voracious Resurgence mission 7-4, page id 460). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's tvr scripts are all stubs (7_4_Altennia_Burns_Bright.lua), so no event or csid is used. Bullet 1 is proven by
-- key item 3295 "Trion's directive", handed out after Halver's cutscene. Bullet 3 is proven by key item 3296 "ember-encrusted orichalcum"
-- (the page says only a player on this mission sees the correct mining point). Neither is the reward (Elite Royal Collar). The Memorian doll
-- (3293) is page 452's reward and is not used. Bullet 5 is the line moving to 468 (Maat on the Rampage). Bullet 2 has no signal and stays
-- a plain bullet; bullet 4 repeats the route of bullet 3 and is a note.
return {
    title = 'Altennia Burns Bright',
    completes = 's5',
    known = {{t = 'mission', line = 'tvr', min = 460, max = 467}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to halver in chateau d'},
         done = {
            {t = 'ki', id = 3295, gained = true, why = "Trion's directive obtained after the Halver cutscene"},
            {t = 'ki_have', id = 3295, have = true, why = "Trion's directive held"},
            {t = 'chat', re = "obtained key item: trion's directive", why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to ifrit s cauldron with'},
         done = {
            {t = 'ki', id = 3296, gained = true, why = 'ember-encrusted orichalcum obtained from the correct mining point'},
            {t = 'ki_have', id = 3296, have = true, why = 'ember-encrusted orichalcum held'},
            {t = 'chat', re = 'obtained key item: ember%-encrusted orichalcum', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'use the ifrit s cauldron unity'}},
        {id = 's5', at = {n = 5, fp = 'return to rahal for the final'},
         done = {
            {t = 'mission', line = 'tvr', min = 468, why = 'mission log: the line moved past Altennia Burns Bright'},
         }},
    },
}

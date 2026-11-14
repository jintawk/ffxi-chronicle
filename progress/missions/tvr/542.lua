-- Step progress for The Prime Weapons (The Voracious Resurgence, page id 542). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's scripts/missions/tvr/9_4_The_Prime_Weapons.lua is a stub (no events, no key items), so no scene is traced; the
-- proof is the page's own key item. Bullet 3 hands over "bronze-hued tag" (key item 3303, res/key_items.lua; no LandSandBoat script and
-- no other tvr page gives it, and it is not the mission's reward, which is the Silver Knife membership card) when the Stygian Ash is traded.
-- The tvr line has no completed set: the end is the line moving to 552 (To Movalpolos!, the next page id) on bullet 6, the final cutscene.
-- Not mapped: bullet 1 (optional hint, no signal), bullet 5 (cutscene), and the prime weapon section after the mission (bullets 7 on).
return {
    title = 'The Prime Weapons',
    completes = 's6',
    known = {{t = 'mission', line = 'tvr', min = 542, max = 551}},
    steps = {
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to leafallia and interact with'}},
        {id = 's3', at = {n = 3, fp = 'trade a stygian ash to the'},
         done = {
            {t = 'ki', id = 3303, gained = true, why = 'bronze-hued tag obtained (the Stygian Ash trade at the Odyssean Passage)'},
            {t = 'ki_have', id = 3303, have = true, why = 'bronze-hued tag held'},
            {t = 'chat', re = 'obtained key item: bronze%-hued tag', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'travel to outer ra kaznar k'}},
        {id = 's6', at = {n = 6, fp = 'return to leafallia and interact with'},
         done = {
            {t = 'mission', line = 'tvr', min = 552, why = 'mission log: the line moved past The Prime Weapons'},
         }},
    },
}

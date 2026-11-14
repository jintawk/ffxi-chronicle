-- Step progress for Epiphany (Adoulin quest 143). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script (the enum names the quest only) and no client event script for Octavernost's or the
-- Hazy Rune events, so the signals are the page's key items and the quest log. The Refined Ra'Kaznar fiber (2804) is handed
-- over at the Meeting Point (bullet 2); Octavernost's offer at bullet 3 gives one of the three Iridal cores (ruins 2880, tomb
-- 2881, pass 2882), any one proves it. The Arcus fiber (2883, the fiber transforming after the 109 fight) is the tomb
-- option's result only, so it is a branch. The draft's "Quiescence" (2573) is the Ergon weapon's permanent key item from
-- another quest, and its completion on the last bullet was a guess: the page gives the reward (15,000 XP, Erilaz Surcoat)
-- at bullet 25 after one game day, so the completed bit is there. The three fight sections (bullets 4 to 22) hold the fight
-- directions and rewards with no signal of their own: notes; the optional bullet 23 is the early return to Octavernost.
-- The page says repeatable (a new key item from Octavernost once per Conquest Tally); nothing separates a second run
-- from the first, so there is no `repeatable` entry.
return {
    title = 'Epiphany',
    completes = 's25',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'speak to octavernost k 9 near'}},
        {id = 's2', at = {n = 2, fp = 'head to outer ra kaznar m'},
         done = {
            {t = 'ki', id = 2804, gained = true, why = "refined Ra'Kaznar fiber obtained"},
            {t = 'ki_have', id = 2804, have = true, why = "refined Ra'Kaznar fiber held"},
            {t = 'chat', re = "obtained key item: refined ra'kaznar fiber", why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to octavernost he will offer'},
         done = {
            {t = 'ki', id = 2880, gained = true, why = 'iridal core of the ruins obtained (the 125 fight)'},
            {t = 'ki', id = 2881, gained = true, why = 'iridal core of the tomb obtained (the 109 fight)'},
            {t = 'ki', id = 2882, gained = true, why = 'iridal core of the pass obtained (the 135 fight)'},
            {t = 'chat', re = 'obtained key item: iridal core of the ruins', why = 'chat: key item obtained'},
            {t = 'chat', re = 'obtained key item: iridal core of the tomb', why = 'chat: key item obtained'},
            {t = 'chat', re = 'obtained key item: iridal core of the pass', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'head to king ranperre s tomb'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'then proceed along the right wall'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'it has very low hp but'}},
        {id = 's7', kind = 'branch', at = {n = 7, fp = 'after defeating arcus blades you will'},
         done = {
            {t = 'ki', id = 2883, gained = true, why = 'arcus fiber obtained (the fiber transforms after the 109 fight)'},
            {t = 'ki_have', id = 2883, have = true, why = 'arcus fiber held'},
            {t = 'chat', re = 'obtained key item: arcus fiber', why = 'chat: key item obtained'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'proceed to the afterwards section below'}},
        {id = 's9', kind = 'note', with = 's3', at = {n = 9, fp = 'proceed to fei yin g 9'}},
        {id = 's10', kind = 'note', with = 's3', at = {n = 10, fp = 'head to e 7 to cross'}},
        {id = 's11', kind = 'note', with = 's3', at = {n = 11, fp = 'go to g 6 and examine'}},
        {id = 's12', kind = 'note', with = 's3', at = {n = 12, fp = 'it has very low hp but'}},
        {id = 's13', kind = 'note', with = 's3', at = {n = 13, fp = 'after defeating arcus blades you will'}},
        {id = 's14', kind = 'note', with = 's3', at = {n = 14, fp = 'proceed to the afterwards section below'}},
        {id = 's15', kind = 'note', with = 's3', at = {n = 15, fp = 'make your way to the strange'}},
        {id = 's16', kind = 'note', with = 's3', at = {n = 16, fp = 'examine the hazy rune behind the'}},
        {id = 's17', kind = 'note', with = 's3', at = {n = 17, fp = 'you may not summon trusts to'}},
        {id = 's18', kind = 'note', with = 's3', at = {n = 18, fp = 'you must be on run for'}},
        {id = 's19', kind = 'note', with = 's3', at = {n = 19, fp = 'it has very low hp but'}},
        {id = 's20', kind = 'note', with = 's3', at = {n = 20, fp = 'after defeating arcus blades you will'}},
        {id = 's21', kind = 'note', with = 's3', at = {n = 21, fp = 'you also earn the title sword'}},
        {id = 's22', kind = 'note', with = 's3', at = {n = 22, fp = 'proceed to the afterwards section below'}},
        {id = 's23', kind = 'optional', at = {n = 23, fp = 'optional return to octavernost at the'}},
        {id = 's24', kind = 'note', with = 's25', at = {n = 24, fp = 'check amchuchu s laboratory at the'}},
        {id = 's25', at = {n = 25, fp = 'wait one game day and then'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Octavernost gives the reward the next game day)'},
         }},
        {id = 's26', kind = 'note', with = 's25', at = {n = 26, fp = 'you may speak to octavernost afterwards'}},
        {id = 's27', kind = 'note', with = 's25', at = {n = 27, fp = 'after receiving your surcoat you may'}},
        {id = 's28', kind = 'note', with = 's25', at = {n = 28, fp = 'he will ask for different ingredients'}},
        {id = 's29', kind = 'note', with = 's25', at = {n = 29, fp = 'you can acquire another erilaz surcoat'}},
    },
}

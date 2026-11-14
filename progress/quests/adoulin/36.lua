-- Step progress for For Whom the Bell Tolls (Adoulin quest 36). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script (the enum names the quest only) and no decoded client event for Sylvie, Nhili Uvolep, Vestavius
-- or the Ergon Locus, so the signals are the log and one key item, from BG-wiki's walkthrough and header (Sylvie starts the
-- quest; the first Ergon Locus cutscene hands over the Silver luopan, key item 2374, a temporary key item from res/key_items.lua
-- and the fight's item requirement; the third examination takes it; Sylvie's last cutscene completes the quest). The draft put
-- the completed bit on the first Ergon Locus bullet and made Sylvie's offer and her final talk notes; the quest completes at
-- bullet 7. The Silver luopan is lost at bullet 6 (the page says so), which is that bullet's signal. Nhili Uvolep's cutscene,
-- Vestavius and the spawn have no signal of their own and are notes on the step they lead into. Bullet 8 is a note of the
-- page. Not repeatable.
return {
    title = 'For Whom the Bell Tolls',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to sylvie at western adoulin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Sylvie)'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'speak to nhili uvolep at eastern'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'travel to k 10 morimar basalt'}},
        {id = 's4', at = {n = 4, fp = 'travel to j 6 morimar basalt'},
         done = {
            {t = 'ki', id = 2374, gained = true, after = 's1', why = 'silver luopan obtained'},
            {t = 'ki_have', id = 2374, have = true, why = 'silver luopan held'},
            {t = 'chat', re = 'obtained key item: silver luopan', why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'examine the ergon locus a second'}},
        {id = 's6', at = {n = 6, fp = 'upon defeating the deranged ameretat examine'},
         done = {
            {t = 'ki', id = 2374, gained = false, after = 's4', why = 'silver luopan taken at the third examination'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to sylvie i 5 western'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'you must wait a game day'}},
    },
}

-- Step progress for Vegetable Vegetable Revolution (Adoulin quest 108). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script for Amchuchu's laboratory door, Midras's ??? or Cid's catalyst
-- talk, so the page is the only source. Key items from res/key_items.lua, each named by its bullet: Memo from Midras (2270,
-- n=2), Cid's catalyst (2271, n=3), Chunk of milky white minerals (2272, the sub-bullet of n=4). The page ends the quest at
-- the door ("to finish the quest and receive your reward", n=5), so the log's completed bit belongs to n=5. The first door
-- click (n=1) has no signal of its own: a note. Not repeatable.
return {
    title = 'Vegetable Vegetable Revolution',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'click on the door amuchuchu s'}},
        {id = 's2', at = {n = 2, fp = 'go to the in the small'},
         done = {
            {t = 'ki', id = 2270, gained = true, why = 'memo from Midras obtained'},
            {t = 'ki_have', id = 2270, have = true, why = 'memo from Midras held'},
            {t = 'chat', re = 'obtained key item: memo from midras', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to the metalworks in bastok'},
         done = {
            {t = 'ki', id = 2271, gained = true, why = "Cid's catalyst obtained"},
            {t = 'ki_have', id = 2271, have = true, why = "Cid's catalyst held"},
            {t = 'chat', re = "obtained key item: cid's catalyst", why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'go back to the in sih'},
         done = {
            {t = 'ki', id = 2272, gained = true, why = 'chunk of milky white minerals obtained'},
            {t = 'ki_have', id = 2272, have = true, why = 'chunk of milky white minerals held'},
            {t = 'chat', re = 'obtained key item: chunk of milky white minerals', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to door amuchuchu s laboratory'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed at the door'},
         }},
    },
}

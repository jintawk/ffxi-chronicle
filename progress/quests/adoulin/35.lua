-- Step progress for Elementary, My Dear Sylvie (Adoulin quest 35). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script (the enum names the quest only) and no decoded client event for Sylvie, Dabnorrin or the
-- Primordial Convergence, so the signals are the log and one key item, from BG-wiki's walkthrough and header (Sylvie starts the
-- quest; Dabnorrin hands over the Vessel of summoning, key item 2373, a temporary key item from res/key_items.lua and the fight's
-- item requirement; the convergence cutscene at the end completes it). The draft added "Rhapsody in Umber" (2885) to the fight
-- bullet: the page names it only as an optional Trust unlock, so it is dropped, and the completed bit moves from the fight to
-- the last bullet (the cutscene and reward). The draft also made Sylvie's offer a note; it is bullet 3's own signal (the
-- accepted bit). The two requirement bullets, the travel, the entrance and the fight itself have no signal and are notes on the
-- step they lead into. Bullet 9 is a note of the page, not a step. Not repeatable.
return {
    title = 'Elementary, My Dear Sylvie',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's8', at = {n = 1, fp = 'at 119 this fight is trivial'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you must have geomancer set as'}},
        {id = 's3', at = {n = 3, fp = 'speak to sylvie at western adoulin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Sylvie)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'travel to morimar basalt fields j'}},
        {id = 's5', at = {n = 5, fp = 'speak to dabnorrin at bivouac 1'},
         done = {
            {t = 'ki', id = 2373, gained = true, after = 's3', why = 'vessel of summoning obtained'},
            {t = 'ki_have', id = 2373, have = true, why = 'vessel of summoning held'},
            {t = 'chat', re = 'obtained key item: vessel of summoning', why = 'chat: key item obtained'},
         }},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'the entrance is at j 6'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'click on the primordial convergence from'}},
        {id = 's8', at = {n = 8, fp = 'click on the primordial convergence again'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

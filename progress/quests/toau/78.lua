-- Step progress for A Stygian Pact (Aht Urhgan quest 78). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat only names the quest (scripts/globals/quests.lua) and has no script; the client event scripts hold
-- no Yoyoroon, Whitegate or Hazhalm gate file, so no event or dialogue line is usable. What is left is the quest log and the
-- key items the page names. Divine Interference (75, a LandSandBoat script, same Naja / Whitegate pattern) logs the quest at
-- the Whitegate talk and the Naja cutscene before it leaves no trace, so the current bit is named for bullet 2 (by analogy:
-- if retail logs it at bullet 1 the only cost is bullet 2 ticking a step early); completed is named for bullet 15, the Naja
-- cutscene that completes the quest. Every key item here (Talisman of the rebel gods 1249, Talisman key 1263, Spatial
-- pressure barometer 1252) is also handed out by The Rider Cometh (76) and Unwavering Resolve (77), which come first, so all
-- are gated after s2: only once this quest is logged do they count for it. The page says repeatable, but a repeat leaves no
-- trace of its own (same key items as 76 and 77, and retail keeps the current bit), so only the first run is tracked: no
-- `repeatable.restart`, and the quest bits are first run only. Talks, trades, the gate, the fight and the reward choice
-- leave no signal: notes on the step they lead into.
return {
    title = 'A Stygian Pact',
    completes = 's15',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'speak to naja salaheem in aht'}},
        {id = 's2', at = {n = 2, fp = 'examine imperial whitegate at aht urhgan'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only: it never clears on retail)'},
         }},
        {id = 's3', kind = 'note', with = 's9', at = {n = 3, fp = 'speak to yoyoroon in nashmau in'}},
        {id = 's4', kind = 'note', with = 's9', at = {n = 4, fp = 'obtain a timeworn talisman from ephramadian'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'trade the timeworn talisman and a'}},
        {id = 's9', at = {n = 9, fp = 'should your appraisal succeed you will'},
         done = {
            {t = 'ki', id = 1249, gained = true, after = 's2', why = 'Talisman of the rebel gods obtained'},
            {t = 'ki_have', id = 1249, have = true, after = 's2', why = 'Talisman of the rebel gods held'},
            {t = 'chat', re = 'obtained key item: talisman of the rebel gods', after = 's2', why = 'chat: key item obtained'},
         }},
        {id = 's10', at = {n = 10, fp = 'return to imperial whitegate for a'},
         done = {
            {t = 'ki', id = 1252, gained = true, after = 's2', why = 'Spatial pressure barometer obtained'},
            {t = 'ki_have', id = 1252, have = true, after = 's2', why = 'Spatial pressure barometer held'},
            {t = 'chat', re = 'obtained key item: spatial pressure barometer', after = 's2', why = 'chat: key item obtained'},
            {t = 'ki', id = 1263, gained = true, after = 's2', why = 'Talisman key obtained'},
            {t = 'ki_have', id = 1263, have = true, after = 's2', why = 'Talisman key held'},
         }},
        {id = 's11', kind = 'note', with = 's15', at = {n = 11, fp = 'enter hazhalm testing grounds and examine'}},
        {id = 's12', kind = 'note', with = 's15', at = {n = 12, fp = 'examine the entry gate again to'}},
        {id = 's13', kind = 'note', with = 's15', at = {n = 13, fp = 'after winning the battle you will'}},
        {id = 's14', kind = 'note', with = 's15', at = {n = 14, fp = 'examine imperial whitegate at aht urhgan'}},
        {id = 's15', at = {n = 15, fp = 'speak to naja salaheem in aht'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
    },
}

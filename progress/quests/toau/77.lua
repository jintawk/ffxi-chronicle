-- Step progress for Unwavering Resolve (Aht Urhgan quest 77). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat only names the quest (scripts/globals/quests.lua) and has no script; the client event scripts hold
-- no Yoyoroon, Whitegate or Hazhalm gate file, so no event or dialogue line is usable. What is left is the quest log and the
-- key items the page names. Divine Interference (75, a LandSandBoat script, same Naja / Whitegate pattern) logs the quest at
-- the Whitegate talk and the Naja cutscene before it leaves no trace, so the current bit is named for bullet 2 (by analogy:
-- if retail logs it at bullet 1 the only cost is bullet 2 ticking a step early); completed is named for bullet 12, the Naja
-- cutscene that "completes the quest". The Talisman of the rebel gods (1249) and the Talisman key (1263) are also handed out by
-- The Rider Cometh (76) and, for 1252 as well, by A Stygian Pact (78), so every key item here is gated after s2: only once
-- this quest is logged do they count for it. The Spatial pressure barometer (1252) is the quest's own marker for bullet 7.
-- The page says repeatable, but a repeat leaves no trace of its own (the same key items belong to 76 and 78, and retail keeps
-- the current bit), so only the first run is tracked: no `repeatable.restart`, and the quest bits are first run only.
-- Talks, trades, the gate, the fight and the reward choice leave no signal: notes on the step they lead into.
return {
    title = 'Unwavering Resolve',
    completes = 's12',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'speak to naja salaheem in aht'}},
        {id = 's2', at = {n = 2, fp = 'examine imperial whitegate at aht urhgan'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only: it never clears on retail)'},
         }},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'speak to yoyoroon in nashmau in'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'obtain a timeworn talisman to be'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'trade the timeworn talisman and a'}},
        {id = 's6', at = {n = 6, fp = 'once your appraisal succeeds you must'},
         done = {
            {t = 'ki', id = 1249, gained = true, after = 's2', why = 'Talisman of the rebel gods obtained'},
            {t = 'ki_have', id = 1249, have = true, after = 's2', why = 'Talisman of the rebel gods held'},
            {t = 'chat', re = 'obtained key item: talisman of the rebel gods', after = 's2', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'examine the imperial whitegate door in'},
         done = {
            {t = 'ki', id = 1252, gained = true, after = 's2', why = 'Spatial pressure barometer obtained'},
            {t = 'ki_have', id = 1252, have = true, after = 's2', why = 'Spatial pressure barometer held'},
            {t = 'chat', re = 'obtained key item: spatial pressure barometer', after = 's2', why = 'chat: key item obtained'},
            {t = 'ki', id = 1263, gained = true, after = 's2', why = 'Talisman key obtained'},
            {t = 'ki_have', id = 1263, have = true, after = 's2', why = 'Talisman key held'},
         }},
        {id = 's8', kind = 'note', with = 's12', at = {n = 8, fp = 'enter hazhalm testing grounds and examine'}},
        {id = 's9', kind = 'note', with = 's12', at = {n = 9, fp = 'examine the entry gate again to'}},
        {id = 's10', kind = 'note', with = 's12', at = {n = 10, fp = 'after winning the battle you will'}},
        {id = 's11', kind = 'note', with = 's12', at = {n = 11, fp = 'examine imperial whitegate at aht urhgan'}},
        {id = 's12', at = {n = 12, fp = 'speak to naja salaheem in aht'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
    },
}

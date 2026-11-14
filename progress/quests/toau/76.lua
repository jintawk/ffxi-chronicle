-- Step progress for The Rider Cometh (Aht Urhgan quest 76). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat only names the quest (scripts/globals/quests.lua) and the battlefield; there is no script and the
-- client event scripts hold no Yoyoroon, Walahra Temple or Hazhalm gate file, so no event or dialogue line is usable. What is
-- left is three key items the page names (Message from Yoyoroon 1250, a permanent key item handed out after the first
-- cutscene; Talisman of the rebel gods 1249 from Yoyoroon's second talk; Talisman key 1263 from the Walahra Temple cutscene)
-- and the quest log's completed bit at the final Whitegate cutscene (the first moment the log is known to change; where the
-- log goes current is not known, so no current bit is used). Talks, trades, the Entry Gate, the fight and the reward choice
-- leave no signal of their own: notes on the step they lead into. Not repeatable.
return {
    title = 'The Rider Cometh',
    completes = 's21',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'enter the walahra temple in aht'}},
        {id = 's2', at = {n = 2, fp = 'speak to yoyoroon in nashmau in'},
         done = {
            {t = 'ki', id = 1250, gained = true, why = 'Message from Yoyoroon obtained'},
            {t = 'ki_have', id = 1250, have = true, why = 'Message from Yoyoroon held'},
            {t = 'chat', re = 'obtained key item: message from yoyoroon', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's12', at = {n = 4, fp = 'obtain a timeworn talisman from ephramadian'}},
        {id = 's8', kind = 'note', with = 's12', at = {n = 8, fp = 'trade the timeworn talisman and a'}},
        {id = 's12', at = {n = 12, fp = 'should your appraisal succeed you will'},
         done = {
            {t = 'ki', id = 1249, gained = true, why = 'Talisman of the rebel gods obtained'},
            {t = 'ki_have', id = 1249, have = true, why = 'Talisman of the rebel gods held'},
            {t = 'chat', re = 'obtained key item: talisman of the rebel gods', why = 'chat: key item obtained'},
         }},
        {id = 's13', at = {n = 13, fp = 'enter the walahra temple in aht'},
         done = {
            {t = 'ki', id = 1263, gained = true, why = 'Talisman key obtained'},
            {t = 'ki_have', id = 1263, have = true, why = 'Talisman key held'},
            {t = 'chat', re = 'obtained key item: talisman key', why = 'chat: key item obtained'},
         }},
        {id = 's14', kind = 'note', with = 's21', at = {n = 14, fp = 'enter hazhalm testing grounds and examine'}},
        {id = 's15', kind = 'note', with = 's21', at = {n = 15, fp = 'examine the entry gate again to'}},
        {id = 's20', kind = 'note', with = 's21', at = {n = 20, fp = 'after winning the battle you will'}},
        {id = 's21', at = {n = 21, fp = 'examine imperial whitegate at aht urhgan'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

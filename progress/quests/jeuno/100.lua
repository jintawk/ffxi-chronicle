-- Step progress for The Miraculous Dale (Jeuno quest 100). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest (scripts/globals/quests.lua) but has no script for Rakuru-Rakoru, who is only a
-- default-action NPC there (scripts/zones/Lower_Jeuno/DefaultActions.lua), and the client event scripts hold no
-- Rakuru-Rakoru file; so no event or dialogue line is usable. What is left is the quest log (current at the accept,
-- completed at the reward) and the temporary key item the page names, Data Analyzer and Logger EX (id 1021 in
-- res/key_items.lua, a Temporary Key Item the NPC hands out at the accept; it goes back with the reward, so its loss is only
-- a supporting mark). The "battle data recorded" line is in a bullet that is not a step. Not repeatable (page meta). The quest
-- log is set at s1, so it is not silent.
return {
    title = 'The Miraculous Dale',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to rakuru rakoru in lower'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 1021, gained = true, why = 'Data Analyzer and Logger EX obtained'},
            {t = 'ki_have', id = 1021, have = true, why = 'Data Analyzer and Logger EX held'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak with rakuru rakoru at any'}},
        {id = 's3', at = {n = 3, fp = 'once all the nm data has'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 1021, gained = false, after = 's1', conf = 'inferred', why = 'Data Analyzer and Logger EX handed back'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'the reward of 59630 gil when'}},
    },
}

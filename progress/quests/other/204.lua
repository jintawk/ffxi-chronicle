-- Step progress for Chacharoon's Cheer (other quest 204). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script covers the Mog Garden (zone 280), so events and NPC lines
-- cannot be cited; the steps rest on key items (res/key_items.lua) and the quest log. a Logger chat log (2025-12-29,
-- 2026-01-03): Zenicca sells "Sakura and the Magic Spoon" for 1000 bayld (purchase, not a reward); the next Mog Garden
-- zone-in plays the Susuroon cutscene; trading the Gold Beastcoin to Chacharoon ends the quest ("The lamb memento
-- satisfies the monster and triggers the Cheer: Lamb"). Cheer: Lamb (2716) is an Active Effects key item that is also
-- re-gained when a cheer is changed, so it only supports the completion. Bullet 3 only describes the reward. Not repeatable.
return {
    title = "Chacharoon's Cheer",
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'upon reaching level 2 in monster'},
         done = {
            {t = 'ki', id = 2633, gained = true, why = '"Sakura and the Magic Spoon" obtained (bought from Zenicca)'},
            {t = 'ki_have', id = 2633, have = true, why = '"Sakura and the Magic Spoon" held'},
            {t = 'chat', re = 'obtained key item: "sakura and the magic spoon"', why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade chacharoon a gold beastcoin to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Gold Beastcoin traded)'},
            {t = 'ki', id = 2716, gained = true, conf = 'inferred', why = 'Cheer: Lamb activated by the completion'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'you ll unlock the ability to'}},
    },
}

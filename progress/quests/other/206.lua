-- Step progress for Doctor Chacharoon (other quest 206). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script covers the Mog Garden (zone 280). a Logger chat log:
-- 2026-03-15 Zenicca sells "Sakura's Excellent Adventure" for 7000 bayld (a purchase); 2026-03-17 the Mog Garden zone-in
-- cutscene (Chacharoon and the adamantoise hatchling) asks for twelve crayfish; 2026-03-31 the trade to the Green Thumb
-- Moogle ends the quest ("up to a maximum of 3 at once"). The cutscene and the trade have no signal of their own
-- (events are not in the references, items are never proof), so the quest log carries the completion.
return {
    title = 'Doctor Chacharoon',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'continue monster rearing and purchase the'},
         done = {
            {t = 'ki', id = 2844, gained = true, why = '"Sakura\'s Excellent Adventure" obtained (bought from Zenicca)'},
            {t = 'ki_have', id = 2844, have = true, why = '"Sakura\'s Excellent Adventure" held'},
            {t = 'chat', re = "obtained key item: \"sakura's excellent adventure\"", why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'enter your mog garden for a'}},
        {id = 's3', at = {n = 3, fp = 'trade 12 crayfish to your green'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (twelve Crayfish traded)'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'note once the quest is activated'}},
    },
}

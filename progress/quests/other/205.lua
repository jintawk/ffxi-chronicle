-- Step progress for Trial of the Chacharoon (other quest 205). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script covers the Mog Garden (zone 280). a Logger chat log
-- (2026-01-03): Zenicca sells "Sakura and the Fountain" for 3000 bayld (a purchase, bought while Chacharoon's Cheer was
-- still open); talking to Chacharoon afterwards shows "up to a maximum of 2 at once". The quest log carries the
-- completion. Bullet 2 is a walk into the new area; the talk in bullet 3 completes the quest.
return {
    title = 'Trial of the Chacharoon',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'care for monsters an additional 5'},
         done = {
            {t = 'ki', id = 2793, gained = true, why = '"Sakura and the Fountain" obtained (bought from Zenicca)'},
            {t = 'ki_have', id = 2793, have = true, why = '"Sakura and the Fountain" held'},
            {t = 'chat', re = 'obtained key item: "sakura and the fountain"', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'after purchasing the key item enter'}},
        {id = 's3', at = {n = 3, fp = 'speak to chacharoon in the newly'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

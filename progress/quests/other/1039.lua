-- Step progress for Full Fields (other quest 1039). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script covers the Mog Garden (zone 280). Zoning in for the
-- first time makes the Green Thumb Moogle hand over the GPS crystal (key item 2398, not a quest reward: it stays for the
-- star counter), so its gain marks bullet 2; the report back at the furrow ends the quest (quest log completed).
return {
    title = 'Full Fields',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'visit either npc outside of the'}},
        {id = 's2', at = {n = 2, fp = 'upon zoning in your green thumb'},
         done = {
            {t = 'ki', id = 2398, gained = true, why = 'GPS crystal obtained (the moogle hands it over)'},
            {t = 'ki_have', id = 2398, have = true, why = 'GPS crystal held'},
            {t = 'chat', re = 'obtained key item: gps crystal', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'after harvesting from the garden furrow'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

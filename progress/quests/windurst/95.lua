-- Step progress for Babban Ny Mheillea (Windurst quest 95). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: none beyond the page and the quest log. LandSandBoat names the quest id (quests.lua) but has no script for it, and
-- the client event scripts hold nothing for Khoto Rokkorah or the Peculiar Rootprints, so no event, key item or dialogue line is
-- known. The page puts the start at the first cutscene (bullet 1: the quest begins after it) and the reward at the last
-- (bullet 5), so the log's accepted bit belongs to s1 and its completed bit to s5. The three Rootprints bullets (2 to 4) have no
-- strong signal and stay plain bullets. Not repeatable (page meta).
return {
    title = 'Babban Ny Mheillea',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'the quest begins after speaking to'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (page: the quest begins after the cutscene)'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to khoto rokkorah to receive'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

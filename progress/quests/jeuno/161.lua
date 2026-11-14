-- Step progress for A Trial in Tandem Redux (Jeuno quest 161). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no script for this quest (scripts/globals/quests.lua names A_TRIAL_IN_TANDEM_REDUX, no
-- scripts/quests file exists) and the client event script for Luto Mewrilah (S4 244_Luto_Mewrilah_010F408C.txt) decodes only
-- events 10031-10033, none of them this quest's; the Magian Moogle is not in the decoded scripts at all. The Magian
-- Mooglehood missive (key items 1768-1772) is shared by the whole Trial in Tandem family and the Tandem Necklace +1 and Silver
-- Meed are items the Magian trials also hand out, so none of them is used. Only the quest log is specific to this quest:
-- current at Luto Mewrilah's first cutscene, completed when the Silver Meed goes back to him (the last bullet). The Magian
-- steps in between stay plain. Not repeatable (page meta). The quest log is set at s1, so it is not silent.
return {
    title = 'A Trial in Tandem Redux',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with luto mewrilah for a'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's6', at = {n = 6, fp = 'trade the silver meed to luto'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

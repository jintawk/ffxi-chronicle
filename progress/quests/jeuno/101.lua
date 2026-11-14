-- Step progress for Clash of the Comrades (Jeuno quest 101). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no script for this quest (scripts/globals/quests.lua names it; the Fellow quests are .todo stubs),
-- and the client event script for Luto Mewrilah (S4 244_Luto_Mewrilah_010F408C.txt) decodes only events 10031-10033, none
-- of them this quest's, so no event id or dialogue line is usable (Luto's events are shared with the other Fellow quests
-- anyway). Only the quest log is: set at Luto Mewrilah's accept, and the page ends at the battlefield (Fellow's level cap
-- raised to 70), so the completed bit is taken as the last bullet. The travel bullet has no signal. Not repeatable (page
-- meta). The quest log is set at s1, so it is not silent.
return {
    title = 'Clash of the Comrades',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with luto mewrilah for a'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'go to the qu bia arena'}},
        {id = 's3', at = {n = 3, fp = 'once your fellow reaches 10 20'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

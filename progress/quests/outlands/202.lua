-- Step progress for Fish Favors the Bold (Outlands quest 202). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: none beyond the quest log. LandSandBoat has no script for this quest (its enum has no entry) and the client dump of
-- Irmilant (S4 247_Irmilant_010F702E.txt) holds only events 77 to 78 and 131 to 135, so no event id or line can be tied to a
-- bullet. The quest log's current bit is set when Irmilant starts the quest (bullet 2), and its completed bit when the rod is
-- upgraded (bullet 5, the reward is the Ebisu F. Rod +1 and the title). The legendary fish and their trade-in (bullets 3 and 4)
-- have no signal of their own (the fish are ordinary items that can come from the Auction House), so they are notes on the last
-- step. Not repeatable.
return {
    title = 'Fish Favors the Bold',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'doing the quest fisherman s heart'}},
        {id = 's2', at = {n = 2, fp = 'talk to irmilant to start the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Irmilant)'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'you will need to catch in'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'if you have already caught one'}},
        {id = 's5', at = {n = 5, fp = 'after you trade in all five'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the rod upgraded)'},
         }},
    },
}

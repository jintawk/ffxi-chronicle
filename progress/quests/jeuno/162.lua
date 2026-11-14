-- Step progress for Yet Another Trial in Tandem (Jeuno quest 162). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest (scripts/globals/quests.lua, id 162) but has no script for it, and the client's event
-- script for Luto Mewrilah (S4 244_Luto_Mewrilah_010F408C.txt) has no text for the Tandem events; the Magian Moogle's events
-- and the Magian Trial trades are shared by every Trial in Tandem quest and by the Magian trials in general, so no event or
-- line here is specific to this quest. Only the quest log's own bits are used: the current bit (set when Luto Mewrilah's
-- cutscene begins the quest, bullet 1) and the completed bit (set when the last trade to Luto Mewrilah completes it). The
-- Magian Mooglehood missive key items (ids 1768 to 1772 in res/key_items.lua, all named alike) are not used: which id belongs
-- to which quest is not shown by any source. The bullets between are plain bullets. Not repeatable (page meta).
return {
    title = 'Yet Another Trial in Tandem',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with luto mewrilah for a'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Luto Mewrilah begins the quest)'},
         }},
        {id = 's2', at = {n = 6, fp = 'trade the mythril meed to luto'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the last trade to Luto Mewrilah)'},
         }},
    },
}

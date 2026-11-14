-- Step progress for A Reputation in Ruins (Jeuno quest 73). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: neither LandSandBoat nor the client's event scripts have anything for this quest (LandSandBoat only lists the id 73
-- in globals/quests.lua; Migliorozz, the Pso'Xja ??? spots and the Avatar Gate have no script and no S4 pseudo-code), so the
-- mapping rests on the quest log and on the four key items the page names: Phoenix armlet 615 or Phoenix pearl 616 (Migliorozz
-- gives one or the other at the start), Blue bracelet 595 (bullet 5) and Green bracelet 596 (bullet 9); ids from
-- res/key_items.lua. The bracelets are permanent key items, so a login snapshot that holds one proves its step. The quest
-- completes at the last bullet (the return to Migliorozz, no key item or event of its own), so only the log's completed bit
-- proves it; the climbing, door, receptor and Avatar Gate bullets are notes on the step they lead into. Not repeatable.
-- Disagreement with the draft: it put the completion on the Green bracelet step. Retail has not been captured (no event ids),
-- so the quest log flagging at s1 follows the page ("speak to Migliorozz" is where the quest begins).
return {
    title = 'A Reputation in Ruins',
    completes = 's15',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'in upper jeuno speak to migliorozz'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 615, gained = true, why = 'Phoenix armlet obtained'},
            {t = 'ki_have', id = 615, have = true, why = 'Phoenix armlet held'},
            {t = 'ki', id = 616, gained = true, why = 'Phoenix pearl obtained'},
            {t = 'ki_have', id = 616, have = true, why = 'Phoenix pearl held'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'head to beaucedine glacier and enter'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'go up the stairs and into'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'when you examine the gargoyle iota'}},
        {id = 's5', at = {n = 5, fp = 'examine the once the nm s'},
         done = {
            {t = 'ki', id = 595, gained = true, why = 'Blue bracelet obtained'},
            {t = 'ki_have', id = 595, have = true, why = 'Blue bracelet held'},
         }},
        {id = 's6', kind = 'note', with = 's9', at = {n = 6, fp = 'head down the stairs to h'}},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'drop down the hole and head'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'checking the will spawn gargoyle lambda'}},
        {id = 's9', at = {n = 9, fp = 'examine the after the nm s'},
         done = {
            {t = 'ki', id = 596, gained = true, why = 'Green bracelet obtained'},
            {t = 'ki_have', id = 596, have = true, why = 'Green bracelet held'},
         }},
        {id = 's10', kind = 'note', with = 's15', at = {n = 10, fp = 'return back to the entrance of'}},
        {id = 's11', kind = 'note', with = 's15', at = {n = 11, fp = 'return upstairs i 8 go down'}},
        {id = 's12', kind = 'note', with = 's15', at = {n = 12, fp = 'head to g 8 where you'}},
        {id = 's13', kind = 'note', with = 's15', at = {n = 13, fp = 'examine the crystal receptor and quickly'}},
        {id = 's14', kind = 'note', with = 's15', at = {n = 14, fp = 'head down the elevator and examine'}},
        {id = 's15', at = {n = 15, fp = 'return to migliorozz for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

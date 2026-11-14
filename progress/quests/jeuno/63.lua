-- Step progress for Painful Memory (Jeuno quest 63). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Painful_Memory.lua (Mertaire in Lower Jeuno begins it and gives key item 228,
-- which the page does not list as a step; the Waters of Oblivion in Ranguemont Pass (166) pop Tros with no event, and after
-- Tros falls play cutscene 8, which runs quest:complete and takes the key item; the Paper Knife reward cannot be given on a
-- full bag while 8 still plays, so 8 is only a reach and the quest log's completed bit carries the last step; the key item is
-- taken only on success). Key item 228 (Mertaire's bracelet) from res/key_items.lua, used by no other quest. The pool and Tros
-- bullets leave no trace the client can see (no event, no unique line), so they are notes. Not repeatable (page meta).
return {
    title = 'Painful Memory',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'travel to ranguemont pass and head'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'activating the waters of oblivion will'}},
        {id = 's3', at = {n = 3, fp = 'click on the waters of oblivion'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 228, gained = false, conf = 'inferred', why = "Mertaire's bracelet handed over (taken only when the quest completes)"},
         },
         reach = {{t = 'event', zone = 166, event = 8, why = 'Waters of Oblivion 8 (also plays when the Paper Knife cannot be given)'}}},
    },
}

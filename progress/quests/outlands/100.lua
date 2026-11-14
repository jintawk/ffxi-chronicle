-- Step progress for Voidwatch Ops: Border Crossing (Outlands quest 100). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script (the quest id exists in globals/quests.lua only) and no client script for Kieran in Norg: his
-- event 249/259 is the shared Voidwatch menu, so no event or line is used. The page says Kieran gives a cutscene and the Ashen
-- stratum abyssite (KI 1447, res/key_items.lua) at the start, and nothing else hands it out, so its gain proves bullet 1. The
-- two sub-quests (bullet 2, started at Hildegard and the Gushing Spring, pages outlands 101 and the Rabao one) are notes: their
-- own pages track them. Bullet 3 ends the quest, so only the quest log's completed bit proves it; the entry is mapped because
-- bullet 1 has a signal of its own. Not repeatable.
return {
    title = 'Voidwatch Ops: Border Crossing',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kieran in norg i'},
         done = {
            {t = 'ki', id = 1447, gained = true, why = 'ashen stratum abyssite obtained'},
            {t = 'ki_have', id = 1447, have = true, why = 'ashen stratum abyssite held'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak with the following npcs to'}},
        {id = 's3', at = {n = 3, fp = 'complete both subquests and return to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

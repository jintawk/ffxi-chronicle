-- Step progress for The Weatherspoon Inquisition (Adoulin quest 136). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script (the enum names the quest only) and no client event script for its NPCs or points, so the
-- signals are the page's key item and the quest log. The Sturdy hide pouch (key item 2597) is handed over at the Occultist
-- Footprints in the middle of the quest (bullet 2), so it proves that bullet and is not the reward; the draft put the completion
-- there, but the page gives the reward at the Hiding Place (bullet 5), which carries the completed bit. The zone-in
-- cutscenes (1, 4) and the Ergon Locus visits (3) have no signal we can name: notes. Not repeatable.
return {
    title = 'The Weatherspoon Inquisition',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'zone into western adoulin from ceizak'}},
        {id = 's2', at = {n = 2, fp = 'check the occultist footprints at the'},
         done = {
            {t = 'ki', id = 2597, gained = true, why = 'sturdy hide pouch obtained'},
            {t = 'ki_have', id = 2597, have = true, why = 'sturdy hide pouch held'},
            {t = 'chat', re = 'obtained key item: sturdy hide pouch', why = 'chat: key item obtained'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'visit the following ergon locus in'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'zone into cirdas caverns for a'}},
        {id = 's5', at = {n = 5, fp = 'check the hiding place at the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the Hiding Place gives the reward)'},
         }},
    },
}

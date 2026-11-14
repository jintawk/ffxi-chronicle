-- Step progress for Vegetable Vegetable Frustration (Adoulin quest 111). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script for Amchuchu's door, Raibaht, the Peculiar Fissure or the
-- Contemplation Site, so the page is the only source. Key items from res/key_items.lua: Packet of Midras's explosives (3027,
-- the sub-bullet of n=7; a Sabiki Rig trade gives a new one after a failed fight, which still only proves n=7) and the
-- Tarnished ring (3028) and Rusty locket (3029), both handed over at the fissure (n=10). The page ends the quest at the
-- laboratory (n=13, "for a cutscene and the reward of Midras's Helm +1"), so the log's completed bit belongs to n=13. The
-- Raibaht talks, the mine trips, the bang-on-the-rock and the NM fight (n=2-6, n=8-9, n=11-12) have no signal of their own:
-- notes on the next step that has one (the NM kill itself has no wording or key item). Not repeatable.
return {
    title = 'Vegetable Vegetable Frustration',
    completes = 's13',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's7', at = {n = 1, fp = 'wait one in game day after'}},
        {id = 's2', kind = 'note', with = 's7', at = {n = 2, fp = 'check amchuchu s laboratory at the'}},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'head to the metalworks in bastok'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'go to palborough mines map 3'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'bang on the rock three times'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'return to raibaht'}},
        {id = 's7', at = {n = 7, fp = 'go to the adoulin waterfront waypoint'},
         done = {
            {t = 'ki', id = 3027, gained = true, why = "packet of Midras's explosives obtained"},
            {t = 'ki_have', id = 3027, have = true, why = "packet of Midras's explosives held"},
            {t = 'chat', re = "obtained key item: packet of midras's explosives", why = 'chat: key item obtained'},
         }},
        {id = 's8', kind = 'note', with = 's10', at = {n = 8, fp = 'return to the peculiar fissure and'}},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'examine it again to spawn incensed'}},
        {id = 's10', at = {n = 10, fp = 'examine the peculiar fissure again for'},
         done = {
            {t = 'ki', id = 3028, gained = true, why = 'tarnished ring obtained'},
            {t = 'ki_have', id = 3028, have = true, why = 'tarnished ring held'},
            {t = 'chat', re = 'obtained key item: tarnished ring', why = 'chat: key item obtained'},
            {t = 'ki', id = 3029, gained = true, why = 'rusty locket obtained'},
            {t = 'ki_have', id = 3029, have = true, why = 'rusty locket held'},
            {t = 'chat', re = 'obtained key item: rusty locket', why = 'chat: key item obtained'},
         }},
        {id = 's11', kind = 'note', with = 's13', at = {n = 11, fp = 'return to raibaht'}},
        {id = 's12', kind = 'note', with = 's13', at = {n = 12, fp = 'return to the contemplation site for'}},
        {id = 's13', at = {n = 13, fp = 'check amchuchu s laboratory at the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed at the laboratory'},
         }},
    },
}

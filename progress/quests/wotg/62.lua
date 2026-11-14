-- Step progress for Manifest Destiny (Crystal War quest 62, Wings of the Goddess). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest (MANIFEST_DESTINY) in its id list only, with no script, and the client has no event script
-- for the Mithran Bivouac, the Iron Grilles or the Collapsing Floor, so the page is the source. Key item 1277 (Poet god's key,
-- res/key_items.lua) is the pickup after the third prison cutscene (n=7). The page says a lost fight needs the key from the
-- Mithran Bivouac again, so the key is used up when the Collapsing Floor battle is entered: its loss after bullet 7 is inferred for
-- bullet 9. The completed bit belongs to the battle (n=11, defeating Tzee Xicu; with a Hi-Reraiser the reward is collected at the
-- Bivouac afterwards). The draft's Yagudo crest (338) on the Collapsing Floor bullet is dropped: that key item belongs to Whence
-- Blows the Wind (jeuno/130), not to this quest. The log's first flag is not known, so the steps before the key are silent. The
-- other bullets (cutscene trips, farming keys, trading them, the fight's facts) have no signal of their own: notes. Not repeatable.
-- Shared-signal audit: the Poet god's key (1277) is named by no LandSandBoat script and nowhere under progress/. The page of the next
-- quest, At Journey's End (63), hands out "another" one at the same Bivouac; that quest is unmapped (no signal of its own) and it can
-- only start after this one is completed, so a second gain cannot tick a step here before the quest is done. The Yagudo crest (338)
-- is shared with Whence Blows the Wind (jeuno/130) and is dropped.
return {
    title = 'Manifest Destiny',
    completes = 's11',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's7'}},
    steps = {
        {id = 's1', kind = 'note', with = 's7', at = {n = 1, fp = 'speak to dhea prandoleh for a'}},
        {id = 's2', kind = 'note', with = 's7', at = {n = 2, fp = 'examine the mithran bivouac in meriphataud'}},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'enter castle oztroja s for a'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'farm three dorter keys which drop'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'click the iron grilles located in'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'trade the dorter keys to three'}},
        {id = 's7', at = {n = 7, fp = 'after freeing three sets of prisoners'},
         done = {
            {t = 'ki', id = 1277, gained = true, why = "Poet god's key obtained"},
            {t = 'ki_have', id = 1277, have = true, why = "Poet god's key held"},
            {t = 'chat', re = "obtained key item: poet god's key", why = 'chat: key item obtained'},
         }},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'head to the top of castle'}},
        {id = 's9', at = {n = 9, fp = 'examine the collapsing floor again to'},
         done = {
            {t = 'ki', id = 1277, gained = false, after = 's7', conf = 'inferred', why = "Poet god's key used up when the battle is entered (page: a lost fight needs a new key)"},
         }},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'the fight is against tzee xicu'}},
        {id = 's11', at = {n = 11, fp = 'defeat tzee xicu the manifest to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed after the battle'},
         }},
    },
}

-- Step progress for A Manifest Problem (Crystal War quest 28, Wings of the Goddess). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest (A_MANIFEST_PROBLEM) but implements nothing beyond the Cait Sith mission's check for
-- its completion; the client event script S4 096_Rotih_Moalghett_010602CE.txt carries only the Tigress Strikes events, so the
-- storytelling sequences have no event id or line to match. Key item 974 (Fort key, res/key_items.lua) is handed over at
-- Rotih's second storytelling (the sub-bullet of n=3) and no LandSandBoat script gives it for anything else. The page ends the
-- quest at the final storytelling in Windurst Waters [S] with the reward (n=5), so the log's completed bit belongs to n=5. The
-- log's first flag is not known, so the steps before the key are silent (unknown, not to do). The Rotih bullet (n=1), the
-- Castle Oztroja zone-in (n=2) and the Colorful Door battle (n=4) have no signal of their own: notes. Not repeatable.
-- Shared-signal audit: the Fort key (974) appears in no other LandSandBoat script and nowhere under progress/.
return {
    title = 'A Manifest Problem',
    completes = 's5',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'speak with rotih moalghett at i'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to castle oztroja s and'}},
        {id = 's3', at = {n = 3, fp = 'return to rotih moalghett for another'},
         done = {
            {t = 'ki', id = 974, gained = true, why = 'Fort key obtained'},
            {t = 'ki_have', id = 974, have = true, why = 'Fort key held'},
            {t = 'chat', re = 'obtained key item: fort key', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'examine the colorful door at h'}},
        {id = 's5', at = {n = 5, fp = 'after the yagudo are all defeated'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed at the final storytelling'},
         }},
    },
}

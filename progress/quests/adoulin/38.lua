-- Step progress for The Communion (Adoulin quest 38). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script (the enum names the quest only) and no decoded client event for Sylvie, Nhili Uvolep or the
-- Overgrown Grave, so the signals are the log and one key item, from BG-wiki's walkthrough and header (Sylvie starts the quest;
-- Nhili Uvolep's second cutscene hands over Lhaiso Neftereh's bell, key item 2375, a temporary key item from res/key_items.lua
-- and the fight's item requirement; Sylvie's last cutscene takes it and completes the quest). The draft put the completed bit on
-- the Nhili Uvolep bullet and made Sylvie's offer and her final talk notes; the quest completes at bullet 7. The addon warning,
-- the grave cutscenes and the spawn have no signal of their own and are notes on the step they lead into. Not repeatable.
return {
    title = 'The Communion',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to sylvie at western adoulin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Sylvie)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'warning the following two windower addons'}},
        {id = 's3', at = {n = 3, fp = 'speak to nhili uvolep at eastern'},
         done = {
            {t = 'ki', id = 2375, gained = true, after = 's1', why = "Lhaiso Neftereh's bell obtained"},
            {t = 'ki_have', id = 2375, have = true, why = "Lhaiso Neftereh's bell held"},
            {t = 'chat', re = "obtained key item: lhaiso neftereh's bell", why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'travel to m 8 9 in'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'examine the overgrown grave again to'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'upon defeating the ancestral rage examine'}},
        {id = 's7', at = {n = 7, fp = 'return to sylvie for one last'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 2375, gained = false, after = 's3', why = "Lhaiso Neftereh's bell taken at the last cutscene"},
         }},
    },
}

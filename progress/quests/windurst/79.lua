-- Step progress for Nothing Matters (Windurst quest 79). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: none beyond the key item and the quest log. LandSandBoat names NOTHING_MATTERS but has no script for it (only
-- Blast_from_the_Past.lua sets a zone-again flag for it), and the client event scripts of Koru-Moru, Fuepepe and the Acolyte
-- Hostel doors carry none of its events, so no NPC event or dialogue line can be named. The Thesis on alchemy (res/key_items.lua
-- 292, a temporary key item) comes from the Acolyte Hostel cutscene of bullet 5, so it proves that bullet; the quest log's
-- completed bit proves the last. Bullets 1 to 4 and 7 to 8 stay plain bullets (the current bit is not known to be set at the
-- first talk without a script, so it is not used). The quest log is not known to be silent, so no `silent_until`.
return {
    title = 'Nothing Matters',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's5', at = {n = 5, fp = 'after answering the questions head to'},
         done = {
            {t = 'ki', id = 292, gained = true, why = 'thesis on alchemy obtained at the Acolyte Hostel'},
            {t = 'ki_have', id = 292, have = true, why = 'thesis on alchemy held'},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'you will receive the thesis on'}},
        {id = 's9', at = {n = 9, fp = 'return to koru moru in a'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

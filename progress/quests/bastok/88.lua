-- Step progress for Fully Mental Alchemist (Bastok quest 88). Data only; see progress/quests/sandoria/27.lua for the format.
-- LandSandBoat has no script for this quest and the client's Titus script is not decoded, so key items and the quest log speak.
-- Titus begins the quest and hands over the Prospector's pan (1177) and the Corked ampoule (1178); washing the riverbed up to
-- 20 grains gives the Ampoule of gold dust (1179); Titus completes the quest, so the completed bit belongs to the last bullet,
-- not the ampoule bullet as the draft had it. All three are temporary key items, so no chat line is used for them. The
-- travel and riverbed option bullets are notes on the ampoule step.
return {
    title = 'Fully Mental Alchemist',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to titus on the second'},
         done = {
            {t = 'ki', id = 1177, gained = true, why = "prospector's pan obtained"},
            {t = 'ki', id = 1178, gained = true, why = 'corked ampoule obtained'},
            {t = 'quest', current = true, why = 'quest log: accepted (Titus begins the quest)'},
         }},
        {id = 's2', kind = 'note', with = 's6', at = {n = 2, fp = 'travel to grauberg s and find'}},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'when you examine the riverbed you'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'when you select one you will'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'to extract gold you must wash'}},
        {id = 's6', at = {n = 6, fp = 'choose that and you will gain'},
         done = {
            {t = 'ki', id = 1179, gained = true, why = 'ampoule of gold dust obtained'},
            {t = 'ki_have', id = 1179, have = true, why = 'ampoule of gold dust held'},
         }},
        {id = 's7', at = {n = 7, fp = 'speak to titus again for a'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 1179, gained = false, after = 's6', conf = 'inferred', why = 'ampoule of gold dust handed over'},
         }},
    },
}

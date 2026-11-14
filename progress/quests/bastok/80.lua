-- Step progress for Hyper Active (Bastok quest 80). Data only; see progress/quests/sandoria/27.lua for the format.
-- LandSandBoat has no script for this quest and the client's Raibaht script (S4 237_Raibaht_010ED02C.txt) carries none of its
-- events, so only key items and the quest log speak. Speaking to Raibaht begins the quest and hands over the Molybdenum box
-- (key item 608); the Street Lamp gives the Hyper altimeter (607, temporary); Raibaht completes the quest, so the completed bit
-- belongs to the last bullet, not the altimeter bullet as the draft had it. The Delkfutt key (1111) is only a requirement of
-- the Lower Delkfutt's Tower bullet, not something the quest hands out, so it is not used. Temporary key items print no
-- wording this pass could verify, so no chat line is used for them. The travel and fight bullets are notes on the altimeter step.
return {
    title = 'Hyper Active',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'if you have just completed teak'}},
        {id = 's2', at = {n = 2, fp = 'speak with raibaht to begin quest'},
         done = {
            {t = 'ki', id = 608, gained = true, why = 'molybdenum box obtained'},
            {t = 'ki_have', id = 608, have = true, why = 'molybdenum box held'},
            {t = 'quest', current = true, why = 'quest log: accepted (Raibaht begins the quest)'},
         }},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'travel to lower delkfutt s tower'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'travel to i 6 of the'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'defeat orna which will make the'}},
        {id = 's6', at = {n = 6, fp = 'travel to lower jeuno and inspect'},
         done = {
            {t = 'ki', id = 607, gained = true, why = 'hyper altimeter obtained'},
            {t = 'ki_have', id = 607, have = true, why = 'hyper altimeter held'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to bastok and speak with'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 607, gained = false, after = 's6', conf = 'inferred', why = 'hyper altimeter handed over'},
         }},
    },
}

-- Step progress for Mysteries of Beadeaux II (Jeuno quest 32). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Mysteries_of_Beadeaux_II.lua (the quest is flagged by Sattal-Mansal's event 89
-- finish in Mysteries of Beadeaux I, scripts/quests/jeuno/Mysteries_of_Beadeaux_I.lua, so the log's accepted bit is the
-- "begin" bullet; trading exactly one Quadav Augury Shell plays event 92 and nothing else, a wrong trade returns no event;
-- the reward Black Matinee Necklace is a key item, given before the event ends, so there is no bag to be full; the finish
-- of 92 runs quest:complete); client event script S4 245_Sattal_Mansal_010F500E.txt (92: say #7720, the same "Okey-dokey,
-- here you go." as Mysteries of Beadeaux I's 91, so the line proves nothing and is left out); key item id from
-- res/key_items.lua (47). The kill bullet (Go'Bhu Gascon, Quadav Augury Shell drop) can only be seen as an item gain,
-- which is no proof, so it is a note on the hand-in. Not repeatable (page meta).
return {
    title = 'Mysteries of Beadeaux II',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to sattal mansal to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (flagged by Mysteries of Beadeaux I, Sattal-Mansal 89)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to beadeaux and kill go'}},
        {id = 's3', at = {n = 3, fp = 'return the quadav augury shell to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 245, event = 92, why = 'Sattal-Mansal 92: the Quadav Augury Shell accepted, runs quest:complete'},
            {t = 'ki', id = 47, gained = true, conf = 'inferred', why = 'black matinee necklace obtained (reward, may already be owned)'},
         }},
    },
}

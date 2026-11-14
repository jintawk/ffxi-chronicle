-- Step progress for Martial Mastery (Jeuno quest 167). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Martial_Mastery.lua (Nomad Moogle 10196 begins the quest when it is available,
-- 10198 plays only while accepted with 15 merits and runs quest:complete, taking 15 merits and giving the Heart of the
-- Bushin key item; neither event id is used by any other quest); client event script S4 243_Nomad_Moogle_010F3075.txt (10196
-- and 10198 are bare events, with no text and no menu to read, so a refused or abandoned play cannot be excluded: both stay
-- reach and the quest log's bits carry the steps); key item id from res/key_items.lua (2059 heart of the bushin, the reward,
-- which may already be owned). The quest log is set at the first talk, so it is not silent. Not repeatable (page meta).
-- Bullet 3 (the skill needed) is a note.
return {
    title = 'Martial Mastery',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to the nomad moogle near'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Nomad Moogle 10196)'},
         },
         reach = {{t = 'event', zone = 243, event = 10196, why = 'Nomad Moogle 10196 (begins the quest)'}}},
        {id = 's2', at = {n = 2, fp = 'give him 15 merits to receive'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Nomad Moogle 10198)'},
            {t = 'ki', id = 2059, gained = true, conf = 'inferred', why = 'heart of the bushin obtained (reward)'},
         },
         reach = {{t = 'event', zone = 243, event = 10198, why = 'Nomad Moogle 10198 (takes the 15 merits, runs quest:complete)'}}},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = '357 skill in a weapon is'}},
    },
}

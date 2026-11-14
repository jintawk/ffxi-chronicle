-- Step progress for Prelude to Puissance (Jeuno quest 170). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/LB09_2_Prelude_to_Puissance.lua (Nomad Moogle 10194 begins the quest and is
-- used by no other quest, so it is only a reach: it has no body in the client's event script S4
-- 243_Nomad_Moogle_010F3075.txt and no menu can be read; the Seasoning Stone trade and the later talk both play 10045,
-- which is shared with every other limit break quest of this NPC (BEYOND_INFINITY, BEYOND_THE_STARS, DORMANT_POWERS_DISLODGED,
-- EXPANDING_HORIZONS, NEW_WORLDS_AWAIT) and is not used; the quest completes in 10045's finish on a choice of option, so
-- the quest log's completed bit carries the step). The reward Soul gem clasp can be bought again, so it proves nothing.
-- The quest log is set at the first talk, so it is not silent. Not repeatable (page meta). Bullets 3 to 5 are notes.
return {
    title = 'Prelude to Puissance',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to the nomad moogle next'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Nomad Moogle 10194)'},
         },
         reach = {{t = 'event', zone = 243, event = 10194, why = 'Nomad Moogle 10194 (begins the quest)'}}},
        {id = 's2', at = {n = 2, fp = 'retrieve a seasoning stone which drops'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (10045 finish, quest:complete)'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'you will receive soul gem clasp'}},
        {id = 's4', kind = 'note', with = 's2', at = {n = 4, fp = 'this quest is now technically completed'}},
    },
}

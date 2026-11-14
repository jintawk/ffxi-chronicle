-- Step progress for Mom, the Adventurer? (Bastok quest 21). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Mom_the_Adventurer.lua (Nbu Latteh 230 gives the Fire Crystal and begins the
-- quest only if the crystal fits, so with a full bag it plays and nothing starts; 231 is his talk while accepted and the
-- letter is not held; Parnika 232 is the guard's line; trading the Copper Ring to Roh Latteh is event 95, which gives key item
-- 107; Nbu Latteh 233 (letter unread, 200 gil) or 234 (letter read, 100 gil) run quest:complete, take the letter and pay gil);
-- client event scripts S4 235_Nbu_Latteh_010EB032.txt, 235_Parnika_010EB040.txt, 234_Roh_Latteh_010EA014.txt; key item 107
-- and item 4096 from res/. The draft proved the completion by 234 only (233 is the unread-letter branch) and had no
-- completion in LandSandBoat; the Fire Crystal rule makes 230 and its line `reach`, so the quest log proves s1. The quest is
-- repeatable at Bastok fame 1 (page meta), but 230 plays on a full bag too and the crystal is no proof of a new run, so
-- there is no `repeatable` entry. Bullet 5 is the result of the Roh Latteh trade (a note on it), bullets 3, 6 and 8 are notes.
-- The quest log is set at s1, so it is not silent.
-- Shared-signal audit: item 4096 (Fire Crystal) is gained everywhere (Tutorial quest, mission rewards, drops) -> dropped; the
-- quest log, 231 and its line still carry s1.
return {
    title = 'Mom, the Adventurer?',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to nbu latteh on gold'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 235, event = 231, conf = 'inferred', why = 'Nbu Latteh 231: only while accepted'},
            {t = 'chat', re = "I've got to make a living, too!", conf = 'inferred', why = 'Nbu Latteh 231 (say #7606)'},
         },
         reach = {
            {t = 'event', zone = 235, event = 230, why = 'Nbu Latteh 230 (also plays with a full bag)'},
            {t = 'chat', re = 'Ah! An adventurrrer! Good, good!', why = 'Nbu Latteh 230 (say #7601)'},
         }},
        {id = 's2', kind = 'optional', at = {n = 2, fp = 'optional speak to nbu latteh again'},
         done = {
            {t = 'event', zone = 235, event = 232, why = 'Parnika 232'},
            {t = 'chat', re = 'There have been numerous reports of burglaries and pick pocketing in this area lately%.', why = 'Parnika 232 (say #7607)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'obtain a copper ring either via'}},
        {id = 's4', at = {n = 4, fp = 'trade copper ring to roh latteh'},
         done = {
            {t = 'event', zone = 234, event = 95, why = 'Roh Latteh 95: the Copper Ring trade'},
            {t = 'chat', re = 'Oh! A prrresent from Mom!', why = 'Roh Latteh 95 (say #10783)'},
            {t = 'ki', id = 107, gained = true, why = 'letter from Roh Latteh obtained'},
            {t = 'ki_have', id = 107, have = true, why = 'letter from Roh Latteh held'},
            {t = 'chat', re = 'obtained key item: letter from roh latteh', why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'upon npc dialogue completion you will'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'if you check the letter as'}},
        {id = 's7', at = {n = 7, fp = 'return to nbu latteh to complete'},
         done = {
            {t = 'event', zone = 235, event = 233, why = 'Nbu Latteh 233: the unread letter'},
            {t = 'event', zone = 235, event = 234, why = 'Nbu Latteh 234: the read letter'},
            {t = 'chat', re = 'Be patient, my little kitten', why = 'Nbu Latteh 233 (say #7609)'},
            {t = 'chat', re = "Wait%.%.%. You've read this, haven't you%?", why = 'Nbu Latteh 234 (say #7610)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 107, gained = false, conf = 'inferred', why = 'letter from Roh Latteh handed over'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'this quest is repeatable for players'}},
    },
}

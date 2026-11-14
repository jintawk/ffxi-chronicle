-- Step progress for Path of the Beastmaster (Jeuno quest 19). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Path_of_the_Beastmaster.lua (Brutus 70 plays only when Save My Son is done
-- and the player is level 30, has no choice and runs quest:complete: unlockJob, key item and title, nothing to refuse; the
-- quest is never accepted, so the log is silent until it completes; after it, Brutus plays 20, Osker 45 and the Chocobo 72,
-- the "brief scene" of the last bullet). Client event scripts S4 244_Brutus_010F400C.txt (70 is a bare cutscene, 20 say
-- #7208), 244_Osker_010F400D.txt (45 say #7212) and 244_Chocobo_010F400A.txt (72 say #7102). Bullet 1 is a prerequisite, so
-- it is a note on the cutscene. Not repeatable.
return {
    title = 'Path of the Beastmaster',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'complete the prior quests chocobo s'}},
        {id = 's2', at = {n = 2, fp = 'speak to brutus in upper jeuno'},
         done = {
            {t = 'event', zone = 244, event = 70, why = 'Brutus 70: the cutscene, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's3', kind = 'optional', at = {n = 3, fp = 'optional visiting the merchant s house'},
         done = {
            {t = 'event', zone = 244, event = 20, why = 'Brutus 20: his talk after the quest (say #7208)'},
            {t = 'event', zone = 244, event = 45, why = 'Osker 45: his talk after the quest (say #7212)'},
            {t = 'event', zone = 244, event = 72, why = 'Chocobo 72: its talk after the quest (say #7102)'},
         }},
    },
}

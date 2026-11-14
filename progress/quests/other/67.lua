-- Step progress for The Call of the Sea (Other Areas quest 67). Data only; see progress/quests/sandoria/27.lua for the format.
-- The quest log stays silent until Anteurephiaux 172 begins the quest (s3), so s2 rests on an event alone.
-- Evidence: LandSandBoat scripts/quests/otherAreas/The_Call_of_the_Sea.lua (Equette 170 at Prog 0; Leporaitceau 171 is a
-- missable optional cutscene that plays before or during the quest; Anteurephiaux 172 at Prog 1 begins the quest; the Misareaux
-- Coast ??? gives the Whispering conch, Temporary KI 603, once Bloody Coffin is dead; Anteurephiaux 173 takes the conch;
-- Equette 174 at Prog 4 completes the quest). The ??? pop line (Misareaux Coast FOUL_STENCH_OF_DEATH) is shared with Knocking on
-- Forbidden Doors, so bullets 4-5 stay notes. The draft put Leporaitceau 171 and Anteurephiaux 173 on the begin step; 171 is
-- the optional first bullet and 173 is bullet 7. Client event scripts S4 026_Anteurephiaux, 026_Equette, 026_Leporaitceau are
-- bare for these events.
return {
    title = 'The Call of the Sea',
    completes = 's8',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', kind = 'optional', at = {n = 1, fp = 'speak to leporaitceau j 8 in'},
         done = {
            {t = 'event', zone = 26, event = 171, why = 'Leporaitceau 171: the optional cutscene'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to equette i 9 on'},
         done = {
            {t = 'event', zone = 26, event = 170, why = 'Equette 170 (Prog 0)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to anteurephiaux j 8 on'},
         done = {
            {t = 'event', zone = 26, event = 172, why = 'Anteurephiaux 172: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'travel to misareaux coast and look'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'checking the will spawn the nm'}},
        {id = 's6', at = {n = 6, fp = 'once the nm is defeated check'},
         done = {
            {t = 'ki', id = 603, gained = true, why = 'Whispering conch obtained'},
            {t = 'ki_have', id = 603, have = true, why = 'Whispering conch held'},
            {t = 'chat', re = 'obtained key item: whispering conch', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to anteurephiaux'},
         done = {
            {t = 'event', zone = 26, event = 173, after = 's3', why = 'Anteurephiaux 173: takes the conch (Prog 3)'},
            {t = 'ki', id = 603, gained = false, conf = 'inferred', why = 'Whispering conch handed over'},
         }},
        {id = 's8', at = {n = 8, fp = 'finally speak to equette to complete'},
         done = {
            {t = 'event', zone = 26, event = 174, after = 's3', why = 'Equette 174: completes the quest (Prog 4)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

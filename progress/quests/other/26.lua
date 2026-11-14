-- Step progress for Inside the Belly (other areas quest 26). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Inside_the_Belly.lua (Zaldon 161 is the offer, only with fishing skill 30 and
-- The Real Gift done, and begins the quest on finish with no menu; 162-165 are his talks while accepted (not used: the checker cannot see them); a
-- fish traded plays 166 (an item found) or 167 (none), both run quest:complete the first time and pay the fish's gil). Client
-- event script S4 248_Zaldon_010F8017.txt (161 say #6910; 166/167 have no text in the client script). Repeatable: the log marks
-- the first run only (run1), as for Bastok quest 0. The notes are the trade rules and the reward chances.
return {
    title = 'Inside the Belly',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'have 30 fishing skill or greater'},
         done = {
            {t = 'event', zone = 248, event = 161, why = 'Zaldon 161: the offer, begins the quest on finish'},
            {t = 'chat', re = 'Bring me some fish like that%. I\'ll gut it and check its innards', why = 'Zaldon 161 (say #6910)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade zaldon certain fish and he'},
         done = {
            {t = 'event', zone = 248, event = 166, why = 'Zaldon 166: a fish gutted, an item found, runs quest:complete'},
            {t = 'event', zone = 248, event = 167, why = 'Zaldon 167: a fish gutted, nothing found, runs quest:complete'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'he will buy the fish that'}},
        {id = 's4', kind = 'note', with = 's2', at = {n = 4, fp = 'as of the november 10th 2021'}},
        {id = 's5', kind = 'note', with = 's2', at = {n = 5, fp = 'note after completing the quest for'}},
    },
}

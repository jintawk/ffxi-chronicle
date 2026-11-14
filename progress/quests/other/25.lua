-- Step progress for Test My Mettle (other areas quest 25). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Test_My_Mettle.lua (Devean 120 is the offer; the quest begins on its finish
-- only when a bet and a deadline were chosen and the gil covers the bet, so the event and the bet line ("you're betting me")
-- also play on a failed bet and are not used, the log's current bit is; 121 is the reminder while the clock runs; the Power
-- Sandals traded in time play 122 and run quest:complete; late they play 123, which deletes the quest and is a failure, not a
-- step; 125 is the late reminder). Client event script S4 248_Devean_010F8023.txt (121 say #6901, 122 say #6902). The jar hunt
-- and the keep-the-sandals option are notes (the sandals can come from elsewhere). Repeatable (daily): the log marks the first
-- run only (run1), as for Bastok quest 0.
return {
    title = 'Test My Mettle',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to devean who will ask'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (Devean 120, a bet placed; first run only)'},
            {t = 'event', zone = 248, event = 121, conf = 'inferred', why = 'Devean 121: reminder, only while the clock runs'},
            {t = 'chat', re = "The clock's tickin'! I told you, comb Davoi for", conf = 'inferred', why = 'Devean 121 (say #6901)'},
         },
         reach = {{t = 'event', zone = 248, event = 120, why = 'Devean 120 offered (the bet may fail on gil)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'once in davoi you need to'}},
        {id = 's3', at = {n = 3, fp = 'return the power sandals to devean'},
         done = {
            {t = 'event', zone = 248, event = 122, why = 'Devean 122: the Power Sandals accepted in time, runs quest:complete'},
            {t = 'chat', re = 'Look what we got here! You made it in time!', why = 'Devean 122 (say #6902)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'you can also choose to keep'}},
    },
}

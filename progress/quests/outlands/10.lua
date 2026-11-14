-- Step progress for Personal Hygiene (Outlands quest 10). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Kazham/npcs/Gatih_Mijurabi.lua (191 begins the quest with no menu; 192 is his reminder
-- while accepted and the scent is on; 193 plays once the scent is gone and runs completeQuest, but with no free slot it only
-- shows "cannot obtain", so it reaches the hand-in and the log's completed bit proves it) and zones/Korroloka_Tunnel/Zone.lua
-- (the hot spring: after five minutes the leave message, IDs.lua LEFT_SPRING_CLEAN 7351, clears the scent; it is the only proof of
-- the waterfall bullet and is gated after s2 so a scent from another route is not counted). Client event script S4
-- 250_Gatih_Mijurabi_010FA040.txt (192 say #10392; 191 and 193 have no line). The quest log is set at s2, so it is not silent.
-- A zonein to Korroloka Tunnel (173) was dropped: Korroloka_Tunnel/Zone.lua onZoneIn (line 18) returns cs = -1, so no zone-in event exists; the entered-spring line is the reach signal.
-- The travel bullets and the leech warning are notes; the scent bullet and the final repeat bullet are plain. Not repeatable.
return {
    title = 'Personal Hygiene',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'after completing even more gullible s'}},
        {id = 's2', at = {n = 2, fp = 'speak to gatih mijurabi i 8'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Gatih Mijurabi 191)'},
            {t = 'event', zone = 250, event = 191, why = 'Gatih Mijurabi 191: begins the quest, no menu'},
            {t = 'event', zone = 250, event = 192, conf = 'inferred', why = 'Gatih Mijurabi 192: reminder, only while accepted with the scent on'},
            {t = 'chat', re = 'You must find a hot spring, but only one located somewhere deep beneath the sea%.', conf = 'inferred', why = 'Gatih Mijurabi 192 (say #10392)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'the hot springs is located in'}},
        {id = 's4', at = {n = 4, fp = 'stand yourself under the waterfall for'},
         done = {
            {t = 'chat', re = 'Your whole body is piping hot, and the smell of the Rafflesia pollen is gone!', after = 's2', why = 'Korroloka Tunnel: left the spring after five minutes (LEFT_SPRING_CLEAN)'},
         },
         reach = {
            {t = 'chat', re = 'The water in this spring is pleasant and tepid%. This looks like a nice place to warm yourself up%.', after = 's2', why = 'Korroloka Tunnel: stepped into a pool with the scent on (ENTERED_SPRING, IDs.lua:25; Zone.lua:41 onTriggerAreaEnter, only while BathedInScent == 1)'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'the waterfall is guarded by several'}},
        {id = 's6', at = {n = 6, fp = 'return to gatih mijurabi to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Gatih Mijurabi 193, with a free slot for the Mithran Stone)'},
         },
         reach = {
            {t = 'event', zone = 250, event = 193, after = 's2', why = 'Gatih Mijurabi 193: the hand-in talk (completes only with a free slot)'},
         }},
    },
}

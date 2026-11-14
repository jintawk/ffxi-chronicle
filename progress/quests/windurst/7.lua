-- Step progress for A Pose by Any Other Name (Windurst quest 7). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/A_Pose_by_Any_Other_Name.lua (Angelica 90 and 91 are the offer menu and can
-- be declined, option 1 begins the quest, so both are only reaches; the first talk while accepted plays 92, which states the
-- job's body piece and starts the hour; the next talk plays 94 when the wrong body is worn ("wear your item"), 96 when the
-- right one is worn in time, or 102 when the hour is over; 96 completes the quest but the Copy of Ancient Blood reward cannot
-- be given on a full bag while 96 still plays, so it is only a reach and the quest log's completed bit carries the last
-- step; 101 plays only once completed). Wearing the right piece at the second talk skips 94 entirely, so bullet 4 is proved
-- by 94 alone and shown done through the later completion otherwise. 102 deletes the quest again (the title "Lower than the
-- Lowest Tunnel Worm"), which is the page's failure branch (bullet 6); declining the offer leaves no event. Bullet 2 (the item
-- list by job) is a note on the request. Client event script S4 238_Angelica_010EE059.txt (90 and 91 menu #7467; the lines
-- are baked into the event, so there is no chat pattern); key item from res/key_items.lua (Angelica's autograph, the reward).
-- The quest log is set at s1, so it is not silent. Not repeatable (page meta).
return {
    title = 'A Pose by Any Other Name',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to angelica f 10'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Angelica 90 or 91, option 1)'},
         },
         reach = {
            {t = 'event', zone = 238, event = 90, why = 'Angelica 90 offered (its finish needs option 1)'},
            {t = 'event', zone = 238, event = 91, why = 'Angelica 91 offered (its finish needs option 1)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'the items she asks you to'}},
        {id = 's3', at = {n = 3, fp = 'talk to angelica and stand still'},
         done = {
            {t = 'event', zone = 238, event = 92, why = 'Angelica 92: the request and the hour, only on the first talk while accepted'},
         }},
        {id = 's4', at = {n = 4, fp = 'talk to angelica again now she'},
         done = {
            {t = 'event', zone = 238, event = 94, why = 'Angelica 94: wear the requested body piece (the wrong one is worn)'},
         }},
        {id = 's5', at = {n = 5, fp = 'talk to her the last time'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 238, event = 101, conf = 'inferred', why = 'Angelica 101: plays only once completed'},
            {t = 'ki', id = 116, gained = true, conf = 'inferred', why = "Angelica's autograph obtained (reward)"},
         },
         reach = {{t = 'event', zone = 238, event = 96, why = 'Angelica 96 (also plays when the Copy of Ancient Blood cannot be given)'}}},
        {id = 's6', kind = 'branch', at = {n = 6, fp = 'if you refuse to model and'},
         done = {
            {t = 'event', zone = 238, event = 102, why = 'Angelica 102: the hour is over, the quest is deleted'},
         }},
    },
}

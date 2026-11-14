-- Step progress for Give a Moogle a Break (Other Areas quest 100). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Give_a_Moogle_a_Break.lua (the Mog House Moogle, in a home-nation Mog House:
-- 30005 is the offer, a menu whose option 1 begins the quest, so it is not used and the quest log's current bit proves the
-- talk; trading a Power Bow and a Beetle Ring plays 30007, which takes them and starts a one-minute timer, only for a matching
-- trade; the next talk after the minute plays 30008, which runs quest:complete (a title and two bigger Mog Safes, nothing that
-- can be refused), so the completed bit marks the last bullet). The 30005 to 30008 ids are used by no other quest in
-- LandSandBoat; the client has no script for the Mog House Moogle, so they are LandSandBoat's alone. The matcher needs a zone
-- id, so the trade event is listed once per home-nation city zone (the Mog House zone is its city's id; unverified, a miss
-- leaves the step to be inferred from the completed bit). The bed bullet is a note on the talk that follows it. The quest log
-- is set at s2.
return {
    title = 'Give a Moogle a Break',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'place a bronze bed in your'}},
        {id = 's2', at = {n = 2, fp = 'wait one earth minute then speak'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Moogle 30005, option 1)'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade your moogle a power bow'},
         done = {
            {t = 'event', zone = 230, event = 30007, why = 'Moogle 30007: the Power Bow and Beetle Ring accepted (Southern San d Oria Mog House)'},
            {t = 'event', zone = 231, event = 30007, why = 'Moogle 30007: the Power Bow and Beetle Ring accepted (Northern San d Oria Mog House)'},
            {t = 'event', zone = 232, event = 30007, why = 'Moogle 30007: the Power Bow and Beetle Ring accepted (Port San d Oria Mog House)'},
            {t = 'event', zone = 234, event = 30007, why = 'Moogle 30007: the Power Bow and Beetle Ring accepted (Bastok Mines Mog House)'},
            {t = 'event', zone = 235, event = 30007, why = 'Moogle 30007: the Power Bow and Beetle Ring accepted (Bastok Markets Mog House)'},
            {t = 'event', zone = 236, event = 30007, why = 'Moogle 30007: the Power Bow and Beetle Ring accepted (Port Bastok Mog House)'},
            {t = 'event', zone = 238, event = 30007, why = 'Moogle 30007: the Power Bow and Beetle Ring accepted (Windurst Waters Mog House)'},
            {t = 'event', zone = 239, event = 30007, why = 'Moogle 30007: the Power Bow and Beetle Ring accepted (Windurst Walls Mog House)'},
            {t = 'event', zone = 240, event = 30007, why = 'Moogle 30007: the Power Bow and Beetle Ring accepted (Port Windurst Mog House)'},
            {t = 'event', zone = 241, event = 30007, why = 'Moogle 30007: the Power Bow and Beetle Ring accepted (Windurst Woods Mog House)'},
         }},
        {id = 's4', at = {n = 4, fp = 'when your moogle returns from his'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Moogle 30008)'},
         }},
    },
}

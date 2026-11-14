-- Step progress for The Moogle's Picnic! (Other Areas quest 101). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/The_Moogles_Picnic.lua (the same shape as Give a Moogle a Break: the Mog House
-- Moogle's offer 30009 only begins the quest with option 1, so the quest log's current bit proves the talk, and it belongs to
-- the third bullet, the cutscene after zoning, not to the bed bullet; trading a Shrimp Lure and a Stick of Selbina Butter plays
-- 30011 for a matching trade only; the next talk after the minute plays 30012, which runs quest:complete and enlarges the Mog
-- Safes, so the completed bit marks the last bullet). The 30009 to 30012 ids are used by no other quest in LandSandBoat; the
-- client has no script for the Mog House Moogle. The matcher needs a zone id, so the trade event is listed once per
-- home-nation city zone (unverified; a miss leaves the step to be inferred from the completed bit). The bed and zoning bullets
-- are notes on the talk. The quest log is set at s3, so the steps before it are notes only.
return {
    title = "The Moogle's Picnic!",
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'place a mahogany bed in your'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'zone out of your mog house'}},
        {id = 's3', at = {n = 3, fp = 'return and speak to the moogle'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Moogle 30009, option 1)'},
         }},
        {id = 's4', at = {n = 4, fp = 'trade your moogle a shrimp lure'},
         done = {
            {t = 'event', zone = 230, event = 30011, why = 'Moogle 30011: the Shrimp Lure and Selbina Butter accepted (Southern San d Oria Mog House)'},
            {t = 'event', zone = 231, event = 30011, why = 'Moogle 30011: the Shrimp Lure and Selbina Butter accepted (Northern San d Oria Mog House)'},
            {t = 'event', zone = 232, event = 30011, why = 'Moogle 30011: the Shrimp Lure and Selbina Butter accepted (Port San d Oria Mog House)'},
            {t = 'event', zone = 234, event = 30011, why = 'Moogle 30011: the Shrimp Lure and Selbina Butter accepted (Bastok Mines Mog House)'},
            {t = 'event', zone = 235, event = 30011, why = 'Moogle 30011: the Shrimp Lure and Selbina Butter accepted (Bastok Markets Mog House)'},
            {t = 'event', zone = 236, event = 30011, why = 'Moogle 30011: the Shrimp Lure and Selbina Butter accepted (Port Bastok Mog House)'},
            {t = 'event', zone = 238, event = 30011, why = 'Moogle 30011: the Shrimp Lure and Selbina Butter accepted (Windurst Waters Mog House)'},
            {t = 'event', zone = 239, event = 30011, why = 'Moogle 30011: the Shrimp Lure and Selbina Butter accepted (Windurst Walls Mog House)'},
            {t = 'event', zone = 240, event = 30011, why = 'Moogle 30011: the Shrimp Lure and Selbina Butter accepted (Port Windurst Mog House)'},
            {t = 'event', zone = 241, event = 30011, why = 'Moogle 30011: the Shrimp Lure and Selbina Butter accepted (Windurst Woods Mog House)'},
         }},
        {id = 's5', at = {n = 5, fp = 'when your moogle returns from his'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Moogle 30012)'},
         }},
    },
}

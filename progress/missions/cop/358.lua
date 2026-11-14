-- Step progress for Darkness Named (Chains of Promathia 3-5, mission id 358). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/3_5_Darkness_Named.lua; client scripts 245_Ghebi_Damomohe_010F5006.txt (events 54 and
-- 52, say #8757 and #8769), 244_Monberaux_010F4001.txt (82 and 75, bodies empty); the Shrouded Maw (10) zone-in cutscene 2 is
-- LandSandBoat's. Monberaux 82 (status 0) starts it; Ghebi 54 (status 1) explains the chips; Ghebi 52 (status 2, plays only on a
-- colored chip with no pass held) hands over the Pso'Xja pass (key item 604); the Shrouded Maw zone-in 2 plays only at status 3;
-- Monberaux 75 (status 5, after the battlefield) completes. The battlefield entry (bullet 8) and its duplicate under Boss Fight
-- (bullet 10) have no event of their own (32001 is any win in that zone): notes with s9. Dropped from the draft: the mysterious
-- amulet key item on s1 (also given and taken by missions 110, 138 and 238), the held-key-item matcher on s3, the Aldo / Harnek /
-- Sattal-Mansal / Tavnazian reminders, Ghebi 53 and Monberaux 3 (reminders), and the matcher-less post step.
return {
    title = 'Darkness Named',
    completes = 's9',
    known = {{t = 'mission', line = 'cop', eq = 358}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with monberaux in upper jeuno'},
         done = {
            {t = 'event', zone = 244, event = 82, why = 'Monberaux 82: the mission begins (status 0 only)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to ghebi damomohe inside neptune'},
         done = {
            {t = 'event', zone = 245, event = 54, why = 'Ghebi Damomohe 54: the chips explained (status 1 only)'},
            {t = 'chat', re = "What, you want to explore the towers of Pso'Xja%?", why = 'Ghebi Damomohe 54 (say #8757)'},
         }},
        {id = 's3', at = {n = 3, fp = 'everyone in your party or if'},
         done = {
            {t = 'event', zone = 245, event = 52, why = "Ghebi Damomohe 52: a chip accepted, the Pso'Xja pass handed over (status 2)"},
            {t = 'chat', re = "You know, you're not a bad treasure hunter%.", why = 'Ghebi Damomohe 52 (say #8769)'},
            {t = 'ki', id = 604, gained = true, why = "Pso'Xja pass obtained"},
            {t = 'chat', re = "obtained key item: pso'xja pass", why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'after receiving your pass the fastest'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'after entering proceed on the singular'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'pass through the walls at h'}},
        {id = 's7', at = {n = 7, fp = 'after the last wall take the'},
         done = {
            {t = 'zonein', zone = 10, event = 2, why = 'The Shrouded Maw zone-in cutscene 2 (status 3 only, LandSandBoat)'},
         }},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'rest and go over strategies in'}},
        {id = 's9', at = {n = 9, fp = 'after diabolos is defeated return to'},
         done = {
            {t = 'mission', line = 'cop', eq = 358, completed = true, why = 'mission log: Darkness Named completed'},
            {t = 'event', zone = 244, event = 75, why = 'Monberaux 75: completes (status 5, after the battlefield)'},
         }},
        {id = 's10', kind = 'note', with = 's9', at = {n = 10, fp = 'after diabolos is defeated return to'}},
    },
}

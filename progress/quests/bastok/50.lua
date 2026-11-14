-- Step progress for A Lady's Heart (Bastok quest 50). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/A_Ladys_Heart.lua (Valah Molkot plays event 160 for every talk and trade and
-- carries the case in P2: 10 a plain talk, 0 a bad trade, 1 another flower, 2 an Amaryllis, 4/5 the same trades after
-- completion; the finish with option 2002 completes the quest and takes the Amaryllis; any other talk or valid-flower trade
-- just begins it; the reward has no item to refuse); client event script S4 236_Valah_Molkot_010EC046.txt (160, the Port
-- Bastok branch sub_02F4: the P2 = 2 branch says #7983). LandSandBoat's P2 values are its own, so the quest log completion
-- is the proof that does not depend on them. Same shape as Growing Flowers (San d'Oria quest 58). The quest log stays
-- silent until the first talk or trade. The optional first talk has no signal of its own (a plain talk also plays 160).
-- Shared-signal audit: the line "You rrreally know how to imprrress a girl" also plays for the other nations' flower quests (Growing Flowers in San d'Oria and the
-- Windurst and Jeuno Mithra NPCs): dropped; the log bit and event 160 with P2 = 2 stay.
return {
    title = "A Lady's Heart",
    completes = 's3',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', kind = 'optional', at = {n = 1, fp = 'optional talk to valah molkot'}, done = {}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'she won t come out and'}},
        {id = 's3', at = {n = 3, fp = 'trade it to her to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 236, event = 160, p = {[2] = 2}, why = 'Valah Molkot 160, P2 = 2: an Amaryllis traded (LandSandBoat)'},
         }},
    },
}

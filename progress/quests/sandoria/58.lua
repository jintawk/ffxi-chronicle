-- Step progress for Growing Flowers (San d'Oria quest 58). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Growing_Flowers.lua (Kuu Mohzolhi event 605 carries the case in P2: 0 a
-- bad trade, 1 another flower, 2 a Marguerite, 10 a plain talk, 4/5 the same trades after completion; the finish with
-- option 1002 completes the quest and takes the Marguerite; the reward is none, so it cannot be refused; any other talk
-- or valid-flower trade just begins the quest); client event script S4 231_Kuu_Mohzolhi_010E706F.txt (605 sub_01BF: the
-- P2 = 2 branch says #12391 "... will be prrrettier than ever"). LandSandBoat's P2 values are its own; the quest log
-- completion is the proof that does not depend on them. The quest log stays silent until the talk or the trade.
-- The optional first talk has no signal of its own (a plain talk also plays 605 with P2 = 10, which proves nothing more).
-- Shared-signal audit (2026-10-28): dropped the chat 'will be prrrettier than ever' (the same Queen Leaute line plays in the Bastok, Windurst and Jeuno flower quests); event 605 with P2 = 2 and the completed bit stay.
return {
    title = 'Growing Flowers',
    completes = 's3',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', kind = 'optional', at = {n = 1, fp = 'optional talk to kuu mohzolhi'}, done = {}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'she won t come out and'}},
        {id = 's3', at = {n = 3, fp = 'trade it to her to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 231, event = 605, p = {[2] = 2}, why = 'Kuu Mohzolhi 605, P2 = 2: a Marguerite traded (LandSandBoat)'},
         }},
    },
}

-- Step progress for Bombs Away! (Other Areas quest 96). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Bombs_Away.lua (Buffalostalker Dodzbraz 6 is the offer, a menu whose
-- option 1 begins the quest, so a declined offer plays it too and it is only the `reach`; every talk after that plays 7,
-- whose lines repeat the "two cores" request; trading exactly two Cluster Cores plays 8, which runs quest:complete for the
-- Chunk of Shumeyo Salt and only then takes the cores, but the event also plays when the reward cannot be given, so the quest
-- log's completed bit proves the trade and 8 is the `reach`). Client event script S4 005_Buffalostalker_Dodzbraz_010051AE.txt
-- (6: the "two cores" line #7353 only under the accepting choice; 7 say #7353; 8 say #7355). Repeat runs (page meta: Yes) are
-- a bare trade with no new accept and are not tracked. The quest log is set at s1, so it is not silent.
return {
    title = 'Bombs Away!',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to buffalostalker dodzbraz to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'chat', re = 'Brings me two cores from bomb clusters%.', why = 'Dodzbraz 6 (accepting choice) or 7 (say #7353)'},
            {t = 'event', zone = 5, event = 7, why = 'Dodzbraz 7: his talk once the quest is not available'},
         },
         reach = {{t = 'event', zone = 5, event = 6, why = 'Dodzbraz 6 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade him two cluster cores a'}, count = {item = 1667, need = 2},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 5, event = 8, why = 'Dodzbraz 8: the two cores traded (also plays when the reward cannot be given)'}}},
    },
}

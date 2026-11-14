-- Step progress for Uninvited Guests (Other Areas quest 81). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Uninvited_Guests.lua (Justinius 570 is the offer and only begins the quest
-- with option 1, so a declined offer plays it too and it is not used; accepting gives the Monarch Linn Patrol Permit, key item
-- 720, and sets the quest; while the permit is held his talk is 571; the permit is used up on entering the battlefield; 572 is
-- the victory report that gives the reward and runs quest:complete, but it also plays when the reward cannot be handed over
-- (the script keeps the quest open then), so the quest log's completed bit proves the last step and 572 is the `reach`).
-- Client event script S4 026_Justinius_0101A00A.txt (571 say #11814, 572 say #11818). The battlefield itself has no bullet of
-- its own that a signal could prove (Monarch Linn's 32001 win event is shared with the other battlefields there), so the
-- travel and fight bullets are notes on the report. Repeat runs (after each conquest tally, 573 or 574 re-issues the permit)
-- are not tracked: the completed bit survives and a second permit needs no new accept bullet. The quest log is set at s1.
return {
    title = 'Uninvited Guests',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with justinius on the top'},
         done = {
            {t = 'ki', id = 720, gained = true, why = 'Monarch Linn Patrol Permit obtained'},
            {t = 'ki_have', id = 720, have = true, why = 'Monarch Linn Patrol Permit held'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'chat', re = 'obtained key item: monarch linn patrol permit', why = 'chat: key item obtained'},
            {t = 'event', zone = 26, event = 571, conf = 'inferred', why = 'Justinius 571: his talk while the permit is held'},
            {t = 'chat', re = 'Take the .- and head for Monarch Linn', conf = 'inferred', why = 'Justinius 571 (say #11814)'},
         }},
        {id = 's2', kind = 'note', with = 's7', at = {n = 2, fp = 'travel to monarch linn'}},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'the bcnm is scaled acording to'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'the mammet 800 opponents have access'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'the mammet 800 will change stance'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'the fight ends as soon as'}},
        {id = 's7', at = {n = 7, fp = 'return to justinius after winning the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (first clear)'},
         },
         reach = {{t = 'event', zone = 26, event = 572, why = 'Justinius 572: the victory report (also plays when the reward cannot be given)'}}},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'this quest can be repeated after'}},
    },
}

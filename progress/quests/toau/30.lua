-- Step progress for Moment of Truth (Aht Urhgan quest 30). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Moment_of_Truth.lua (Mishhar 800 is the offer, no option, and begins the quest;
-- the Teahouse trigger area plays 802 at Prog 0 and sets Prog 1; Mishhar 803 at Prog 1 sets Prog 2 (his 801 is the reminder at
-- Prog 0, 588 at Prog 2); the Mamook ??? plays 221 at Prog 2 and sets Prog 3; the Jade Sepulcher door plays 3 at Prog 3 and sets
-- Prog 4; the battlefield win (event 32001, shared by every battlefield there) sets Prog 5, so entering and winning have no signal
-- of their own and the boss bullets are notes; Mishhar 805 at Prog 5 hands over a job-specific reward item and runs quest:complete
-- only when the item is given, so a full bag replays 805 and only the completed bit proves the last bullet). Events 802, 803, 805
-- (Whitegate), 221 (Mamook) and 3 (Jade Sepulcher) are used by no other quest or mission there. Client event script S4
-- 050_Mishhar_010321AE.txt (801 say #6959, 588 say #8713, 804 says #7005 and #7006; 800, 802, 803 and 805 are bare). Not repeatable.
return {
    title = 'Moment of Truth',
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with mishhar near hp 1'},
         done = {
            {t = 'event', zone = 50, event = 800, why = 'Mishhar 800: plays while available, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'go to the teahouse j 12'},
         done = {
            {t = 'event', zone = 50, event = 802, why = 'Teahouse trigger area 802: plays only at Prog 0, sets Prog 1'},
         },
         reach = {
            {t = 'event', zone = 50, event = 801, why = 'Mishhar 801: his reminder at Prog 0, after the offer'},
            {t = 'chat', re = 'Minfram is probably at Shararat Teahouse now', why = 'Mishhar 801 (say #6959)'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to mishhar h 8'},
         done = {
            {t = 'event', zone = 50, event = 803, why = 'Mishhar 803: plays only at Prog 1, sets Prog 2'},
         }},
        {id = 's4', at = {n = 4, fp = 'enter mamook from d 12 in'},
         done = {
            {t = 'event', zone = 65, event = 221, why = 'the ??? 221 in Mamook: plays only at Prog 2, sets Prog 3'},
         },
         reach = {
            {t = 'event', zone = 50, event = 588, why = 'Mishhar 588: his reminder at Prog 2, after the return'},
            {t = 'chat', re = "Make your way to Mamook, I'll be right behind you", why = 'Mishhar 588 (say #8713)'},
         }},
        {id = 's5', at = {n = 5, fp = 'head to jade sepulcher and click'},
         done = {
            {t = 'event', zone = 67, event = 3, why = 'Jade Sepulcher door 3: plays only at Prog 3, sets Prog 4'},
         },
         reach = {
            {t = 'event', zone = 50, event = 804, why = 'Mishhar 804: his reminder at Prog 3 and 4'},
            {t = 'chat', re = 'My intuition tells me that they have been taken to the Jade Sepulcher', why = 'Mishhar 804 (say #7005)'},
         }},
        {id = 's6', kind = 'note', with = 's10', at = {n = 6, fp = 'click again to enter the bcnm'}},
        {id = 's7', kind = 'note', with = 's10', at = {n = 7, fp = 'blacktattoo vedool ja blm'}},
        {id = 's8', kind = 'note', with = 's10', at = {n = 8, fp = 'shadowhand kajeel ja nin'}},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'whitetattoo rahool ja whm'}},
        {id = 's10', at = {n = 10, fp = 'return to mishhar for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 50, event = 805, why = 'Mishhar 805: plays only at Prog 5 (the battle won), hands over the reward and completes (replays if the item cannot be given)'}}},
    },
}

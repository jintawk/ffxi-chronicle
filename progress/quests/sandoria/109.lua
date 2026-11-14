-- Step progress for Tea with a Tonberry? (San d'Oria quest 109). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Tea_with_a_Tonberry.lua (Sobane 738 begins it with no choice; 739 is her
-- reminder; Anguenet 27 is the first talk (Prog 1), 28 the reminder, 29 the trade of the Attohwa Ginseng that gives key
-- item 627; Riche 5 needs 627, its menu ends on the fifth question and takes the item (Prog 3); the Davoi ??? plays 126 once
-- the Hematic Cyst is dead (Prog 4 -> 5); Sobane 740 at Prog 5 completes); client event scripts S4 230_Sobane_010E601A.txt,
-- 002_Anguenet_0100216C.txt (29 say #7482) and 001_Riche_0100101F.txt (5 print #7424 first, say #7430 only on the last
-- question). The draft put Anguenet 28 as proof and Riche's key item loss as a plain inferred: 28 is only a reminder (so it
-- is `reach` with 27), and the Riche line used is the last answer, which ends the event. Treasury Gold (bullet 7) can only be
-- inferred from the item, the Treasury Gold trade (bullet 8) has no line of its own ("You are under attack!" is a generic
-- text), so both bullets stay plain.
return {
    title = 'Tea with a Tonberry?',
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to sobane to begin this'},
         done = {
            {t = 'event', zone = 230, event = 738, why = 'Sobane 738'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 230, event = 739, conf = 'inferred', why = 'Sobane 739: reminder, only once accepted'},
            {t = 'chat', re = 'I wonder if Sir Louverance is the one threatening Count Teulomme', conf = 'inferred', why = 'Sobane 739 (say #9856)'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'you will need a attohwa ginseng'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'enter carpenters landing by taking the'}},
        {id = 's4', at = {n = 4, fp = 'speak to anguenet j 10 and'},
         done = {
            {t = 'event', zone = 2, event = 29, why = 'Anguenet 29: the ginseng traded'},
            {t = 'chat', re = 'Your contribution is most appreciated%.', why = 'Anguenet 29 (say #7482)'},
            {t = 'ki', id = 627, gained = true, why = 'Tonberry blackboard obtained'},
            {t = 'ki_have', id = 627, have = true, why = 'Tonberry blackboard held'},
            {t = 'chat', re = 'obtained key item: tonberry blackboard', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 2, event = 27, why = 'Anguenet 27: the first talk'},
                  {t = 'event', zone = 2, event = 28, why = 'Anguenet 28: reminder while the ginseng is due'}}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'purchase a ticket and board a'}},
        {id = 's6', at = {n = 6, fp = 'on the ship you will find'},
         done = {
            {t = 'chat', re = 'Davoi%. Waterfall%.', why = 'Riche 5, the last question (say #7430)'},
            {t = 'ki', id = 627, gained = false, conf = 'inferred', why = 'Tonberry blackboard taken by Riche'},
         },
         reach = {{t = 'event', zone = 1, event = 5, why = 'Riche 5 started'}}},
        {id = 's9', at = {n = 9, fp = 'after the hematic cyst is defeated'},
         done = {
            {t = 'event', zone = 149, event = 126, why = 'Davoi ??? 126: the cutscene after the Hematic Cyst'},
         }},
        {id = 's10', at = {n = 10, fp = 'return to sobane for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 230, event = 740, why = 'Sobane 740: plays even when the Willpower Torque does not fit, so it is not proof'}}},
    },
}

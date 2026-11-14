-- Step progress for Mihgo's Amigo (Windurst quest 25). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Mihgos_Amigo.lua (Nanaa Mihgo 80, or 81 when Crying Over Onions is accepted,
-- are her available-state talks and both begin the quest in their finish; while accepted she plays 82 and Cha Lebagta 85, both
-- accepted-only; the four Yagudo Bead Necklaces are traded for 88, which runs quest:complete with a title and no item reward;
-- 494 is the same trade once completed and also completes; 89 is her talk once completed until the player zones); client event
-- script S4 241_Nanaa_Mihgo_010F1072.txt (81 say #7608, 82 #7610, 494 #8688), 241_Cha_Lebagta_010F1074.txt (85 #7615). A repeat
-- needs no new accept (the completed-state trade alone), so there is no `repeatable` entry. The quest log is set at s1, so it
-- is not silent. The necklace bullet (n=2) is a note on the trade; bullets 4 and 5 (fame, Trust) are plain facts and stay
-- unmapped.
return {
    title = "Mihgo's Amigo",
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to nanaa mihgo multiple times'},
         done = {
            {t = 'event', zone = 241, event = 80, why = 'Nanaa Mihgo 80: her available-state talk, begins the quest'},
            {t = 'event', zone = 241, event = 81, why = 'Nanaa Mihgo 81: her talk with Crying Over Onions, begins the quest'},
            {t = 'chat', re = "Haven't I seen you somewhere beforrre%?", why = 'Nanaa Mihgo 81 (say #7608)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 241, event = 82, why = 'Nanaa Mihgo 82: only while accepted'},
            {t = 'chat', re = 'Well, if you want to be all chummy with me, you had better bring me a token offerrring firrrst%.', why = 'Nanaa Mihgo 82 (say #7610)'},
            {t = 'event', zone = 241, event = 85, why = 'Cha Lebagta 85: only while accepted'},
            {t = 'chat', re = 'We crrrawled up to the top cat by taking her four', why = 'Cha Lebagta 85 (say #7615)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you will have to obtain 4'}},
        {id = 's3', at = {n = 3, fp = 'trade nanaa mihgo the necklaces to'},
         done = {
            {t = 'event', zone = 241, event = 88, why = 'Nanaa Mihgo 88: the four necklaces accepted, completes'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 241, event = 494, why = 'Nanaa Mihgo 494: the necklaces again, once completed'},
            {t = 'chat', re = 'Oh, what a cleverrr little kitten you are%.', why = 'Nanaa Mihgo 494 (say #8688)'},
            {t = 'event', zone = 241, event = 89, why = 'Nanaa Mihgo 89: her talk once completed'},
            {t = 'chat', re = "Just 'cause I accepted your token of esteem", why = 'Nanaa Mihgo 89 (say #7622)'},
         }},
    },
}

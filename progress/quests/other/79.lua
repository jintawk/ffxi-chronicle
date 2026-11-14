-- Step progress for Confessions of a Bellmaker (Other Areas quest 79). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Confessions_of_a_Bellmaker.lua (the Stone Monument in Riverne - Site #A01
-- plays 101 while the quest is available, a plain cutscene whose finish begins the quest and gives the Ornamented scroll; Reinberta
-- 402 in Bastok Markets and Mevreauche 74 in Northern San d'Oria each play once, in that order; the Stone Monument plays 102 at
-- Prog 2, spawns Arcane Phantasm at Prog 3 with no cutscene, and plays 103 at Prog 4; 103 runs quest:complete and takes the
-- scroll, but it also plays when the reward cannot be given, so the quest log's completed bit proves the last step and 103 is the
-- `reach`). Client event scripts S4 030_Stone_Monument_0101E117.txt (103 bare), 235_Reinberta_010EB00E.txt (402 bare) and
-- 231_Mevreauche_010E702B.txt (74 bare); 101 and 102 are LandSandBoat's. The cutscene bullet belongs to s1, the spawn bullet is a
-- note on the last step. The quest log is set at s1, so it is not silent.
return {
    title = 'Confessions of a Bellmaker',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'travel to riverne site a01 and'},
         done = {
            {t = 'event', zone = 30, event = 101, why = 'Stone Monument 101: the offer cutscene (no menu, begins the quest)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 712, gained = true, why = 'ornamented scroll obtained'},
            {t = 'ki_have', id = 712, have = true, why = 'ornamented scroll held'},
            {t = 'chat', re = 'obtained key item: ornamented scroll', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'you will receive a cutscene and'}},
        {id = 's3', at = {n = 3, fp = 'speak to reinberta in i 8'},
         done = {
            {t = 'event', zone = 235, event = 402, why = 'Reinberta 402: plays once while accepted at Prog 0'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to mevreauche in e 6'},
         done = {
            {t = 'event', zone = 231, event = 74, why = 'Mevreauche 74: plays once after Reinberta'},
         }},
        {id = 's5', at = {n = 5, fp = 'head back to and check the'},
         done = {
            {t = 'event', zone = 30, event = 102, why = 'Stone Monument 102: plays once after Mevreauche'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'examine it again to spawn arcane'}},
        {id = 's7', at = {n = 7, fp = 'after defeating the nm click the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 712, gained = false, conf = 'inferred', why = 'ornamented scroll handed over'},
         },
         reach = {{t = 'event', zone = 30, event = 103, why = 'Stone Monument 103 after the kill (also plays when the reward cannot be given)'}}},
    },
}

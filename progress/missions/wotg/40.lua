-- Step progress for Her Memories (Wings of the Goddess, mission id 40). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/41_Her_Memories.lua (empty: the mission is closed by xi.wotg.helpers.checkMemoryFragments,
-- called by each of the five Her Memories quests in scripts/quests/crystalWar/). Four large memory fragments end the mission; the page
-- lists three quests (the fourth is the nation's Footfalls quest, bullets 4 to 6, notes on the last step).
-- The fragments are no signal on their own (reward key items, and the four ids are not pinned to a quest), so each step rests on its
-- quest's own closing signal: Homecoming Queen ends on the third tiny fragment with the "meld together" line (only that quest uses it:
-- Port San d'Oria / Northern San d'Oria / Batallia Downs IDs.lua FRAGMENTS_MELD); Of Malign Maladies ends at Raustigne (Southern San
-- d'Oria [S] 169, which needs the Fey stone and calls quest:complete); Operation Cupid ends at the Batallia Downs [S] zone-in cutscene 24
-- (from Rolanberry Fields [S] with Prog 2; 23 only begins the quest). Whichever quest closes fourth prints "report to Cait Sith" and
-- completes the mission, so that line and the mission line sit on the last bullet's step. The quests can be done in any order, so an
-- earlier step shows done when a later one is (the model's rule), which is right once the mission is completed.
return {
    title = 'Her Memories',
    completes = 's3',
    known = {{t = 'mission', line = 'wotg', eq = 40}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'her memories homecoming queen will give'},
         done = {
            {t = 'chat', re = 'meld together to form', why = 'FRAGMENTS_MELD: the last of the three tiny fragments, Homecoming Queen completes'},
         }},
        {id = 's2', at = {n = 2, fp = 'her memories of malign maladies will'},
         done = {
            {t = 'event', zone = 80, event = 169, why = 'Raustigne 169: needs the Fey stone, completes Of Malign Maladies'},
         }},
        {id = 's3', at = {n = 3, fp = 'her memories operation cupid will give'},
         done = {
            {t = 'zonein', zone = 84, event = 24, why = 'Batallia Downs [S] zone-in 24 from Rolanberry Fields [S] (Prog 2): completes Operation Cupid'},
            {t = 'chat', re = 'make haste and report to cait sith', why = 'REPORT_TO_CAIT_SITH: all four fragments held, the mission completes'},
            {t = 'mission', line = 'wotg', eq = 40, completed = true, why = 'mission log: Her Memories completed'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'san d oria her memories carnelian'}},
        {id = 's5', kind = 'note', with = 's3', at = {n = 5, fp = 'bastok her memories azure footfalls'}},
        {id = 's6', kind = 'note', with = 's3', at = {n = 6, fp = 'windurst her memories verdure footfalls'}},
    },
}

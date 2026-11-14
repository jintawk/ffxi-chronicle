-- Step progress for Rock Bottom (Aht Urhgan quest 20). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Rock_Bottom.lua (the ??? at Mount Zhayolm plays 7 while the quest is available
-- and begins it at once; a Pickaxe trade plays 8 at Prog 1 and sets Prog 2 with a zone wait; a Mythril Pick trade after zoning plays
-- 9 at Prog 2, which runs quest:complete (reward is a key item or gil, so 9 never replays on a full bag). Events 7, 8 and 9 of zone
-- 61 are used by no other script (Waudeen uses 3 to 6). The draft proved the first bullet with the Plasma Rock key item; the page
-- says that key item is not obtainable and LandSandBoat never gives it, so it is dropped, and the draft's completes guess is
-- replaced by the real one. The zone-out bullet is a note on the final trade. No client event script exists for the ???.
return {
    title = 'Rock Bottom',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the unnamed target on a'},
         done = {
            {t = 'event', zone = 61, event = 7, why = 'the ??? 7: plays only while available, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade a pickaxe to the same'},
         done = {
            {t = 'event', zone = 61, event = 8, why = 'the ??? 8: the Pickaxe accepted, only at Prog 1'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head south to zone out of'}},
        {id = 's4', at = {n = 4, fp = 'trade a mythril pick to the'},
         done = {
            {t = 'event', zone = 61, event = 9, why = 'the ??? 9: the Mythril Pick accepted, only at Prog 2 after zoning, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

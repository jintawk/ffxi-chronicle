-- Step progress for Path of the Bard (Jeuno quest 20). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Path_of_the_Bard.lua (the quest is never accepted, so the log is silent until
-- the Song Runes cutscene, Valkurm Dunes event 2, runs quest:complete: unlockJob, gil, key item and title, nothing to
-- refuse; the file's own note says all the Lower Jeuno dialogue is optional and the player can go straight to the runes, so
-- bullets 1 and 2 are optional; Bki Tbujhja 182 and Mataligeat 144 play only while the quest is available and A Minstrel in
-- Despair is done, 180 and 143 are the after-quest talks). Client event scripts S4 245_Bki_Tbujhja_010F501E.txt (182 say
-- #7443), 245_Mataligeat_010F501D.txt (144 say #7433) and 103_Song_Runes_0106724F.txt (2 is a bare cutscene). Not repeatable.
-- Bullets 1 and 2 are plain bullets (no steps): Bki Tbujhja 182 and Mataligeat 144, with their lines, play identically for A Minstrel
-- in Despair (A_Minstrel_In_Despair.lua, same two NPCs and events), and this quest has no accepted bit to gate them on.
return {
    title = 'Path of the Bard',
    completes = 's3',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's3', at = {n = 3, fp = 'travel through the tunnel in valkurm'},
         done = {
            {t = 'event', zone = 103, event = 2, why = 'Song Runes 2: the last cutscene, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}

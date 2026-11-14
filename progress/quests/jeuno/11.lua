-- Step progress for The Old Monument (Jeuno quest 11). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/The_Old_Monument.lua (the quest is never begun, only completed, so the log shows
-- nothing before the end; Mertaire 102 at Prog 0 sets Prog 1; the Song Runes in Buburimu Peninsula play the cutscene 0 at
-- Prog 1; trading a Sheet of Parchment plays 2 and the zone's writing text, then quest:complete, but the reward is the
-- Poetic Parchment, so event 2 and the text also play when the bag is full and are only a reach: the log's completed bit
-- proves the last step; event 2 also belongs to A Minstrel in Despair, so it counts only after the cutscene). Client event
-- scripts S4 245_Mertaire_010F501C.txt (102 say #7425) and 118_Song_Runes_01076251.txt (0 has no text). Bullets 2 and 3
-- (Bki Tbujhja, the parchment) have no signal and stay plain. Not repeatable.
return {
    title = 'The Old Monument',
    completes = 's5',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's5'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to mertaire at merry minstrel'},
         done = {
            {t = 'event', zone = 245, event = 102, why = 'Mertaire 102: the first talk, only at Prog 0'},
            {t = 'chat', re = 'Hey, who do you think you are!%?', why = 'Mertaire 102 (say #7425)'},
         }},
        {id = 's4', at = {n = 4, fp = 'travel to buburimu peninsula at g'},
         done = {
            {t = 'event', zone = 118, event = 0, why = 'Song Runes 0: the cutscene, only at Prog 1'},
         }},
        {id = 's5', at = {n = 5, fp = 'trade a parchment to the song'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 118, event = 2, after = 's4', why = 'Song Runes 2 (also plays when the Poetic Parchment cannot be given)'}}},
    },
}
